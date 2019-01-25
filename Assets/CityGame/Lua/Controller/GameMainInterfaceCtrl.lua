GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPanel)
UIPanel:ResgisterOpen(GameMainInterfaceCtrl) --注册打开的方法

local gameMainInterfaceBehaviour;
local Mails
local countDown = 0
local groundState


function  GameMainInterfaceCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GameMainInterfacePanel.prefab"
end

function GameMainInterfaceCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function GameMainInterfaceCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
    for key, v in pairs(Good) do
        PlayerTempModel.tempTestReqAddItem(key,500)
    end

    for key, v in pairs(Material) do
        PlayerTempModel.tempTestReqAddItem(key,500)
    end
    Event.AddListener("c_beginBuildingInfo",self.c_beginBuildingInfo,self)
    Event.AddListener("c_ChangeMoney",self.c_ChangeMoney,self)
    Event.AddListener("c_openBuildingInfo", self.c_openBuildingInfo,self)
    Event.AddListener("c_GetBuildingInfo", self.c_GetBuildingInfo,self)
    Event.AddListener("c_receiveOwnerDatas",self.SaveData,self)
    Event.AddListener("m_MainCtrlShowGroundAuc",self.SaveData,self)
end

function GameMainInterfaceCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_AllMails",self.c_AllMails,self)
    Event.AddListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)   --获取拍卖状态
end

function GameMainInterfaceCtrl:Hide()

    UIPanel.Hide(self)

    Event.RemoveListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.RemoveListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.RemoveListener("c_AllMails",self.c_AllMails,self)
    Event.RemoveListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)  --获取拍卖状态
end

--金币改变
function GameMainInterfaceCtrl:c_ChangeMoney(money)
    self.money = getPriceString("E"..money..".0000",24,20)
    GameMainInterfacePanel.money.text = self.money
end

function GameMainInterfaceCtrl:SaveData(ownerData)
    if self.groundOwnerDatas then
        table.insert(self.groundOwnerDatas,ownerData)
    end
end

--获取拍卖状态
function GameMainInterfaceCtrl:m_MainCtrlShowGroundAuc()
   local state =  UIBubbleManager._getNowAndSoonState() --获取状态
    if state.groundState == 0 then
        GameMainInterfacePanel.auctionButton.transform.localScale = Vector3.one
        GameMainInterfacePanel.isAuction.localScale = Vector3.zero
        local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
        countDown = state.beginTime - currentTime   --倒计时间
        groundState = GetLanguage(11020002)
    elseif state.groundState == 1 then
        GameMainInterfacePanel.auctionButton.transform.localScale = Vector3.one
        GameMainInterfacePanel.isAuction.localScale = Vector3.one
        countDown = state.durationSec
        groundState = GetLanguage(11020001)
    else
        GameMainInterfacePanel.auctionButton.transform.localScale = Vector3.zero
    end
end

function GameMainInterfaceCtrl:c_beginBuildingInfo(buildingInfo,func)
    -- TODO:ct.log("system","重新开业")
    if DataManager.GetMyOwnerID()~=buildingInfo.ownerId  then
        return
    end
    local workerNum=PlayerBuildingBaseData[buildingInfo.mId].maxWorkerNum
    local dayWage=PlayerBuildingBaseData[buildingInfo.mId].salary

    local data = {workerNum=workerNum ,dayWage=dayWage ,buildInfo= buildingInfo,callback=function ()
            Event.Brocast("m_ReqHouseSetSalary1",buildingInfo.id,100)
            Event.Brocast("m_startBusiness",buildingInfo.id)
    end}

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
        Event.Brocast("m_QueryPlayerInfoChat",Ids)
    end

    --请求建筑主人的信息
    local ids={}
    table.insert(ids,buildingInfo.ownerId)
    Event.Brocast("m_QueryPlayerInfoChat",ids)

end

function GameMainInterfaceCtrl:Awake()
    gameMainInterfaceBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.noticeButton.gameObject,self.OnNotice,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.head.gameObject,self.OnHead,self); --点击头像

    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.friendsButton.gameObject, self.OnFriends, self)
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.guideBool.gameObject,self.OnGuideBool,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.advertisFacilitie.gameObject,self.OnAdvertisFacilitie,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.worldChatPanel,self.OnChat,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.auctionButton,self.OnAuction,self); --拍卖
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.centerBuilding,self.OnCenterBuilding,self); --中心建筑

    --头像
    local faceId = DataManager.GetFaceId()
    LoadSprite(PlayerHead[faceId].MainPath, GameMainInterfacePanel.headItem, true)
    self.insId = OpenModelInsID.GameMainInterfaceCtrl
    local info = DataManager.GetMyPersonalHomepageInfo()
    self.name = info.name
    self.gender = info.male

    local gold = DataManager.GetMoney()
    self.money = getPriceString("E"..gold..".0000",24,20)
    GameMainInterfacePanel.money.text = self.money
