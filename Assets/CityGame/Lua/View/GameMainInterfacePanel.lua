
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

    this.head = transform:Find("LeftUpPanel/head").gameObject --头像
    this.headItem = transform:Find("LeftUpPanel/head/headItem"):GetComponent("Image") --头像
    this.name = transform:Find("LeftUpPanel/name"):GetComponent("Text");
    this.male = transform:Find("LeftUpPanel/name/male");
    this.woman = transform:Find("LeftUpPanel/name/woman");
    this.money = transform:Find("LeftUpPanel/gold/money"):GetComponent("Text");

    this.noticeButton = transform:Find("NoticeButton").gameObject;
    this.noticeItem = transform:Find("NoticeButton/noticeItem"); --通知红点
    this.friendsButton = transform:Find("FriendsButton").gameObject --好友
    this.friendsNotice = transform:Find("FriendsButton/NoticeItem").gameObject --好友红点提示
    this.setButton = transform:Find("SetButton").gameObject;

    this.time = transform:Find("Info/time"):GetComponent("Text");   --时间
    this.date = transform:Find("Info/date"):GetComponent("Text");   --日期
    this.city = transform:Find("Info/city"):GetComponent("Text");   --城市
    this.weather = transform:Find("Info/weather"):GetComponent("Image");   --天气

    this.buildButton = transform:Find("BuildButton").gameObject;--建筑--
    this.auctionButton =  transform:Find("AuctionButton").gameObject;--拍卖--


    this.worldChatPanel = transform:Find("WorldChatPanel").gameObject;--世界聊天--
    this.worldChatContent = transform:Find("WorldChatPanel/Content")--世界内容--
    this.worldChatNoticeItem = transform:Find("WorldChatPanel/NoticeItem").gameObject--世界聊天红点提示--
    
    this.advertisFacilitie = transform:Find("DownCreatePanel/AdvertisingFacilitie").gameObject;--广告设施--
    this.guideBool = transform:Find("GuideBoolButton").gameObject; --指南书--
    this.centerBuilding = transform:Find("CenterBuildingButton").gameObject; --中心建筑
end
