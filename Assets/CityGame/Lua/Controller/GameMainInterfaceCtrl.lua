GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPage)
UIPage:ResgisterOpen(GameMainInterfaceCtrl) --注册打开的方法

local gameMainInterfaceBehaviour;
local gameObject;
local Mails


function  GameMainInterfaceCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GameMainInterfacePanel.prefab"
end

function GameMainInterfaceCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function GameMainInterfaceCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameMainInterfaceBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.noticeButton.gameObject,self.OnNotice,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.head.gameObject,self.OnHead,self); --点击头像

    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.friendsButton.gameObject, self.OnFriends, self)
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.guideBool.gameObject,self.OnGuideBool,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.advertisFacilitie.gameObject,self.OnAdvertisFacilitie,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.centerWareHouse.gameObject,self.OncenterWareHouse,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.worldChatPanel,self.OnChat,self);



    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_openBuildingInfo", self.c_openBuildingInfo,self)
    Event.AddListener("c_GetBuildingInfo", self.c_GetBuildingInfo,self)
    Event.AddListener("c_receiveOwnerDatas",self.SaveData,self)
    Event.AddListener("c_beginBuildingInfo",self.c_beginBuildingInfo,self)
    Event.AddListener("c_AllMails",self.c_AllMails,self)

end

function GameMainInterfaceCtrl:SaveData(ownerData)
    if self.groundOwnerDatas then
        table.insert(self.groundOwnerDatas,ownerData)
    end
end


function GameMainInterfaceCtrl:c_beginBuildingInfo(buildingInfo,func)
    -- TODO:ct.log("system","重新开业")
    if DataManager.GetMyOwnerID()~=buildingInfo.ownerId  then
        return
    end

    local data = {workerNum=20,buildInfo= buildingInfo,func=func}
    ct.OpenCtrl("WagesAdjustBoxCtrl",data)

    Event.AddListener("c_successBuilding",function ()
        func()
        Event.Brocast("SmallPop","Success",300)
    end ,self)
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

function GameMainInterfaceCtrl:Awake()
    local info = DataManager.GetMyPersonalHomepageInfo()
    self.name = info.name
    self.gender = info.male
    local gold = DataManager.GetMoney()
    self.money = getPriceString("E"..gold..".0000",24,20)
end

function GameMainInterfaceCtrl:Refresh()
    --打开主界面Model
    Mails = nil
    self:initInsData()
    self:_showFriendsNotice()
    self:_showWorldChatNoticeItem()
end

function GameMainInterfaceCtrl:initInsData()
    DataManager.OpenDetailModel(GameMainInterfaceModel,4)
    DataManager.DetailModelRpcNoRet(4, 'm_GetAllMails')
    --初始化姓名,性别,金币
    GameMainInterfacePanel.name.text = self.name
    GameMainInterfacePanel.money.text = self.money
    UpdateBeat:Add(self._update, self);

    if self.gender then
        GameMainInterfacePanel.male.localScale = Vector3.one
        GameMainInterfacePanel.woman.localScale = Vector3.zero
    else
        GameMainInterfacePanel.male.localScale = Vector3.zero
        GameMainInterfacePanel.woman.localScale = Vector3.one
    end
end

function GameMainInterfaceCtrl:_update()
    GameMainInterfacePanel.time.text = os.date("%H:%M");
    GameMainInterfacePanel.date.text = os.date("%d").."," ..os.date("%B %a");
end

--获取所有邮件
function GameMainInterfaceCtrl:c_AllMails(DataInfo)
     Mails = DataInfo
    --判定红点是否显示
    if Mails == nil then
        GameMainInterfacePanel.noticeItem.localScale = Vector3.zero
        return
    end
    for i, v in pairs(Mails) do
        if v.read == false then
            GameMainInterfacePanel.noticeItem.localScale = Vector3.one
            return
        else
            GameMainInterfacePanel.noticeItem.localScale = Vector3.zero
        end
    end
end

--点击头像
function GameMainInterfaceCtrl:OnHead()
   local ownerInfo = DataManager.GetMyPersonalHomepageInfo()
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", ownerInfo)

end

--通知--

function GameMainInterfaceCtrl.OnNotice(go)
    GameMainInterfaceCtrl:RemoveUpdata()
--[[    if  NoticeMgr.notice ~= nil then
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
    end]]

    if Mails == nil then
        ct.OpenCtrl("NoMessageCtrl")
    else
        ct.OpenCtrl('GameNoticeCtrl',Mails)
    end
end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    GameMainInterfaceCtrl:RemoveUpdata()
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
    local saveUnread = DataManager.GetUnread()
    for _, v in pairs(chatFriendsInfo) do
        if v.unreadNum and v.unreadNum > 0 then
            GameMainInterfacePanel.worldChatNoticeItem:SetActive(true)
            return
        end
    end
    for _, m in pairs(chatStrangersInfo) do
        if m.unreadNum and m.unreadNum > 0 then
            GameMainInterfacePanel.worldChatNoticeItem:SetActive(true)
            return
        end
    end
    if saveUnread then
        for _, n in pairs(saveUnread) do
            if n and n[1] then
                GameMainInterfacePanel.worldChatNoticeItem:SetActive(true)
                return
            end
        end
    end
end

--设置--
function GameMainInterfaceCtrl.Onset()
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("SystemSettingCtrl")
end

--建筑--
function GameMainInterfaceCtrl.OnBuild()
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl('ConstructCtrl')
    --相机切换到建造状态
    CameraMove.ChangeCameraState(TouchStateType.ConstructState)
end

--住宅--
function GameMainInterfaceCtrl.OnHouse()
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("HouseCtrl", PlayerTempModel.tempHouseData.info.id)
end

--原料厂--
function GameMainInterfaceCtrl.OnRawMaterialFactory()
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("ScienceSellHallCtrl")

end

--指南书--
function GameMainInterfaceCtrl.OnGuideBool()
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("GuidBookCtrl")
end

--广告设施
function GameMainInterfaceCtrl:OnAdvertisFacilitie()
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("MunicipalCtrl")
    Event.Brocast("m_detailPublicFacility",MunicipalModel.lMsg.info.id)
end

--中心仓库
function GameMainInterfaceCtrl:OncenterWareHouse()
    --Event.Brocast("m_opCenterWareHouse")
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("CenterWareHouseCtrl",PlayerTempModel.roleData)
end

--关闭updata
function GameMainInterfaceCtrl:RemoveUpdata()
    if UpdateBeat then
        UpdateBeat:Remove(self._update, self);
    end
end


