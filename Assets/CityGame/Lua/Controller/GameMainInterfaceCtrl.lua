GameMainInterfaceCtrl = class('GameMainInterfaceCtrl',UIPanel)
UIPanel:ResgisterOpen(GameMainInterfaceCtrl) --注册打开的方法

local gameMainInterfaceBehaviour;
local Mails
local incomeNotify    --收益详情表
local lastTime = 0  --上一次时间
--todo 城市广播
local radioTime      --时间
local radioIndex     --索引
local radio          --广播信息表(有序)
local newRadio       --未播放的广播信息表

local  cost = {}          --重大交易金额
local time = {}          --重大交易时间
local index = 0
local indexs = 0

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
    Event.AddListener("c_beginBuildingInfo",self.c_beginBuildingInfo,self)
    Event.AddListener("c_ChangeMoney",self.c_ChangeMoney,self)
    Event.AddListener("c_openBuildingInfo", self.c_openBuildingInfo,self)
    Event.AddListener("c_GetBuildingInfo", self.c_GetBuildingInfo,self)
    Event.AddListener("c_receiveOwnerDatas",self.SaveData,self)
    --Event.AddListener("m_MainCtrlShowGroundAuc",self.SaveData,self)
end

function GameMainInterfaceCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.AddListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.AddListener("c_AllMails",self.c_AllMails,self)
    Event.AddListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)   --获取拍卖状态
    Event.AddListener("c_RefreshMails",self.c_RefreshMails,self)   --跟新邮件
    Event.AddListener("c_AllNpcNum",self.c_AllNpcNum,self)   --全城Npc数量
    --Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self) --玩家信息网络回调
    --Event.AddListener("c_RadioInfo", self.c_OnRadioInfo, self) --城市广播
    --Event.AddListener("c_MajorTransaction", self.c_OnMajorTransaction, self) --重大交易
    Event.AddListener("c_AllExchangeAmount", self.c_AllExchangeAmount, self) --所有交易量
    --Event.AddListener("c_CityBroadcasts", self.c_CityBroadcasts, self) --获取城市广播

    GameMainInterfacePanel.noMessage:GetComponent("Text").text = GetLanguage(11020005)
end

function GameMainInterfaceCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_OnReceiveAddFriendReq", self.c_OnReceiveAddFriendReq, self)
    Event.RemoveListener("c_OnReceiveRoleCommunication", self.c_OnReceiveRoleCommunication, self)
    Event.RemoveListener("c_AllMails",self.c_AllMails,self)
    Event.RemoveListener("m_MainCtrlShowGroundAuc",self.m_MainCtrlShowGroundAuc,self)  --获取拍卖状态
    Event.RemoveListener("c_RefreshMails",self.c_RefreshMails,self)   --跟新邮件
    Event.RemoveListener("c_AllNpcNum",self.c_AllNpcNum,self)   --全城Npc数量
    --Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)--玩家信息网络回调
    --Event.RemoveListener("c_RadioInfo", self.c_OnRadioInfo, self) --城市广播
    --Event.RemoveListener("c_majorTransaction", self.c_OnMajorTransaction, self) --重大交易
    Event.RemoveListener("c_AllExchangeAmount", self.c_AllExchangeAmount, self) --所有交易量
    --Event.RemoveListener("c_CityBroadcasts", self.c_CityBroadcasts, self) --获取城市广播
    GameMainInterfaceCtrl:OnClick_EarningBtn(false)
    self:RemoveUpdata()
end

function GameMainInterfaceCtrl:Close()
    self:RemoveUpdata()
    UIPanel.Close(self)
    Event.RemoveListener("c_IncomeNotify",self.c_IncomeNotify,self) --收益详情
    self = nil
end

--金币改变
function GameMainInterfaceCtrl:c_ChangeMoney(money)
    self.money = getPriceString("E"..GetClientPriceString(money),24,20)
    GameMainInterfacePanel.money.text = self.money
end

function GameMainInterfaceCtrl:SaveData(ownerData)
    if self.groundOwnerDatas then
        table.insert(self.groundOwnerDatas,ownerData[1])
    end
end

