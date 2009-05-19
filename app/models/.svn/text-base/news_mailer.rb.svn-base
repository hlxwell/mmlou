class NewsMailer < ActionMailer::Base

  def newsletter(expressMail,user)
    if user.language == "zh"
      @subject    = "美眉楼快报---#{expressMail.datetime.strftime("%y年%m月%d日")}刊"
      @body       = {:photos=>expressMail.getMailPhotos(),:mail=>expressMail,:user=>user}
      @recipients = user.email
      @from       = '美眉楼快报 <mmlouwebmaster@gmail.com>'
      @sent_on    = expressMail.datetime
    else
      @subject    = "MMLou Newsletter---#{expressMail.datetime.strftime("%y-%m-%d")}"
      @body       = {:photos=>expressMail.getMailPhotos(),:mail=>expressMail,:user=>user}
      @recipients = user.email
      @from       = 'MMLou Newsletter <mmlouwebmaster@gmail.com>'
      @sent_on    = expressMail.datetime
    end
  end
end