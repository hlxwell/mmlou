class FriendController < ApplicationController
  before_filter :authorize,:except=>[:list,:add]
  verify :method => :post,:params=>:friend_id ,:xhr=>true, :only =>[:delete]
  
  layout "home"
  
  def list
    @user  = User.find(params[:user_id])
    @user.beViewed    
    @title = @user.username
    
    @friend_pages, @friends = paginate( :friend,
                                        :conditions=>["user_id = ?",params[:user_id]],
                                        :per_page => 18)
  end

  def add
    if request.post?
      if not session[:user]
        render :text=>l("ajaxReply_loginFirst")
      else
        @friend = Friend.new
        @friend.friend_id  = params[:friend_id]   
        @friend.user_id   = session[:user].id
        @friend.datetime  = Time.now
  
        if @friend.save
          render :text=>l("ajaxReply_addToFriendDone")
        else
          render :text=>@friend.errors["friend_id"]
        end
      end
    end
  rescue
    render :text=>l("ajaxReply_addToFriendFailed")
  end

  def delete
    if request.post?
      Friend.destroy_all(["user_id=? and friend_id=?",session[:user].id,params[:friend_id]])
      render :text=>l("ajaxReply_deleteFriendDone")
    end
  rescue
    render :text=>l("ajaxReply_deleteFriendFailed")
  end
end
