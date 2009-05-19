class Albumcomment < ActiveRecord::Base
  belongs_to :album
  belongs_to :commentator,
             :class_name=>"User",
             :foreign_key => "commentator_id"
  
  validates_presence_of :content,
                        :message => "- "+l("validate_enterCommentContent"),
                        :on=>:create
end