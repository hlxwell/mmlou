class AlbumController < ApplicationController
  before_filter :authorize,:except=>[:view,:storyView,:list,:simpleView,:only_create]
  verify :method => :post,:params=>:id ,:xhr=>true, :only =>[:delete,:setCover,:editPhotos]

  layout "home",:except=>[:simpleView]

  def list
    @start = Time.now #计算页面处理时间

    @user=User.find(params[:user_id])
    @user.beViewed
    @title=@user.username
    @desc=@user.username

    if params[:format] == 'json'
      render :text => @user.albums.map(&:cover_url).to_json
      return
    end

    if isHost
      @album_pages, @albums = paginate(:album,
        :per_page => 18,
        :conditions => ["user_id = ?", params[:user_id]])
      render :template=>"/album/list_host"
    else
      if not read_fragment("/#{getBrowserLanguage()}/user/#{params[:user_id]}/album/list/page_#{params[:page]||=1}")
        @album_pages, @albums = paginate(:album,
          :per_page => 18,
          :conditions => ["user_id = ?", params[:user_id]])
      end
      render :template=>"/album/list"
    end
  end

  def view
    @start = Time.now #计算页面处理时间

    @user  = User.find(params[:user_id])
    @user.beViewed
    @album = Album.find(params[:album_id])
    @album.click unless params[:page] #点击下一页不算访问一次
    @title=@album.name
    @desc=@user.username

    #if isHost or not read_fragment(:action=>"view",:album_id=>params[:album_id],:user_id=>params[:user_id],:page=>params[:page]||="1",:lang=>getBrowserLanguage())
    if isHost
      @photo_pages, @photos = paginate(:photo,
        :per_page => 9,
        :conditions => ["album_id =?",params[:album_id]])
      render :template=>"/album/view_host"
    else
      unless read_fragment("/#{getBrowserLanguage()}/user/#{params[:user_id]}/album/view/#{params[:album_id]}/page/#{params[:page]||=1}")
        @photo_pages, @photos = paginate(:photo,
          :per_page => 9,
          :conditions => ["isAuth=1 and album_id =?", params[:album_id]])
      end
      render :template=>"/album/view"
    end
  end

  def storyView
    @start = Time.now #计算页面处理时间

    @user   = User.find(params[:user_id])
    @user.beViewed
    @album  = Album.find(params[:album_id])
    @album.click unless params[:page]
    @desc=@user.username
    @title=@album.name

    if isHost
      @photo_pages, @photos = paginate(:photo,
        :per_page => 5,
        :conditions => ["album_id = ?", params[:album_id]])

      render :template=>"/album/storyView_host"
    else
      if not read_fragment("/#{getBrowserLanguage()}/user/#{params[:user_id]}/album/storyView/#{params[:album_id]}/page/#{params[:page]||=1}")
        @photo_pages, @photos = paginate(:photo,
          :per_page => 5,
          :conditions => ["isAuth=1 and album_id = ?", params[:album_id]])

        render :template=>"/album/storyView"
      end
    end
  end

  def simpleView
    @user  = User.find(params[:user_id])
    @user.beViewed
    @album = Album.find(params[:album_id])
    @desc=@user.username
    @title=@album.name

    @photo_pages, @photos = paginate(:photo,
      :per_page => 9,
      :conditions => ["album_id = ? and isAuth=1", params[:album_id]])
  end

  ### 下载 ###################################################
  def download
    @album=Album.find(params[:album_id],:include=>"user")

    if params[:user_id].to_s != @album.user_id.to_s
      redirect_to "/#{@album.user_id.to_s}/album/download/#{params[:album_id]}"
    elsif session[:user].point < @album.downloadPoint
      @alertMessage=l("ajaxReply_noEnoughPoints")
    else
      downloadPoint=@album.downloadPoint
      #税点为5分之一
      tax=downloadPoint/5
      #扣分
      session[:user].minusPoint(downloadPoint)
      #加分
      @album.user.gainPoint(downloadPoint-tax)
      @album.download

      #make a point op log
      log = Pointoplog.new
      log.user_id = session[:user].id
      log.operation = "download"
      log.point = (downloadPoint-tax)
      log.datetime = Time.now
      log.ip = request.remote_ip()
      log.save()

      isXsendfile = false
      if isXsendfile
        x_send_file("#{RAILS_ROOT}/public/packs/#{@album.packName}",
          :filename => "#{Time.now.strftime('%Y%m%d')}_from_mmLou.zip",
          :type => 'application/zip',
          :header => 'X-LIGHTTPD-SEND-FILE',
          :disposition => 'attachment')
      else
        send_file("#{RAILS_ROOT}/public/packs/#{@album.packName}",
          :filename => "#{Time.now.strftime('%Y%m%d')}_from_mmLou.zip",
          :type=>'application/zip',
          :stream=>false,
          :disposition=>'attachment')
      end
    end
  end

  ###Edit zone################################################
  def delete
    Album.destroy(params[:id])
    expireUserAllPage(session[:user][:id])

    render :text=>l("ajaxReply_albumDeleteDone")
  rescue
    retried = false
    if retried
      render :text=>l("ajaxReply_albumDeleteFailed")
    else
      retried = true
      retry
    end
  end

  def create
    @title=l("constValue_CreateAlbum")

    if request.post?
      @album = Album.new(params[:album])
      @album.datetime = Time.now
      @album.user_id  = session[:user][:id]

      if @album.save
        @result=true
        expireUserAllPage(session[:user][:id])

        @alertMessage=l("ajaxReply_albumCreateDone")
      else
        @result=false
        @alertMessage=l("ajaxReply_albumCreateFailed")
      end
    end
  end

  def only_create
    if request.post?
      @exist_album = Album.find_by_name(params[:album][:name])

      if @exist_album
        render :text => @exist_album.id.to_s
      else
        @album = Album.new(params[:album])
        @album.datetime = Time.now
        @album.user_id  = params[:album][:user_id]||session[:user][:id]

        if @album.save
          render :text => @album.id.to_s
        else
          render :text => '0'
        end
      end
    end
  end

  def setCover
    if params[:isAuth]
      Album.update(params[:id],{:coverPhoto_id => params[:photoID]})
      expireUserAllPage(session[:user][:id])

      render :text=>"true"
    else
      render :text=>"false"
    end
  end

  def edit
    @title = session[:user].username
    @album = Album.find(params[:id])

    if request.post?
      if @album.update_attributes(params[:album])
        @result=true
        @alertMessage=l("ajaxReply_albumEditDone")
        expireUserAllPage(session[:user][:id])

        @redirect_url = url_for({:controller=>:album,:action=>:view,:user_id=>session[:user].id,:album_id=>params[:album][:id]}) #"/#{session[:user].id}/album/view/#{params[:album][:id]}"
      else
        @result = false
        @alertMessage=l("ajaxReply_albumEditFailed")
      end
    end
  end

  def batchEditPhotos
    @album = Album.find(params[:album_id])
    @photos = Photo.find(:all,:conditions=>["album_id=?",params[:album_id]],:order=>"datetime desc")
  end

  def editPhotos
    if request.post?
      @album = Album.find(params[:id])
      for photo in @album.allPhotos
        if not photo.update_attributes(params[photo.id.to_s])
          render :text=>l("ajaxReply_photoBatchEditFailed")
        end
      end
      render :text=>l("ajaxReply_photoBatchEditDone")
    end
  rescue Exception=>e
    render :text=>l("ajaxReply_photoBatchEditFailed")+e
  end
end