--全城Npc数量
function GameMainInterfaceCtrl:c_AllNpcNum(info)
    local num = 0
    if info then
        for i, v in pairs(info) do
            num = num + v.value
        end
    end
    GameMainInterfacePanel.allNpcNum.text = getMoneyString(num)
end

--todo 收益详情
function GameMainInterfaceCtrl:c_IncomeNotify(dataInfo)
    --incomeNotify = dataInfo
    --local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    --if currentTime - lastTime > 60 then
    --    local ts = getFormatUnixTime(currentTime)
    --    GameMainInterfacePanel.timeText.text = ts.hour..":"..ts.minute
    --end
    --lastTime = currentTime
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
            GameMainInterfacePanel.income.text = "土地"
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/landx1.png", GameMainInterfacePanel.simplePicture, true)
            GameMainInterfacePanel.simplePictureText.text = "("..dataInfo.coord[1].x..","..dataInfo.coord[1].y..")"
        elseif dataInfo.type == "INSHELF" then
            GameMainInterfacePanel.income.text = GetLanguage(PlayerBuildingBaseData[dataInfo.bid].sizeName) .. GetLanguage(PlayerBuildingBaseData[dataInfo.bid].typeName)
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", GameMainInterfacePanel.simplePicture)
            GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
        elseif dataInfo.type == "PROMO" then
            if dataInfo.itemId == 1300 then
                GameMainInterfacePanel.income.text = GetLanguage(41020004)
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-ad.png", GameMainInterfacePanel.simplePicture, true)
            elseif dataInfo.itemId == 1400 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-ad.png", GameMainInterfacePanel.simplePicture, true)
            else
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", GameMainInterfacePanel.simplePicture)
            end
            GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.duration .. "h"
        elseif dataInfo.type == "LAB" then
            GameMainInterfacePanel.income.text = GetLanguage(41020006)
            if dataInfo.itemId == 51 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-food.png", GameMainInterfacePanel.simplePicture, true)
            elseif dataInfo.itemId == 52 then
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-clothes.png",GameMainInterfacePanel.simplePicture, true)
            else
                LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/picture/icon-EVA-s.png", GameMainInterfacePanel.simplePicture, true)
            end
            GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.duration .. "h"
        end
        elseif dataInfo.buyer == "NPC" then
        if dataInfo.type == "RENT_ROOM" then
            GameMainInterfacePanel.income.text = "NPC住房"
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/icon-apartment.png", GameMainInterfacePanel.simplePicture, true)
            GameMainInterfacePanel.simplePictureText.text = "X1"
        elseif dataInfo.type == "INSHELF" then
            GameMainInterfacePanel.income.text = "NPC购物"
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/earnings/goods/"..dataInfo.itemId..".png", GameMainInterfacePanel.simplePicture)
            GameMainInterfacePanel.simplePictureText.text = "X"..dataInfo.count
        end
    end
        if incomeNotify then
            GameMainInterfacePanel.earningScroll:ActiveLoopScroll(self.earnings, #incomeNotify)
        end
end

--好友信息
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

    Event.AddListener("c_successBuilding",
        function ()
         func()
         Event.Brocast("SmallPop",GetLanguage(40010020),300)
         end
    ,self)

end

function GameMainInterfaceCtrl:c_openBuildingInfo(buildingInfo)
    --打开界面
    if buildingInfo then
        buildingInfo.ctrl=self
        ct.OpenCtrl('StopAndBuildCtrl',buildingInfo)
    end

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
        --Event.Brocast("m_QueryPlayerInfoChat",Ids)
        PlayerInfoManger.GetInfos(Ids,self.SaveData,self)
    end

    --请求建筑主人的信息
    local ids={}
    table.insert(ids,buildingInfo.ownerId)
    PlayerInfoManger.GetInfos(ids,self.SaveData,self)

end

--todo 城市广播
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

--todo 重大交易
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
----重大交易人物信息
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

----获取所有城市广播
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


function GameMainInterfaceCtrl:Awake()
    --PlayerTempModel.tempTestCreateAll()
    Event.AddListener("c_OnConnectTradeSuccess",self.c_OnSSSuccess,self)        --連接ss成功回調
    Event.AddListener("c_IncomeNotify",self.c_IncomeNotify,self) --收益详情
    CityEngineLua.login_tradeapp(true)
    gameMainInterfaceBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.noticeButton.gameObject,self.OnNotice,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.head.gameObject,self.OnHead,self); --点击头像
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.companyBtn,self.OnCompanyBtn,self); --点击公司名
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.addGold,self.OnAddGold,self); --充值
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.friendsButton.gameObject, self.OnFriends, self)
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.setButton.gameObject,self.Onset,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.buildButton.gameObject,self.OnBuild,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.guide.gameObject,self.OnGuideBool,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.smallMap.gameObject,self.OnSmallMap,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.chat,self.OnChat,self);
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.auctionButton,self.OnAuction,self); --拍卖
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.cityInfo,self.OnCityInfo,self); --城市信息
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.league,self.OnLeague,self); --联盟
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.eva,self.OnEva,self); --Eva

    --todo 收益
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.open,self.OnOpen,self); --打开收益详情
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.earningsPanelBg,self.OnEarningsPanelBg,self); --点击收益详情Bg
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.close,self.OnClose,self); --关闭收益详情
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.xBtn,self.OnXBtn,self); --点击xBtn
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.clearBtn,self.OnClearBtn,self); --点击ClearBtn
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.clearBg,self.OnClearBg,self); --点击ClearBg
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.simple,self.OnSimple,self); --点击简单收益面板

    --todo 城市广播
    --gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.leftRadioBtn,self.OnLeftRadioBtn,self);
    --gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.rightRadio,self.OnRightRadio,self);

    --交易记录
    gameMainInterfaceBehaviour:AddClick(GameMainInterfacePanel.volume,self.OnVolume,self);

    --滑动互用
    self.earnings = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.earnings.mProvideData = GameMainInterfaceCtrl.static.EarningsProvideData
    self.earnings.mClearData = GameMainInterfaceCtrl.static.EarningsClearData

    --头像
    local faceId = DataManager.GetFaceId()

    AvatarManger.GetSmallAvatar(faceId,GameMainInterfacePanel.headItem.transform,0.15)
    self.insId = OpenModelInsID.GameMainInterfaceCtrl
    local info = DataManager.GetMyPersonalHomepageInfo()
    self.name = info.name
    self.company = info.companyName
    --self.gender = info.male

    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)

    LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/"..WeatherConfig[tonumber(ts.year..ts.month..ts.day)].weather[tonumber(ts.hour) + 1], GameMainInterfacePanel.weather,true)
    GameMainInterfacePanel.temperature.text = WeatherConfig[tonumber(ts.year..ts.month..ts.day)].temperature[tonumber(ts.hour) + 1].."℃"

    local gold = DataManager.GetMoneyByString()
    self.money = "E"..getPriceString(gold,24,20)
    GameMainInterfacePanel.money.text = self.money

    --收益倒计时条件
    self.isTimmer = false

    --radioTime = 0
    radioIndex = 1
   -- radio = {{type = 1,ts = 1,sellName = "12",buyName = "34",cost = 100000},{type = 2,ts = 11,num = 100},{type = 3 ,ts = 22,num = 200},{type = 4 ,ts = 33,cost = 200000},{type = 5 ,ts = 44,num = 300}}

    --初始化循环参数
    self.intTime = 1
    self.m_Timer = Timer.New(slot(self.RefreshWeather, self), 1, -1, true)

    -- 初始化两个世界聊天的item
    self.worldChatDouble = {}
    for a = 1, 2 do
        panelMgr:LoadPrefab_A("Assets/CityGame/Resources/View/Chat/ChatWorldItem.prefab", nil, nil, function(ins, obj )
            if obj ~= nil then
                local go = ct.InstantiatePrefab(obj)
                local rect = go.transform:GetComponent("RectTransform")
                go.transform:SetParent(GameMainInterfacePanel.worldChatContent)
                if a == 1 then
                    rect.transform.localScale = Vector3.New(0.8, 0.8, 0.8)
                else
                    rect.transform.localScale = Vector3.one
                end
                self.worldChatDouble[a] = ChatWorldItem:new(go)
            end
        end)
    end
