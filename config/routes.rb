ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up ''
  # -- just remember to delete public/index.html.
  map.connect '', :controller => "index"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  # map.error ':controllername',  :controller => 'index',:action => 'index'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action/:id'

  #转定向为了就是传两个值不使用问号
  map.connect '/user/login.:format',:controller=>'user',:action=>'login'
  
  map.connect '/:user_id/album/storyView/:album_id',:controller=>'album',:action=>'storyView'
  map.connect '/:user_id/album/view/:album_id',:controller=>'album',:action=>'view'
  map.connect '/:user_id/album/view/:album_id.:format',:controller=>'album',:action=>'view'
  map.connect '/:user_id/album/batchEditPhotos/:album_id',:controller=>'album',:action=>'batchEditPhotos'
  map.connect '/:user_id/album/simpleView/:album_id',:controller=>'album',:action=>'simpleView'
  map.connect '/:user_id/album/download/:album_id',:controller=>'album',:action=>'download'
  map.connect '/:user_id/photo/download/:photo_id',:controller=>'photo',:action=>'download'
  map.connect '/:user_id/photo/view/:photo_id',:controller=>'photo',:action=>'view'
  map.connect '/:user_id/photo/view/:photo_id.:format',:controller=>'photo',:action=>'view'
  map.connect '/:user_id/comment/list/',:controller=>'comment',:action=>'list'
  map.connect '/:user_id/album/list/',:controller=>'album',:action=>'list'
  map.connect '/:user_id/album/list.:format',:controller=>'album',:action=>'list'
  map.connect '/:user_id/photo/list/',:controller=>'photo',:action=>'list'
  map.connect '/:user_id/favorite/list/',:controller=>'favorite',:action=>'list'
  map.connect '/:user_id/friend/list/',:controller=>'friend',:action=>'list'
  map.connect '/:user_id/popular/photo',:controller=>'popular',:action=>'photo'
  map.connect '/:user_id/popular/album',:controller=>'popular',:action=>'album'
  map.connect '/:user_id/popular/mostFavorite',:controller=>'popular',:action=>'mostFavorite'
  map.connect '/:user_id/popular/mostComment',:controller=>'popular',:action=>'mostComment'
  map.connect '/:user_id/user/index',:controller=>'user',:action=>'index'
  map.connect '/:user_id/user/profile',:controller=>'user',:action=>'profile'
end
