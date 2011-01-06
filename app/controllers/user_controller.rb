class UserController < ApplicationController
  before_filter :authorize,:except=>[:home,:index,:login,:logout,:register,:pay_notify_handler]

  require "md5"
  layout "home"

  def login
    if checkCookie()
      redirect_to("/user/home")
    elsif params[:format] == 'json'
      user = User.login(params[:username], params[:password], 'en', request.remote_ip)
      if user
        render :text => "true"
      else
        render :text => "false"
      end
    elsif request.post?
      user = User.login(params[:user][:username],params[:user][:password],getBrowserLanguage(),request.remote_ip())

      unless user.nil?
        @result=true
        @alertMessage = l("common_alert_loginDone")
        session[:user]=user

        #清除一下统计数
        expireUserHeaderMenu(user.id)

        #remember me,set cookies
        if params[:remember_me]=="1"
          cookies[:username]={ :value => params[:user][:username],
                               :expires => 30.days.from_now,
                               :path => "/"}
          cookies[:password]={ :value => MD5.new(params[:user][:password]).to_s,
                               :expires => 30.days.from_now,
                               :path => "/"}
        end
      else
        @result=false
        @alertMessage = l("constValue_loginFailed")
      end
    else #not post,method is get
      #if no comeFrom then redirect to user home
      if request.env["HTTP_REFERER"]
        session[:comeFrom] = request.env["HTTP_REFERER"]
      else
        session[:comeFrom] = "/user/home/"
      end
    end
  end

  def logout
    if session[:user]
      reset_session
      #delete cookies
      cookies.delete(:username)
      cookies.delete(:password)
    end
  end

  def index
    if not params[:user_id].nil?
      @user=User.find(params[:user_id])
      @user.beViewed
      #content of title tag.
      @title=@user.username
      @desc=@user.username

      #if is page host,then render host view.
      if isHost
        @photo_pages, @photos = paginate( :photo,
                                          :per_page => 10,
                                          :conditions => ["user_id = ?", params[:user_id]],
                                          :order => "datetime desc")
        render :template=>"/user/index_host"
      else
        unless read_fragment("/#{getBrowserLanguage()}/user/#{params[:user_id]}/index/page_#{params[:page]||=1}")
          @photo_pages, @photos = paginate( :photo,
                                            :per_page => 10,
                                            :conditions => ["user_id = ? and isAuth=1", params[:user_id]],
                                            :order => "datetime desc")
        end
        render :template=>"/user/index"
      end
    else
      redirect_to "/404/"
    end
  end

  def home


    checkCookie()
    #cache fragment
    unless read_fragment("/#{getBrowserLanguage()}/user/home")
      #最新更新
      config = readFile("#{RAILS_ROOT}/config/userData/newAlbums.txt")
      @newAlbums = Array.new
      for albumID in config.split(',')
        if albumID
          album = Album.find(:first,:conditions=>["id = ?",albumID])

          #判断是否找到相应的相册
          if not album.nil?
            @newAlbums << album  #加入返回集合数组中
          end
        end
      end

      #精选相册
      config = readFile("#{RAILS_ROOT}/config/userData/goodAlbums.txt")
      @goodAlbums = Array.new
      for albumID in config.split(',')
        if albumID
          album = Album.find(:first,:conditions=>["id = ?",albumID])

          #判断是否找到相应的相册
          if not album.nil?
            @goodAlbums << album  #加入返回集合数组中
          end
        end
      end

      #明星用户
      config = readFile("#{RAILS_ROOT}/config/userData/starUsers.txt")
      @starUsers = Array.new
      for userID in config.split(',')
        if userID
          user = User.find(:first,:conditions=>["id = ?",userID])

          #判断是否找到相应的相册
          if not user.nil?
            @starUsers << user  #加入返回集合数组中
          end
        end
      end

      config = readFile("#{RAILS_ROOT}/config/userData/sliderImages.txt")
      @sliderImages = Array.new
      for imageID in config.split(',')
        if imageID
          photo = Photo.find(:first,:conditions=>["id = ?",imageID])

          #判断是否找到相应的相册
          if not photo.nil?
            @sliderImages << photo  #加入返回集合数组中
          end
        end
      end
    end #end of cache fragment
  end

  def profile


    @user=User.find(params[:user_id],:include=>"userinformation")
    @user.beViewed
    #content of title tag.
    @title=@user.username
  end

  ###User Edit Area################################################
  def register
    if request.post?
      @user = User.new(params[:user])

      if @user.save
        @alertMessage=l("constValue_registerDone")
        @result=true
      else
        @alertMessage=l("constValue_registerFailed")
        @result=false
      end
    end
  end

  def updateInformation
    @currentHeaderMenu = "user"
    @currentSubMenu = "information"

    @sexChoice = {
      l("userUpdateInform_label_sexBoy")=>"boy",
      l("userUpdateInform_label_sexGirl")=>"girl"
    }
    if request.post?
      @userinformation=session[:user].userinformation

      if params[:userinformation][:sign].size < 255
        if @userinformation.update_attributes(params[:userinformation])
          @result=true
          @alertMessage=l("constValue_userInformEditDone")
        else
          @result=false
          @alertMessage=l("constValue_userInformEditFailed")
        end
      else
        @result=false
        @alertMessage=l("constValue_signTooLong")
      end
    else
      @userinformation = session[:user].userinformation
    end
    render :layout=>"user"
  end

  def portraitEdit
    @currentHeaderMenu = "user"
    @currentSubMenu = "uploadPortrait"

    if request.post?
      file=params[:user][:portrait]
      @result=false

      if file.length <= 0
        @alertMessage=l("constValue_portrait_selectOne")
      elsif not isPhoto(file.original_filename)
        @alertMessage=l("constValue_portrait_selectRightFormat")
      elsif file.length > 200*1024 #超过200K
        @alertMessage=l("constValue_portrait_tooLarge")
      else
        #获得上传后的文件名，如果失败会返回老的文件名
        params[:user][:portrait]=uploadPersonPortrait(file)

        session[:user].update_attribute(:portrait,params[:user][:portrait])
        @result=true
        @alertMessage=l("constValue_portrait_uploadDone")
      end
    end

    render :layout=>"user"
  rescue
    @alertMessage=l("constValue_portrait_uploadFailed")
  end

  def editEmail
    @currentHeaderMenu = "user"
    @currentSubMenu = "email"

    if request.post?
      #because sometime it makes mistake,so I have to make it like this.looks stupid
      @user=session[:user]

      if @user.update_attributes(params[:user])
        @result=true
        @alertMessage=l("constValue_emailEditDone")
      else
        session[:user]=User.find(session[:user].id)
        @result=false
        @alertMessage=l("constValue_emailEditFailed")
      end
    end
    render :layout=>"user"
  end

  def account
    @currentHeaderMenu = "user"
    @currentSubMenu = "account"

    if request.post?
      @result=false
      user = session[:user]

      if MD5.new(params[:oldUser][:password])!=user.password
        @alertMessage=l("constValue_password_wrongOldPassword")
      elsif params[:user][:password].length<1
        @alertMessage=l("constValue_password_enterNewPassword")
      elsif params[:user][:password].length<6 or params[:user][:password].length>35
        @alertMessage=l("constValue_password_lengthRange")
      elsif params[:user][:password_confirmation]!=params[:user][:password]
        @alertMessage=l("constValue_password_differentForConfirm")
      else
        user.update_attribute(:password, MD5.new(params[:user][:password]).to_s)
        @result=true
        @alertMessage=l("constValue_password_editDone")
      end
    end
    render :layout=>"user"
  end

  def myPacks
    @currentHeaderMenu = "packs"
    @currentSubMenu = "myPacks"

    @album_pages, @albums = paginate( :album,
                                      :per_page => 18,
                                      :conditions => ["user_id = ? and isPacked = true", session[:user].id])
    render :layout=>"user"
  end

  def income
    @currentHeaderMenu = "point"
    @currentSubMenu = "income"

    render :layout=>"user"
  end

  def buyPoint
    @currentHeaderMenu = "point"
    @currentSubMenu = "pay"

    render :layout=>"user"
  end

  def joinVip
    @currentHeaderMenu = "point"
    @currentSubMenu = "vip"

    render :layout=>"user"
  end
end
