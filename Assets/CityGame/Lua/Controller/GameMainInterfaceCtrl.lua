GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPanel)
UIPanel:ResgisterOpen(GameMainInterfaceCtrl) --How to open the registration
local gameMainInterfaceBehaviour;
local Mails
local incomeNotify    --Revenue details table
local lastIncomeNotify  --Open the income statement in front of the income panel
local lastTime = 0  --Last time
--todo City radio
local radioTime      --时间time
local radioIndex     --index
local radio          --Broadcast information table (ordered)
local newRadio       --Unplayed broadcast information table

local  cost = {}          --Major transaction amount
local time = {}          --Major trading hours
local index = 0
local indexs = 0
local chatItemNum = 3   -- Number of world chats displayed

GameMainInterfaceCtrl.SmallPop_Path="Assets/CityGame/Resources/View/GoodsItem/TipsParticle.prefab"--Small popup path

function  GameMainInterfaceCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GameMainInterfacePanel.prefab"
end

function GameMainInterfaceCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)
end

--Start event -
function GameMainInterfaceCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
    Event.AddListener("c_beginBuildingInfo",self.c_beginBuildingInfo,self)
    Event.AddListener("c_openBuildingInfo", self.c_openBuildingInfo,self)
    Event.AddListener("c_GetBuildingInfo", self.c_GetBuildingInfo,self)
    Event.AddListener("c_receiveOwnerDatas",self.SaveData,self)
    --Sound effect switching after entering the game
    PlayMus(1001)
    --Event.AddListener("m_MainCtrlShowGroundAuc",self.SaveData,self)
end

function GameMainInterfaceCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_AllMails",self.c_AllMails,self)
    Event.AddListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)   --Get auction status
    Event.AddListener("c_RefreshMails",self.c_RefreshMails,self)   --Follow new mail
    Event.AddListener("c_AllNpcNum",self.c_AllNpcNum,self)   --Number of NPCs in the city
    --Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self) --Player Information Network Callback
    --Event.AddListener("c_RadioInfo", self.c_OnRadioInfo, self) --City radio
    --Event.AddListener("c_MajorTransaction", self.c_OnMajorTransaction, self) --Major transaction
    Event.AddListener("c_AllExchangeAmount", self.c_AllExchangeAmount, self) --All transactions
    --Event.AddListener("c_CityBroadcasts", self.c_CityBroadcasts, self) --Get City Radio
    Event.AddListener("c_GuildMessageNewJoinReq", self.c_GuildMessageNewJoinReq, self) -- Receive new guild application
    Event.AddListener("c_GameMainExitSociety", self.c_GameMainExitSociety, self) -- Withdraw from the alliance
    Event.AddListener("c_UnLineInformation", self.c_UnLineInformation, self) --Offline notification

    GameMainInterfacePanel.city.text = GetLanguage(10050002)
    GameMainInterfacePanel.smallMapText.text = GetLanguage(11010005)
    GameMainInterfacePanel.cityInfoText.text = GetLanguage(11010004)
    GameMainInterfacePanel.guideText.text = GetLanguage(11010003)
    GameMainInterfacePanel.buildButtonText.text = GetLanguage(11010002)
    GameMainInterfacePanel.evaText.text = GetLanguage(11010001)
    GameMainInterfacePanel.grossVolume.text = GetLanguage(11010006)
    GameMainInterfacePanel.noMessage:GetComponent("Text").text = GetLanguage(11010009)
end

function GameMainInterfaceCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.RemoveListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.RemoveListener("c_AllMails",self.c_AllMails,self)
    Event.RemoveListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)  --Get auction status
    Event.RemoveListener("c_RefreshMails",self.c_RefreshMails,self)   --Follow new mail
    Event.RemoveListener("c_AllNpcNum",self.c_AllNpcNum,self)   --Number of NPCs in the city
    --Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)--Player Information Network Callback
    --Event.RemoveListener("c_RadioInfo", self.c_OnRadioInfo, self) --City radio
    --Event.RemoveListener("c_majorTransaction", self.c_OnMajorTransaction, self) --Major transaction
    Event.RemoveListener("c_AllExchangeAmount", self.c_AllExchangeAmount, self) --All transactions
    --Event.RemoveListener("c_CityBroadcasts", self.c_CityBroadcasts, self) --Get City Radio
    Event.RemoveListener("TemperatureChange",self.c_TemperatureChange,self)
    Event.RemoveListener("WeatherIconChange",self.c_WeatherIconChange,self)
    Event.RemoveListener("c_GuildMessageNewJoinReq",self.c_GuildMessageNewJoinReq,self)
    Event.RemoveListener("c_GameMainExitSociety",self.c_GameMainExitSociety,self)
    Event.RemoveListener("c_UnLineInformation",self.c_UnLineInformation,self)

    GameMainInterfaceCtrl:OnClick_EarningBtn(false,self)
    self:RemoveUpdata()
end

