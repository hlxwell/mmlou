class Tag < ActiveRecord::Base
  validates_uniqueness_of :tagName, :message => l("validate_tagExist")
  validates_presence_of :coverPhoto_id, :message => l("validate_enterTagCover")
    
  belongs_to :cover,
             :class_name=>"Photo",
             :foreign_key=>"coverPhoto_id"
  
  def self.updateCount
    for tag in Tag.find(:all)
      tag.referedPhotos=Photo.count("isAuth=1 and tags like '%#{tag.tagName}%'")
      tag.referedAlbums=Album.count("name like '%#{tag.tagName}%'")
      tag.save
    end
  end
  
  def self.all
    return Tag.find(:all)
  end
end
