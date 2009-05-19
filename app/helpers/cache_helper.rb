module CacheHelper
  def expireUserHome
    expire_fragment(%r{/*/user/home})
  end
  
  def expireSearch(type="all")
    case type
      when "all"
        expire_fragment(%r{/*/search/*})
      when "user"
        expire_fragment(%r{/*/search/user/*})
        expire_fragment(%r{/*/user/*})
      when "photo"
        expire_fragment(%r{/*/search/photo/*})
      when "album"
        expire_fragment(%r{/*/search/album/*})
      when "download"
        expire_fragment(%r{/*/search/download/*})
      when "comment"
        expire_fragment(%r{/*/search/comment/*})
      else
        expire_fragment(%r{/*/search/*})
    end
  end
  
  def expireIndex
    expire_fragment(%r{/*/index})
  end

  def expireTag
    expire_fragment(%r{/*/subjectTags})
    expire_fragment(%r{/*/search/albumTags})
    expire_fragment(%r{/*/search/photoTags})    
  end
  
  def expireRelatedAlbum
    expire_fragment(%r{/*/photo/relatedAlbum/*})
  end
  
  #### User Information ##################################  
  #def expirePhotoView(user_id,photo_id)
  #  expire_fragment(%r{/*/user/#{user_id}/photo/view/#{photo_id}/*})
  #end
  
  def expireUserAllPage(user_id)
    expire_fragment(%r{/*/user/#{user_id}/*})
  end
  
  def expirePhotoList(user_id)
    expire_fragment(%r{/*/user/#{user_id}/photo/list/*})
  end
  
  def expireAlbumList(user_id)
    expire_fragment(%r{/*/user/#{user_id}/album/list/*})
  end
  
  def expireAllMoreAlbum(user_id)
    expire_fragment(%r{/*/user/#{user_id}/album/view/*/*})
  end
    
  def expireAlbumView(user_id,album_id)
    expire_fragment(%r{/*/user/#{user_id}/album/view/#{album_id}/page/*})
  end
  
  def expireUserIndex(user_id)
    expire_fragment(%r{/*/user/#{user_id}/index/*})
  end
  
  def expireUserHeaderMenu(user_id)
    expire_fragment(%r{/*/user/#{user_id}/userHeaderMenu*})
  end
end
