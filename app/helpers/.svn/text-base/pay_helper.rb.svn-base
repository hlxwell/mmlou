module PayHelper
  ### transform money and fee ##########################
  def getPointFromFee(total_fee)
    case total_fee
      when "100"
        getPoint=20
      when "500"
        getPoint=100
      when "1500"
        getPoint=400
    end
    return getPoint
  end
  
  def getFeeFromPoint(buyPoint)
    case buyPoint
      when "20"
        total_fee = "100"
      when "100"
        total_fee = "500"
      when "400"
        total_fee = "1500"
    end
    return total_fee
  end
  
  #加入VIP######################################
  def getMonthFromFee(total_fee)
    case total_fee
      when "100"
        getPoint=1
      when "600"
        getPoint=6
      when "1200"
        getPoint=12
    end
    return getPoint
  end
  
  def getFeeFromMonth(month)
    case month
      when "1"
        total_fee = "100"
      when "6"
        total_fee = "600"
      when "12"
        total_fee = "1200"
    end
    return total_fee
  end
end
