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
    --gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.chatButton.gameObject,self.OnChat,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.friendsButton.gameObject, self.OnFriends, self)
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.exchangeButton.gameObject,self.OnExchange,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.houseButton.gameObject,self.OnHouse,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.rawMaterialFactory.gameObject,self.OnRawMaterialFactory,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.sourceMill.gameObject,self.OnSourceMill,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.advertisFacilitie.gameObject,self.OnAdvertisFacilitie,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.centerWareHouse.gameObject,self.OncenterWareHouse,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.worldChatPanel,self.OnChat,self);


    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_openBuildingInfo", self.c_openBuildingInfo,self)
    Event.AddListener("c_GetBuildingInfo", self.c_GetBuildingInfo,self)
    Event.AddListener("c_receiveOwnerDatas",self.SaveData,self)
    Event.AddListener("c_beginBuildingInfo",self.c_beginBuildingInfo,self)

end

function GameMainInterfaceCtrl:SaveData(ownerData)
    if self.groundOwnerDatas then
        table.insert(self.groundOwnerDatas,ownerData)
    end
end


function GameMainInterfaceCtrl:c_beginBuildingInfo(buildingInfo,func)
    -- TODO:ct.log("system","重新开业")
    local data = {workerNum=20,buildInfo= buildingInfo,func=func}
    ct.OpenCtrl("WagesAdjustBoxCtrl",data)
end

function GameMainInterfaceCtrl:c_openBuildingInfo(buildingInfo)
    --打开界面
    buildingInfo.ctrl=self
    ct.OpenCtrl('StopAndBuildCtrl',buildingInfo)
end

function GameMainInterfaceCtrl:c_GetBuildingInfo(buildingInfo)
    --请求土地信息
    local startBlockId=TerrainManager.GridIndexTurnBlockID(buildingInfo.pos)
    local blockIds = DataManager.CaculationTerrainRangeBlock(startBlockId,PlayerBuildingBaseData[buildingInfo.mId].x)
    self.groundDatas={}
    for i, blockId in ipairs(blockIds) do
        local data = DataManager.GetGroundDataByID(blockId)
        table.insert(self.groundDatas,data)
    end

    --请求土地主人的信息
    self.groundOwnerDatas={}
    for i, groundData in ipairs(self.groundDatas) do
        local Ids={}
        table.insert(Ids,groundData.Data.ownerId)
        Event.Brocast("m_QueryPlayerInfo",Ids)
    end

    --请求建筑主人的信息
    local ids={}
    table.insert(ids,buildingInfo.ownerId)
    Event.Brocast("m_QueryPlayerInfo",ids)

end


function GameMainInterfaceCtrl:Refresh()
    --打开主界面Model
    self:initInsData()
    self:_showFriendsNotice()
    self:_showWorldChatNoticeItem()
end

function GameMainInterfaceCtrl:initInsData()
        DataManager.OpenDetailModel(GameMainInterfaceModel,4)
        DataManager.DetailModelRpcNoRet(4, 'm_GetAllMails')
end

--获取所有邮件
function GameMainInterfaceCtrl:_receiveAllMails(DataInfo)
     self.Mails = DataInfo
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

--[[    if self.Mails == nil then
        ct.OpenCtrl("NoMessageCtrl")
    else
        ct.OpenCtrl('GameNoticeCtrl',self.Mails)
    end]]
end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    ct.log("rodger_w8_GameMainInterface","[test_OnChat]  测试完毕")
    ct.OpenCtrl("ChatCtrl", {toggleId = 1})
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

-- 世界聊天显示
function GameMainInterfaceCtrl:c_OnReceiveRoleCommunication(chatData)
    if chatData.channel == "WORLD" then
        if GameMainInterfacePanel.worldChatContent.childCount >= 5 then
            for i = 1, GameMainInterfacePanel.worldChatContent.childCount - 4 do
                UnityEngine.GameObject.Destroy(GameMainInterfacePanel.worldChatContent:GetChild(i-1).gameObject)
            end
        end

        local prefab = UnityEngine.GameObject.Instantiate(UnityEngine.Resources.Load("View/Chat/ChatWorldItem"))
        local rect = prefab.transform:GetComponent("RectTransform")
        prefab.transform:SetParent(GameMainInterfacePanel.worldChatContent)
        rect.transform.localScale = Vector3.one

        local chatWorldItem = ChatWorldItem:new(prefab, chatData)
    else
        GameMainInterfacePanel.worldChatNoticeItem:SetActive(true)
    end
end

function GameMainInterfaceCtrl._showWorldChatNoticeItem()
    GameMainInterfacePanel.worldChatNoticeItem:SetActive(false)
    local chatFriendsInfo = DataManager.GetMyChatInfo(2)
    local chatStrangersInfo = DataManager.GetMyChatInfo(3)
    for _, v in pairs(chatFriendsInfo) do
        if v.unreadNum and v.unreadNum > 0 then
            GameMainInterfacePanel.worldChatNoticeItem:SetActive(true)
            break
        end
    end
    for _, m in pairs(chatStrangersInfo) do
        if m.unreadNum and m.unreadNum > 0 then
            GameMainInterfacePanel.worldChatNoticeItem:SetActive(true)
            break
        end
    end
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
    --相机切换到建造状态
    CameraMove.ChangeCameraState(TouchStateType.ConstructState)
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
    --ct.log("rodger_w8_GameMainInterface","[test_OnRawMaterialFactory]  测试完毕")
    ----UnitTest.Exec_now("fisher_w8_RemoveClick", "c_MaterialModel_ShowPage",self)
    --local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    --Event.Brocast('m_ReqOpenMaterial',buildingId)
    --ct.OpenCtrl('MaterialCtrl')
    ct.OpenCtrl("ScienceSellHallCtrl")

end

--加工厂--
function GameMainInterfaceCtrl.OnSourceMill()
    --ct.log("rodger_w8_GameMainInterface","[test_OnSourceMill]  测试完毕")
    --local buildingId = PlayerTempModel.roleData.buys.produceDepartment[1].info.id
    --Event.Brocast('m_ReqOpenProcessing',buildingId)
    --ct.OpenCtrl('ProcessingCtrl')
    ct.OpenCtrl("GuidBookCtrl")
end

--广告设施
function GameMainInterfaceCtrl:OnAdvertisFacilitie()
    ct.log("rodger_w8_GameMainInterface","[test_OnAdvertisFacilitie]  测试完毕")
    ct.OpenCtrl("MunicipalCtrl")
    Event.Brocast("m_detailPublicFacility",MunicipalModel.lMsg.info.id)
end

--中心仓库
function GameMainInterfaceCtrl:OncenterWareHouse()
    --Event.Brocast("m_opCenterWareHouse")
    ct.OpenCtrl("CenterWareHouseCtrl",PlayerTempModel.roleData)
end


