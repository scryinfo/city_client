
require('Framework/UI/UIPage')
require "Common/define"
--require('Controller/HouseCtrl')
--require('Controller/ExchangeCtrl')

local class = require 'Framework/class'
GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPage)

local gameMainInterfaceBehaviour;
local gameObject;


function  GameMainInterfaceCtrl:bundleName()
    return "GameMainInterface"
end

function GameMainInterfaceCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function GameMainInterfaceCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    gameMainInterfaceBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.noticeButton.gameObject,self.OnNotice,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.chatButton.gameObject,self.OnChat,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.exchangeButton.gameObject,self.OnExchange,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.houseButton.gameObject,self.OnHouse,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.rawMaterialFactory.gameObject,self.OnRawMaterialFactory,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.sourceMill.gameObject,self.OnSourceMill,self);
end

--通知--
function GameMainInterfaceCtrl.OnNotice()
    log("rodger_w8_GameMainInterface","[test_OnNotice]  测试完毕")
end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    log("rodger_w8_GameMainInterface","[test_OnChat]  测试完毕")
end

--设置--
function GameMainInterfaceCtrl.Onset()
    log("rodger_w8_GameMainInterface","[test_Onset]  测试完毕")
end

--建筑--
function GameMainInterfaceCtrl.OnBuild()
    log("rodger_w8_GameMainInterface","[test_OnBuild]  测试完毕")
end

--交易所--
function GameMainInterfaceCtrl.OnExchange()
    log("rodger_w8_GameMainInterface","[test_OnExchange]  测试完毕")
    --UIPage:ShowPage(ExchangeCtrl)
    UIPage:OpenCtrl('ExchangeCtrl')
end

--住宅--
function GameMainInterfaceCtrl.OnHouse()
    log("rodger_w8_GameMainInterface","[test_OnHouse]  测试完毕")
    local info = {}
    --UIPage:ShowPage(HouseCtrl, info)
    UIPage:OpenCtrl('HouseCtrl',info)
    --Event.Brocast("c_OnOppenHouse");
end

--原料厂--
function GameMainInterfaceCtrl.OnRawMaterialFactory()
    log("rodger_w8_GameMainInterface","[test_OnRawMaterialFactory]  测试完毕")
    --UnitTest.Exec_now("fisher_w8_RemoveClick", "c_MaterialModel_ShowPage",self)
    --Event.Brocast('c_OnOpenLoginCtrl')
    UIPage:OpenCtrl('MaterialCtrl')
end

--加工厂--
function GameMainInterfaceCtrl.OnSourceMill()
    log("rodger_w8_GameMainInterface","[test_OnSourceMill]  测试完毕")
    --Event.Brocast("");
end



