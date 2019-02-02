GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPanel)
UIPanel:ResgisterOpen(GameMainInterfaceCtrl) --注册打开的方法

local gameMainInterfaceBehaviour;
local Mails
local countDown = 0
local groundState
local incomeNotify    --收益详情表
local lastTime   --上一次时间


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
    --for key, v in pairs(Good) do
    --    PlayerTempModel.tempTestReqAddItem(key,500)
    --end
    --
    --for key, v in pairs(Material) do
    --    PlayerTempModel.tempTestReqAddItem(key,500)
    --end
    Event.AddListener("c_beginBuildingInfo",self.c_beginBuildingInfo,self)
    Event.AddListener("c_ChangeMoney",self.c_ChangeMoney,self)
    Event.AddListener("c_openBuildingInfo", self.c_openBuildingInfo,self)
    Event.AddListener("c_GetBuildingInfo", self.c_GetBuildingInfo,self)
    Event.AddListener("c_receiveOwnerDatas",self.SaveData,self)
    --Event.AddListener("m_MainCtrlShowGroundAuc",self.SaveData,self)
end

function GameMainInterfaceCtrl:Active()
    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_AllMails",self.c_AllMails,self)
    Event.AddListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)   --获取拍卖状态
    Event.AddListener("c_RefreshMails",self.c_RefreshMails,self)   --跟新邮件
    Event.AddListener("c_IncomeNotify",self.c_IncomeNotify,self) --收益详情
    Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self) --玩家信息网络回调

    GameMainInterfacePanel.noMessage:GetComponent("Text").text = GetLanguage(11020005)
end

function GameMainInterfaceCtrl:Hide()

    UIPanel.Hide(self)

    Event.RemoveListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.RemoveListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.RemoveListener("c_AllMails",self.c_AllMails,self)
    Event.RemoveListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)  --获取拍卖状态
    Event.RemoveListener("c_RefreshMails",self.c_RefreshMails,self)   --跟新邮件
    Event.RemoveListener("c_IncomeNotify",self.c_IncomeNotify,self) --收益详情
    Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)--玩家信息网络回调
    GameMainInterfaceCtrl:OnClick_EarningBtn(false)
end

function GameMainInterfaceCtrl:Close()
    self:RemoveUpdata()
    UIPanel.Close(self)
    self = nil
end

--金币改变
function GameMainInterfaceCtrl:c_ChangeMoney(money)
    self.money = getPriceString("E"..GetClientPriceString(money),24,20)
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
    if state ~= nil and state.groundState ~= nil then
        if state.groundState == 0 then
            GameMainInterfacePanel.auctionButton.transform.localScale = Vector3.one
            GameMainInterfacePanel.isAuction.localScale = Vector3.zero
            local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
            countDown = state.beginTime - currentTime   --倒计时间
            groundState = GetLanguage(11020002)
        elseif state.groundState == 1 then
            GameMainInterfacePanel.auctionButton.transform.localScale = Vector3.one
            GameMainInterfacePanel.isAuction.localScale = Vector3.one
            local endTime = state.beginTime + state.durationSec    --结束时间
            local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
            countDown = endTime - currentTime
            groundState = GetLanguage(11020001)
        end
    else
        GameMainInterfacePanel.auctionButton.transform.localScale = Vector3.zero
    end
end

