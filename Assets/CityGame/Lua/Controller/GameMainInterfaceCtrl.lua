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
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.friendsButton.gameObject, self.OnFriends, self)
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.exchangeButton.gameObject,self.OnExchange,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.houseButton.gameObject,self.OnHouse,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.rawMaterialFactory.gameObject,self.OnRawMaterialFactory,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.sourceMill.gameObject,self.OnSourceMill,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.advertisFacilitie.gameObject,self.OnAdvertisFacilitie,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.centerWareHouse.gameObject,self.OncenterWareHouse,self);

    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
end

function GameMainInterfaceCtrl:Refresh()
    self:_showFriendsNotice()
end

--通知--
function GameMainInterfaceCtrl.OnNotice()
    if  NoticeMgr.notice ~= nil then
        if  #NoticeMgr.notice == 0 then
            ct.OpenCtrl("NoMessageCtrl")
        else
            ct.OpenCtrl('GameNoticeCtrl')
        end
    else
        if #Notice == 0  then
            ct.OpenCtrl("NoMessageCtrl")
        else
            ct.OpenCtrl('GameNoticeCtrl')
        end
    end

end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    ct.log("rodger_w8_GameMainInterface","[test_OnChat]  测试完毕")
    ct.OpenCtrl("ChatCtrl")
end

--好友--
function GameMainInterfaceCtrl.OnFriends()
    ct.OpenCtrl("FriendsCtrl")
end

--好友红点--
function GameMainInterfaceCtrl._showFriendsNotice()
    local friendsApply = DataManager.GetMyFriendsApply()
    GameMainInterfacePanel.friendsNotice:SetActive(#friendsApply > 0)
end
function GameMainInterfaceCtrl:c_OnReceiveAddFriendReq()
    self._showFriendsNotice()
end

--设置--
function GameMainInterfaceCtrl.Onset()
    ct.log("rodger_w8_GameMainInterface","[test_Onset]  测试完毕")
    ct.OpenCtrl("SystemSettingCtrl")
end

--建筑--
function GameMainInterfaceCtrl.OnBuild()
    ct.log("rodger_w8_GameMainInterface","[test_OnBuild]  测试完毕")
    ct.OpenCtrl('ConstructCtrl')
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
    ct.OpenCtrl("HouseCtrl", PlayerTempModel.tempHouseData.info.id)
end

--原料厂--
function GameMainInterfaceCtrl.OnRawMaterialFactory()
    ct.log("rodger_w8_GameMainInterface","[test_OnRawMaterialFactory]  测试完毕")
    --UnitTest.Exec_now("fisher_w8_RemoveClick", "c_MaterialModel_ShowPage",self)
    local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    Event.Brocast('m_ReqOpenMaterial',buildingId)
    ct.OpenCtrl('MaterialCtrl')
end

--加工厂--
function GameMainInterfaceCtrl.OnSourceMill()
    ct.log("rodger_w8_GameMainInterface","[test_OnSourceMill]  测试完毕")
    local buildingId = PlayerTempModel.roleData.buys.produceDepartment[1].info.id
    Event.Brocast('m_ReqOpenProcessing',buildingId)
    ct.OpenCtrl('ProcessingCtrl')
end

--广告设施
function GameMainInterfaceCtrl:OnAdvertisFacilitie()
    ct.log("rodger_w8_GameMainInterface","[test_OnAdvertisFacilitie]  测试完毕")
    ct.OpenCtrl("MunicipalCtrl")
    Event.Brocast("m_detailPublicFacility",MunicipalModel.lMsg.info.id)
end

--中心仓库
function GameMainInterfaceCtrl:OncenterWareHouse()
    Event.Brocast("m_opCenterWareHouse")
    --ct.OpenCtrl("ScienceSellHallCtrl")

end