end

--連接ss成功回調
function GameMainInterfaceCtrl:c_OnSSSuccess()
    DataManager.OpenDetailModel(GameMainInterfaceModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_AllExchangeAmount')
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetNpcNum')
    --DataManager.DetailModelRpcNoRet(self.insId , 'm_queryCityBroadcast')
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
    self.m_Timer:Start()
    --初始化姓名,性别,公司名字
    GameMainInterfacePanel.name.text = self.name
    --GameMainInterfacePanel.company.text = self.company
    --if self.gender then
    --    GameMainInterfacePanel.male.localScale = Vector3.one
    --    GameMainInterfacePanel.woman.localScale = Vector3.zero
    --else
    --    GameMainInterfacePanel.male.localScale = Vector3.zero
    --    GameMainInterfacePanel.woman.localScale = Vector3.one
    --end
    GameMainInterfacePanel.city.text = GetLanguage(10030003)
end

local date
local hour
function GameMainInterfaceCtrl:RefreshWeather()

    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
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
    if self.weatherDay ~= date or  self.weatherHour ~= hour then
        self.weatherDay = date
        self.weatherHour = hour
        if WeatherConfig[date].weather[hour] ~= nil then
            LoadSprite("Assets/CityGame/Resources/Atlas/GameMainInterface/weather/"..WeatherConfig[date].weather[hour], GameMainInterfacePanel.weather,true)
            GameMainInterfacePanel.temperature.text = WeatherConfig[date].temperature[hour].."℃"
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

    -- todo  城市广播
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
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.L) then
        PlayerTempModel.tempTestCreateAll()
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

