class Photo < ActiveRecord::Base
  include ApplicationHelper
  
  belongs_to :album
  belongs_to :user
  has_many :comments,
           :dependent=>:destroy
           
  has_many :favorites,
           :dependent=>:destroy
           
  def self.allAuthPhotos
    Photo.find(:all,:conditions=>["isAuth=true"],:order=>"datetime desc")
  end
  
  def allCommentNum
    Comment.count("id",:conditions=>["photo_id = ?",self.id])
  end
  
  def Tags
    if self.tags #if tags exist
      returnValue = ""
      for tag in self.tags.split(/[,， ]/)
        if tag.length > 0
          returnValue+=tag+","
        end
      end
      return returnValue.chomp(",")
    else
      return ""
    end
  end
  
  def isPrivate
    if self.private == 0
      return false
    elsif self.private == 1
      return true
    else
      return false
    end    
  end
  
  def click
    self.clickCount+=1
    self.save()
  end
  
  #评论和加入收藏的数量操作
  def addCommentsCount
    self.commentsCount+=1
    self.save()
  end
  
  def minusCommentsCount
    if self.commentsCount > 0
      self.commentsCount-=1
      #如果没有评论了
      if self.commentsCount == 0
        self.lastComment_at = "null"
      end
      self.save()
    end
  end
  
  def addAddFavorCount
    self.addFavorCount+=1
    self.save()
  end
  
  def minusAddFavorCount
    if self.addFavorCount > 0
      self.addFavorCount-=1
      self.save()
    end
  end
  
  def before_destroy
    deletePhotoFile(self)
  end
  
  #获得小图片url
  def getSmallImageUrl()
    return '/uploads/small/'+self.datetime.strftime('%Y%m%d')+'/'+self.filename
  end
  
  #获得中图片url
  def getMiddleImageUrl()
    return '/uploads/middle/'+self.datetime.strftime('%Y%m%d')+'/'+self.filename
  end
  
  #获得大图url
  def getBigImageUrl()
    return '/uploads/big/'+self.datetime.strftime('%Y%m%d')+'/'+MD5.new(self.datetime.strftime('%Y%m%d')).to_s+self.filename
  end
  
  #获得缩略图url
  def getThumbImageUrl()
    return '/uploads/thumb/'+self.datetime.strftime('%Y%m%d')+'/'+self.filename
  end
  
  #获得方格图url
  def getBoxImageUrl()
    if not photo.nil?
      return '/uploads/box/'+self.datetime.strftime('%Y%m%d')+'/'+self.filename
    else
      return "/images/default_set_photo.gif"
    end
  end
  
  ### 获得照片相关的相册
  def getRelatedAlbums()
    if self.tags #if tags exist
      tags = self.tags.split(/[,， ]/)
      conditions=""
      for tag in tags
        if tag.size > 1
          conditions+="name like \"%#{tag}%\" or "
        end
      end
      conditions = conditions.chomp(" or ")
      
      if conditions.size > 1
        return Album.find(:all,:conditions=>conditions,:order=>"datetime desc")
      else
        return nil
      end
    else
      return nil
    end
  end
end
