class Expressmail < ActiveRecord::Base
  validates_presence_of :photoIDs, :message => l("validate_requireAlbumID")
  
  def getMailPhotos()
    photos = Array.new
    for photoID in self.photoIDs.split(',')
      photos << Photo.find(:first,:conditions=>["id = ?",photoID])
    end
    return photos
  end
end