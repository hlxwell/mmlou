# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base  
    require "fileutils"
    require "RMagick"
    include ApplicationHelper
  
    # Pick a unique cookie name to distinguish our session data from others'
    session :session_key => 'mmlou_session_id'
  
    ###### XXS prevent #####################################
    before_filter :ip_banner
    before_filter :getStartTime
    before_filter :sanitize_params
    before_filter :checkLanguage
  
    def ip_banner
        ip = request.remote_ip
        
        if not /211\.138\.\d+\.\d+/.match(ip).nil?
            render :text=>'No Permission!'
        end
    end
  
    def getStartTime
        @start=Time.now #计算页面处理时间
    end
  
    def sanitize_params
        #strange for upgrade to new version of rails it occurs
        if params
            temp = walk_hash(params)
            params = temp
            return params
        end
    end
  
    def walk_hash(hash)
        hash.keys.each do |key|
            if hash[key].is_a? String
                hash[key] = white_list(hash[key])
                #去掉脏话
                hash[key] = sanitizeBadWord(hash[key])
            elsif hash[key].is_a? Hash
                hash[key] = walk_hash(hash[key])
            elsif hash[key].is_a? Array
                hash[key] = walk_array(hash[key])
            end
        end
        hash
    end
  
    def walk_array(array)
        array.each_with_index do |el,i|
            if el.is_a? String
                array[i] = white_list(el)
            elsif el.is_a? Hash
                array[i] = walk_hash(el)
            elsif el.is_a? Array
                array[i] = walk_array(el)
            end
        end
        array
    end
end
