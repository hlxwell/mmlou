module ApplicationHelper
  include CacheHelper,PhotoHelper,PayHelper,TagHelper,MenuHelper
  
  ###Constants############################################
  @@maxUserSpace = 1000000 #用户相册最大容量
  @@uploadVipPassword = "pig" 
  ########################################################
  
  #去除坏词
  def sanitizeBadWord(word)
    badwords = Array.new
    badwords = ["淫荡","强奸","激情电影","淫奸","淫乱","欲火焚身","裸聊","色情","情色","性交","做爱","他妈的","你妈逼","法轮","江泽民","胡锦涛","温家宝","幼女"]
    for badword in badwords
      word = word.gsub(badword," * ")
    end
    return word
  end

  #### authorize ###############################################
  def authorize
    unless session[:user]
      redirect_to("/user/login")
    end
  end
  
  def adminAuthorize
    unless session[:admin]
      redirect_to("/admin/login")
    end
  end
  
  ### 浏览器语言检测 ###########################################
  def checkLanguage
    setLanguage()
  end
  
  def setLanguage
    lang = getBrowserLanguage  
    if lang == "zh"
      set_language_if_valid :zh
    else
      set_language_if_valid :en
    end
  end
  
  def getBrowserLanguage
    lang = request.env["HTTP_ACCEPT_LANGUAGE"]
    if lang.nil?
      return "en"
    else
      if lang.include?("en")
        return "en"
      elsif lang.include?("zh")
        return "zh"
      else
        return "en"
      end
    end
  end
  
  #检查cookie
  def checkCookie
    #have cookie
    if not cookies[:username].nil? and not cookies[:password].nil?
      #unlogin
      if session[:user].nil?
        user = User.find_by_username_and_password(cookies[:username],cookies[:password])
        #is right cookie
        if user
          #set session for user object
          session[:user] = user
          return true
        end
      end
    end
    
    return false
  end
  
  #### public method ###################################################
  #是否为当前用户
  def isCurrentUser(user)
    if user
      if (not session[:user].nil?) and session[:user].id.to_s == user.id.to_s
        return true
      end
    end
    return false
  end
  
  #当前用户是否为主页的主人
  def isHost(user_id=params[:user_id])
    if (not session[:user].nil?) and session[:user].id.to_s == user_id.to_s
      return true
    elsif isAdmin
      return true
    end
    return false
  end
  
  #当前用户是否为主页的主人
  def isAdmin()
    if session[:admin]
      return true
    else
      return false
    end
  end
  
  #判断是否为朋友
  def isFriend(friend_id=params[:user_id])
    if not session[:user]
      return false
    else
      friend = Friend.find(:first,:conditions=>["user_id=? and friend_id=?",session[:user].id,friend_id])
      if friend
        return true
      else
        return false
      end
    end    
  end
  
  ### page link generator method ##############################
  def page_links_full(paginator,options={})
    options[:name] ||=  :page
    options[:link_to_current_page] ||=  false
    options[:window_size] ||=  4
    #paginator.current_page = "<span class='current'>a</span>"
    html = ''
    
    if paginator.current.previous
      html << "<a class='nextprev' href='?#{options[:name]}=#{paginator.current.previous.number}'>#{l("common_link_prevPage")}</a>"
    else
      html << "<span class='nextprev'>#{l("common_link_prevPage")}</span>"
    end
    
    html << (pagination_links_each(paginator,options) do |n|
      "<a href = '?#{options[:name]}=#{n}'>#{n}</a>"
    end || '')
    
    if paginator.current.next
      html << "<a class='nextprev' href='?#{options[:name]}=#{paginator.current.next.number}'>#{l("common_link_nextPage")}</a>"
    else
      html << "<span class='nextprev'>#{l("common_link_nextPage")}</span>"
    end
              
    return html
  end
  
  #rewrite the pagination method
  def pagination_links_each(paginator, options)
    options = ActionView::Helpers::PaginationHelper::DEFAULT_OPTIONS.merge(options)
    link_to_current_page = options[:link_to_current_page]
    always_show_anchors = options[:always_show_anchors]
 
    current_page = paginator.current_page
    window_pages = current_page.window(options[:window_size]).pages
    return if window_pages.length <= 1 unless link_to_current_page
         
    first, last = paginator.first, paginator.last
         
    html = ''
    if always_show_anchors and not (wp_first = window_pages[0]).first?
      html << yield(first.number)
      html << ' <a> ... </a> ' if wp_first.number - first.number > 1
      html << ' '
    end
       
    window_pages.each do |page|
    if current_page == page && !link_to_current_page
      html << "<span class='current'>#{page.number.to_s}</span>"
    else
      html << yield(page.number)
    end
    html << ' '
    end
     
    if always_show_anchors and not (wp_last = window_pages[-1]).last? 
      html << '<a> ... </a>' if last.number - wp_last.number > 1
      html << yield(last.number)
    end
    
    html
  end

  ### file operation #####################
  #content should be a string
  def writeFile(path,content)
    File.open(path,"w") do |f|
      f.write(content)
    end
  end
  
  #return a string
  def readFile(path)
    content=""
    File.open(path) do |f|
      f.each_line do |line|
        content += line
      end
    end
    return content
  end
end