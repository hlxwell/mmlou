class PhotoController < ApplicationController
  before_filter :authorize,:except=>[:view,:list,:upload,:create]
  verify :method => :post,:params=>:id ,:xhr=>true, :only =>[:delete,:updateDescription]

  layout "home"
  require "RMagick"

  def list
    @user=User.find(params[:user_id])
    @user.beViewed
    @title=@user.username
    @desc=@user.username

    if isHost
      @photo_pages, @photos = paginate( :photo,
        :per_page => 9,
        :order => "datetime desc",
        :conditions=>['user_id=?',params[:user_id]])

      render :template=>"/photo/list_host"
    else
      unless read_fragment("/#{getBrowserLanguage()}/user/#{params[:user_id]}/photo/list/#{params[:page]||=1}")
        @photo_pages, @photos = paginate( :photo,
          :per_page => 9,
          :conditions => ["user_id=? and isAuth=1",params[:user_id]],
          :order => "datetime desc")
      end

      render :template=>"/photo/list"
    end
  end

  def view
    @photo=Photo.find(params[:photo_id])

    if params[:format] == 'json'
      render :text => @photo.getSmallImageUrl.to_json
      return
    end

    if (@photo and @photo.isAuth) or isHost
      @user=User.find(params[:user_id])
      @user.beViewed

      #description on the title
      @desc=@user.username
      tags = @photo.Tags
      if tags
        @title=tags+" From "+@photo.album.name
      else
        @title=@photo.album.name
      end

      @prePhoto,@nextPhoto = getPreNextPhoto(@photo)
      @photo.click
    else
      render :text=>l("userIndex_label_photoUnauthed")
    end
  end

  ### 图片下载 ###############################################
  def download
    @photo=Photo.find(params[:photo_id],:include=>"user")

    #vip 用户
    if session[:user].isVIP
      session[:user].vipinfo.downloadPhoto()
      isXsendfile = false
      if isXsendfile
        x_send_file("#{RAILS_ROOT}/public/#{getBigImageUrl(@photo)}",
          :filename => @photo.originalName,
          :type => 'image/jpeg',
          :header => 'X-LIGHTTPD-SEND-FILE',
          :disposition => 'attachment')
      else
        send_file("#{RAILS_ROOT}/public/#{getBigImageUrl(@photo)}",
          :filename => @photo.originalName,
          :type=>'image/jpeg',
          :stream=>false,
          :disposition=>'attachment')
      end
    else #积分用户
      if params[:user_id].to_s != @photo.user_id.to_s
        redirect_to "/#{@photo.user_id.to_s}/photo/downloadBigImage/#{params[:photo_id]}"
      elsif session[:user].point < 1
        @alertMessage=l("ajaxReply_noEnoughPoints")
      else
        downloadPoint=1
        #扣分
        session[:user].minusPoint(downloadPoint)
        #加分
        @photo.user.gainPoint(downloadPoint)
        #@photo.download

        #make a point op log
        log = Pointoplog.new
        log.user_id = session[:user].id
        log.operation = "downloadBigImage"
        log.point = (downloadPoint)
        log.datetime = Time.now
        log.ip = request.remote_ip()
        log.save()

        if isXsendfile
          x_send_file("#{RAILS_ROOT}/public/#{getBigImageUrl(@photo)}",
            :filename => @photo.originalName,
            :type => 'image/jpeg',
            :header => 'X-LIGHTTPD-SEND-FILE',
            :disposition => 'attachment')
        else
          send_file("#{RAILS_ROOT}/public/#{getBigImageUrl(@photo)}",
            :filename => @photo.originalName,
            :type=>'image/jpeg',
            :stream=>false,
            :disposition=>'attachment')
        end
      end
    end
  end

  ### Edit area #############################################
  def delete
    Photo.destroy(params[:id])
    expireUserAllPage(session[:user][:id])
    render :text=>l("ajaxReply_photoDeleteDone")
  rescue
    render :text=>l("ajaxReply_photoDeleteFailed")
  end

  def setPrivate
    Photo.update(params[:id],{:private=>1})
    expireUserAllPage(session[:user][:id])
    render :text=>l("ajaxReply_setDone")
  rescue
    render :text=>l("ajaxReply_setFailed")
  end

  def setPublic
    Photo.update(params[:id],{:private=>0})
    render :text=>l("ajaxReply_setDone")
  rescue
    render :text=>l("ajaxReply_setFailed")
  end

  def updateDescription
    Photo.update(params[:id],:description=>params[:description])
    expireUserAllPage(session[:user][:id])
    render :text=>params[:description]
  end

  def updateTags
    Photo.update(params[:id],:tags=>params[:photo][:tags])
    render :text=>l("ajaxReply_tagsUpdateDone")
  end

  def upload
    ##### 供 Flash 使用 ##############################
    #获得用户所有的相册
    if session[:user]
      if not session[:user].albums.nil?
        albumNames=""
        albumIDs=""
        for album in session[:user].albums
          albumNames+=album.name+","
          albumIDs+=album.id.to_s+","
        end

        #去掉最后的“,”
        albumNames = albumNames.chomp(",");
        albumIDs = albumIDs.chomp(",");
        @albumList="&albums="+albumNames+"&albumIDs="+albumIDs
      end

      #是否加入到新的相册中去
      if not params[:addToNewAlbum].nil?
        @addToNewAlbum="&addToNewAlbum=true"
      end

      #当前使用的相册
      if not params[:currentAlbumID].nil?
        @currentAlbumID="&currentAlbumID="+params[:currentAlbumID]
      end

      #可以使用的空间
      remainedSpace = session[:user].remainedSpace/(@@maxUserSpace/1000)
      @availableSize= "&availableSize="+remainedSpace.to_s
      @remainedSize = remainedSpace
      @maxUserSpace = @@maxUserSpace/(@@maxUserSpace/1000)
    end
    ####################################################
    #当上传文件的时候执行
    file = params[:Filedata]
    if file
      #添加记录 insert the photo info
      newfilename,photo = uploadPhoto(file,params[:albumId],params[:user_id])

      expireUserIndex(params[:user_id])
      expirePhotoList(params[:user_id])

      #把添加了的照片全部加入随机产生的Session
      randomSessionName = session[:sessionName]
      if session[randomSessionName]
        session[randomSessionName]+=newfilename+","
      else
        session[randomSessionName]=newfilename+","
      end

      #garbage clear
      GC.start
    else
      session[:sessionName] = getRandomString(5)
    end

    #if pass the vip password then display uploadVIP view
    if params[:id]==@@uploadVipPassword
      render :template=>"/photo/uploadVIP"
    else
      render :template=>"/photo/upload"
    end
  end

  def create
    file = params[:file]
    if file
      newfilename,photo = uploadPhoto(file,params[:albumId],params[:user_id])
      photo.tags = params[:tags]
      photo.save
      GC.start
      render :text=> 'true'
    else
      render :text=>'false'
    end
  end

  def uploadVIP
    redirect_to("/photo/upload")
  end

  #上传完后的图片修改页
  def editUploaded
    #有上传了图片才能进入
    if session[:sessionName]
      randomSessionName   = session[:sessionName]
      uploadedPhotoNames  = session[randomSessionName].split(",")

      @photos=Array.new
      for photoName in uploadedPhotoNames
        @photos<<Photo.find_by_filename(photoName)
      end
    end
  end

  def batchEdit
    if not session[:sessionName].nil?
      randomSessionName = session[:sessionName]
      if not session[randomSessionName].nil?
        uploadedPhotoNames= session[randomSessionName].split(",")

        #if they uploaded photos with same filename???
        photos=Array.new
        for photoName in uploadedPhotoNames
          photos<<Photo.find_by_filename(photoName)
        end

        #default value
        for photo in photos
          if not photo.update_attributes(params[photo.filename])
            render :text=>l("ajaxReply_photoBatchEditFailed")
          end
        end

        #clear temp session
        session[randomSessionName]=nil
        expireUserAllPage(session[:user][:id])
        render :text=>l("ajaxReply_photoBatchEditDone")
      else
        render :text=>l("ajaxReply_photoBatchEditFailed")
      end
    end
  end
end