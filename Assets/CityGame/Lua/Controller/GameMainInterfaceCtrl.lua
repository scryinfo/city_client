GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPage)
UIPage:ResgisterOpen(GameMainInterfaceCtrl) --注册打开的方法

local gameMainInterfaceBehaviour;
local gameObject;


function  GameMainInterfaceCtrl:bundleName()
    return "GameMainInterfacePanel"
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
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.advertisFacilitie.gameObject,self.OnAdvertisFacilitie,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.centerWareHouse.gameObject,self.OncenterWareHouse,self);
end

--通知--
function GameMainInterfaceCtrl.OnNotice()
    ct.log("rodger_w8_GameMainInterface","[test_OnNotice]  测试完毕")
end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    ct.log("rodger_w8_GameMainInterface","[test_OnChat]  测试完毕")
end

--设置--
function GameMainInterfaceCtrl.Onset()
    ct.log("rodger_w8_GameMainInterface","[test_Onset]  测试完毕")
end

--建筑--
function GameMainInterfaceCtrl.OnBuild()
    ct.log("rodger_w8_GameMainInterface","[test_OnBuild]  测试完毕")
end

--交易所--
function GameMainInterfaceCtrl.OnExchange()
    ct.log("rodger_w8_GameMainInterface","[test_OnExchange]  测试完毕")
    --UIPage:ShowPage(ExchangeCtrl)
    ct.OpenCtrl('ExchangeCtrl')
end

--住宅--
function GameMainInterfaceCtrl.OnHouse()
    ct.log("rodger_w8_GameMainInterface","[test_OnHouse]  测试完毕")
    local info = {}
    --UIPage:ShowPage(HouseCtrl, info)
    ct.OpenCtrl('HouseCtrl',info)
    --Event.Brocast("c_OnOppenHouse");
end

--原料厂--
function GameMainInterfaceCtrl.OnRawMaterialFactory()
    ct.log("rodger_w8_GameMainInterface","[test_OnRawMaterialFactory]  测试完毕")
    --UnitTest.Exec_now("fisher_w8_RemoveClick", "c_MaterialModel_ShowPage",self)
    --Event.Brocast('c_OnOpenLoginCtrl')
    ct.OpenCtrl('MaterialCtrl')
end

--加工厂--
function GameMainInterfaceCtrl.OnSourceMill()
    ct.log("rodger_w8_GameMainInterface","[test_OnSourceMill]  测试完毕")
    --Event.Brocast("");
   -- UIPage:OpenCtrl('CenterWareHouseCtrl')
    --UIPage:ShowPage(CenterWareHouseCtrl)
    --ct.OpenCtrl('CenterWareHouseCtrl')
end

--广告设施
function GameMainInterfaceCtrl:OnAdvertisFacilitie()
    ct.log("rodger_w8_GameMainInterface","[test_OnAdvertisFacilitie]  测试完毕")
    ct.OpenCtrl("MunicipalCtrl")
end

--中心仓库
function GameMainInterfaceCtrl:OncenterWareHouse()
    ct.OpenCtrl("CenterWareHouseCtrl")
end


