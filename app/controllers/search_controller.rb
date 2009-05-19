class SearchController < ApplicationController
  layout "home"
  
  #caches_page :photo,:comment,:album
  #caches_action :photo
  
  def comment
    @start = Time.now #计算页面处理时间
    unless read_fragment(:action=>"comment",:page=>params[:page]||="1",:lang=>getBrowserLanguage())                                          
      @commentedPhoto_pages,@commentedPhotos = paginate(:photo,
                                                        :per_page => 5, 
                                                        :conditions => ["lastComment_at != 0"],
                                                        :order => "lastComment_at desc")
    end
  end
  
  def photo
    @start = Time.now #计算页面处理时间
    unless read_fragment(:action=>"photo",:id=>params[:id]||="",:page=>params[:page]||="1",:lang=>getBrowserLanguage())
      keyword = params[:id]||=''
      @title = keyword+l("constValue_photoSearchResult")
      @photoSize = Photo.count("id",:conditions=>["isAuth = true and tags like ?",'%'+keyword+'%'])
      @photo_pages, @photos = paginate( :photo,
                                        :per_page => 36,
                                        :select=>"id,user_id,filename,datetime,tags,isAuth,description",
                                        :conditions => ["isAuth = true and tags like ?",'%'+keyword+'%'],
                                        :order => "datetime desc")
    end
  end
  
  def album
    @start = Time.now #计算页面处理时间
    unless read_fragment(:action=>"album",:id=>params[:id]||="",:page=>params[:page]||="1",:lang=>getBrowserLanguage())
      keyword = params[:id]||=''
      @title = keyword+l("constValue_albumSearchResult")
      
      @albumSize = Album.count("id",:conditions=>["name like ?",'%'+keyword+'%'])
      @album_pages, @albums = paginate( :album,
                                        :per_page => 36,
                                        :conditions => ["name like ?",'%'+keyword+'%'],
                                        :order => "datetime desc")
    end
  end
  
  def user
    @start = Time.now #计算页面处理时间
    unless read_fragment(:action=>"user",:id=>params[:id]||="",:page=>params[:page]||="1",:lang=>getBrowserLanguage())
      keyword = params[:id]||=''
      @title = keyword+l("constValue_userSearchResult")      
      @userSize = User.count("id",:conditions=>["username like ?",'%'+keyword+'%'])
      @user_pages, @users = paginate( :user,
                                      :per_page => 18,
                                      :conditions => ["username like ?",'%'+keyword+'%'],
                                      :order => "registerDatetime desc")        
    end
  end
  
  def download
    @start = Time.now #计算页面处理时间
    unless read_fragment(:action=>"download",:id=>params[:id]||="",:page=>params[:page]||="1",:lang=>getBrowserLanguage())
      keyword = params[:id]||=''
      @albumSize = Album.count("id",:conditions=>["isPacked = true and name like ?",'%'+keyword+'%'])
      @album_pages, @albums = paginate( :album,
                                        :per_page => 36,
                                        :conditions=>["isPacked = true and name like ?",'%'+keyword+'%'],
                                        :order => "datetime desc")
    end
  end
end