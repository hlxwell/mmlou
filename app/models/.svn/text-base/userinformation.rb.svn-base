class Userinformation < ActiveRecord::Base
  belongs_to :user
  
  def Realname
    if self.realname
      return self.realname
    else
      return l("common_label_notFill")
    end
  end
  
  def Sex
    if self.sex
      return self.sex
    else
      return l("common_label_notFill")
    end
  end
  
  def Birthday
    if self.birthday
      return self.birthday.strftime("%Y-%m-%d")
    else
      return l("common_label_notFill")
    end
  end
  
  def Hometown
    if self.hometown
      return self.hometown
    else
      return l("common_label_notFill")
    end
  end
  
  def Sign
    if self.sign
      return self.sign
    else
      return l("common_label_notFill")
    end
  end
end
