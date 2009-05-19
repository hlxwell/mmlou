class AboutController < ApplicationController
  layout "home"
  
  def report    
    if request.post?
      newReport = Report.new(params[:report])
      newReport.datetime=Time.now
      newReport.save
      @alertMessage = "谢谢您的举报，我们将尽快采取措施！Thanks for reporting! <br><a href='javascript:history.go(-2)'>返回 BACK</a>"
    end
  end
end