class Album < ActiveRecord::Base  
  include ApplicationHelper
  
  belongs_to :user
  
  has_many :allPhotos,
           :class_name=>"Photo",
           :dependent=>:destroy

  has_many :authPhotos,
           :class_name=>"Photo",
           :conditions=>"isAuth=1"

  has_many :comments,
           :class_name=>"Albumcomment",
           :dependent=>:destroy,
           :order=>"datetime asc"

  belongs_to :cover,
             :class_name=>"Photo",
             :foreign_key=>"coverPhoto_id"

  ###### vertify ###########################################
  validates_presence_of :name,
                        :message => "- "+l("validate_enterAlbumName")
  
  validates_inclusion_of  :downloadPoint,
                          :in => [5,10,15,20,25,30],
                          :message => "- "+l("validate_albumDownloadPoint"),
                          :on => :update
                          
  validates_numericality_of :downloadPoint, 
                            :only_integer => true,
                            :message => "- "+l("validate_requireNumber"),
                            :on => :update
  
  def cover_url
    if cover.nil?
      allPhotos.first.getSmallImageUrl
    else
      cover.getSmallImageUrl
    end
  end
  
  def before_destroy
    #删除压缩包
    if self.isPacked
      deleteFile("#{RAILS_ROOT}/public/packs/#{self.packName}")
    end
    
    if self.isMiddlePacked
      deleteFile("#{RAILS_ROOT}/public/packs/#{self.middlePackName}")
    end
  end
  
  def allPhotoNum
    Photo.count("id",:conditions=>["album_id = ?",self.id])
  end
  
  def allAuthPhotoNum
    Photo.count("id",:conditions=>["isAuth = 1 and album_id = ?",self.id])
  end
  
  def allCommentNum
    Albumcomment.count("id",:conditions=>["album_id = ?",self.id])
  end
  
  def click
    self.clickCount+=1
    Album.update(self.id,{:clickCount=>self.clickCount})
  end
  
  def download
    self.downloadCount+=1
    self.save()
  end
  
  def auth?
    return self.allPhotos.size == self.authPhotos.size
  end
end
