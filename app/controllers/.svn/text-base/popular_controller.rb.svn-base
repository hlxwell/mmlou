class PopularController < ApplicationController
    layout "home"
  
    def photo
        @user  = User.find(params[:user_id])
        @user.beViewed
        @title = @user.username
    
        @photo_pages,@photos = paginate(:photo,
            :per_page => 10,
            :conditions => ["isAuth = 1 and user_id = ?", params[:user_id]],
            :order => "clickCount desc")
    end

    def album
        @user  = User.find(params[:user_id])
        @user.beViewed
        @title = @user.username
        @album_pages,@albums = paginate(:album,
            :per_page => 10,
            :conditions => ["user_id = ?", params[:user_id]],
            :order => "clickCount desc")
    end

    def mostFavorite
        @user  = User.find(params[:user_id])
        @user.beViewed
        @title = @user.username
    
        @photo_pages,@photos = paginate(:photo,
            :per_page => 10,
            :conditions => ["isAuth = 1 and user_id = ?", params[:user_id]],
            :order => "addFavorCount desc")
    end

    def mostComment
    

        @user  = User.find(params[:user_id])
        @user.beViewed
        @title = @user.username
    
        @photo_pages,@photos = paginate(:photo,
            :per_page => 10,
            :conditions => ["isAuth = 1 and user_id = ?", params[:user_id]],
            :order => "commentsCount desc")
    end
end