--todo 收益详情
function GameMainInterfaceCtrl:c_IncomeNotify(dataInfo)
    if incomeNotify == nil then
        incomeNotify = {}
        incomeNotify[1] = dataInfo
        lastTime = TimeSynchronized.GetTheCurrentTime()
        local ts = getFormatUnixTime(lastTime)
        GameMainInterfacePanel.timeText.text = ts.hour..":"..ts.minute
    else
        table.insert(incomeNotify,dataInfo)
        local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
        if currentTime - lastTime > 60 then
            local ts = getFormatUnixTime(currentTime)
            GameMainInterfacePanel.timeText.text = ts.hour..":"..ts.minute
        end
        lastTime = currentTime
    end
    self.isTimmer = true
    self.timmer = 2
    GameMainInterfacePanel.simpleEarning.transform.localScale = Vector3.one
    GameMainInterfacePanel.open.transform.localScale = Vector3.zero

    GameMainInterfacePanel.simpleMoney.text = "E"..GetClientPriceString(dataInfo.cost)

    if dataInfo.buyer == "PLAYER" then
        if dataInfo.type == "BUY_GROUND" or dataInfo.type == "RENT_GROUND" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture.png", GameMainInterfacePanel.simplePicture, true)
            GameMainInterfacePanel.simplePictureText.text = "("..dataInfo.coord[1].x..","..dataInfo.coord[1].y..")"
        elseif dataInfo.type == "INSHELF" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", GameMainInterfacePanel.simplePicture)
            GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
        end
        elseif dataInfo.buyer == "NPC" then
        if dataInfo.type == "RENT_ROOM" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-apartment.png", GameMainInterfacePanel.simplePicture, true)
            GameMainInterfacePanel.simplePictureText.text = "X1"
        elseif dataInfo.type == "INSHELF" then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", GameMainInterfacePanel.simplePicture)
            GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
        end
    end
    GameMainInterfacePanel.earningScroll:ActiveLoopScroll(self.earnings, #incomeNotify)
end

--好友信息
function GameMainInterfaceCtrl:c_OnReceivePlayerInfo(playerData)
    local info = {}
    info.id = playerData.info[1].id
    info.name = playerData.info[1].name
    info.companyName = playerData.info[1].companyName
    info.des = playerData.info[1].des
    info.faceId = playerData.info[1].faceId
    info.male = playerData.info[1].male
    info.createTs = playerData.info[1].createTs
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", info)
end

function GameMainInterfaceCtrl:c_beginBuildingInfo(buildingInfo,func)
    -- TODO:ct.log("system","重新开业")
    if DataManager.GetMyOwnerID()~=buildingInfo.ownerId  then
        return
    end



    local workerNum=PlayerBuildingBaseData[buildingInfo.mId].maxWorkerNum
    local dayWage=PlayerBuildingBaseData[buildingInfo.mId].salary

    if DataManager.GetMoney()< workerNum*dayWage then
        Event.Brocast("SmallPop",GetLanguage(4301006),300)
    end

    local data = {workerNum=workerNum ,dayWage=dayWage ,buildInfo= buildingInfo,callback=function ()
            Event.Brocast("m_ReqHouseSetSalary1",buildingInfo.id,100)
            Event.Brocast("m_startBusiness",buildingInfo.id)
    end}

    ct.OpenCtrl("WagesAdjustBoxCtrl",data)

    Event.AddListener("c_successBuilding",function ()
            func()
        Event.Brocast("SmallPop",GetLanguage(40010020),300)
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
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.smallMap.gameObject,self.OnSmallMap,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.worldChatPanel,self.OnChat,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.auctionButton,self.OnAuction,self); --拍卖
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.centerBuilding,self.OnCenterBuilding,self); --中心建筑

    --todo 收益
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.open,self.OnOpen,self); --打开收益详情
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.earningsPanelBg,self.OnEarningsPanelBg,self); --点击收益详情Bg
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.close,self.OnClose,self); --关闭收益详情
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.xBtn,self.OnXBtn,self); --点击xBtn
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.clearBtn,self.OnClearBtn,self); --点击ClearBtn
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.clearBg,self.OnClearBg,self); --点击ClearBg
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.simple,self.OnSimple,self); --点击简单收益面板

    --滑动互用
    self.earnings = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.earnings.mProvideData = GameMainInterfaceCtrl.static.EarningsProvideData
    self.earnings.mClearData = GameMainInterfaceCtrl.static.EarningsClearData

    --头像
    local faceId = DataManager.GetFaceId()
    LoadSprite(PlayerHead[faceId].MainPath, GameMainInterfacePanel.headItem, true)
    self.insId = OpenModelInsID.GameMainInterfaceCtrl
    local info = DataManager.GetMyPersonalHomepageInfo()
    self.name = info.name
    self.gender = info.male

    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/"..WeatherConfig[tonumber(ts.year..ts.month..ts.day)].weather[tonumber(ts.hour)], GameMainInterfacePanel.weather,true)

    local gold = DataManager.GetMoneyByString()
    self.money = "E"..getPriceString(gold,24,20)
    GameMainInterfacePanel.money.text = self.money

    GameMainInterfaceCtrl:m_MainCtrlShowGroundAuc() --获取土地拍卖状态

    --收益倒计时条件
    self.isTimmer = false

    --初始化循环参数
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self.RefreshWeather, self), 1, -1, true)
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
    UIPanel.Active(self)
    self.m_Timer:Start()
    --初始化姓名,性别
    GameMainInterfacePanel.name.text = self.name
    if self.gender then
        GameMainInterfacePanel.male.localScale = Vector3.one
        GameMainInterfacePanel.woman.localScale = Vector3.zero
    else
        GameMainInterfacePanel.male.localScale = Vector3.zero
        GameMainInterfacePanel.woman.localScale = Vector3.one
    end
    GameMainInterfacePanel.city.text = GetLanguage(10030003)
end

local date
local hour
function GameMainInterfaceCtrl:RefreshWeather()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    GameMainInterfacePanel.time.text = ts.hour..":"..ts.minute
    --GameMainInterfacePanel.date.text = os.date("%d").."," ..os.date("%B %a")
    GameMainInterfacePanel.date.text = ts.year.."-"..ts.month.."-"..ts.day
    date = tonumber(ts.year..ts.month..ts.day)
    hour = tonumber(ts.hour)
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
    if groundState ~= nil then
        countDown = countDown - 1
        local ts = getFormatUnixTime(countDown)
        local time = ts.minute..":"..ts.second
        GameMainInterfacePanel.auctionTime.text = time
        if countDown <= 0 then
            GameMainInterfaceCtrl:m_MainCtrlShowGroundAuc()
        end
    end
    if  self.isTimmer then
        self.timmer = self.timmer -1
        if self.timmer <= 0 then
            GameMainInterfacePanel.simpleEarning.transform.localScale = Vector3.zero
            if GameMainInterfacePanel.bg.transform.localScale ~= Vector3.one then
                GameMainInterfacePanel.open.transform.localScale = Vector3.one
            end
            self.isTimmer = false
        end
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

