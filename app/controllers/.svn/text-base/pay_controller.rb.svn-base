class PayController < ApplicationController
  before_filter :authorize,:except=>[:pay_notify_handler]
  
  require "md5"
  layout "home"
  
  @@mySPid   = "1202100001"                          # 这里替换为您的实际商户号
  @@mySPkey  = "dcc89cd3963e24756f6da201c03a7e1e"    # sp_key是32位商户密钥, 请替换为您的实际密钥

  ### 支付 ##########################################################
  def payForVIP
    if params.size>0
      #参数#######
      joinTime    = params[:buy][:time]                               #购买的点数 
      productDesc = "www.MMLou.com_Join_VIP_For_#{joinTime}_month(s)" #商品描述
      totalFee    = getFeeFromMonth(joinTime)                         #价格
      #交易后传回的自定义数据
      userInform  = "#{session[:user].id},#{session[:user].password},vip" #用户信息
      ###########
      
      serverDate = Time.now.strftime("%Y%m%d")      
      #请求字符串
      #request_text=""
      #md5签名加密
      @md5_sign=""
      
      @spid    = @@mySPid                                #这里替换为您的实际商户号
      @sp_key  = @@mySPkey                               #sp_key是32位商户密钥, 请替换为您的实际密钥
      @sp_billno  = Time.now.strftime("%m%d%I%M%S")      #商户生成的订单号(最多32位) 
      
      #下面是请求参数
      @cmdno   = "1"                  # 财付通支付为"1" (当前只支持 cmdno=1) 
      @bill_date = serverDate         # 交易日期 (yyyymmdd) 
      @bank_type = "0"                # 银行类型: 0   财付通
                                      #     1001  招商银行   
                                      #     1002  中国工商银行  
                                      #     1003  中国建设银行  
                                      #     1004  上海浦东发展银行   
                                      #     1005  中国农业银行  
                                      #     1006  中国民生银行  
                                      #     1008  深圳发展银行   
                                      #     1009  兴业银行   
      
      @desc         = productDesc # 商品名称
      @purchaser_id = ""          # 用户财付通帐号，如果没有可以置空
      @bargainor_id = @spid       # 商户号
      
      # 重要:
      # 交易单号(28位): 商户号(10位) + 日期(8位) + 流水号(10位), 必须按此格式生成, 且不能重复
      # 如果sp_billno超过10位, 则截取其中的流水号部分加到transaction_id后部(不足10位左补0)
      # 如果sp_billno不足10位, 则左补0, 加到transaction_id后部
      @transaction_id = @spid + @bill_date + @sp_billno 
      
      # 总金额, 分为单位
      @total_fee= totalFee
      @fee_type   = "1"        # 货币类型: 1 – RMB(人民币) 2 - USD(美元) 3 - HKD(港币)
      @return_url   = "http://www.mmlou.com/pay/pay_notify_handler" # 财付通回调页面地址, (最长255个字符)
      @attach     = userInform  # 商户私有数据, 请求回调页面时原样返回
      
      # 生成MD5签名    
      @sign_text = "cmdno=#{@cmdno}&date=#{@bill_date}&bargainor_id=#{@bargainor_id}&transaction_id=#{@transaction_id}&sp_billno=#{@sp_billno}&total_fee=#{@total_fee}&fee_type=#{@fee_type}&return_url=#{@return_url}&attach=#{@attach}&key=#{@sp_key}"
      @md5_sign = MD5.new(@sign_text).to_s.upcase        # 转换为大写
    else
      redirect_to "/user/joinVip"
    end
  end
  
  def payForPoint
    if params.size>0
      #参数#######
      buyPoint    = params[:buy][:point]                              #购买的点数 
      productDesc = "www.MMLou.com_Buy_#{buyPoint}_point(s)"          #商品描述
      totalFee    = getFeeFromPoint(buyPoint)                         #价格
      #交易后传回的自定义数据
      userInform  = "#{session[:user].id},#{session[:user].password},point" #用户信息
      ###########
      
      serverDate = Time.now.strftime("%Y%m%d")      
      #请求字符串
      #request_text=""
      #md5签名加密
      @md5_sign=""
      
      @spid       = @@mySPid                                #这里替换为您的实际商户号
      @sp_key     = @@mySPkey                               #sp_key是32位商户密钥, 请替换为您的实际密钥
      @sp_billno  = Time.now.strftime("%m%d%I%M%S")      #商户生成的订单号(最多32位) 
      
      #下面是请求参数
      @cmdno      = "1"               # 财付通支付为"1" (当前只支持 cmdno=1) 
      @bill_date  = serverDate        # 交易日期 (yyyymmdd) 
      @bank_type  = "0"               # 银行类型: 0   财付通
                                      #     1001  招商银行   
                                      #     1002  中国工商银行  
                                      #     1003  中国建设银行  
                                      #     1004  上海浦东发展银行   
                                      #     1005  中国农业银行  
                                      #     1006  中国民生银行  
                                      #     1008  深圳发展银行   
                                      #     1009  兴业银行   
      
      @desc         = productDesc # 商品名称
      @purchaser_id = ""          # 用户财付通帐号，如果没有可以置空
      @bargainor_id = @spid       # 商户号
      
      # 重要:
      # 交易单号(28位): 商户号(10位) + 日期(8位) + 流水号(10位), 必须按此格式生成, 且不能重复
      # 如果sp_billno超过10位, 则截取其中的流水号部分加到transaction_id后部(不足10位左补0)
      # 如果sp_billno不足10位, 则左补0, 加到transaction_id后部
      @transaction_id = @spid + @bill_date + @sp_billno 
      
      # 总金额, 分为单位
      @total_fee= totalFee
      @fee_type   = "1"        # 货币类型: 1 – RMB(人民币) 2 - USD(美元) 3 - HKD(港币)
      @return_url   = "http://www.mmlou.com/pay/pay_notify_handler" # 财付通回调页面地址, (最长255个字符)
      @attach     = userInform  # 商户私有数据, 请求回调页面时原样返回
      
      # 生成MD5签名    
      @sign_text = "cmdno=#{@cmdno}&date=#{@bill_date}&bargainor_id=#{@bargainor_id}&transaction_id=#{@transaction_id}&sp_billno=#{@sp_billno}&total_fee=#{@total_fee}&fee_type=#{@fee_type}&return_url=#{@return_url}&attach=#{@attach}&key=#{@sp_key}"
      @md5_sign = MD5.new(@sign_text).to_s.upcase        # 转换为大写
    else
      redirect_to "/user/buyPoint"
    end
  end
  
  def pay_notify_handler
    #取返回参数
    cmdno         = params[:cmdno]         #1为财付通
    pay_result    = params[:pay_result]    #支付结果，成功为0
    #pay_info      = params[:pay_info]     #支付结果信息，如果成功就是空 unuse yet
    bill_date     = params[:date]          #支付日期
    bargainor_id  = params[:bargainor_id]  #商号
    transaction_id= params[:transaction_id]#交易单号
    sp_billno     = params[:sp_billno]     #流水号
    total_fee     = params[:total_fee]     #交易费用
    fee_type      = params[:fee_type]      #货币类型
    attach        = params[:attach]        #商家数据
    md5_sign      = params[:sign]          #MD5加密签名
    
    #本地参数
    spid    = @@mySPid   # 这里替换为您的实际商户号
    sp_key  = @@mySPkey  # sp_key是32位商户密钥, 请替换为您的实际密钥
    
    #返回值定义
    retOK = 0           # 成功
    invalidSpid = 1     # 商户号错误
    invalidSign = 2     # 签名错误
    tenpayErr = 3       # 财付通返回支付失败
    
    #验签函数
    origText      = "cmdno=#{cmdno}&pay_result=#{pay_result}&date=#{bill_date}&transaction_id=#{transaction_id}&sp_billno=#{sp_billno}&total_fee=#{total_fee}&fee_type=#{fee_type}&attach=#{attach}&key=#{sp_key}"
    localSignText = MD5.new(origText).to_s.upcase # 转换为大写
    verifyMd5Sign = (localSignText == md5_sign)
    
    #返回值
    retValue = retOK
    
    #判断商户号
    if bargainor_id != spid
      retValue = invalidSpid
    # 验签
    elsif verifyMd5Sign != true
      retValue = invalidSign
    # 检查财付通返回值
    elsif pay_result != 0
      retValue = tenpayErr
    end
    
    #在这里处理业务逻辑 
    
    #输出信息
    pay_msg=""
    case retValue
      when retOK
        pay_msg = "支付成功!"
      when invalidSpid
        pay_msg = "错误的商户号!" 
      when invalidSign
        pay_msg = "验证MD5签名失败!"
      else
        pay_msg = "支付失败!"
    end
    
    #获取用户名密码
    username = attach.split(',')[0]
    password = attach.split(',')[1]
    product  = attach.split(',')[2]
    
    #核对以后再进行操作
    opuser = User.find_by_id_and_password(username,password)
    if opuser
      #买点数的 #########################
      if product == 'point'
        session[:user]=opuser
        #how many point
        getPoint = getPointFromFee(total_fee)
        #give point
        opuser.addPoint(getPoint)
        #add a pointOpLog
        operation="id:#{transaction_id} buy #{getPoint.to_s} points for #{(total_fee.to_i/100).to_s} yuan on #{bill_date} result:#{pay_msg}"
        Pointoplog.new(:user_id=>opuser.id,:operation=>operation,:point=>getPoint,:datetime=>Time.now,:ip=>request.remote_ip).save
        redirect_to("/user/payResult/success?fee=#{getPoint}")
      #加入VIP的 ########################
      elsif product == 'vip'
        session[:user]=opuser
        #获得了多少时间
        month = getMonthFromFee(total_fee)
        #增加VIP时间
        opuser.addToVIP(month)
        #增加记录
        operation="id:#{transaction_id} buy #{month.to_s} Month(s) VIP for #{(total_fee.to_i/100).to_s} yuan on #{bill_date} result:#{pay_msg}"
        Pointoplog.new(:user_id=>opuser.id,:operation=>operation,:point=>0,:datetime=>Time.now,:ip=>request.remote_ip).save
        redirect_to("/pay/payResult/success?month=#{month}")
      end
    else
      redirect_to("/pay/payResult/fail")
    end
  end
  
  def payResult
    if params[:id]=="success"
      if params[:fee]
        @alertMessage = l("problem_label_buyPointDone",params[:fee],session[:user].point)    
      elsif params[:month]
        @alertMessage = l("problem_label_buyVIPDone",params[:month],session[:user].vipinfo.end_at.strftime("%Y-%m-%d"))   
      end
    elsif params[:id]=="fail"
      @alertMessage = l("userPay_label_failed")
    end
  end
end
