require "Common/define"
require('Framework/UI/UIPage')
require('Controller/CreateRoleCtrl')
require('Controller/GameMainInterfaceCtrl')
local class = require 'Framework/class'
ServerListCtrl = class('ServerListCtrl',UIPage)
UIPage:ResgisterOpen(ServerListCtrl) --注册打开的方法

local serverListBehaviour;
local gameObject;

function  ServerListCtrl:bundleName()
    return "ServerList"
end

function ServerListCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function ServerListCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    serverListBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    serverListBehaviour:AddClick(ServerListPanel.serverOneBtn,self.c_OnServerOne,self);
    serverListBehaviour:AddClick(ServerListPanel.serverTwoBtn,self.c_OnServerTwo,self);
    serverListBehaviour:AddClick(ServerListPanel.oKBtn,self.c_OnOK,self);

    --普通消息注册
    Event.AddListener("c_GsCreateRole",self.c_GsCreateRole,self);
    Event.AddListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);

end

function ServerListCtrl:Refresh()
    log("rodger_w8_GameMainInterface","[ServerListCtrl:Refresh] UI数据刷新， 数据为: m_data =",self.m_data);
    ServerListPanel.serverOneText:GetComponent('Text').text =self.m_data[1];
    ServerListPanel.serverTwoText:GetComponent('Text').text = self.m_data[2];
end

--选择服务器一--
function ServerListCtrl:c_OnServerOne()
    local showTest =ServerListPanel.serverOneText:GetComponent('Text').text;
    ServerListPanel.serverText:GetComponent('Text').text = showTest;
    local Index = 1;
    Event.Brocast("m_chooseGameServer", Index);
end

--选择服务器二--
function ServerListCtrl:c_OnServerTwo()
    local showTest =ServerListPanel.serverTwoText:GetComponent('Text').text;
    ServerListPanel.serverText:GetComponent('Text').text = showTest;
    local Index = 2;
    Event.Brocast("m_chooseGameServer", Index);
end

--点击确定--
function ServerListCtrl:c_OnOK()
    Event.Brocast("m_GsOK");
end

function ServerListCtrl:c_GsCreateRole()
    UIPage:ClearAllPages()
    UIPage:ShowPage(CreateRoleCtrl)
end
function ServerListCtrl:c_GsLoginSuccess()
    UIPage:ClearAllPages()
    UIPage:ShowPage(GameMainInterfaceCtrl)
    --UIPage:ShowPage(TopBarCtrl)
    --UIPage:ShowPage(MainPageCtrl,"UI数据传输测试")
end