end

function GameMainInterfaceCtrl:Refresh()
    --打开主界面Model
    Mails = nil
    self:initInsData()
    self:_showFriendsNotice()
    self:_showWorldChatNoticeItem()
end

function GameMainInterfaceCtrl:initInsData()
    DataManager.OpenDetailModel(GameMainInterfaceModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetAllMails')
    --初始化姓名,性别
    GameMainInterfacePanel.name.text = self.name
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self.RefreshWeather, self), 1, -1, true)
    self.m_Timer:Start()
    if self.gender then
        GameMainInterfacePanel.male.localScale = Vector3.one
        GameMainInterfacePanel.woman.localScale = Vector3.zero
    else
        GameMainInterfacePanel.male.localScale = Vector3.zero
        GameMainInterfacePanel.woman.localScale = Vector3.one
    end
end

local date
local hour
function GameMainInterfaceCtrl:RefreshWeather()
    GameMainInterfacePanel.time.text = os.date("%H:%M")
    GameMainInterfacePanel.date.text = os.date("%d").."," ..os.date("%B %a")
    date = tonumber(os.date("%Y%m%d"))
    hour = tonumber(os.date("%H"))
    if self.weatherDay == nil then
        self.weatherDay = date
    end
    if self.weatherHour == nil then
        self.weatherHour = hour
    end
    if self.weatherDay ~= date or  self.weatherHour ~= hour then
        self.weatherDay = date
        self.weatherHour = hour
        if WeatherConfig[date].weather[hour] ~= nil then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/"..WeatherConfig[date].weather[hour], GameMainInterfacePanel.weather,true)
        end
    end
    countDown = countDown - 1
    local ts = getFormatUnixTime(countDown)
    local time = ts.minute..":"..ts.second
    GameMainInterfacePanel.auctionTime.text = groundState.."..."..time
    if countDown <= 0 then
        GameMainInterfaceCtrl:m_MainCtrlShowGroundAuc()
    end
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
    PlayMusEff(1002)
    local ownerInfo = DataManager.GetMyPersonalHomepageInfo()
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", ownerInfo)
end

--通知--

function GameMainInterfaceCtrl.OnNotice(go)
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    if Mails == nil then
        ct.OpenCtrl("NoMessageCtrl")
    else
        ct.OpenCtrl('GameNoticeCtrl',Mails)
    end
end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("ChatCtrl", {toggleId = 1})
end

--好友--
function GameMainInterfaceCtrl.OnFriends()
    PlayMusEff(1002)
    ct.OpenCtrl("FriendsCtrl")
end

--好友红点--
function GameMainInterfaceCtrl._showFriendsNotice()
    local friendsApply = DataManager.GetMyFriendsApply()
    GameMainInterfacePanel.friendsNotice:SetActive(#friendsApply > 0)
end

function GameMainInterfaceCtrl:c_OnReceiveAddFriendReq()
    PlayMusEff(1006)
    self._showFriendsNotice()
end

-- 世界聊天显示
function GameMainInterfaceCtrl:c_OnReceiveRoleCommunication(chatData)
    if chatData.channel == "WORLD" then
        if GameMainInterfacePanel.worldChatContent.childCount >= 4 then
            for i = 1, GameMainInterfacePanel.worldChatContent.childCount - 3 do
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
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("SystemSettingCtrl")
end

--建筑--
function GameMainInterfaceCtrl.OnBuild()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl('ConstructCtrl')
    --相机切换到建造状态
    CameraMove.ChangeCameraState(TouchStateType.ConstructState)
end

--拍卖
function GameMainInterfaceCtrl:OnAuction()
    PlayMusEff(1002)
    GAucModel._moveToAucPos()
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
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("GuidBookCtrl")
end

--广告设施
function GameMainInterfaceCtrl:OnAdvertisFacilitie()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("MunicipalCtrl")
    Event.Brocast("m_detailPublicFacility",MunicipalModel.lMsg.info.id)
end

--中心建筑
function GameMainInterfaceCtrl:OnCenterBuilding()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    --TerrainManager.MoveToCentralBuidingPosition()
    ct.OpenCtrl("CenterBuildingCtrl")
end

--关闭updata
function GameMainInterfaceCtrl:RemoveUpdata()
    if self.m_Timer ~= nil then
        self.m_Timer:Start()
    end
end



