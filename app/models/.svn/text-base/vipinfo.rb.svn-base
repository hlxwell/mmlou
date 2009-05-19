class Vipinfo < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :user_id,
                          :on => :create,
                          :message => l("validate_vipExist")
                          
  def status
    if self.isTimeout
      return l("common_label_timeout")
    else
      return l("common_label_normal")
    end
  end
  
  def isTimeout
    if self.end_at > Time.now and Time.now > self.start_at
      return false
    else
      return true
    end
  end
  
  def downloadPhoto
    self.photoDownloadCount += 1
    self.save
  end
  
  def downloadAlbum
    self.albumDownloadCount += 1
    self.save
  end
end
