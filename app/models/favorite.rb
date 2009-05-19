class Favorite < ActiveRecord::Base
  belongs_to :user,
             :foreign_key => "user_id"
             
  belongs_to :owner,
             :class_name=>"User",
             :foreign_key => "owner_id"
             
  belongs_to :photo
  
  validates_uniqueness_of :photo_id, 
                          :scope => "user_id", 
                          :message=> l("validate_existInFavorite")

  def after_create   
    self.photo.addAddFavorCount
  end
  
  def after_destroy
    self.photo.minusAddFavorCount
  end
end