function GameMainInterfaceCtrl:Close()
    self:RemoveUpdata()
    UIPanel.Close(self)
    Event.RemoveListener("c_IncomeNotify",self.c_IncomeNotify,self) --Revenue details
    Event.RemoveListener("updatePlayerName",self.updateNameFunc,self)  --Change the name
    Event.RemoveListener("SmallPop",self.c_SmallPop,self)
    Event.RemoveListener("c_ChangeMoney",self.c_ChangeMoney,self)
    self = nil
end

--Gold coins change
function GameMainInterfaceCtrl:c_ChangeMoney(money)
    self.money = getPriceString("E"..getMoneyString(GetClientPriceString(money)),24,20)
    GameMainInterfacePanel.money.text = self.money
end

---Popup
function GameMainInterfaceCtrl:c_SmallPop(string,type)
    if  not self.prefab then
        local function callback(prefab)
            self.prefab = prefab
            SmallPopItem:new(string,type,prefab ,self,gameMainInterfaceBehaviour);
        end
        createPrefab(GameMainInterfaceCtrl.SmallPop_Path,self.root, callback)
    else
        SmallPopItem:new(string,type,self.prefab ,self,gameMainInterfaceBehaviour);
    end
end

function GameMainInterfaceCtrl:SaveData(ownerData)
    if self.groundOwnerDatas then
        table.insert(self.groundOwnerDatas,ownerData[1])
    end
end

--Change name
function GameMainInterfaceCtrl:updateNameFunc(name)
    GameMainInterfacePanel.name.text = name
end

--Number of NPCs in the city
function GameMainInterfaceCtrl:c_AllNpcNum(info)
    local num = 0
    num = info.workNpcNum + info.unEmployeeNpcNum
    GameMainInterfacePanel.allNpcNum.text = getMoneyString(num)
end

