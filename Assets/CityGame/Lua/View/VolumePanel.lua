---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/2/28 17:44
---交易量panel
local transform;
local gameObject;

VolumePanel = {};
local this = VolumePanel;

--启动事件--
function VolumePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function VolumePanel.InitPanel()
    --top
    this.back = transform:Find("return").gameObject --返回
    this.name = transform:Find("name"):GetComponent("Text");
    this.volume = transform:Find("Volume/volumeImage").gameObject;  --交易量Bg
    this.volumeText = transform:Find("Volume/volumeImage/volumeText"):GetComponent("Text")  --交易量

    this.volumetitle = transform:Find("Volume/title")  --交易量提示
    this.total = transform:Find("Volume/title/total"):GetComponent("Text")
    this.content = transform:Find("Volume/title/content"):GetComponent("Text")
    this.playercurrRoot = transform:Find("playercurr");
    --this.firstScroll =this.playercurrRoot:Find("topRoot/firstScroll/Viewport/Content"):GetComponent("ActiveLoopScrollRect");
    this.firstScroll =this.playercurrRoot:Find("topRoot/firstScroll/Viewport"):GetComponent("ActiveLoopScrollRect");
    this.secondScroll = this.playercurrRoot:Find("topRoot/secondScroll/Viewport"):GetComponent("ActiveLoopScrollRect");
    this.threeScroll = this.playercurrRoot:Find("topRoot/threeScroll/Viewport"):GetComponent("ActiveLoopScrollRect");

    --left
    this.citzenRect = transform:Find("leftBg/citzen"):GetComponent("RectTransform");
    this.turnoverRect = transform:Find("leftBg/moneyBg"):GetComponent("RectTransform");
    this.playerRect = transform:Find("leftBg/player"):GetComponent("RectTransform");
    this.infoBgrRect = transform:Find("leftBg/infoBg"):GetComponent("RectTransform");
    this.TradingCount = transform:Find("leftBg/infoBg/Tradingvolume/count"):GetComponent("Text");     --玩家交易量
    this.Tradingname = transform:Find("leftBg/infoBg/Tradingvolume/name");
    this.Tradingnum = transform:Find("leftBg/infoBg/Tradingnum/count"):GetComponent("Text");        --玩家人数
    this.Tradingnumname = transform:Find("leftBg/infoBg/Tradingnum/name"):GetComponent("Text");

    this.citzen = transform:Find("leftBg/citzen/citzenText"):GetComponent("Text");   --市民
    this.turnover = transform:Find("leftBg/moneyBg/turnover/turnoverText"):GetComponent("Text"); --营业额
    this.money = transform:Find("leftBg/moneyBg/money/moneyText"):GetComponent("Text"); --营业额

    this.cityTitle = transform:Find("leftBg/moneyBg/numberBg/city/title"); --城市市民提示
    this.titleText = transform:Find("leftBg/moneyBg/numberBg/city/title/titleText"):GetComponent("Text"); --城市市民提示内容
    this.funds = transform:Find("leftBg/moneyBg/numberBg/city/title/cityFundsBg/funds"):GetComponent("Text"); --城市奖金池
    this.fundsText = transform:Find("leftBg/moneyBg/numberBg/city/title/cityFundsBg/fundsBg/cityFunds"):GetComponent("Text"); --城市奖金池
    this.income = transform:Find("leftBg/moneyBg/numberBg/city/title/income/incomeText"):GetComponent("Text");
    this.incomesText = transform:Find("leftBg/moneyBg/numberBg/city/title/income/incomes/incomesText"):GetComponent("Text");
    this.income = transform:Find("leftBg/moneyBg/numberBg/city/title/expense/expenseText"):GetComponent("Text");
    this.incomesText = transform:Find("leftBg/moneyBg/numberBg/city/title/expense/expenses/expensesText"):GetComponent("Text");

    this.cityBg = transform:Find("leftBg/moneyBg/numberBg/city").gameObject; --城市市民Bg
    this.city = transform:Find("leftBg/moneyBg/numberBg/city/hint/Text"):GetComponent("Text"); --城市市民
    this.adult = transform:Find("leftBg/moneyBg/numberBg/adult/adultImage/adultText"):GetComponent("Text"); --成年人
    this.old = transform:Find("leftBg/moneyBg/numberBg/old/oldImage/oldText"):GetComponent("Text"); --老人
    this.youth = transform:Find("leftBg/moneyBg/numberBg/youth/youthImage/youthText"):GetComponent("Text"); --青年人

    --right
    this.clotherBtn = transform:Find("rightBg/clotherBtn").gameObject; --clotherBtn
    this.clotherBtnText = transform:Find("rightBg/clotherBtn/clotherBtnText"):GetComponent("Text");
    this.clothes = transform:Find("rightBg/clothes");    --clothes
    this.clothes = transform:Find("rightBg/clothes/clothesText"):GetComponent("Text");
    this.foodBtn = transform:Find("rightBg/foodBtn").gameObject; --foodBtn
    this.foodBtnText = transform:Find("rightBg/foodBtn/foodBtnText"):GetComponent("Text");
    this.food = transform:Find("rightBg/food");    --food
    this.foodText = transform:Find("rightBg/food/foodText"):GetComponent("Text");
    this.requirement = transform:Find("rightBg/requirementLine/requirementText"):GetComponent("Text"); --Prospective requirement
    this.undateTime = transform:Find("rightBg/updateImage/undateTime"):GetComponent("Text"); --更新时间倒计时
    this.content = transform:Find("rightBg/Scroll View/Viewport/Content");
    this.scroll = transform:Find("rightBg/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect");

    --PlayerTrading
    this.trade =  transform:Find("PlayerTrading")
    this.yScale = transform:Find("PlayerTrading/trade/yScale"):GetComponent("RectTransform");  --Y轴
    this.curve = transform:Find("PlayerTrading/trade/curveBg/curve"):GetComponent("RectTransform");
    this.slide = transform:Find("PlayerTrading/trade/curveBg/curve"):GetComponent("Slide");  --滑动
    this.graph = transform:Find("PlayerTrading/trade/curveBg/curve"):GetComponent("FunctionalGraph");     --绘制曲线

    --PlayerSTrading
    this.strade =  transform:Find("PlayerSTrading")
    this.syScale = transform:Find("PlayerSTrading/trade/yScale"):GetComponent("RectTransform");  --Y轴
    this.scurve = transform:Find("PlayerSTrading/trade/curveBg/curve"):GetComponent("RectTransform");
    this.sslide = transform:Find("PlayerSTrading/trade/curveBg/curve"):GetComponent("Slide");  --滑动
    this.sgraph = transform:Find("PlayerSTrading/trade/curveBg/curve"):GetComponent("FunctionalGraph");  --绘制曲线


    this.titleBg = transform:Find("titleBg").gameObject; --提示框Bg
end
