
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
    this.headItem = transform:Find("LeftUpPanel/head/headBg/headItem"):GetComponent("Image") --头像
    this.name = transform:Find("LeftUpPanel/bg/name"):GetComponent("Text");
    this.companyBtn = transform:Find("LeftUpPanel/bg/company").gameObject
    this.company = transform:Find("LeftUpPanel/bg/company/companyText"):GetComponent("Text");
    this.male = transform:Find("LeftUpPanel/bg/name/male");
    this.woman = transform:Find("LeftUpPanel/bg/name/woman");
    this.money = transform:Find("LeftUpPanel/gold/money"):GetComponent("Text");

    this.noticeButton = transform:Find("NoticeButton").gameObject;
    this.noticeText = transform:Find("NoticeButton/notice/noticeText"):GetComponent("Text");
    this.noticeItem = transform:Find("NoticeButton/noticeItem"); --通知红点
    this.friendsButton = transform:Find("FriendsButton").gameObject --好友
    this.friendsText = transform:Find("FriendsButton/friends/frirndsText"):GetComponent("Text");
    this.friendsNotice = transform:Find("FriendsButton/NoticeItem").gameObject --好友红点提示
    this.setButton = transform:Find("SetButton").gameObject;
    this.setText = transform:Find("SetButton/set/setText"):GetComponent("Text");
    this.guideBool = transform:Find("GuideBoolButton").gameObject; --指南书--
    this.guideBoolText = transform:Find("GuideBoolButton/guideBook/guideText"):GetComponent("Text");

    this.time = transform:Find("Info/time"):GetComponent("Text");   --时间
    this.date = transform:Find("Info/date"):GetComponent("Text");   --日期
    this.city = transform:Find("Info/city"):GetComponent("Text");   --城市
    this.temperature = transform:Find("Info/city/temperatureText"):GetComponent("Text");   --温度
    this.weather = transform:Find("Info/city/temperatureText/weather"):GetComponent("Image");   --天气

    this.buildButton = transform:Find("BuildButton").gameObject;--建筑--
    this.auctionButton =  transform:Find("AuctionButton").gameObject;--拍卖--
    this.isAuction =  transform:Find("AuctionButton/auction/isAuction");--正在拍卖--
    this.auctionTime =  transform:Find("AuctionButton/time").gameObject:GetComponent("Text");--拍卖时间--


    this.worldChatPanel = transform:Find("WorldChatPanel").gameObject;--世界聊天--
    this.worldChatContent = transform:Find("WorldChatPanel/Content")--世界内容--
    this.worldChatNoticeItem = transform:Find("WorldChatPanel/NoticeItem").gameObject--世界聊天红点提示--
    
    this.smallMap = transform:Find("DownCreatePanel/SmallMap").gameObject;--小地图--
    this.smallMapText = transform:Find("DownCreatePanel/SmallMap/mapText"):GetComponent("Text");
    this.centerBuilding = transform:Find("DownCreatePanel/CenterBuildingButton").gameObject; --中心建筑
    this.cityText = transform:Find("DownCreatePanel/CenterBuildingButton/cityText"):GetComponent("Text");
    this.league = transform:Find("DownCreatePanel/League").gameObject; --联盟
    this.leagueText = transform:Find("DownCreatePanel/League/leagueText"):GetComponent("Text");

    -- todo 收益
    this.open = transform:Find("EarningsPanel/open").gameObject; --打开收益详情
    this.close = transform:Find("EarningsPanel/bg/close").gameObject; --关闭收益详情
    this.simpleEarning = transform:Find("EarningsPanel/simpleEarning").gameObject; --点击简易收益
    this.xBtn = transform:Find("EarningsPanel/bg/xBtn").gameObject; --删除简易收益
    this.timeEarning = transform:Find("EarningsPanel/bg/time").gameObject; --收益时间
    this.timeBg = transform:Find("EarningsPanel/bg/time");
    this.timeText = transform:Find("EarningsPanel/bg/time/timeText").gameObject:GetComponent("Text");
    this.clearBtn = transform:Find("EarningsPanel/bg/clearBtn").gameObject; --清空简易收益
    this.clearBg = transform:Find("EarningsPanel/bg/clearBg").gameObject; --清空简易收益背景
    this.simple = transform:Find("EarningsPanel/simpleEarning").gameObject; --简易收益面板
    this.simpleMoney = transform:Find("EarningsPanel/simpleEarning/incomeText").gameObject:GetComponent("Text"); --简易收益面板金额
    this.simplePicture = transform:Find("EarningsPanel/simpleEarning/picture").gameObject:GetComponent("Image"); --简易收益面板图片
    this.simplePictureText = transform:Find("EarningsPanel/simpleEarning/picture/pictureText").gameObject:GetComponent("Text"); --简易收益面板图片内容

    --滑动互用
    this.earningScroll = transform:Find("EarningsPanel/bg/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect"); --收益时间

    this.bg = transform:Find("EarningsPanel/bg"):GetComponent("RectTransform");    --收益详情背景
    this.noMessage = transform:Find("EarningsPanel/bg/noMessage");    --收益详情背景
    this.earningsPanelBg = transform:Find("EarningsPanelBg").gameObject;    --收益背景
end
