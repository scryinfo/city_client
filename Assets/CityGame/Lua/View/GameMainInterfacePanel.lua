
local transform;
local gameObject;

GameMainInterfacePanel = {};
local this = GameMainInterfacePanel;

--启动事件--
function GameMainInterfacePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function GameMainInterfacePanel.InitPanel()
    this.usernameText = transform:Find("LeftUpPanel/UserNameBG/UserName").gameObject;
    this.monetText = transform:Find("LeftUpPanel/MoneyBG/Money").gameObject
    this.earningText = transform:Find("LeftUpPanel/EarningBG/Earning").gameObject--收益--

    this.noticeButton = transform:Find("LeftDownPanel/NoticeButton").gameObject;
    this.noticeItem = transform:Find("LeftDownPanel/NoticeButton/noticeItem").gameObject;
    this.chatButton = transform:Find("LeftDownPanel/ChatButton").gameObject;
    this.setButton = transform:Find("LeftDownPanel/SetButton").gameObject;

    this.buildButton = transform:Find("RightDownPanel/BuildButton").gameObject;--建筑--

    this.bonusPoolText = transform:Find("RightUpPanel/BonusPool/BonusPoolText").gameObject;--奖金池--
    this.messageText = transform:Find("RightUpPanel/Message/MessageText").gameObject;--信息--

    this.exchangeButton = transform:Find("DownLoadPrefab_A/ExchangeButton").gameObject;--交易所--
    this.houseButton = transform:Find("DownLoadPrefab_A/HouseButton").gameObject;--住宅--
    this.rawMaterialFactory = transform:Find("DownLoadPrefab_A/RawMaterialFactoryButton").gameObject;--原料厂--
    this.sourceMill = transform:Find("DownLoadPrefab_A/SourceMillButton").gameObject;--加工厂--
    this.advertisFacilitie = transform:Find("DownLoadPrefab_A/AdvertisingFacilitie").gameObject;--广告设施--
    this.centerWareHouse = transform:Find("DownLoadPrefab_A/CnterWareHouseButton").gameObject; --中心仓库--
end
