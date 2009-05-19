module PhotoHelper
  require 'zip/zip'
  require 'md5'
  
  ### 根据photoIDs获得
  def showPhotosByIDs(photoIDs)
    photos = ""
    for photoID in photoIDs.split(',')
      photo = Photo.find(:first,:conditions=>["id = ?",photoID])
      photos += "<img src='#{getBoxImageUrl(photo)}' style='float:left'>"
    end
    return photos
  end
  
  #### 推广代码 ##################################################
  #获得HTML的推广代码
  def getAlbumHTML(album)    
    html=""
    
    for photo in album.authPhotos
      html+="<img src=http://www.mmlou.com"+getMiddleImageUrl(photo)+" border=0 alt=点击查看大图>"
      
      #add tags      
      tags=photo.tags
      
      if tags #if tags exist
        tags = tags.split(/[,， ]/)
        html+="<br>美眉楼相关Tags："
        for tag in tags
          html+="<a href=http://www.mmlou.com/search/photo/#{tag}>#{tag}</a>  "
        end
      end
      html+="<br>"
    end
    
    #add foot content
    html+="以上图片均来自于<a href=http://www.mmlou.com>www.mmlou.com</a>美眉楼！"
    html+="<br><a href=http://www.mmlou.com><img src=/images/logo.gif border=0></a>"
    
    return html
  end
  
  #获得UBB的推广代码
  def getAlbumUBB(album)
    ubb=""
    
    #add all photo in the album
    for photo in album.authPhotos
      #add img
      ubb+="[align=Left]"
      ubb+="[img]http://www.mmlou.com"+getMiddleImageUrl(photo)+"[/img]"
      ubb+="[/align]"
      
      #add tags
      
      tags=photo.tags
      if tags #if tags exist
        tags = tags.split(/[,， ]/)
        ubb+="[align=Left]"  #this tag will translated to <div>
        ubb+="美眉楼相关Tags："
        for tag in tags
          ubb+="[url=http://www.mmlou.com/search/photo/#{tag}]#{tag}[/url] "
        end
        ubb+="[/align]"
      end      
    end
    
    #add foot content
    ubb+="[align=Left]以上图片均来自于[url=http://www.mmlou.com]www.mmlou.com[/url]美眉楼！[/align]"
    ubb+="[align=Left][url=http://www.mmlou.com][img]http://mmlou.com/images/logo.gif[/img][/url][/align]"
    
    return ubb
  end
  
  #### 打包 ######################################################
  #打包
  def packAlbum(album_id)
    packName = getRandomString+album_id
    album = Album.find(album_id)
    
    Zip::ZipFile.open "#{RAILS_ROOT}/public/packs/#{packName}.zip",Zip::ZipFile::CREATE do |zip|
      for photo in album.authPhotos
        if zip.find_entry(photo.originalName).nil?
          zip.add("From mmlou.com " + photo.originalName, "#{RAILS_ROOT}/public/#{getBigImageUrl(photo)}")
        else
          zip.add("From mmlou.com " + Time.now.strftime("%H%M%S")+photo.originalName, "#{RAILS_ROOT}/public/#{getBigImageUrl(photo)}")
        end
      end
    end
    
    if album.update_attributes(:isPacked=>true,:packName=>"#{packName}.zip")
      return "大图打包成功！" 
    else
      return "大图打包失败！" 
    end
  end
  
  #把压缩包删除
  def unpackAlbum(album_id)
    album=Album.find(album_id)
    
    if album.isPacked
      deleteFile("#{RAILS_ROOT}/public/packs/#{album.packName}") #delete old album zip file
      
      if album.update_attributes(:isPacked=>false,:packName=>"")
        return "删大图包成功！" 
      else
        return "删大图包失败！" 
      end
    end
  end
  
  #打中图的包
  def packMiddleAlbum(album_id)
    packName = "middle_"+getRandomString+album_id
    album = Album.find(album_id)
    
    Zip::ZipFile.open "#{RAILS_ROOT}/public/packs/#{packName}.zip",Zip::ZipFile::CREATE do |zip|
      for photo in album.authPhotos
        if zip.find_entry(photo.originalName).nil?
          zip.add("sexy beautiful girl from mmlou.com " + photo.originalName, "#{RAILS_ROOT}/public/#{getMiddleImageUrl(photo)}")
        else
          zip.add("sexy beautiful girl from mmlou.com " + Time.now.strftime("%H%M%S")+photo.originalName, "#{RAILS_ROOT}/public/#{getMiddleImageUrl(photo)}")
        end
      end
    end
    
    if album.update_attributes(:isMiddlePacked=>1,:middlePackName=>"#{packName}.zip")
      return "中图打包成功！" 
    else
      return "中图打包失败！"
    end
  end
  
  #把中图压缩包删除
  def unpackMiddleAlbum(album_id)
    album=Album.find(album_id)
    
    if album.isMiddlePacked
      deleteFile("#{RAILS_ROOT}/public/packs/#{album.middlePackName}") #delete old album zip file
      
      if album.update_attributes(:isMiddlePacked=>0,:middlePackName=>"")
        return "删除中图包成功！" 
      else
        return "删除中图包失败！" 
      end
    end
  end
  
  #删除文件，给定文件地址和文件名
  def deleteFile(filepath)
    if filepath.length>0
      if File.exist?(filepath)
        File.delete(filepath)
      end
    end
  end
    
  #获得随机字符串
  def getRandomString(length=30)
    chars = 'abcdefghijklmnopqrstuvwxyz0123456789'
    str = ''
    length.downto(1) { |i| str << chars[rand(chars.length - 1)] }
    return str
  end

  #上传图片文件到指定目录
  def uploadFile(file,path)
    filePath = path
    
    File.open(filePath, "wb") do |f|
      f.write(file.read)        
    end
  end
  
  #判断扩展名是否是图片
  def isPhoto(filename)
    ext = File.extname(filename)
    ext = ext.downcase
    if ext==".jpg" or ext==".gif" or ext==".png" or ext==".bmp" or ext==".jpeg"
      return true
    else
      return false
    end
  end
  
  #上传个人头像
  def uploadPersonPortrait(file)
    userPortraitDir="#{RAILS_ROOT}/public/uploads/portrait/"
    oldFilename = session[:user].portrait #for deleting old photo
    
    #有文件上传
    if file.length>0
      filename = File.basename(file.original_filename)
      newFilename = getRandomString+File.extname(filename)
      #是图片?
      if isPhoto(filename)
        #delete old file if the old portrait file is exist
        if oldFilename.length > 0
          deleteFile(userPortraitDir+oldFilename)
        end
        #upload new file
        File.open(userPortraitDir+newFilename,'wb') do |f|
          f.puts file.read
        end
        #generate a thumb
        thumb = Magick::Image.read(userPortraitDir+newFilename).first
        thumb = thumb.crop_resized(52,52)
        thumb.write(userPortraitDir+newFilename)
        GC.start
        return newFilename
      else
        return oldFilename
      end
    else
      return oldFilename
    end
  end
  
  def deletePortrait(user)
    userPortraitDir = "#{RAILS_ROOT}/public/uploads/portrait/"
    portraitFilename = user.portrait #for deleting old photo
    
    #delete old file if the old portrait file is exist
    if portraitFilename.length > 0
      deleteFile(userPortraitDir+portraitFilename)
    end
  end
  
  #上传照片，并且生成小图片
  def uploadPhoto(file,album_id,user_id)
    if file
      ###第一步: 设置新文件名 make a new filename
      fileName    = File.basename(file.original_filename)
      fileExt     = File.extname(file.original_filename).downcase
      newfilename = getRandomString+fileExt
      timeNow = Time.now
      photoUploadDate = timeNow.strftime('%Y%m%d')
      newBigfilename= MD5.new(photoUploadDate).to_s+newfilename
      
      ###第二步: 设置目录 make directory(like 2006-09-14) if it is not exist
      if not File.exist?("#{RAILS_ROOT}/public/uploads/big/#{photoUploadDate}")
        Dir.mkdir("#{RAILS_ROOT}/public/uploads/big/#{photoUploadDate}")
        Dir.mkdir("#{RAILS_ROOT}/public/uploads/middle/#{photoUploadDate}")
        Dir.mkdir("#{RAILS_ROOT}/public/uploads/small/#{photoUploadDate}")
        Dir.mkdir("#{RAILS_ROOT}/public/uploads/thumb/#{photoUploadDate}")
        Dir.mkdir("#{RAILS_ROOT}/public/uploads/box/#{photoUploadDate}")
      end
      newBigFilePath    = "#{RAILS_ROOT}/public/uploads/big/#{photoUploadDate}/#{newBigfilename}"
      newMiddleFilePath = "#{RAILS_ROOT}/public/uploads/middle/#{photoUploadDate}/#{newfilename}"
      newSmallFilePath  = "#{RAILS_ROOT}/public/uploads/small/#{photoUploadDate}/#{newfilename}"
      newThumbFilePath  = "#{RAILS_ROOT}/public/uploads/thumb/#{photoUploadDate}/#{newfilename}"
      newBoxFilePath    = "#{RAILS_ROOT}/public/uploads/box/#{photoUploadDate}/#{newfilename}"
      
      ###第三步: 上传文件 upload big photo
      uploadFile(file,newBigFilePath)

      @middlePicWidth = 500
      @smallPicWidth  = 240
      @thumbPicWidth  = 100
      
      ###第四步: 生成各类小图片
      #生成中图片 make middle photo      
      bigPic = Magick::Image.read(newBigFilePath).first
      
      picFilesize  = File.size(newBigFilePath)
      picWidth     = bigPic.columns
      picHeight    = bigPic.rows
      
      if bigPic.columns.to_i < @middlePicWidth
        #打水印
        watermark = Magick::Image.read("#{RAILS_ROOT}/public/images/watermark.gif").first
        bigPic = bigPic.composite(watermark, Magick::NorthWestGravity, Magick::OverCompositeOp)
        #存盘
        bigPic.write(newMiddleFilePath)
      else
        height = (bigPic.rows*1.00/bigPic.columns*1.00)*@middlePicWidth        
        #生成小图
        bigPic = bigPic.thumbnail(@middlePicWidth,height)
        #打水印
        watermark = Magick::Image.read("#{RAILS_ROOT}/public/images/watermark.gif").first
        bigPic = bigPic.composite(watermark, Magick::NorthWestGravity, Magick::OverCompositeOp)
        #存盘
        bigPic.write(newMiddleFilePath)        
      end
      
      middle = Magick::Image.read(newMiddleFilePath).first
      
      #生成小图片 small photo(edit from newMiddleFilePath)      
      height = (middle.rows*1.00/middle.columns*1.00)*@smallPicWidth
      middle = middle.thumbnail(@smallPicWidth,height)    
      middle.write(newSmallFilePath)
      
      #生成缩略图片 thumb photo(edit from newMiddleFilePath)
      height=(middle.rows*1.00/middle.columns*1.00)*@thumbPicWidth
      middle = middle.thumbnail(@thumbPicWidth,height)    
      middle.write(newThumbFilePath)
      
      #生成方块图,相册封面用的
      box = middle
      box = box.crop_resized(75,75)
      box.write(newBoxFilePath)
      
      #当图片的信息入库
      photo=Photo.new
      photo.filename    = newfilename
      photo.originalName= fileName
      photo.filesize    = picFilesize
      photo.width       = picWidth
      photo.height      = picHeight
      photo.album_id    = album_id
      photo.user_id     = user_id
      photo.datetime    = timeNow
      photo.save
      return newfilename,photo
    end
  end
  
  #删除照片
  def deletePhotoFile(photo)    
    bigPath = "#{RAILS_ROOT}/public/uploads/big/#{photo.datetime.strftime('%Y%m%d')}/"+MD5.new(photo.datetime.strftime('%Y%m%d')).to_s+photo.filename
    middlePath = "#{RAILS_ROOT}/public/uploads/middle/#{photo.datetime.strftime('%Y%m%d')}/"+photo.filename
    smallPath = "#{RAILS_ROOT}/public/uploads/small/#{photo.datetime.strftime('%Y%m%d')}/"+photo.filename
    thumbPath = "#{RAILS_ROOT}/public/uploads/thumb/#{photo.datetime.strftime('%Y%m%d')}/"+photo.filename
    boxPath = "#{RAILS_ROOT}/public/uploads/box/#{photo.datetime.strftime('%Y%m%d')}/"+photo.filename
        
    deleteFile(bigPath)
    deleteFile(middlePath)
    deleteFile(smallPath)
    deleteFile(thumbPath)
    deleteFile(boxPath)
  end
  
  #获得个人头像图片url
  def getPortraitImageUrl(user)
    if not user.portrait.nil? and user.portrait.length>0
      return '/uploads/portrait/'+user.portrait
    else    
      return '/images/default_buddy_icon.jpg'
    end
  end
  
  #获得小图片url
  def getSmallImageUrl(photo)
    return '/uploads/small/'+photo.datetime.strftime('%Y%m%d')+'/'+photo.filename
  end
  
  #获得中图片url
  def getMiddleImageUrl(photo)
    return '/uploads/middle/'+photo.datetime.strftime('%Y%m%d')+'/'+photo.filename
  end
  
  #获得大图url
  def getBigImageUrl(photo)
    return '/uploads/big/'+photo.datetime.strftime('%Y%m%d')+'/'+MD5.new(photo.datetime.strftime('%Y%m%d')).to_s+photo.filename
  end
  
  #获得缩略图url
  def getThumbImageUrl(photo)
    return '/uploads/thumb/'+photo.datetime.strftime('%Y%m%d')+'/'+photo.filename
  end
  
  #获得方格图url
  def getBoxImageUrl(photo)
    if not photo.nil?
      return '/uploads/box/'+photo.datetime.strftime('%Y%m%d')+'/'+photo.filename
    else
      return "/images/default_set_photo.gif"
    end
  end
  
  #获得相册封面图url
  def getAlbumCover(album,type=0)
    if album.cover
      case type
        when 0
          getBoxImageUrl(album.cover)      
        when 1
          getSmallImageUrl(album.cover)
        when 2
          getMiddleImageUrl(album.cover)   
        when 3
          getBigImageUrl(album.cover)
        else
          getBoxImageUrl(album.cover)
      end
    elsif isHost and album.allPhotos.size>0
      case type
        when 0
          getBoxImageUrl(album.allPhotos[0])      
        when 1
          getSmallImageUrl(album.allPhotos[0])
        when 2
          getMiddleImageUrl(album.allPhotos[0])   
        when 3
          getBigImageUrl(album.allPhotos[0])
        else
          getBoxImageUrl(album.allPhotos[0])
      end
    elsif not isHost and album.authPhotos.size>0
      case type
        when 0
          getBoxImageUrl(album.authPhotos[0])      
        when 1
          getSmallImageUrl(album.authPhotos[0])
        when 2
          getMiddleImageUrl(album.authPhotos[0])   
        when 3
          getBigImageUrl(album.authPhotos[0])
        else
          getBoxImageUrl(album.authPhotos[0])
      end
    else
      return "/images/default_set_photo.gif"
    end
  end
  
  def getPreNextPhoto(curPhoto)
    if isHost or session[:admin]
      #当前照片的位置
      curPosition = curPhoto.album.allPhotos.index(curPhoto)
      #获得总共有的位置
      totalPositions = curPhoto.album.allPhotos.size-1
      
      if curPosition == 0
        return nil,curPhoto.album.allPhotos[1]
      elsif curPosition == totalPositions
        return curPhoto.album.allPhotos[totalPositions-1],nil
      else
        return curPhoto.album.allPhotos[curPosition-1],curPhoto.album.allPhotos[curPosition+1]
      end
    else
      curPosition = curPhoto.album.authPhotos.index(curPhoto)
      totalPositions = curPhoto.album.authPhotos.size-1
      
      if curPosition == 0
        return nil,curPhoto.album.authPhotos[1]
      elsif curPosition == totalPositions
        return curPhoto.album.authPhotos[totalPositions-1],nil
      else
        return curPhoto.album.authPhotos[curPosition-1],curPhoto.album.authPhotos[curPosition+1]
      end
    end
  end
end