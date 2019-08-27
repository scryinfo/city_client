---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/10 10:59
---城市信息Panel
local transform;
local gameObject;

CityInfoPanel = {};
CityInfoPanel = {};
local this = CityInfoPanel;
--启动事件--
function CityInfoPanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CityInfoPanel.InitPanel()
    this.back = transform:Find("top/back").gameObject
    this.name = transform:Find("top/back/Text"):GetComponent("Text")
    --left
    this.notBasic = transform:Find("content/left/basic/notSelectBg").gameObject
    this.notBasicText = transform:Find("content/left/basic/notSelectBg/Image/Text"):GetComponent("Text")
    this.basic = transform:Find("content/left/basic/selectBg")
    this.basicText = transform:Find("content/left/basic/selectBg/Image/Text"):GetComponent("Text")
    this.notIndustry = transform:Find("content/left/industry/notSelectBg").gameObject
    this.notIndustryText = transform:Find("content/left/industry/notSelectBg/Image/Text"):GetComponent("Text")
    this.industry = transform:Find("content/left/industry/selectBg")
    this.industryText = transform:Find("content/left/industry/selectBg/Image/Text"):GetComponent("Text")
    this.content = transform:Find("content/left/content"):GetComponent("RectTransform")
    this.industryInfoItem = transform:Find("content/left/content/IndustryInfoItem").gameObject
    --right
    this.basicInfo = transform:Find("content/right/basicInfoBg")   --基础信息

    this.citizenNum = transform:Find("content/right/basicInfoBg/topBg/sumBg/citizenNum/Text"):GetComponent("Text")
    this.playerNum = transform:Find("content/right/basicInfoBg/topBg/sumBg/playerNum/Text"):GetComponent("Text")

    this.level = transform:Find("content/right/basicInfoBg/topBg/developeBg/score/Text"):GetComponent("Text") --科技等级
    this.levelBtn = transform:Find("content/right/basicInfoBg/topBg/developeBg/downBg").gameObject
    this.levelSlider = transform:Find("content/right/basicInfoBg/topBg/developeBg/Slider"):GetComponent("Slider")
    this.levelSliderText = transform:Find("content/right/basicInfoBg/topBg/developeBg/Slider/Text"):GetComponent("Text")

    this.volume = transform:Find("content/right/basicInfoBg/topBg/volumeBg/score/Text"):GetComponent("Text") --城市交易额
    this.volumeBtn = transform:Find("content/right/basicInfoBg/topBg/volumeBg/downBg").gameObject

    this.fundPool = transform:Find("content/right/basicInfoBg/topBg/fundBg/score/Text"):GetComponent("Text") --城市奖金池
    this.fundPoolBtn = transform:Find("content/right/basicInfoBg/topBg/fundBg/downBg").gameObject

    this.richBtn = transform:Find("content/right/basicInfoBg/topBg/richBg/downBg").gameObject      --城市排行榜

    this.industryInfo = transform:Find("content/right/industryInfo")   --行业信息

    this.industryBg = transform:Find("content/right/industryInfo/industryBg")   --行业销售额
    this.income = transform:Find("content/right/industryInfo/industryBg/income"):GetComponent("Text")
    this.yScale = transform:Find("content/right/industryInfo/industryBg/yScale"):GetComponent("RectTransform")
    this.sum = transform:Find("content/right/industryInfo/industryBg/sum"):GetComponent("Text")
    this.curve = transform:Find("content/right/industryInfo/industryBg/curveBg/curve"):GetComponent("RectTransform")
    this.slide = transform:Find("content/right/industryInfo/industryBg/curveBg/curve"):GetComponent("Slide")  --滑动
    this.graph = transform:Find("content/right/industryInfo/industryBg/curveBg/curve"):GetComponent("FunctionalGraph")  --绘制曲线
    this.homeHouse = transform:Find("content/right/industryInfo/industryBg/homeHouse/bg").gameObject
    this.homeHouseText = transform:Find("content/right/industryInfo/industryBg/homeHouse/Image/Text"):GetComponent("Text")
    this.homeHouseTag = transform:Find("content/right/industryInfo/industryBg/homeHouse/tag")

    this.supermarket = transform:Find("content/right/industryInfo/industryBg/supermarket/bg").gameObject
    this.supermarketText = transform:Find("content/right/industryInfo/industryBg/supermarket/Image/Text"):GetComponent("Text")
    this.supermarketTag = transform:Find("content/right/industryInfo/industryBg/supermarket/tag")

    this.materialPlant = transform:Find("content/right/industryInfo/industryBg/materialPlant/bg").gameObject
    this.materialPlantText = transform:Find("content/right/industryInfo/industryBg/materialPlant/Image/Text"):GetComponent("Text")
    this.materialPlantTag = transform:Find("content/right/industryInfo/industryBg/materialPlant/tag")

    this.factory = transform:Find("content/right/industryInfo/industryBg/factory/bg").gameObject
    this.factoryText = transform:Find("content/right/industryInfo/industryBg/factory/Image/Text"):GetComponent("Text")
    this.factoryTag = transform:Find("content/right/industryInfo/industryBg/factory/tag")

    this.advertising = transform:Find("content/right/industryInfo/industryBg/advertising/bg").gameObject
    this.advertisingText = transform:Find("content/right/industryInfo/industryBg/advertising/Image/Text"):GetComponent("Text")
    this.advertisingTag = transform:Find("content/right/industryInfo/industryBg/advertising/tag")

    this.technology = transform:Find("content/right/industryInfo/industryBg/technology/bg").gameObject
    this.technologyText = transform:Find("content/right/industryInfo/industryBg/technology/Image/Text"):GetComponent("Text")
    this.technologyTag = transform:Find("content/right/industryInfo/industryBg/technology/tag")

    this.land = transform:Find("content/right/industryInfo/industryBg/land/bg").gameObject
    this.landText = transform:Find("content/right/industryInfo/industryBg/land/Image/Text"):GetComponent("Text")
    this.landTag = transform:Find("content/right/industryInfo/industryBg/land/tag")

    this.eva = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva")    --Eva等级分布
    this.evaTechnology = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/technology")
    this.evaTechnologyText = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/technology/Text"):GetComponent("Text")
    this.evaTechnologyBtn = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/technology/unChoose").gameObject
    this.evaAdvertising = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/advertising")
    this.evaAdvertisingText = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/advertising/Text"):GetComponent("Text")
    this.evaAdvertisingBtn = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/advertising/unChoose").gameObject
    this.speed = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/speed")
    this.speedText = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/speed/Text"):GetComponent("Text")
    this.speedBtn = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/eva/speed/unChoose").gameObject

    this.oneContent = transform:Find("content/right/industryInfo/oneContent")          --第一层信息
    this.titleBg = transform:Find("content/right/industryInfo/oneContent/titleBg"):GetComponent("RectTransform")
    this.title = transform:Find("content/right/industryInfo/oneContent/titleBg/title").gameObject
    this.supplyDemandBg = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg")   --行业供需

    this.shelves = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/shelves")
    this.shelvesText = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/shelves/Text"):GetComponent("Text")
    this.purchases = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/purchases")
    this.purchasesText = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/purchases/Text"):GetComponent("Text")
    this.supplyDemandYScale = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/yScale"):GetComponent("RectTransform")
    this.supplyDemandSum = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/sum"):GetComponent("Text")
    this.supplyDemandCurve = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/curveBg/curve"):GetComponent("RectTransform")
    this.supplyDemandSlide = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/curveBg/curve"):GetComponent("Slide")  --滑动
    this.supplyDemandGraph = transform:Find("content/right/industryInfo/oneContent/supplyDemandBg/curveBg/curve"):GetComponent("FunctionalGraph")  --绘制曲线

    this.rankList = transform:Find("content/right/industryInfo/oneContent/rankList")   --收入排行
    this.four = transform:Find("content/right/industryInfo/oneContent/rankList/four")   --4列收入排行

    this.fourTotal = transform:Find("content/right/industryInfo/oneContent/rankList/four/total/Text"):GetComponent("Text")
    this.fourRank = transform:Find("content/right/industryInfo/oneContent/rankList/four/title/rank"):GetComponent("Text")
    this.fourUser = transform:Find("content/right/industryInfo/oneContent/rankList/four/title/user"):GetComponent("Text")
    this.fourIncome = transform:Find("content/right/industryInfo/oneContent/rankList/four/title/income"):GetComponent("Text")
    this.fourVolume = transform:Find("content/right/industryInfo/oneContent/rankList/four/title/volume"):GetComponent("Text")
    this.fourContent = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.fourRankFourItem = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/Viewport/Content/RankFourItem").gameObject
    this.fourMyRankFourItem = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/myRankFourItem")
    this.fourMyRank = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/myRankFourItem/rank"):GetComponent("Text")
    this.fourMyIcon = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/myRankFourItem/head/icon")
    this.fourMyMame = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/myRankFourItem/head/name"):GetComponent("Text")
    this.fourMyIncome = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/myRankFourItem/income"):GetComponent("Text")
    this.fourMyVolume = transform:Find("content/right/industryInfo/oneContent/rankList/four/Scroll View/myRankFourItem/volume"):GetComponent("Text")

    this.five = transform:Find("content/right/industryInfo/oneContent/rankList/five")   --5列收入排行

    this.fiveEmployees = transform:Find("content/right/industryInfo/oneContent/rankList/five/totalEmployees/Text"):GetComponent("Text")
    this.fiveTotalIncome = transform:Find("content/right/industryInfo/oneContent/rankList/five/totalIncome/Text"):GetComponent("Text")
    this.fiveRank = transform:Find("content/right/industryInfo/oneContent/rankList/five/title/rank"):GetComponent("Text")
    this.fiveUser = transform:Find("content/right/industryInfo/oneContent/rankList/five/title/user"):GetComponent("Text")
    this.fiveIncome = transform:Find("content/right/industryInfo/oneContent/rankList/five/title/income"):GetComponent("Text")
    this.fiveStaff = transform:Find("content/right/industryInfo/oneContent/rankList/five/title/staff"):GetComponent("Text")
    this.fiveTechnology = transform:Find("content/right/industryInfo/oneContent/rankList/five/title/technology"):GetComponent("Text")
    this.fiveContent = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.fiveRankFiveItem = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/Viewport/Content/RankFiveItem").gameObject
    this.fiveMyRankFiveItem = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem")
    this.fiveMyRank = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem/rank"):GetComponent("Text")
    this.fiveMyIcon = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem/head/icon")
    this.fiveMyMame = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem/head/name"):GetComponent("Text")
    this.fiveMyIncome = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem/income"):GetComponent("Text")
    this.fiveMyStaff = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem/staff"):GetComponent("Text")
    this.fiveMyTechnology = transform:Find("content/right/industryInfo/oneContent/rankList/five/Scroll View/myRankFiveItem/technology"):GetComponent("Text")

    this.six = transform:Find("content/right/industryInfo/oneContent/rankList/six")   --6列收入排行

    this.sixEmployees = transform:Find("content/right/industryInfo/oneContent/rankList/six/totalEmployees/Text"):GetComponent("Text")
    this.sixTotalIncome = transform:Find("content/right/industryInfo/oneContent/rankList/six/totalIncome/Text"):GetComponent("Text")
    this.sixRank = transform:Find("content/right/industryInfo/oneContent/rankList/six/title/rank"):GetComponent("Text")
    this.sixUser = transform:Find("content/right/industryInfo/oneContent/rankList/six/title/user"):GetComponent("Text")
    this.sixIncome = transform:Find("content/right/industryInfo/oneContent/rankList/six/title/income"):GetComponent("Text")
    this.sixStaff = transform:Find("content/right/industryInfo/oneContent/rankList/six/title/staff"):GetComponent("Text")
    this.sixTechnology = transform:Find("content/right/industryInfo/oneContent/rankList/six/title/technology"):GetComponent("Text")
    this.sixMarket = transform:Find("content/right/industryInfo/oneContent/rankList/six/title/market"):GetComponent("Text")
    this.sixContent = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.sixRankSixItem = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/Viewport/Content/RankSixItem").gameObject
    this.sixMyRankSixItem = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem")
    this.sixMyRank = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/rank"):GetComponent("Text")
    this.sixMyIcon = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/head/icon")
    this.sixMyMame = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/head/name"):GetComponent("Text")
    this.sixMyIncome = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/income"):GetComponent("Text")
    this.sixMyStaff = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/staff"):GetComponent("Text")
    this.sixMyTechnology = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/technology"):GetComponent("Text")
    this.sixMyMarket = transform:Find("content/right/industryInfo/oneContent/rankList/six/Scroll View/myRankSixItem/market"):GetComponent("Text")

    this.twoContent = transform:Find("content/right/industryInfo/oneContent/twoContent").gameObject  --第二层
    this.productIcon = transform:Find("content/right/industryInfo/oneContent/twoContent/products/iconBg/icon"):GetComponent("Image")
    this.productText = transform:Find("content/right/industryInfo/oneContent/twoContent/products/iconBg/Text"):GetComponent("Text")
    this.productDown = transform:Find("content/right/industryInfo/oneContent/twoContent/products/line/down").gameObject
    this.productUp = transform:Find("content/right/industryInfo/oneContent/twoContent/products/line/up")
    this.productContent = transform:Find("content/right/industryInfo/oneContent/twoContent/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.productTitleInfoItem = transform:Find("content/right/industryInfo/oneContent/twoContent/Scroll View/Viewport/Content/TitleInfoItem").gameObject
    this.productsList = transform:Find("content/right/industryInfo/oneContent/twoContent/productsList").gameObject
    this.productsListContent = transform:Find("content/right/industryInfo/oneContent/twoContent/productsList/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.productsListTitleGoodsItem = transform:Find("content/right/industryInfo/oneContent/twoContent/productsList/Scroll View/Viewport/Content/TitleGoodsItem").gameObject
    this.close = transform:Find("content/right/industryInfo/oneContent/twoContent/close").gameObject

    this.threeSupplyDemand = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threecurve/supplyDemand")  --第三层
    this.threeYScale = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threecurve/yScale"):GetComponent("RectTransform")
    this.threeSum = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threecurve/sum"):GetComponent("Text")
    this.threeCurve = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threecurve/curveBg/curve"):GetComponent("RectTransform")
    this.threeSlide = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threecurve/curveBg/curve"):GetComponent("Slide")  --滑动
    this.threeGraph = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threecurve/curveBg/curve"):GetComponent("FunctionalGraph")  --绘制曲线

    this.threeRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank").gameObject   --详细收入排行
    this.detailFour = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four")   --4列详细收入排行

    this.detailFourRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/title/rank"):GetComponent("Text")
    this.detailFourUser = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/title/user"):GetComponent("Text")
    this.detailFourIncome = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/title/income"):GetComponent("Text")
    this.detailFourVolume = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/title/volume"):GetComponent("Text")
    this.detailFourContent = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.detailFourRankFourItem = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/Viewport/Content/RankFourItem").gameObject
    this.detailFourMyRankFourItem = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/myRankFourItem")
    this.detailFourMyRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/myRankFourItem/rank"):GetComponent("Text")
    this.detailFourMyIcon = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/myRankFourItem/head/icon")
    this.detailFourMyMame = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/myRankFourItem/head/name"):GetComponent("Text")
    this.detailFourMyIncome = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/myRankFourItem/income"):GetComponent("Text")
    this.detailFourMyVolume = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/four/Scroll View/myRankFourItem/volume"):GetComponent("Text")

    this.detailFive = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five")   --5列详细收入排行

    this.detailFiveRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/title/rank"):GetComponent("Text")
    this.detailFiveUser = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/title/user"):GetComponent("Text")
    this.detailFiveIncome = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/title/income"):GetComponent("Text")
    this.detailFiveStaff = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/title/staff"):GetComponent("Text")
    this.detailFiveTechnology = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/title/technology"):GetComponent("Text")
    this.detailFiveContent = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.detailFiveRankFiveItem = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/Viewport/Content/RankFiveItem").gameObject
    this.detailFiveMyRankFiveItem = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem")
    this.detailFiveMyRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem/rank"):GetComponent("Text")
    this.detailFiveMyIcon = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem/head/icon")
    this.detailFiveMyMame = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem/head/name"):GetComponent("Text")
    this.detailFiveMyIncome = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem/income"):GetComponent("Text")
    this.detailFiveMyStaff = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem/staff"):GetComponent("Text")
    this.detailFiveMyTechnology = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/five/Scroll View/myRankFiveItem/technology"):GetComponent("Text")

    this.detailSix = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six")   --6列详细收入排行

    this.detailSixRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/title/rank"):GetComponent("Text")
    this.detailSixUser = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/title/user"):GetComponent("Text")
    this.detailSixIncome = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/title/income"):GetComponent("Text")
    this.detailSixStaff = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/title/staff"):GetComponent("Text")
    this.detailSixTechnology = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/title/technology"):GetComponent("Text")
    this.detailSixMarket = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/title/market"):GetComponent("Text")
    this.detailSixContent = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/Viewport/Content"):GetComponent("RectTransform")
    this.detailSixRankSixItem = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/Viewport/Content/RankSixItem").gameObject
    this.detailSixMyRankSixItem = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem")
    this.detailSixMyRank = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/rank"):GetComponent("Text")
    this.detailSixMyIcon = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/head/icon")
    this.detailSixMyMame = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/head/name"):GetComponent("Text")
    this.detailSixMyIncome = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/income"):GetComponent("Text")
    this.detailSixMyStaff = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/staff"):GetComponent("Text")
    this.detailSixMyTechnology = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/technology"):GetComponent("Text")
    this.detailSixMyMarket = transform:Find("content/right/industryInfo/oneContent/twoContent/threeContent/threeContentBg/threeRank/six/Scroll View/myRankSixItem/market"):GetComponent("Text")
end