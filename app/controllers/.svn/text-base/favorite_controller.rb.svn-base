class FavoriteController < ApplicationController
  before_filter :authorize,:except=>[:list,:addToFavorite]
  verify :method => :post,:params=>:id ,:xhr=>true, :only =>[:delete]
  
  layout "home"
  
  def list
    

    @user  = User.find(params[:user_id])
    @user.beViewed    
    @title = @user.username
    @desc = @user.username
    
    @favorite_pages,@favorites = paginate(:favorite,
                                          :per_page => 18, 
                                          :conditions => ["user_id = ?", params[:user_id]],
                                          :order => "datetime desc")
  end
  
  def delete
    Favorite.destroy(params[:id])
    render :text=>l("ajaxReply_favoriteDeleteDone")
  rescue Exception=>e
    render :text=>l("ajaxReply_favoriteDeleteFailed")+e
  end
  
  def addToFavorite
    if request.post?
      if params[:isAuth]=="false"
        render :text=>l("ajaxReply_unauthedPhotoCannotAddToFavor")
      elsif not session[:user]
        render :text=>l("ajaxReply_loginFirst")
      else
        @favorite = Favorite.new
        @favorite.photo_id  = params[:photo_id]   
        @favorite.user_id   = session[:user].id
        @favorite.owner_id  = params[:owner_id]
        @favorite.datetime  = Time.now

        if @favorite.save
          render :text=>l("ajaxReply_addToFavoriteDone")
        else
          render :text=>@favorite.errors["photo_id"]
        end
      end
    end
  rescue
    render :text=>l("ajaxReply_addToFavoriteFailed")
  end
end