--点击公司名
function GameMainInterfaceCtrl:OnCompanyBtn()
    PlayMusEff(1002)
    local ownerInfo = DataManager.GetMyPersonalHomepageInfo()
    ct.OpenCtrl("CompanyCtrl", ownerInfo)
end

--通知--

function GameMainInterfaceCtrl.OnNotice(go)
    PlayMusEff(1002)
    if Mails == nil then
        ct.OpenCtrl("NoMessageCtrl")
    else
        ct.OpenCtrl('GameNoticeCtrl',Mails)
    end
end

--聊天--
function GameMainInterfaceCtrl.OnChat()
    PlayMusEff(1002)
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

-- 世界聊天显示
function GameMainInterfaceCtrl:c_OnReceiveRoleCommunication(chatData)
    if chatData.channel == "WORLD" then
        if not self.ChatWorldData then
            self.ChatWorldData = {}
        end
        if #self.ChatWorldData == 0 then
            self.ChatWorldData[1] = chatData
            self.worldChatDouble[1]:_ShowPrefab(false)
            self.worldChatDouble[2]:_ShowPrefab(true)
            self.worldChatDouble[2]:_ShowChatContent(self.ChatWorldData[1])
        elseif #self.ChatWorldData == 1 then
            self.ChatWorldData[2] = chatData
            self.worldChatDouble[2]:_ShowPrefab(true)
            self.worldChatDouble[2]:_ShowChatContent(self.ChatWorldData[2])
            self.worldChatDouble[1]:_ShowPrefab(true)
            self.worldChatDouble[1]:_ShowChatContent(self.ChatWorldData[1])
        elseif #self.ChatWorldData == 2 then
            self.ChatWorldData[3] = chatData
            table.remove(self.ChatWorldData, 1)
            self.worldChatDouble[2]:_ShowChatContent(self.ChatWorldData[2])
            self.worldChatDouble[1]:_ShowChatContent(self.ChatWorldData[1])
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
        self.ChatWorldData = {}
        if  worldInfoAllNum ==1 then
            self.ChatWorldData[1] = data[1]
            self.worldChatDouble[1]:_ShowPrefab(false)
            self.worldChatDouble[2]:_ShowPrefab(true)
            self.worldChatDouble[2]:_ShowChatContent(self.ChatWorldData[1])
        else
            self.ChatWorldData[1] = data[worldInfoAllNum - 1]
            self.ChatWorldData[2] = data[worldInfoAllNum]
            self.worldChatDouble[2]:_ShowPrefab(true)
            self.worldChatDouble[2]:_ShowChatContent(self.ChatWorldData[2])
            self.worldChatDouble[1]:_ShowPrefab(true)
            self.worldChatDouble[1]:_ShowChatContent(self.ChatWorldData[1])
        end
    end
