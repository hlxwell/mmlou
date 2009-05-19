class TagController < ApplicationController
  layout "home"
  
  def subject
    

    unless read_fragment(:action=>"subject",:id=>params[:id],:page=>params[:page]||="1",:commentPage=>params[:commentPage]||="1",:lang=>getBrowserLanguage())
      if params[:id]
        @title = params[:id]+l("common_label_subject")
        #相片TOP5
        @topPhotos = Photo.find(:all,:conditions=>["tags like ?",'%'+params[:id]+'%'],:order=>"clickCount desc",:limit=>5)
        #相册TOP5
        @topAlbums = Album.find(:all,:conditions=>["name like ?",'%'+params[:id]+'%'],:order=>"clickCount desc",:limit=>5)
        #所有内容
        @photo_pages, @photos = paginate(:photo,
                                         :per_page => 24,
                                         :conditions => ["tags like ?", '%'+params[:id]+'%'])
        @commentedPhoto_pages,@commentedPhotos = paginate(:photo,
                                                          :per_page => 5, 
                                                          :conditions => ["lastComment_at != 0 and tags like ?", '%'+params[:id]+'%'],
                                                          :order => "lastComment_at desc",
                                                          :parameter => "commentPage")
      else
        redirect_to "/tag/index"
      end
    end
  end
end