--todo revenue details
function GameMainInterfaceCtrl:c_IncomeNotify(dataInfo)
    GameMainInterfacePanel.simpleEarning.transform.localScale = Vector3.zero
    GameMainInterfacePanel.simpleEarningBg.localScale = Vector3.one
    if incomeNotify == nil then
        incomeNotify = {}
        incomeNotify[1] = dataInfo
        lastTime = TimeSynchronized.GetTheCurrentTime()
        local ts = getFormatUnixTime(lastTime)
        GameMainInterfacePanel.timeText.text = ts.hour..":"..ts.minute
    else
        table.insert(incomeNotify,dataInfo)
        local currentTime = TimeSynchronized.GetTheCurrentTime()    --Current server time (seconds)
        if currentTime - lastTime > 1 then
            local ts = getFormatUnixTime(currentTime)
            GameMainInterfacePanel.timeText.text = ts.hour..":"..ts.minute
        --else
        --    GameMainInterfacePanel.timeText.text = GetLanguage(11010015)
        end
        lastTime = currentTime
    end
    if not self.isOpen then
        self.isTimmer = true
        self.timmer = 2
        GameMainInterfacePanel.simpleEarning:GetComponent("RectTransform"):DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        GameMainInterfacePanel.simpleEarning:GetComponent("Image"):DOFade(1,0.1):SetEase(DG.Tweening.Ease.OutCubic);

        GameMainInterfacePanel.simpleMoney.text = "E"..GetClientPriceString(dataInfo.cost)

        if dataInfo.buyer == "PLAYER" then
            if dataInfo.type == "BUY_GROUND" or dataInfo.type == "RENT_GROUND" then
                GameMainInterfacePanel.income.text = GetLanguage(11010010)
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/landx1.png", GameMainInterfacePanel.simplePicture, true)
                GameMainInterfacePanel.simplePictureText.text = "("..dataInfo.coord[1].x..","..dataInfo.coord[1].y..")"
            elseif dataInfo.type == "INSHELF" then
                GameMainInterfacePanel.income.text = GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
                GameMainInterfacePanel.simplePicture.sprite = SpriteManager.GetSpriteByPool(dataInfo.itemId)
                GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
            elseif dataInfo.type == "PROMO" then
                GameMainInterfacePanel.income.text =  GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
                LoadSprite(ResearchConfig[dataInfo.itemId].buildingPath, GameMainInterfacePanel.simplePicture)

                GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
            elseif dataInfo.type == "LAB" then
                GameMainInterfacePanel.income.text =  GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
                LoadSprite(ResearchConfig[dataInfo.itemId].iconPath, GameMainInterfacePanel.simplePicture)

                GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
            end
        elseif dataInfo.buyer == "NPC" then
            if dataInfo.type == "RENT_ROOM" then
                GameMainInterfacePanel.income.text = GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-apartment.png", GameMainInterfacePanel.simplePicture, true)
                GameMainInterfacePanel.simplePictureText.text = "X1"
            elseif dataInfo.type == "INSHELF" then
                GameMainInterfacePanel.income.text =  GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
                GameMainInterfacePanel.simplePicture.sprite = SpriteManager.GetSpriteByPool(dataInfo.itemId)
                GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
            end
        end
    else
        self.isTimmer = true
        if incomeNotify then
            GameMainInterfacePanel.earningScroll:ActiveLoopScroll(self.earnings, #incomeNotify)
            lastIncomeNotify = ct.deepCopy(incomeNotify)
        end
    end
end


function GameMainInterfaceCtrl:c_OnReceivePlayerInfo(playerData)
    local info = {}
    info.id = playerData[1].id
    info.name = playerData[1].name
    info.companyName = playerData[1].companyName
    info.des = playerData[1].des
    info.faceId = playerData[1].faceId
    info.male = playerData[1].male
    info.createTs = playerData[1].createTs
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", info)
end

function GameMainInterfaceCtrl:c_beginBuildingInfo(buildingInfo,func)
    -- TODO:ct.log("system","Reopen")
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

    Event.AddListener("c_successBuilding",
        function ()
         func()
         Event.Brocast("SmallPop",GetLanguage(24020018),300)
         end
    ,self)

end

function GameMainInterfaceCtrl:c_openBuildingInfo(buildingInfo)
    --Open the interface
    if buildingInfo then
        buildingInfo.ctrl=self
        ct.OpenCtrl('StopAndBuildCtrl',buildingInfo)
    end

end

function GameMainInterfaceCtrl:c_GetBuildingInfo(buildingInfo)
    --Request land information
    local startBlockId=TerrainManager.GridIndexTurnBlockID(buildingInfo.pos)
    local blockIds = DataManager.CaculationTerrainRangeBlock(startBlockId,PlayerBuildingBaseData[buildingInfo.mId].x)
    self.groundDatas={}
    for i, blockId in ipairs(blockIds) do
        local data = DataManager.GetGroundDataByID(blockId)
        table.insert(self.groundDatas,data)
    end

    --Request information from the landowner
    self.groundOwnerDatas={}
    for i, groundData in ipairs(self.groundDatas) do
        local Ids={}
        table.insert(Ids,groundData.Data.ownerId)
        --Event.Brocast("m_QueryPlayerInfoChat",Ids)
        PlayerInfoManger.GetInfos(Ids,self.SaveData,self)
    end

    --Request information from the owner
    local ids={}
    table.insert(ids,buildingInfo.ownerId)
    PlayerInfoManger.GetInfos(ids,self.SaveData,self)

end

--todo City radio
--function GameMainInterfaceCtrl:c_OnRadioInfo(info)
--    local index
--    if radio == nil then
--        radio = {}
--        radio[1] = info
--    else
--        if info.type ~= 1 then
--            for i, v in pairs(radio) do
--                if info.type == v.type then
--                   index = i
--                end
--            end
--            if index ~= nil then
--                table.remove(radio,index)
--            end
--        end
--        table.insert(radio,info)
--    end
--    if #radio >1 then
--        if radio[#radio].ts - radio[#radio-1].ts < 10 then
--            if newRadio == nil then
--                newRadio = {}
--                newRadio[1] = info
--            else
--                table.insert(newRadio,info)
--            end
--        else
--            GameMainInterfaceCtrl:BroadcastRadio(radio,#radio)
--            radioTime = 10
--            radioIndex = 1
--        end
--    end
--
--end

--todo Major transaction
--function GameMainInterfaceCtrl:c_OnMajorTransaction(info)
--    cost = nil
--    time = nil
--    cost = info.cost
--    time = info.ts
--    local idTemp = {}
--    table.insert(idTemp,info.sellerId)
--    table.insert(idTemp,info.buyerId)
--
--    PlayerInfoManger.GetInfos(idTemp, self.c_OnMajorTransactionInfo, self)
--end
--
--function GameMainInterfaceCtrl:c_OnOldMajorTransaction(info)
--    index = index +1
--    cost[index] = info.cost
--    time[index] = info.ts
--    local idTemp = {}
--    table.insert(idTemp,info.sellerId)
--    table.insert(idTemp,info.buyerId)
--
--    PlayerInfoManger.GetInfos(idTemp, self.c_OnOldMajorTransactionInfo, self)
--end
--
----Major transaction information
--function GameMainInterfaceCtrl:c_OnMajorTransactionInfo(info)
--    local data = {}
--    data.sellName = info[1].name
--    data.sellFaceId = info[1].faceId
--    data.buyName = info[2].name
--    data.buyFaceId = info[2].faceId
--    data.cost = cost
--    data.ts = time
--    data.type = 1
--    GameMainInterfaceCtrl:c_OnRadioInfo(data)
--end
--
--function GameMainInterfaceCtrl:c_OnOldMajorTransactionInfo(info)
--    indexs = indexs + 1
--    local data = {}
--    data.sellName = info[1].name
--    data.sellFaceId = info[1].faceId
--    --data.buyName = info[2].name
--    --data.buyFaceId = info[2].faceId
--    data.cost = cost[indexs]
--    data.ts = time[indexs]
--    data.type = 1
--    if radio == nil then
--        radio = {}
--        table.insert(radio,data)
--    else
--        table.insert(radio,data)
--    end
--    table.sort(radio, function (m, n) return m.ts < n.ts end)
--end

--所有交易量
function GameMainInterfaceCtrl:c_AllExchangeAmount(info)
    GameMainInterfacePanel.volumeText.text ="E"..getMoneyString(GetClientPriceString(info))
end

----Get all city radio
--function GameMainInterfaceCtrl:c_CityBroadcasts(info)
--
--    if info == nil then
--        return
--    end
--
--        for i, v in ipairs(info) do
--            if v.type == 1 then
--                GameMainInterfaceCtrl:c_OnOldMajorTransaction(v)
--            else
--                if radio == nil then
--                    radio = {}
--                    table.insert(radio,v)
--                end
--            end
--        end
--
--end

--temperature change
function GameMainInterfaceCtrl:c_TemperatureChange()
    if ClimateManager.Temperature ~= nil then
        GameMainInterfacePanel.temperature.text = math.floor(ClimateManager.Temperature) .."℃"
    else
        GameMainInterfacePanel.temperature.text = "0 ℃"
    end
end

--weather change
function GameMainInterfaceCtrl:c_WeatherIconChange()
    if ClimateManager.WeatherIcon ~= nil then
        LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/".. ClimateManager.WeatherIcon ..".png", GameMainInterfacePanel.weather,true)
    else
        ct.log("system","服务器同步天气Icon失败")
    end
end

-- New membership request
function GameMainInterfaceCtrl:c_GuildMessageNewJoinReq()
    GameMainInterfacePanel.leagueNotice.localScale = Vector3.one
end

-- Withdraw from the alliance
function GameMainInterfaceCtrl:c_GameMainExitSociety()
    self:_showWorldChatNoticeItem()
end

-- Offline notification
function GameMainInterfaceCtrl:c_UnLineInformation(unLineInformations)
    ct.OpenCtrl('OfflineNotificationCtrl',unLineInformations)
end

function GameMainInterfaceCtrl:Awake()
    --PlayerTempModel.tempTestCreateAll()
    self.root=self.gameObject.transform.root:Find("FixedRoot");
    Event.AddListener("c_OnConnectTradeSuccess",self.c_OnSSSuccess,self)        --Connect ss success callback
    Event.AddListener("c_IncomeNotify",self.c_IncomeNotify,self) --Revenue details
    Event.AddListener("updatePlayerName",self.updateNameFunc,self)  --Change name
    Event.AddListener("c_ChangeMoney",self.c_ChangeMoney,self)
    Event.AddListener("TemperatureChange",self.c_TemperatureChange,self)
    Event.AddListener("WeatherIconChange",self.c_WeatherIconChange,self)
    self.c_TemperatureChange()
    self.c_WeatherIconChange()
   
    Event.AddListener("SmallPop",self.c_SmallPop,self)
    CityEngineLua.login_tradeapp(true)
    gameMainInterfaceBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.noticeButton.gameObject,self.OnNotice,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.head.gameObject,self.OnHead,self); 
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.companyBtn,self.OnCompanyBtn,self); 
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.addGold,self.OnAddGold,self); 
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.friendsButton.gameObject, self.OnFriends, self)
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.guide.gameObject,self.OnGuideBool,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.smallMap.gameObject,self.OnSmallMap,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.chat,self.OnChat,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.auctionButton,self.OnAuction,self); 
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.cityInfo,self.OnCityInfo,self); 
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.league,self.OnLeague,self); 
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.eva,self.OnEva,self); 

    --todo income
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.open,self.OnOpen,self); --Open revenue details
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.earningsPanelBg,self.OnEarningsPanelBg,self); --Click on earnings details Bg
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.close,self.OnClose,self); --Close earnings details
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.xBtn,self.OnXBtn,self); --Click xBtn
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.clearBtn,self.OnClearBtn,self); --Click ClearBtn
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.clearBg,self.OnClearBg,self); --Click ClearBg
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.simple,self.OnSimple,self); --Click the simple earnings panel


    --todo City radio
    --gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.leftRadioBtn,self.OnLeftRadioBtn,self);
    --gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.rightRadio,self.OnRightRadio,self);

    --Transaction Record
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.volume,self.OnVolume,self);

    --Sliding interoperability
    self.earnings = UnityEngine.UI.LoopScrollDataSource.New()  --Quotes
    self.earnings.mProvideData = GameMainInterfaceCtrl.static.EarningsProvideData
    self.earnings.mClearData = GameMainInterfaceCtrl.static.EarningsClearData

    self.insId = OpenModelInsID.GameMainInterfaceCtrl
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --Current server time (seconds)
    local ts = getFormatUnixTime(currentTime)

    --LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/"..WeatherConfig[tonumber(ts.year..ts.month..ts.day)].weather[tonumber(ts.hour) + 1], GameMainInterfacePanel.weather,true)
    --GameMainInterfacePanel.temperature.text = WeatherConfig[tonumber(ts.year..ts.month..ts.day)].temperature[tonumber(ts.hour) + 1].."℃"

    --Countdown conditions for earnings
    self.isTimmer = false

    --radioTime = 0
    radioIndex = 1
    --Initialize loop parameters
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self.RefreshWeather, self), 1, -1, true)

    -- Initialize three world chat items
    self.worldChatItem = {}
    for a = 1, chatItemNum do
        local go = ct.InstantiatePrefab(GameMainInterfacePanel.chatWorldItem)
        local rect = go.transform:GetComponent("RectTransform")
        go.transform:SetParent(GameMainInterfacePanel.worldChatContent)
        rect.transform.localScale = Vector3.one
        rect.transform.localPosition = Vector3.zero
        go:SetActive(true)

        self.worldChatItem[a] = ChatWorldItem:new(go)
    end