end


--设置--
function GameMainInterfaceCtrl.Onset()
    PlayMusEff(1002)
    ct.OpenCtrl("SystemSettingCtrl")
end

--建筑--
function GameMainInterfaceCtrl.OnBuild()
    PlayMusEff(1002)
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
    ct.OpenCtrl("HouseCtrl", PlayerTempModel.tempHouseData.info.id)
end

--原料厂--
function GameMainInterfaceCtrl.OnRawMaterialFactory()
    ct.OpenCtrl("ScienceSellHallCtrl")
end

--指南书--
function GameMainInterfaceCtrl.OnGuideBool()
    PlayMusEff(1002)
    ct.OpenCtrl("GuidBookCtrl")
end

--小地图
function GameMainInterfaceCtrl:OnSmallMap()
    PlayMusEff(1002)
    ct.OpenCtrl("MapCtrl")
end

--城市信息
function GameMainInterfaceCtrl:OnCityInfo()
    PlayMusEff(1002)
end

--Eva
function GameMainInterfaceCtrl:OnEva()
    PlayMusEff(1002)
end

--充值
function GameMainInterfaceCtrl:OnAddGold()
    PlayMusEff(1002)
end

--联盟
function GameMainInterfaceCtrl:OnLeague()
    PlayMusEff(1002)
    local societyId = DataManager.GetGuildID()
    if societyId then
        ct.OpenCtrl("GuildOwnCtrl", societyId)
    else
        ct.OpenCtrl("GuildListCtrl")
    end
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
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(true)
end

--点击收益背景
function GameMainInterfaceCtrl:OnEarningsPanelBg()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(false)
end

--关闭
function GameMainInterfaceCtrl:OnClose()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(false)
end

--点击xBtn
function GameMainInterfaceCtrl:OnXBtn()
    PlayMusEff(1002)
    GameMainInterfacePanel.clearBtn.transform.localScale = Vector3.one
    GameMainInterfacePanel.clearBg.transform.localScale = Vector3.one
    GameMainInterfacePanel.xBtn.transform.localScale = Vector3.zero
end

--点击ClearBtn
function GameMainInterfaceCtrl:OnClearBtn(go)
    PlayMusEff(1002)
    incomeNotify = {}
    GameMainInterfacePanel.earningScroll:ActiveLoopScroll(go.earnings, 0)
end

--点击ClearBg
function GameMainInterfaceCtrl:OnClearBg()
    PlayMusEff(1002)
    GameMainInterfacePanel.clearBtn.transform.localScale = Vector3.zero
    GameMainInterfacePanel.clearBg.transform.localScale = Vector3.zero
    GameMainInterfacePanel.xBtn.transform.localScale = Vector3.one
end

--点击简单收益面板
function GameMainInterfaceCtrl:OnSimple()
    PlayMusEff(1002)
    GameMainInterfaceCtrl:OnClick_EarningBtn(true)
end

--滑动互用
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

--打开关闭收益详情
function GameMainInterfaceCtrl:OnClick_EarningBtn(isShow)
    if isShow then
        GameMainInterfacePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        GameMainInterfacePanel.open.transform.localScale = Vector3.zero
        GameMainInterfacePanel.opens.transform.localScale = Vector3.zero
        GameMainInterfacePanel.close.transform.localScale = Vector3.one
        GameMainInterfacePanel.closes.transform.localScale = Vector3.one
        GameMainInterfacePanel.earningsPanelBg.transform.localScale = Vector3.one
    else
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

--todo 城市广播

--function GameMainInterfaceCtrl:OnLeftRadioBtn()
--    GameMainInterfaceCtrl:OnClick_RadioCity(true)
--end
--
--function GameMainInterfaceCtrl:OnRightRadio()
--    GameMainInterfaceCtrl:OnClick_RadioCity(false)
--end
--
----打开关闭城市广播
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
----播放表中图片
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

    --todo 交易量
    function GameMainInterfaceCtrl:OnVolume()
    ct.OpenCtrl("VolumeCtrl")
    end


