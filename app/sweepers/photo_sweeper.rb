class PhotoSweeper < ActionController::Caching::Sweeper
  observe Photo
  
  def after_destroy(photo)
    expire_cache_for(photo)
  end

  def expire_cache_for(photo)
    expire_fragment(:controller => 'photo', :action => 'view', :user_id=>photo.user_id ,:photo_id => photo.id,:superView=>true )
    expire_fragment(:controller => 'photo', :action => 'view', :user_id=>photo.user_id ,:photo_id => photo.id,:superView=>false )
  end
end