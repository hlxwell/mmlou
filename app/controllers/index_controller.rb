class IndexController < ApplicationController
  layout "index"
  
  def index
    
   
    if checkCookie
      redirect_to "/user/home"
    elsif not read_fragment(:action => "index", :lang=>getBrowserLanguage())
      config = readFile("#{RAILS_ROOT}/config/userData/homePagePhoto.txt")

      @photos = Array.new
      for photoID in config.split(',')
        if photoID
          photo = Photo.find(:first,:conditions=>["id = ?",photoID])
          if not photo.nil?
            @photos << photo
          end
        end
      end   
    end    
  end
end