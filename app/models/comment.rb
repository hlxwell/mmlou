class Comment < ActiveRecord::Base
  belongs_to :photo
  belongs_to :user
  belongs_to :commentator,
             :class_name=>"User",
             :foreign_key => "commentator_id"
             
  validates_presence_of :content,
                        :message => "- "+l("validate_enterCommentContent")

  def after_create          
    self.photo.addCommentsCount
  end
  
  def after_destroy
    self.photo.minusCommentsCount
  end
end