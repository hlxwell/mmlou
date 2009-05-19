class AlbumcommentController < ApplicationController
  before_filter :authorize,:except=>[:create]
  verify :method => :post,:params=>:id ,:xhr=>true, :only =>[:delete]

  layout "home"
  
  def create
    if request.post?
      if session[:user]
        @result=false
        @album_id=params[:comment][:album_id]
        @comment = Albumcomment.new(params[:comment])
        @comment.commentator_id=session[:user].id
        @comment.user_id=params[:comment][:user_id]
        @comment.datetime=Time.now
        
        if @comment.save
          @result=true
          @alertMessage=l("ajaxReply_commentDone")
        else
          @alertMessage=l("ajaxReply_commentFailed")
        end
        
        #发送邮件通知有新评论了
        if not isHost(params[:comment][:user_id])
          owner = User.find(params[:comment][:user_id])
          owner.sendAlertMail("你的相册有新评论了，请查看！New comment on your photo! <a href='http://mmlou.com/#{@comment.user_id}/album/view/#{params[:comment][:album_id]}'><b>立即前往查看 Go and CHeck</b></a>")
        end
        
        render :text=>@alertMessage
      else
        render :text=>"false"
      end
    end
  end
  
  def delete
    Albumcomment.destroy(params[:id])    
          
    render :text=>l("ajaxReply_commentDeleteDone")
  rescue
    render :text=>l("ajaxReply_commentDeleteFailed")
  end
end
