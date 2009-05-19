module MenuHelper
  def userHeaderMenu(currentMenu="")
    @user=User.find(params[:user_id])
    @currentMenu = currentMenu
    
    render :partial=>"/menu/userHeaderMenu"
  end
  
  def adminHeaderMenu(current)
    case current
      when "album":@title="相册管理"
      when "photo":@title="相片管理"
      when "user":@title="用户管理"
      when "pack":@title="打包管理"
      when "page":@title="页面管理"
      when "homePage":@title="首页管理"
    end
    @currentMenu=current
    render :partial=>"/menu/adminHeaderMenu"
  end
    
  def adminSubMenu(currentMenu)
    case currentMenu
      when "photo":
        @title="相片管理"
        @group=1
      when "tag":
        @title="Tag管理"
        @group=1
      when "album":
        @title="相册管理"
        @group=2
      when "pack"
        @title="打包管理"
        @group=2
      when "mail"
        @title="美眉快报"
        @group=2
      when "user":
        @title="用户管理"
        @group=3
      when "vip":
        @title="VIP管理"
        @group=3
      when "point":
        @title="积分管理"
        @group=4
      when "log":
        @title="日志管理"
        @group=4
      when "report":
        @title="举报管理"
        @group=5
      when "homePage":
        @title="首页管理"
        @group=6
      when "userHomePage":
        @title="逛逛首页管理"
        @group=6
      when "cache":
        @title="缓存管理"
        @group=6
    end
    @currentMenu=currentMenu
    render :partial=>"/menu/adminSubMenu"
  end
  
  def userManageHeaderMenu(currentMenu="")
    case currentMenu
      when "user":@title=l("userManageSubMenu_link_account")
      when "point":@title=l("userManageSubMenu_link_pointManage")
      when "packs":@title=l("userManageSubMenu_link_myPacks")
    end
    @currentMenu = currentMenu
    render :partial=>"/menu/userManageHeaderMenu"
  end
  
  def userManageSubMenu(currentMenu="")
    case currentMenu
      when "account":
        @title=l("userManageSubMenu_link_account")
        @group=1
      when "information":
        @title=l("userManageSubMenu_link_editInform")
        @group=1
     when "email":
        @title=l("userManageSubMenu_link_editEmail")
        @group=1
      when "uploadPortrait"
        @title=l("userManageSubMenu_link_uploadPortrait")
        @group=1
      when "income":
        @title=l("userManageSubMenu_link_pointManage")
        @group=2
      when "pay":
        @title=l("userManageSubMenu_link_onlinePay")
        @group=2
      when "vip":
        @title=l("userManageSubMenu_link_joinVIP")
        @group=2
      when "myPacks":
        @title=l("userManageSubMenu_link_myPacks")
        @group=3
    end
    @currentMenu=currentMenu
    render :partial=>"/menu/userManageSubMenu"
  end
end