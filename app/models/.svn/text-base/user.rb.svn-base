class User < ActiveRecord::Base
  include ApplicationHelper,CacheHelper,PhotoHelper
  
  require "md5"
  
  has_many :albums,
           :dependent=>:destroy
  
  has_many :pointoplogs,
           :dependent=>:nullify
  
  has_many :allPhotos,
           :class_name=>"Photo",
           :order=>"datetime desc",
           :dependent=>:destroy

  has_many :authPhotos,
           :class_name=>"Photo",
           :order=>"datetime desc",
           :conditions=>"isAuth=1"
           
  has_many :comments,
           :order=>"datetime desc",
           :dependent=>:destroy
           
  has_many :favorites,
           :dependent=>:destroy
  
  has_one :userinformation,
          :dependent=>:destroy
  
  has_one :vipinfo,
          :dependent=>:destroy
  
  has_many :friends
  
  #has_many :friends,:through=>"friend"
  
  validates_presence_of :username,
                        :message => "- "+l("validate_enterUsername"),
                        :on=>:create
                        
  validates_format_of :username,
                      :with => /^\S*$/,
                      :message => "- "+l("validate_badWordInUsername"),
                      :on=>:create
                        
  validates_uniqueness_of :username,
                          :message => "- "+l("validate_usernameExist"),
                          :on=>:create
                          
  validates_length_of :password,
                      :in=>6..35,
                      :too_short => "- "+l("validate_passwordTooShort"),
                      :too_long => "- "+l("validate_passwordTooLong")
                      
  validates_presence_of :password,
                        :message => "- "+l("validate_enterPassword")

  validates_confirmation_of :password,
                            :message => "- "+l("validate_differentConfirmPassword")

  validates_presence_of :email,
                        :message => "- "+l("validate_enterEmail")
  
  validates_uniqueness_of :email,
                          :message => "- "+l("validate_sameEmailExist")
                          
  validates_format_of :email,
                      :with => /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/,
                      :message => "- "+ l("validate_wrongEmailFormat")
                        
  def Username
    if self.isVIP
      return self.username + "[vip]"
    else
      return self.username
    end
  end
  
  def before_create
    self.registerDatetime=Time.now
    self.lastLoginDatetime=Time.now
    self.password = MD5.new(self.password).to_s
    self.userinformation = Userinformation.new()
  end
    
  def self.all
    return User.find(:all)
  end
    
  def self.allUserMailbox
    mailboxs = ""
    users = User.find(:all)
    
    for user in users
      mailboxs += user.email + ","
    end
    
    return mailboxs.chomp(",");
  end
    
  def self.login(username, password, language,ipAddress)
    user = User.find_by_username_and_password(username,MD5.new(password).to_s,:include=>"userinformation")
    
    if user
      user.update_attribute(:lastLoginDatetime,Time.now)
      user.update_attribute(:language,language)
      user.update_attribute(:lastIP,ipAddress)
      user.loginCount+=1
      user.save
      
      return user
    else
      return nil
    end
  end
  
  def allPhotoNum
    Photo.count("id",:conditions=>["user_id = ?",self.id])
  end
  
  def allAuthPhotoNum
    Photo.count("id",:conditions=>["isAuth = true and user_id = ?",self.id])
  end
  
  def allAlbumNum
    Album.count("id",:conditions=>["user_id = ?",self.id])
  end
  
  def allCommentNum
    Comment.count("id",:conditions=>["user_id = ?",self.id])
  end
  
  def self.adminLogin(username, password)
    user = User.find_by_username_and_password_and_isAdmin(username,MD5.new(password).to_s,true)
    if user
      user.update_attribute(:lastLoginDatetime,Time.now)
      return user
    else
      return nil
    end
  end
  
  #显示赚钱了的用户
  def self.gainedUsers
    basicLine = 10
    return User.find( :all,
                      :conditions=>["gain > #{basicLine}"],
                      :order=>"gain desc")
  end
  
  def usedSpace 
    myUsedSpace = Photo.sum(:filesize,:conditions=>["user_id=?",self.id])
    if myUsedSpace.nil?
      myUsedSpace=0
    end
    return myUsedSpace/(@@maxUserSpace/1000) #KB
  end
  
  def remainedSpace 
    return @@maxUserSpace-self.usedSpace
  end
  
  def addToVIP(month)
    #当前不是会员
    if self.vipinfo.nil?
      self.vipinfo = Vipinfo.new(:user_id=>self.id,:start_at=>Time.now,:end_at=>(Time.now + month.months))
    #当前还是会员
    elsif Time.now < self.vipinfo.end_at
      self.vipinfo.end_at += month.months
    end
  end
  
  def isVIP
    if self.vipinfo.nil?
      return false
    elsif self.vipinfo.isTimeout
      return false
    else
      return true
    end
  end
  #### destroy #############################################
  def before_destroy
    deletePortrait(self)
  end
  
  ######## point operation ######################## 
  def minusPoint(point)
    self.point -= point
    self.save
  end
  
  def addPoint(point)
    self.point += point
    self.save
  end
  
  def gainPoint(point)
    self.point += point
    self.gain += point
    self.save
  end
  
  def beViewed
    self.viewCount += 1
    User.update(self.id,{:viewCount => self.viewCount})
  end
  
  #在线监测
  def isOnline
    sessions = CGI::Session::ActiveRecordStore::Session.find_all
    sessions.each do |s|
      time = Time.now-s.updated_at
      time = time/60
      
      #十分钟清除一次session
      if time>=20
        CGI::Session::ActiveRecordStore::Session.delete(s.id)
      end
      
      #三分钟为不在线
      if time<3 and s.data[:user][:id] == self.id
        return true
      else
        return false
      end
    end
  end
  
  #### 发送邮件 #####################################
  def sendAlertMail(content)
    AlertMailer.deliver_alert(content,self)
    return true
  end
end