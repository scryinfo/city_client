
local transform;
local gameObject;

GameMainInterfacePanel = {};
local this = GameMainInterfacePanel;

--Start event--
function GameMainInterfacePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--Initialization panel--
function GameMainInterfacePanel.InitPanel()

    this.head = transform:Find("LeftUpPanel/head").gameObject --Avatar
    this.headItem = transform:Find("LeftUpPanel/head/headBg")
    this.name = transform:Find("LeftUpPanel/bg/name"):GetComponent("Text");
    this.companyBtn = transform:Find("LeftUpPanel/bg/company").gameObject
    --this.company = transform:Find("LeftUpPanel/bg/company/companyText"):GetComponent("Text");
    --this.male = transform:Find("LeftUpPanel/bg/name/male");
    --this.woman = transform:Find("LeftUpPanel/bg/name/woman");
    this.addGold = transform:Find("LeftUpPanel/gold/addGold").gameObject --Top up
    this.money = transform:Find("LeftUpPanel/gold/money"):GetComponent("Text");

    this.noticeButton = transform:Find("setBg/notice").gameObject;
    this.noticeItem = transform:Find("setBg/notice/noticeItem"); --Notification Red Dot
    this.friendsButton = transform:Find("setBg/friends").gameObject --Buddy
    this.friendsNotice = transform:Find("setBg/friends/friendsItem") --Friends red dot tips
    this.setButton = transform:Find("setBg/setting").gameObject;
    this.league = transform:Find("setBg/League").gameObject; --alliance
    this.leagueNotice = transform:Find("setBg/League/noticeItem") --Alliance Red Dot Tips
    this.chat = transform:Find("setBg/chat").gameObject   --chat
    this.chatItem = transform:Find("setBg/chat/chatItem")   --Chat red dot
    this.chatWorldItem = transform:Find("setBg/chat/WorldChatPanel/ChatWorldItem").gameObject   --Chat item

    this.time = transform:Find("LeftUpPanel/upBg/time"):GetComponent("Text");   --time
    this.city = transform:Find("LeftUpPanel/upBg/city"):GetComponent("Text");   --city
    this.temperature = transform:Find("LeftUpPanel/upBg/temperatureText"):GetComponent("Text");   --temperature
    this.weather = transform:Find("LeftUpPanel/upBg/weather"):GetComponent("Image");   --the weather
    this.allNpcNum = transform:Find("LeftUpPanel/upBg/npc/npcText"):GetComponent("Text");   --Number of NPCs in the city

    --this.worldChatPanel = transform:Find("WorldChatPanel").gameObject;--World Chat--
    this.worldChatContent = transform:Find("setBg/chat/WorldChatPanel/Content")--World content--
    --this.chatNoticeItem = transform:Find("ChatBg/chat/chatItem").gameObject--World chat red dot tips--
    
    this.smallMap = transform:Find("DownCreatePanel/SmallMap").gameObject;--Small map--
    this.smallMapText = transform:Find("DownCreatePanel/SmallMap/Text"):GetComponent("Text");--Minimap--
    this.cityInfo = transform:Find("DownCreatePanel/CityInfo").gameObject;--City Information--
    this.cityInfoText = transform:Find("DownCreatePanel/CityInfo/Text"):GetComponent("Text");--City Letter--
    this.guide = transform:Find("DownCreatePanel/Guide").gameObject;--Instructions--
    this.guideText = transform:Find("DownCreatePanel/Guide/Text"):GetComponent("Text");--Instructions--
    this.buildButton = transform:Find("DownCreatePanel/Build").gameObject;--building--
    this.buildButtonText = transform:Find("DownCreatePanel/Build/Text"):GetComponent("Text");--building--
    this.eva = transform:Find("DownCreatePanel/Eva").gameObject;--EVA--
    this.evaText = transform:Find("DownCreatePanel/Eva/Text"):GetComponent("Text");--EVA--

    -- todo income
    this.open = transform:Find("LeftUpPanel/gold/open").gameObject; --Open revenue details
    this.opens = transform:Find("LeftUpPanel/gold/opens").gameObject; --Open revenue details
    this.closes = transform:Find("LeftUpPanel/gold/closes").gameObject; --Close earnings details
    this.close = transform:Find("LeftUpPanel/gold/close").gameObject; --Close earnings details
    this.simpleEarning = transform:Find("EarningsPanel/simpleEarning").gameObject; --Click Simple Income
    this.xBtn = transform:Find("EarningsPanel/bg/xBtn").gameObject; --Delete simple income
    this.timeEarning = transform:Find("EarningsPanel/bg/time").gameObject; --Profit time
    this.timeBg = transform:Find("EarningsPanel/bg/time");
    this.timeText = transform:Find("EarningsPanel/bg/time/timeText").gameObject:GetComponent("Text");
    this.clearBtn = transform:Find("EarningsPanel/bg/clearBtn").gameObject; --Clear simple income
    this.clearBg = transform:Find("EarningsPanel/bg/clearBg").gameObject; --Clear simple income background
    this.simple = transform:Find("EarningsPanel/simpleEarning").gameObject; --Simple income panel
    this.simpleEarningBg = transform:Find("EarningsPanel/simpleEarning/simpleEarningBg")
    this.income = transform:Find("EarningsPanel/simpleEarning/simpleEarningBg/income").gameObject:GetComponent("Text"); --Building Type
    this.simpleMoney = transform:Find("EarningsPanel/simpleEarning/simpleEarningBg/incomeText").gameObject:GetComponent("Text"); --Amount of simple income panel
    this.simplePicture = transform:Find("EarningsPanel/simpleEarning/simpleEarningBg/picture").gameObject:GetComponent("Image"); --Picture of simple income panel
    this.simplePictureText = transform:Find("EarningsPanel/simpleEarning/simpleEarningBg/picture/pictureText").gameObject:GetComponent("Text"); --Picture content of simple income panel

    --滑动互用
    this.earningScroll = transform:Find("EarningsPanel/bg/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect"); --Profit time

    this.bg = transform:Find("EarningsPanel/bg"):GetComponent("RectTransform");    --Earnings details background
    this.noMessage = transform:Find("EarningsPanel/bg/noMessage");    --Earnings details background
    this.earningsPanelBg = transform:Find("EarningsPanelBg").gameObject;    --Earnings background

    --交易记录
    this.volume = transform:Find("LeftUpPanel/upBg/volumeBg").gameObject;    --Transaction Record
    this.volumeText = transform:Find("LeftUpPanel/upBg/volumeImage/volumeText"):GetComponent("Text");
    this.grossVolume = transform:Find("LeftUpPanel/upBg/volumeImage/volum"):GetComponent("Text");

    ----广播
    --this.leftRadio = transform:Find("RadioCity/left"):GetComponent("RectTransform");
    --this.radioImage = transform:Find("RadioCity/bg/radioImage"):GetComponent("Image");
    --this.bgRadio = transform:Find("RadioCity/bg");
    --this.leftRadioBtn = transform:Find("RadioCity/leftBtn").gameObject;
    --this.leftRadioBtns = transform:Find("RadioCity/leftBtns");
    --this.rightRadio = transform:Find("RadioCity/bg/rightBtn").gameObject;
    --
    --this.Playersbreak = transform:Find("RadioCity/bg/radioImage/Playersbreak");   --Player breakthrough
    --this.PlayersbreakNum = transform:Find("RadioCity/bg/radioImage/Playersbreak/playerNum"):GetComponent("Text");   --Player breakthroughs
    --this.PlayersbreakTime = transform:Find("RadioCity/bg/radioImage/Playersbreak/playerTime"):GetComponent("Text");   --Player breakthrough time
    --this.PlayersbreakConter = transform:Find("RadioCity/bg/radioImage/Playersbreak/playerConter"):GetComponent("Text");   --Player breakthrough content
    --
    --this.Budilingsbreak = transform:Find("RadioCity/bg/radioImage/Budilingsbreak");   --Architectural breakthrough
    --this.budiligNum = transform:Find("RadioCity/bg/radioImage/Budilingsbreak/budiligNum"):GetComponent("Text");   --Number of building breakthroughs
    --this.budilingTime = transform:Find("RadioCity/bg/radioImage/Budilingsbreak/budilingTime"):GetComponent("Text");   --Building breakthrough time
    --this.budilingConter = transform:Find("RadioCity/bg/radioImage/Budilingsbreak/budilingConter"):GetComponent("Text");   --Architectural breakthrough content
    --
    --this.majorTransaction = transform:Find("RadioCity/bg/radioImage/majorTransaction");   --Major transaction
    --this.mTNum = transform:Find("RadioCity/bg/radioImage/majorTransaction/number"):GetComponent("Text");   --Significant transaction amount
    --this.mTTime = transform:Find("RadioCity/bg/radioImage/majorTransaction/time"):GetComponent("Text");   --Major trading hours
    --this.mTSell = transform:Find("RadioCity/bg/radioImage/majorTransaction/sellName"):GetComponent("Text");   --Major transaction seller name
    --this.mTBuy = transform:Find("RadioCity/bg/radioImage/majorTransaction/buyName"):GetComponent("Text");   --Major transaction buyer name
    --this.mTgoods = transform:Find("RadioCity/bg/radioImage/majorTransaction/goods"):GetComponent("Image");  --Major trading commodities
    --this.sellHead = transform:Find("RadioCity/bg/radioImage/majorTransaction/sellHead")  --Big Deal Seller Avatar
    --this.buyHead = transform:Find("RadioCity/bg/radioImage/majorTransaction/buyHead");  --Avatar for major transaction buyer
    --
    --this.Npcbreak = transform:Find("RadioCity/bg/radioImage/Npcbreak");   --Npc breakthrough
    --this.npcNum = transform:Find("RadioCity/bg/radioImage/Npcbreak/npcNum"):GetComponent("Text");   --Npc breakthrough number
    --this.npcTime = transform:Find("RadioCity/bg/radioImage/Npcbreak/npcTime"):GetComponent("Text");   --Npc breakthrough time and content
    --
    --this.Bonuspoolbreak = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak");   --Prize pool breakthrough
    --this.bonuspoolNum = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak/bonuspoolNum"):GetComponent("Text");   --Number of prize pool breakthroughs
    --this.bonuspoolTime = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak/bonuspoolTime"):GetComponent("Text");   --Bonus pool breakout time
    --this.bonuspoolConter = transform:Find("RadioCity/bg/radioImage/Bonuspoolbreak/bonuspoolConter"):GetComponent("Text");   --Breakout content in bonus pool
end
