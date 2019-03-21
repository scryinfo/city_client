
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
    this.headItem = transform:Find("LeftUpPanel/head/headBg/headItem")
    this.name = transform:Find("LeftUpPanel/bg/name"):GetComponent("Text");
    this.companyBtn = transform:Find("LeftUpPanel/bg/company").gameObject
    this.company = transform:Find("LeftUpPanel/bg/company/companyText"):GetComponent("Text");
    this.male = transform:Find("LeftUpPanel/bg/name/male");
    this.woman = transform:Find("LeftUpPanel/bg/name/woman");
    this.money = transform:Find("LeftUpPanel/gold/money"):GetComponent("Text");

    this.noticeButton = transform:Find("ChatBg/closeBg/notice").gameObject;
    this.noticeItem = transform:Find("ChatBg/closeBg/notice/noticeItem"); --通知红点
    this.friendsButton = transform:Find("ChatBg/closeBg/friends").gameObject --好友
    this.friendsNotice = transform:Find("ChatBg/closeBg/friends/friendsItem") --好友红点提示
    this.setButton = transform:Find("ChatBg/closeBg/setting").gameObject;
    this.guideBool = transform:Find("ChatBg/closeBg/guide").gameObject; --指南书--
    this.chat = transform:Find("ChatBg/chat").gameObject   --聊天
    this.chatItem = transform:Find("ChatBg/chat/chatItem")   --聊天红点

    this.openBtn = transform:Find("ChatBg/openBg/openBtn").gameObject    --打来隐藏图标
    this.openBg = transform:Find("ChatBg/openBg")    --打来隐藏图标背景
    this.closeBtn = transform:Find("ChatBg/closeBg/closeBtn").gameObject    --关闭隐藏图标
    this.closeBg = transform:Find("ChatBg/closeBg")    --关闭隐藏图标背景

    this.time = transform:Find("Info/time"):GetComponent("Text");   --时间
    this.city = transform:Find("Info/city"):GetComponent("Text");   --城市
    this.temperature = transform:Find("Info/temperatureText"):GetComponent("Text");   --温度
    this.weather = transform:Find("Info/weather"):GetComponent("Image");   --天气

    this.buildButton = transform:Find("BuildButton").gameObject;--建筑--


    --this.worldChatPanel = transform:Find("WorldChatPanel").gameObject;--世界聊天--
    this.worldChatContent = transform:Find("ChatBg/chat/WorldChatPanel/Content")--世界内容--
    --this.chatNoticeItem = transform:Find("ChatBg/chat/chatItem").gameObject--世界聊天红点提示--
    
    this.smallMap = transform:Find("DownCreatePanel/SmallMap").gameObject;--小地图--
    this.centerBuilding = transform:Find("DownCreatePanel/CenterBuildingButton").gameObject; --中心建筑
    this.league = transform:Find("DownCreatePanel/League").gameObject; --联盟

    -- todo 收益
    this.open = transform:Find("LeftUpPanel/gold/open").gameObject; --打开收益详情
    this.opens = transform:Find("LeftUpPanel/gold/opens").gameObject; --打开收益详情
    this.closes = transform:Find("LeftUpPanel/gold/closes").gameObject; --关闭收益详情
    this.close = transform:Find("LeftUpPanel/gold/close").gameObject; --关闭收益详情
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

    --交易记录
    this.volume = transform:Find("Volume").gameObject;    --交易记录
    this.volumeText = transform:Find("Volume/volumeImage/volumeText"):GetComponent("Text");

    --广播
    this.leftRadio = transform:Find("RadioCity/left"):GetComponent("RectTransform");
    this.radioImage = transform:Find("RadioCity/bg/radioImage"):GetComponent("Image");
    this.bgRadio = transform:Find("RadioCity/bg");
    this.leftRadioBtn = transform:Find("RadioCity/leftBtn").gameObject;
    this.leftRadioBtns = transform:Find("RadioCity/leftBtns");
    this.rightRadio = transform:Find("RadioCity/bg/rightBtn").gameObject;

    this.Playersbreak = transform:Find("RadioCity/bg/radioImage/Playersbreak");   --玩家突破
    this.PlayersbreakNum = transform:Find("RadioCity/bg/radioImage/Playersbreak/playerNum"):GetComponent("Text");   --玩家突破数量
    this.PlayersbreakTime = transform:Find("RadioCity/bg/radioImage/Playersbreak/playerTime"):GetComponent("Text");   --玩家突破时间
    this.PlayersbreakConter = transform:Find("RadioCity/bg/radioImage/Playersbreak/playerConter"):GetComponent("Text");   --玩家突破内容

    this.Budilingsbreak = transform:Find("RadioCity/bg/radioImage/Budilingsbreak");   --建筑突破
    this.budiligNum = transform:Find("RadioCity/bg/radioImage/Budilingsbreak/budiligNum"):GetComponent("Text");   --建筑突破数量
    this.budilingTime = transform:Find("RadioCity/bg/radioImage/Budilingsbreak/budilingTime"):GetComponent("Text");   --建筑突破时间
    this.budilingConter = transform:Find("RadioCity/bg/radioImage/Budilingsbreak/budilingConter"):GetComponent("Text");   --建筑突破内容

    this.majorTransaction = transform:Find("RadioCity/bg/radioImage/majorTransaction");   --重大交易
    this.mTNum = transform:Find("RadioCity/bg/radioImage/majorTransaction/number"):GetComponent("Text");   --重大交易金额
    this.mTTime = transform:Find("RadioCity/bg/radioImage/majorTransaction/time"):GetComponent("Text");   --重大交易时间
    this.mTSell = transform:Find("RadioCity/bg/radioImage/majorTransaction/sellName"):GetComponent("Text");   --重大交易卖家名字
    this.mTBuy = transform:Find("RadioCity/bg/radioImage/majorTransaction/buyName"):GetComponent("Text");   --重大交易买家名字
    this.mTgoods = transform:Find("RadioCity/bg/radioImage/majorTransaction/goods"):GetComponent("Image");  --重大交易商品
    this.sellHead = transform:Find("RadioCity/bg/radioImage/majorTransaction/sellHead")  --重大交易卖家头像
    this.buyHead = transform:Find("RadioCity/bg/radioImage/majorTransaction/buyHead");  --重大交易买家头像

    this.Npcbreak = transform:Find("RadioCity/bg/radioImage/Npcbreak");   --Npc突破
    this.npcNum = transform:Find("RadioCity/bg/radioImage/Npcbreak/npcNum"):GetComponent("Text");   --Npc突破数量
    this.npcTime = transform:Find("RadioCity/bg/radioImage/Npcbreak/npcTime"):GetComponent("Text");   --Npc突破时间及内容

    this.Bonuspoolbreak = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak");   --奖金池突破
    this.bonuspoolNum = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak/bonuspoolNum"):GetComponent("Text");   --奖金池突破数量
    this.bonuspoolTime = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak/bonuspoolTime"):GetComponent("Text");   --奖金池突破时间
    this.bonuspoolConter = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak/bonuspoolConter"):GetComponent("Text");   --奖金池突破内容

end
