---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/10 10:59
---城市信息Panel
local transform;
local gameObject;

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
end