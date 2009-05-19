class AlertMailer < ActionMailer::Base

  def alert(content,user)
    if user.language == "zh"
      @subject    = "美眉楼重要通知---#{Time.now.strftime("%y年%m月%d日")}"
      @body       = {:content=>content,:user=>user}
      @recipients = user.email
      @from       = '美眉楼重要通知 <mmlouAdmin@gmail.com>'
      @sent_on    = Time.now
    else
      @subject    = "MMLou Alert Mail---#{Time.now.strftime("%y-%m-%d")}"
      @body       = {:content=>content,:user=>user}
      @recipients = user.email
      @from       = 'MMLou Alert Mail <mmlouAdmin@gmail.com>'
      @sent_on    = Time.now
    end
  end
end