end

--Connect ss success callback
function GameMainInterfaceCtrl:c_OnSSSuccess()
    DataManager.OpenDetailModel(GameMainInterfaceModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_AllExchangeAmount')
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetNpcNum')
    --DataManager.DetailModelRpcNoRet(self.insId , 'm_queryCityBroadcast')
end

function GameMainInterfaceCtrl:Refresh()
    --Open the main interface Model
    Mails = nil
    self:initInsData()
    self:_showFriendsNotice()
    self:_showWorldChatNoticeItem()
    self:_showLeagueNoticeItem()
end

function GameMainInterfaceCtrl:initInsData()
    DataManager.OpenDetailModel(GameMainInterfaceModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetAllMails')
    --DataManager.DetailModelRpcNoRet(self.insId , 'm_WeatherInfo')
    self.m_Timer:Start()


    local faceId = DataManager.GetFaceId()

    ----The avatar needs to be refreshed
    if self.my_avatarFaceID == nil or self.my_avatarFaceID ~= faceId then
        self.my_avatarFaceID = faceId
        if self.my_avatarData ~= nil then
            AvatarManger.CollectAvatar(self.my_avatarData)
            self.my_avatarData = nil
        end
        self.my_avatarData =  AvatarManger.GetSmallAvatar(faceId,GameMainInterfacePanel.headItem.transform,0.15)
    end
    local info = DataManager.GetMyPersonalHomepageInfo()
    self.name = info.name
    self.company = info.companyName
    --self.gender = info.male

    local gold = DataManager.GetMoneyByString()
    gold = getMoneyString(gold)
    self.money = getPriceString("E"..gold,24,20)
    GameMainInterfacePanel.money.text = self.money

    -- Initialize name, gender, company name
    GameMainInterfacePanel.name.text = self.name
    --GameMainInterfacePanel.company.text = self.company
    --if self.gender then
    --    GameMainInterfacePanel.male.localScale = Vector3.one
    --    GameMainInterfacePanel.woman.localScale = Vector3.zero
    --else
    --    GameMainInterfacePanel.male.localScale = Vector3.zero
    --    GameMainInterfacePanel.woman.localScale = Vector3.one
    --end
end

local date
local hour
function GameMainInterfaceCtrl:RefreshWeather()

    local currentTime = TimeSynchronized.GetTheCurrentTime()    --Current server time (seconds)
    local ts = getFormatUnixTime(currentTime)

    if tonumber(ts.second) % 10 == 0 then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_AllExchangeAmount')
        DataManager.DetailModelRpcNoRet(self.insId , 'm_GetNpcNum')
    end

    GameMainInterfacePanel.time.text = ts.hour..":"..ts.minute
    date = tonumber(ts.year..ts.month..ts.day)
    hour = tonumber(ts.hour)
    if self.weatherDay == nil then
        self.weatherDay = date
    end
    if self.weatherHour == nil then
        self.weatherHour = hour
    end
    --[[
    if self.weatherDay ~= date or  self.weatherHour ~= hour then
        self.weatherDay = date
        self.weatherHour = hour
        if WeatherConfig[date].weather[hour] ~= nil then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/"..WeatherConfig[date].weather[hour], GameMainInterfacePanel.weather,true)
            GameMainInterfacePanel.temperature.text = WeatherConfig[date].temperature[hour].."℃"
        end
    end
    --]]
    if  self.isTimmer then
        self.timmer = self.timmer -1
        if self.timmer <= 0 then
            GameMainInterfacePanel.simpleEarningBg.localScale = Vector3.zero
            GameMainInterfacePanel.simpleEarning:GetComponent("Image"):DOFade(0,0.3):SetEase(DG.Tweening.Ease.OutCubic):OnComplete(function ()
                GameMainInterfacePanel.simpleEarning.transform.localScale = Vector3.zero
            end);
            self.isTimmer = false
        end
    end

    -- todo  City radio
    --radioTime = radioTime -1
    --if radioTime <= 0 then
    --    if newRadio == nil and radio == nil then
    --        return
    --    end
    --    radioTime = 10
    --    if newRadio ~= nil then
    --        GameMainInterfaceCtrl:BroadcastRadio(newRadio,1)
    --        table.remove(newRadio,1)
    --        if #newRadio == 0 then
    --            newRadio = nil
    --        end
    --    else
    --        if radio == nil then
    --            return
    --        end
    --            GameMainInterfaceCtrl:BroadcastRadio(radio,radioIndex)
    --        radioIndex = radioIndex + 1
    --        if radioIndex > #radio then
    --            radioIndex = radioIndex - #radio
    --        end
    --    end
    --end
end

--Get all mail
function GameMainInterfaceCtrl:c_AllMails(DataInfo)
     Mails = DataInfo
    --Determine whether the red dot is displayed
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

--Update mail
function GameMainInterfaceCtrl:c_RefreshMails(mails)
    GameMainInterfacePanel.noticeItem.localScale = Vector3.one
    if Mails == nil then
        Mails = {}
        Mails[1] = mails
    else
        table.insert(Mails,mails)
    end
end

--Click on the avatar
function GameMainInterfaceCtrl:OnHead()
    PlayMusEff(1002)
    local ownerInfo = DataManager.GetMyPersonalHomepageInfo()
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", ownerInfo)
end

--Click on the company name
function GameMainInterfaceCtrl:OnCompanyBtn()
    PlayMusEff(1002)
    local ownerInfo = DataManager.GetMyPersonalHomepageInfo()
    ct.OpenCtrl("CompanyCtrl", ownerInfo)
end

--Notice--

function GameMainInterfaceCtrl.OnNotice(go)
    PlayMusEff(1002)
    if Mails == nil then
        ct.OpenCtrl("NoMessageCtrl")
    else
        ct.OpenCtrl('GameNoticeCtrl',{mails = Mails})
    end
end

--chat--
function GameMainInterfaceCtrl.OnChat()
    PlayMusEff(1002)
    ct.OpenCtrl("ChatCtrl", {toggleId = 1})
end

--Friends--
function GameMainInterfaceCtrl.OnFriends()
    PlayMusEff(1002)
    ct.OpenCtrl("FriendsCtrl")
end

--Friends Red Dot -
function GameMainInterfaceCtrl._showFriendsNotice()
    local friendsApply = DataManager.GetMyFriendsApply()
    if #friendsApply > 0 then
        GameMainInterfacePanel.friendsNotice.localScale = Vector3.one
    else
        GameMainInterfacePanel.friendsNotice.localScale = Vector3.zero
    end
end

function GameMainInterfaceCtrl:c_OnReceiveAddFriendReq()
    PlayMusEff(1006)
    self._showFriendsNotice()
end

-- World chat display
function GameMainInterfaceCtrl:c_OnReceiveRoleCommunication(chatData)
    if chatData.channel == "WORLD" then
        for i = 1, chatItemNum do
            if i == 3 then
                self.worldChatItem[i]:_ShowChatContent(chatData)
            else
                if self.worldChatItem[i + 1].data then
                    self.worldChatItem[i]:_ShowChatContent(self.worldChatItem[i + 1].data)
                end
            end
        end
    else
        GameMainInterfacePanel.chatItem.localScale = Vector3.one
    end
end

function GameMainInterfaceCtrl:_showWorldChatNoticeItem()
    GameMainInterfacePanel.chatItem.localScale = Vector3.zero
    local chatFriendsInfo = DataManager.GetMyChatInfo(2)
    local chatStrangersInfo = DataManager.GetMyChatInfo(3)
    local saveUnread = DataManager.GetUnread()
    for _, v in pairs(chatFriendsInfo) do
        if v.unreadNum and v.unreadNum > 0 then
            GameMainInterfacePanel.localScale = Vector3.one
            return
        end
    end
    for _, m in pairs(chatStrangersInfo) do
        if m.unreadNum and m.unreadNum > 0 then
            GameMainInterfacePanel.chatItem.localScale = Vector3.one
            return
        end
    end
    if saveUnread then
        for _, n in pairs(saveUnread) do
            if n and n[1] then
                GameMainInterfacePanel.chatItem.localScale = Vector3.one
                return
            end
        end
    end

    local data = DataManager.GetMyChatInfo(1)
    local worldInfoAllNum = #data
    if worldInfoAllNum >=1 then
        for i = 1, chatItemNum do
            if data[worldInfoAllNum - chatItemNum + i] then
                self.worldChatItem[i]:_ShowChatContent(data[worldInfoAllNum - chatItemNum + i])
            end
        end
    end

    if DataManager.GetIsReadGuildChatInfo() then
        GameMainInterfacePanel.chatItem.localScale = Vector3.one
    end
end

function GameMainInterfaceCtrl:_showLeagueNoticeItem()
    local societyInfo = DataManager.GetGuildInfo()
    if societyInfo then
        if societyInfo.reqs and societyInfo.reqs[1] then
            GameMainInterfacePanel.leagueNotice.localScale = Vector3.one
        else
            GameMainInterfacePanel.leagueNotice.localScale = Vector3.zero
        end
    end
end

--Settings--
function GameMainInterfaceCtrl.Onset()
    PlayMusEff(1002)
    ct.OpenCtrl("SystemSettingCtrl")
end

--building--
function GameMainInterfaceCtrl.OnBuild()
    PlayMusEff(1002)
    ct.OpenCtrl('ConstructCtrl')
    --The camera switches to the construction state
    CameraMove.ChangeCameraState(TouchStateType.ConstructState)
end

----auction
function GameMainInterfaceCtrl:OnAuction()
    PlayMusEff(1002)
    GAucModel._moveToAucPos()
end

--Residential--
function GameMainInterfaceCtrl.OnHouse()
    ct.OpenCtrl("HouseCtrl", PlayerTempModel.tempHouseData.info.id)
end

--Raw material factory--
function GameMainInterfaceCtrl.OnRawMaterialFactory()
    ct.OpenCtrl("ScienceSellHallCtrl")
end

--Guide Book--
function GameMainInterfaceCtrl.OnGuideBool()
    PlayMusEff(1002)
    ct.OpenCtrl("NoviceTutorialCtrl")
end

--Minimap
function GameMainInterfaceCtrl:OnSmallMap()
    PlayMusEff(1002)
    ct.OpenCtrl("MapCtrl")
end

--City Information
function GameMainInterfaceCtrl:OnCityInfo()
    PlayMusEff(1002)
    ct.OpenCtrl("CenterBuildingCtrl")
end

--Eva
function GameMainInterfaceCtrl:OnEva()
    PlayMusEff(1002)
    local evaSaveKey = string.format("%sEvaOpen", DataManager.GetMyOwnerID())
    local isOpenEva = UnityEngine.PlayerPrefs.HasKey(evaSaveKey)
    if isOpenEva then 
        ct.OpenCtrl("EvaCtrl")
    else 
        UnityEngine.PlayerPrefs.SetInt(evaSaveKey, 1)
        ct.OpenCtrl("EvaJoinCtrl")
    end
end


function GameMainInterfaceCtrl:OnAddGold()
    PlayMusEff(1002)
    ct.OpenCtrl("WalletCtrl")
end


function GameMainInterfaceCtrl:OnLeague()
    PlayMusEff(1002)
    local societyId = DataManager.GetGuildID()
    if societyId then
        ct.OpenCtrl("GuildOwnCtrl", societyId)
    else
        ct.OpenCtrl("GuildListCtrl")
    end
end


function GameMainInterfaceCtrl:RemoveUpdata()
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
end



function GameMainInterfaceCtrl:OnOpen(go)
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(true,go)
end

--Click earnings background
function GameMainInterfaceCtrl:OnEarningsPanelBg(go)
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(false,go)
end

--close
function GameMainInterfaceCtrl:OnClose(go)
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(false,go)
end


function GameMainInterfaceCtrl:OnXBtn()
    PlayMusEff(1002)
    GameMainInterfacePanel.clearBtn.transform.localScale = Vector3.one
    GameMainInterfacePanel.clearBg.transform.localScale = Vector3.one
    GameMainInterfacePanel.xBtn.transform.localScale = Vector3.zero
end

--click ClearBtn
function GameMainInterfaceCtrl:OnClearBtn(go)
    PlayMusEff(1002)
    incomeNotify = {}
    GameMainInterfacePanel.earningScroll:ActiveLoopScroll(go.earnings, 0)
end

--Click ClearBg
function GameMainInterfaceCtrl:OnClearBg()
    PlayMusEff(1002)
    GameMainInterfacePanel.clearBtn.transform.localScale = Vector3.zero
    GameMainInterfacePanel.clearBg.transform.localScale = Vector3.zero
    GameMainInterfacePanel.xBtn.transform.localScale = Vector3.one
end

--Click the simple earnings panel
function GameMainInterfaceCtrl:OnSimple(go)
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(true,go)
end


GameMainInterfaceCtrl.static.EarningsProvideData = function(transform, idx)

    idx = idx + 1
    local item = DetailsEarningItem:new(incomeNotify[#incomeNotify-idx+1],transform,idx)
    local earningItems = {}
    earningItems[idx] = item
    gameMainInterfaceBehaviour:AddClick(transform:Find("bg/headImage/head").gameObject, GameMainInterfaceCtrl._OnHeadBtn, item)
end

GameMainInterfaceCtrl.static.EarningsClearData = function(transform)
    gameMainInterfaceBehaviour:RemoveClick( transform:Find("bg/headImage/head").gameObject, GameMainInterfaceCtrl._OnHeadBtn)
end

function GameMainInterfaceCtrl:_OnHeadBtn(go)
    if go.playerId ~= 0 then
        PlayerInfoManger.GetInfos({go.playerId},GameMainInterfaceCtrl.c_OnReceivePlayerInfo, GameMainInterfaceCtrl)
    end
end


function GameMainInterfaceCtrl:OnClick_EarningBtn(isShow,go)
    if isShow then
        go.isOpen = true
        if lastIncomeNotify ~= incomeNotify then
            if incomeNotify then
                GameMainInterfacePanel.earningScroll:ActiveLoopScroll(go.earnings, #incomeNotify)
            end
            lastIncomeNotify = ct.deepCopy(incomeNotify)
        end
        GameMainInterfacePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        GameMainInterfacePanel.open.transform.localScale = Vector3.zero
        GameMainInterfacePanel.opens.transform.localScale = Vector3.zero
        GameMainInterfacePanel.close.transform.localScale = Vector3.one
        GameMainInterfacePanel.closes.transform.localScale = Vector3.one
        GameMainInterfacePanel.earningsPanelBg.transform.localScale = Vector3.one
    else
        go.isOpen = false
        GameMainInterfacePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        GameMainInterfacePanel.open.transform.localScale = Vector3.one
        GameMainInterfacePanel.opens.transform.localScale = Vector3.one
        GameMainInterfacePanel.close.transform.localScale = Vector3.zero
        GameMainInterfacePanel.closes.transform.localScale = Vector3.zero
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

--todo

--function GameMainInterfaceCtrl:OnLeftRadioBtn()
--    GameMainInterfaceCtrl:OnClick_RadioCity(true)
--end
--
--function GameMainInterfaceCtrl:OnRightRadio()
--    GameMainInterfaceCtrl:OnClick_RadioCity(false)
--end
--
----Open and close city radio
--function GameMainInterfaceCtrl:OnClick_RadioCity(isShow)
--    if isShow then
--        GameMainInterfacePanel.bgRadio:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
--        GameMainInterfacePanel.leftRadio.anchoredPosition = Vector3.New(-570,0,0)
--        GameMainInterfacePanel.leftRadioBtn.transform.localScale = Vector3.zero
--        GameMainInterfacePanel.leftRadioBtns.localScale = Vector3.zero
--    else
--        GameMainInterfacePanel.bgRadio:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
--        GameMainInterfacePanel.leftRadio.anchoredPosition = Vector3.New(0,0,0)
--        GameMainInterfacePanel.leftRadioBtn.transform.localScale = Vector3.one
--        GameMainInterfacePanel.leftRadioBtns.localScale = Vector3.one
--    end
--end
--
---- Pictures in the playlist
--function GameMainInterfaceCtrl:BroadcastRadio(table,index)
--    if table == nil then
--        return
--    end
--    local ts = getFormatUnixTime(table[index].ts/1000)
--    local time = ts.hour.. ":" .. ts.minute
--        local type = table[index].type
--        if type == 1 then
--            GameMainInterfacePanel.majorTransaction.localScale =Vector3.one
--            GameMainInterfacePanel.Npcbreak.localScale =Vector3.zero
--            GameMainInterfacePanel.Budilingsbreak.localScale =Vector3.zero
--            GameMainInterfacePanel.Bonuspoolbreak.localScale =Vector3.zero
--            GameMainInterfacePanel.Playersbreak.localScale =Vector3.zero
--
--            GameMainInterfacePanel.mTNum.text = GetClientPriceString(table[index].cost)
--            GameMainInterfacePanel.mTTime.text = time
--            GameMainInterfacePanel.mTSell.text = table[index].sellName
--            GameMainInterfacePanel.mTBuy.text = table[index].buyName
--
--        if GameMainInterfacePanel.sellHead.transform.childCount == 0 then
--           AvatarManger.GetSmallAvatar(table[index].sellFaceId,GameMainInterfacePanel.sellHead.transform,0.15)
--           AvatarManger.GetSmallAvatar(table[index].buyFaceId,GameMainInterfacePanel.buyHead.transform,0.15)
--        end
--
--    elseif type == 2 then
--        GameMainInterfacePanel.majorTransaction.localScale =Vector3.zero
--        GameMainInterfacePanel.Npcbreak.localScale =Vector3.one
--        GameMainInterfacePanel.Budilingsbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Bonuspoolbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Playersbreak.localScale =Vector3.zero
--
--        GameMainInterfacePanel.npcNum.text = table[index].num
--        GameMainInterfacePanel.npcTime.text = time
--    elseif type == 3 then
--        GameMainInterfacePanel.majorTransaction.localScale =Vector3.zero
--        GameMainInterfacePanel.Npcbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Budilingsbreak.localScale =Vector3.one
--        GameMainInterfacePanel.Bonuspoolbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Playersbreak.localScale =Vector3.zero
--
--        GameMainInterfacePanel.budiligNum.text = table[index].num
--        GameMainInterfacePanel.budilingTime.text = time
--    elseif type == 4 then
--        GameMainInterfacePanel.majorTransaction.localScale =Vector3.zero
--        GameMainInterfacePanel.Npcbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Budilingsbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Bonuspoolbreak.localScale =Vector3.one
--        GameMainInterfacePanel.Playersbreak.localScale =Vector3.zero
--
--        GameMainInterfacePanel.bonuspoolNum.text = GetClientPriceString(table[index].cost)
--        GameMainInterfacePanel.bonuspoolTime.text = time
--    elseif type == 5 then
--        GameMainInterfacePanel.majorTransaction.localScale =Vector3.zero
--        GameMainInterfacePanel.Npcbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Budilingsbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Bonuspoolbreak.localScale =Vector3.zero
--        GameMainInterfacePanel.Playersbreak.localScale =Vector3.one
--
--        GameMainInterfacePanel.PlayersbreakNum.text = table[index].num
--        GameMainInterfacePanel.PlayersbreakTime.text = time
--    end
--       LoadSprite(RadioType[table[index].type], GameMainInterfacePanel.radioImage, true)
--    end

--todo Trading volume
function GameMainInterfaceCtrl:OnVolume()
    ct.OpenCtrl("CityInfoCtrl")
end


