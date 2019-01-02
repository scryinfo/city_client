
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
    this.friendsButton = transform:Find("LeftDownPanel/FriendsButton").gameObject --好友
    this.friendsNotice = transform:Find("LeftDownPanel/FriendsButton/NoticeItem").gameObject --好友红点提示
    this.setButton = transform:Find("LeftDownPanel/SetButton").gameObject;

    this.buildButton = transform:Find("RightDownPanel/BuildButton").gameObject;--建筑--

    this.bonusPoolText = transform:Find("RightUpPanel/BonusPool/BonusPoolText").gameObject;--奖金池--
    this.messageText = transform:Find("RightUpPanel/Message/MessageText").gameObject;--信息--
    this.worldChatPanel = transform:Find("RightUpPanel/WorldChatPanel").gameObject;--世界聊天--
    this.worldChatContent = transform:Find("RightUpPanel/WorldChatPanel/Content")--世界内容--
    this.worldChatNoticeItem = transform:Find("RightUpPanel/WorldChatPanel/NoticeItem").gameObject--世界聊天红点提示--

    this.exchangeButton = transform:Find("DownCreatePanel/ExchangeButton").gameObject;--交易所--
    this.houseButton = transform:Find("DownCreatePanel/HouseButton").gameObject;--住宅--
    this.rawMaterialFactory = transform:Find("DownCreatePanel/RawMaterialFactoryButton").gameObject;--原料厂--
    this.sourceMill = transform:Find("DownCreatePanel/SourceMillButton").gameObject;--加工厂--
    this.advertisFacilitie = transform:Find("DownCreatePanel/AdvertisingFacilitie").gameObject;--广告设施--
    this.centerWareHouse = transform:Find("DownCreatePanel/CnterWareHouseButton").gameObject; --中心仓库--
end