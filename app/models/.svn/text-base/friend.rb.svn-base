class Friend < ActiveRecord::Base
  belongs_to :user,
             :foreign_key=>"friend_id"
             
  validates_uniqueness_of :friend_id, 
                          :scope => "user_id", 
                          :message=>l("validate_alreadyBeFriend")
end
