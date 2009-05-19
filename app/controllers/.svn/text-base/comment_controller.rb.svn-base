class CommentController < ApplicationController
  before_filter :authorize,:except=>[:list,:create]
  verify :method => :post,:params=>:id ,:xhr=>true, :only =>[:delete]
  
  layout "home"
  
  def list
    

    @user  = User.find(params[:user_id])
    @user.beViewed    
    @title = @user.username
    @desc = @user.username
    
    @commentedPhoto_pages,@commentedPhotos = paginate(:photo,
                                                      :per_page => 5, 
                                                      :conditions => ["lastComment_at != 0 and user_id = ?", params[:user_id]],
                                                      :order => "lastComment_at desc")
  end
  
  def create
    if request.post?
      if params[:isAuth]=="false"
        render :text=>"unAuth"
      elsif not session[:user]
        render :text=>"unLogin"
      else
        @comment = Comment.new(params[:comment])
        @comment.commentator_id=session[:user].id
        @comment.datetime=Time.now
        @comment.photo.lastComment_at = Time.now
        
        @comment.photo.save()
        
        if @comment.save        
          #清除缓存
          expireSearch("comment")  
          #发送邮件通知有新评论了          
#          if not isHost(@comment.user_id)
#            @comment.user.sendAlertMail("你的相片有新评论了，请查看！New comment on your photo!<a href='http://mmlou.com/#{@comment.user_id}/photo/view/#{params[:comment][:photo_id]}'><b>立即前往查看 Go and Check</b></a>")
#          end
          session[:user].addPoint(1)
          render :text=>l("ajaxReply_commentDone")
        else
          render :text=>l("ajaxReply_commentFailed")
        end
      end
    end
  rescue
    render :text=>l("ajaxReply_commentDone")
  end
  
  def delete
    Comment.destroy(params[:id])
    #清除缓存
    expireSearch("comment")
    
    render :text=>l("ajaxReply_commentDeleteDone")
  rescue
    render :text=>l("ajaxReply_commentDeleteFailed")
  end
end