--更新邮件
function GameMainInterfaceCtrl:c_RefreshMails(mails)
    GameMainInterfacePanel.noticeItem.localScale = Vector3.one
    if Mails == nil then
        Mails = {}
        Mails[1] = mails
    else
        table.insert(Mails,mails)
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

    local data = DataManager.GetMyChatInfo(1)
    local worldInfoAllNum = #data
    if worldInfoAllNum >=1 then
        for i = 1, GameMainInterfacePanel.worldChatContent.childCount do
            UnityEngine.GameObject.Destroy(GameMainInterfacePanel.worldChatContent:GetChild(i-1).gameObject)
        end
        for j = math.max(1, worldInfoAllNum - 3), worldInfoAllNum do
            panelMgr:LoadPrefab_A("Assets/CityGame/Resources/View/Chat/ChatWorldItem.prefab", nil, nil, function(ins, obj )
                if obj ~= nil then
                    local go = ct.InstantiatePrefab(obj)
                    local rect = go.transform:GetComponent("RectTransform")
                    go.transform:SetParent(GameMainInterfacePanel.worldChatContent)
                    rect.transform.localScale = Vector3.one
                    local chatWorldItem = ChatWorldItem:new(go, data[j])
                end
            end)
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

--小地图
function GameMainInterfaceCtrl:OnSmallMap()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:RemoveUpdata()
    ct.OpenCtrl("MiniMapCtrl")
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
        self.m_Timer:Stop()
    end
end

--todo  收益
--打开
function GameMainInterfaceCtrl:OnOpen()
    GameMainInterfaceCtrl:OnClick_EarningBtn(true)
end

--点击收益背景
function GameMainInterfaceCtrl:OnEarningsPanelBg()
    GameMainInterfaceCtrl:OnClick_EarningBtn(false)
end

--关闭
function GameMainInterfaceCtrl:OnClose()
    GameMainInterfaceCtrl:OnClick_EarningBtn(false)
end

--点击xBtn
function GameMainInterfaceCtrl:OnXBtn()
    GameMainInterfacePanel.clearBtn.transform.localScale = Vector3.one
    GameMainInterfacePanel.clearBg.transform.localScale = Vector3.one
    GameMainInterfacePanel.xBtn.transform.localScale = Vector3.zero
end

--点击ClearBtn
function GameMainInterfaceCtrl:OnClearBtn(go)
    incomeNotify = {}
    GameMainInterfacePanel.earningScroll:ActiveLoopScroll(go.earnings, 0)
end

--点击ClearBg
function GameMainInterfaceCtrl:OnClearBg()
    GameMainInterfacePanel.clearBtn.transform.localScale = Vector3.zero
    GameMainInterfacePanel.clearBg.transform.localScale = Vector3.zero
    GameMainInterfacePanel.xBtn.transform.localScale = Vector3.one
end

--点击简单收益面板
function GameMainInterfaceCtrl:OnSimple()
    GameMainInterfaceCtrl:OnClick_EarningBtn(true)
end

--滑动互用
GameMainInterfaceCtrl.static.EarningsProvideData = function(transform, idx)

    idx = idx + 1
    local item = DetailsEarningItem:new(incomeNotify[#incomeNotify-idx+1],transform,idx)
    local earningItems = {}
    earningItems[idx] = item
end

GameMainInterfaceCtrl.static.EarningsClearData = function(transform)

end

--打开关闭收益详情
function GameMainInterfaceCtrl:OnClick_EarningBtn(isShow)
    if isShow then
        GameMainInterfacePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        GameMainInterfacePanel.open.transform.localScale = Vector3.zero
        GameMainInterfacePanel.earningsPanelBg.transform.localScale = Vector3.one
    else
        GameMainInterfacePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        GameMainInterfacePanel.open.transform.localScale = Vector3.one
        GameMainInterfacePanel.earningsPanelBg.transform.localScale = Vector3.zero
    end
    GameMainInterfaceCtrl:OnClearBg()
    if incomeNotify  == nil then
        GameMainInterfacePanel.noMessage.localScale = Vector3.one
        GameMainInterfacePanel.timeBg.transform.localScale = Vector3.zero
        GameMainInterfacePanel.xBtn.transform.localScale =  Vector3.zero
    else
        GameMainInterfacePanel.noMessage.localScale = Vector3.zero
        GameMainInterfacePanel.timeBg.transform.localScale = Vector3.one
        GameMainInterfacePanel.xBtn.transform.localScale =  Vector3.one
    end
end



