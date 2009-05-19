class MailAlert < ActionMailer::Base

  def newComment(sent_at = Time.now)
    @subject    = 'MailAlert#newComment'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end

  def photoAuthed(sent_at = Time.now)
    @subject    = 'MailAlert#photoAuthed'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end

  def photoDeleted(sent_at = Time.now)
    @subject    = 'MailAlert#photoDeleted'
    @body       = {}
    @recipients = ''
    @from       = ''
    @sent_on    = sent_at
    @headers    = {}
  end
end
