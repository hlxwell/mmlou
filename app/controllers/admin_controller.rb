class AdminController < ApplicationController
  before_filter :adminAuthorize,:except=>[:adminLogin,:logout,:index,:login]
  verify :method => :post,:params=>:id ,:xhr=>true, :only =>[:deletePhoto,:deleteAlbum,:packingAlbum,:unpackingAlbum,:deleteUser,:addPoint,:minusPoint,:deleteReport]
  
  layout "admin"
  
  def index
    redirect_to("/admin/login")
  end
  
  def login
    if request.post?
      user = User.adminLogin(params[:user][:username],params[:user][:password])
      if not user.nil?
        @alertMessage = "登录成功！"
        @result=true
        session[:user]=user
        session[:admin]=user
      else
        @alertMessage="登录失败！用户名或者密码错误！或者您不是管理员！"
        @result=false
      end
    end
    render :layout=>"home"
  end
  
  def logout
    if session[:admin]
      session[:admin]=nil
    end
    render :layout=>"home"
  end
    
  ### photo ###############################################
  def photoManage
    @currentHeaderMenu = "photo"
    @currentSubMenu = "photo"
    
    @photo_pages, @photos = paginate( :photo,:per_page => 20,:order=>"datetime desc")
    @photoIDs=""
    for photo in @photos
      @photoIDs+=photo.id.to_s+","
    end
  end
  
  def authPhotos
    #get photo_ids need auth
    params[:photoIDs]=params[:photoIDs].split(",")
    
    #for get and set auth photos
    for param in params
      if param[0].to_i!=0
        Photo.update(param[0],:isAuth=>"true")
        params[:photoIDs].delete(param[0])
      end
    end
    
    #set unauth to other photos
    for photoID in params[:photoIDs]
      Photo.update(photoID,:isAuth=>"false")
    end    
    
    render :text=>"认证修改成功！"
  end
  
  def deletePhoto
    Photo.destroy(params[:id])
  end
  
  ### album ########################################
  def albumManage
    @currentHeaderMenu = "album"
    @currentSubMenu = "album"
    
    @album_pages, @albums = paginate( :album,:per_page => 20,:order=>"datetime desc")
    @albumIDs = @albums.map {|album|
      album.id.to_s
    }.join(',')
  end
  
  def authAlbums
    #get photo_ids need auth
    params[:albumIDs]=params[:albumIDs].split(",")
    
    #for get and set auth photos
    for param in params
      if param[0].to_i!=0
        Photo.update_all("isAuth=true",:album_id=>param[0])
        params[:albumIDs].delete(param[0])
      end
    end
    
    #set unauth to other photos
    for albumID in params[:albumIDs]
      Photo.update_all("isAuth=false",:album_id=>albumID)
    end    
    
    render :text=>"认证修改成功！"
  end
  
  def deleteAlbum
    Album.destroy(params[:id])
  end
  
  def albumHTML
    album=Album.find(params[:id])
    render :inline=>"<%=h(getAlbumHTML(album))%>",:locals => { :album => album }
  end
  
  def albumUBB
    album=Album.find(params[:id])
    render :text=>getAlbumUBB(album)
  end
  ### packing ######################################
  def packManage
    @currentHeaderMenu = "album"
    @currentSubMenu = "pack"
    
    @album_pages, @albums = paginate( :album,:per_page => 20,:order=>"datetime desc")
  end
  
  def packingAlbum    
    render :text=>packAlbum(params[:id])
  end
  
  def unpackingAlbum
    render :text=>unpackAlbum(params[:id])
  end
  
  def packingMiddleAlbum
    render :text=>packMiddleAlbum(params[:id])
  end
  
  def unpackingMiddleAlbum
    render :text=>unpackMiddleAlbum(params[:id])
  end
  
  ### user #########################################
  def deleteUser
    if not params[:id].nil?
      User.destroy(params[:id])
      render :text=>"删除用户成功！"
    end
  end
  
  def userManage
    @currentHeaderMenu = "user"
    @currentSubMenu = "user"
    
    if params[:id]=="todayLogin"
      @user_pages, @users = paginate( :user,:per_page => 20,:conditions=>["lastLoginDatetime < ? and lastLoginDatetime > ? ",Time.now+1.day, Time.now-1.day],:order=>"lastLoginDatetime desc")
    elsif params[:id]=="todayRegister"
      @user_pages, @users = paginate( :user,:per_page => 20,:conditions=>["registerDatetime < ? and registerDatetime > ?",Time.now+1.day, Time.now-1.day],:order=>"registerDatetime desc")
    elsif params[:id]=="loginMost"
      @user_pages, @users = paginate( :user,:per_page => 20,:order=>"loginCount desc")
    else
      @user_pages, @users = paginate( :user,:per_page => 20,:order=>"registerDatetime desc")
    end
  end
  
  ### point #############################################
  def pointManage
    @currentHeaderMenu = "point"
    @currentSubMenu = "point"
    
    @user_pages, @users = paginate( :user,:per_page => 20,:order=>"registerDatetime desc")
  end
  
  def pointLog
    @currentHeaderMenu = "point"
    @currentSubMenu = "log"
    
    @log_pages, @logs = paginate( :pointoplog,:per_page => 20,:order=>"datetime desc")
  end
  
  def addPoint
    user=User.find(params[:id])
    user.addPoint(5)
  end
  
  def minusPoint
    user=User.find(params[:id])
    user.minusPoint(5)
  end
  
  ### tag #######################################
  def tagManage
    @currentHeaderMenu = "photo"
    @currentSubMenu = "tag"
    
    @tag_pages, @tags = paginate( :tag,:per_page => 20,:order=>"datetime desc")
  end
  
  def addTag
    tag = Tag.new(params[:tag])
    tag.datetime=Time.now
    
    if tag.save()
      expireTag()
      render :text=>"添加成功！"
    else
      render :text=>tag.errors["tagName"]
    end
  end
  
  def deleteTag
    Tag.destroy(params[:id])
    expireTag()  
    render :text=>"删除成功！"
  end
  
  def updateTagNum
    Tag.updateCount
    expireTag()
    
    render :text=>"更新成功！"
  end
  
  def updateTagCover    
    params.each { |key,value| 
      if (key =~ /^\d*$/)==0
        Tag.update(key.to_i, {:coverPhoto_id => value[:coverPhoto_id]})
      end
    }
    
    expireTag()
    render :text=> "更新成功！" 
  end
  
  ### report #######################################
  def reportManage
    @currentHeaderMenu = "report"
    @currentSubMenu = "report"
    
    @report_pages, @reports = paginate( :report,:per_page => 20,:order=>"datetime desc")
  end
  
  def deleteReport
    Report.destroy(params[:id])
  end
  
  ### home Page photos #############################
  def homePageManage
    @currentHeaderMenu = "homePage"
    @currentSubMenu = "homePage"
    
    @photoIDs = []
    @photoIDs = readFile("#{RAILS_ROOT}/config/userData/homePagePhoto.txt").split(',')
  end
  
  def updateHomePage
    content = ""
    for i in 0..27
      content += params["photo#{i}"]+','
    end
    writeFile("#{RAILS_ROOT}/config/userData/homePagePhoto.txt",content)
    
    expireUserHome()
    render :text=>"首页图片修改成功！"
  end
  
  ### user home page manage #########################
  def userHomeManage
    @currentHeaderMenu = "homePage"
    @currentSubMenu = "userHomePage"
    
    @newAlbums  = []
    @goodAlbums = []
    @starUsers  = []
    
    @newAlbums  = readFile("#{RAILS_ROOT}/config/userData/newAlbums.txt").split(',')
    @goodAlbums = readFile("#{RAILS_ROOT}/config/userData/goodAlbums.txt").split(',')
    @starUsers  = readFile("#{RAILS_ROOT}/config/userData/starUsers.txt").split(',')
    @sliderImages = readFile("#{RAILS_ROOT}/config/userData/sliderImages.txt").split(',')
  end
  
  def updateNewAlbums
    content = ""
    for i in 0..9
      content += params["newAlbum#{i}"]+','
    end
    writeFile("#{RAILS_ROOT}/config/userData/newAlbums.txt",content)
    
    expireUserHome()
    render :text=>"修改最新相册成功！"
  end
  
  def updateGoodAlbums
    content = ""
    for i in 0..29
      content += params["goodAlbum#{i}"]+','
    end
    writeFile("#{RAILS_ROOT}/config/userData/goodAlbums.txt",content)
    
    expireUserHome()
    render :text=>"修改精选相册成功！"
  end
  
  def updateStarUsers
    content = ""
    for i in 0..11
      content += params["user#{i}"]+','
    end
    writeFile("#{RAILS_ROOT}/config/userData/starUsers.txt",content)
    
    expireUserHome()
    render :text=>"修改明星用户成功！"
  end
  
  def updateSliderImages
    content = ""
    for i in 0..9
      content += params["image#{i}"]+','
    end
    writeFile("#{RAILS_ROOT}/config/userData/sliderImages.txt",content)
    
    expireUserHome()
    render :text=>"修改首页大图列表成功！"
  end
  
  ### 缓存管理 #####################################
  def cacheManage
    @currentHeaderMenu = "homePage"
    @currentSubMenu = "cache"
  end
  
  def clearUserSearchCache
    expireSearch("user")
    render :text=>"住户缓存清理成功！"
  end
  
  def clearPhotoSearchCache
    expireSearch("photo")
    render :text=>"相片缓存清理成功！"
  end
  
  def clearAlbumSearchCache    
    expireSearch("album")
    expireRelatedAlbum()
    render :text=>"相册缓存，相关相册清理成功！"
  end
  
  def clearCommentSearchCache
    expireSearch("comment")
    render :text=>"评论缓存清理成功！"
  end
  
  def clearDownloadSearchCache
    expireSearch("download")
    render :text=>"下载缓存清理成功！"
  end
  
  def clearIndexCache
    expireIndex()
    render :text=>"首页缓存清理成功！"
  end
  
  def clearHomeCache
    expireUserHome()    
    render :text=>"逛逛页缓存清理成功！"
  end
  
  def checkPhotoLastComment
    for photo in Photo.find(:all)
      if not photo.comments.last.nil?
        photo.lastComment_at = photo.comments.last.datetime
      else
        photo.lastComment_at = "null"
      end
      photo.save
    end
    expireSearch("comment")
    render :text=>"照片评论时间核对完毕！"
  end
  
  def checkPhotoFavorAndCommentsCount
    for photo in Photo.find(:all)
      photo.commentsCount = photo.comments.size
      photo.addFavorCount = photo.favorites.size
      photo.save
    end
    expireSearch("comment")
    render :text=>"照片评论和加入收藏数核对完毕！"
  end
  
  def clearSubjectCache
    expireUserHome()
    render :text=>"逛逛页缓存清理成功！"
  end
  ### news mailer #####################################################
  def mailManage
    @currentHeaderMenu = "album"
    @currentSubMenu = "mail"
    
    @expressMails_pages, @expressMails = paginate( :expressmail,:per_page => 20,:order=>"datetime desc")
  end
  
  def addExpressMail
    mail = Expressmail.new(params[:expressmail])
    mail.datetime=Time.now
    
    if mail.save()
      render :text=>"添加成功！"
    else
      render :text=>mail.errors["photoIDs"]
    end
  end
  
  def deleteExpressMail
    Expressmail.destroy(params[:id])
    render :text=>"删除成功！"
  end
  
  def viewExpressMail
    @mail = Expressmail.find(params[:id])
    @photos = @mail.getMailPhotos()
    if params[:lang]=="cn"
      render(:template=>"news_mailer/newsletter_zh",:layout=>false)
    elsif params[:lang]=="en"
      render(:template=>"news_mailer/newsletter_en",:layout=>false)
    end
  end
  
  def sendExpressMail
    mail = Expressmail.find(params[:id])    
    for user in User.all
      NewsMailer.deliver_newsletter(mail,user)
    end
    render :text=>"发送成功"
  rescue Exception => error
    render :text=>"发送失败: "+error
  end
  
  #### vip 用户管理 #################################
  def vipManage
    @currentHeaderMenu = "user"
    @currentSubMenu = "vip"
    
    @vip_pages, @vips = paginate( :vipinfo,:per_page => 20, :include=>:user)
  end
  
  def addToVip
    user = User.find(params[:id])
    user.addToVIP(0)
    
    expireSearch("user")
    render :text=>"#{user.username} 成功成为VIP！"
  end
  
  def editVip
    @vipinfo = Vipinfo.find(params[:id])
    if request.post?
      if @vipinfo.update_attributes(params[:vipinfo])
        @alertMessage="修改成功！<a href='#' onclick='window.close()'>关闭</a>"
      end
    end
    
    render :layout => false
  end
  
  def deleteVip
    Vipinfo.destroy(params[:id])
    render :text=>"删除成功！"
  end
end
