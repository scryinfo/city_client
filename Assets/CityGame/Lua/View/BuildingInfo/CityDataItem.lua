---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/26 16:10
---
local class = require 'Framework/class'
require('Framework/UI/UIPage')
CityDataItem = class('CityDataItem')

--初始化方法   数据（读配置表）
function CityDataItem:initialize(inluabehaviour, prefab, mgr, DataInfo ,id)
    self.prefab = prefab;
    self.DataInfo = DataInfo;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.show = self.prefab.transform.gameObject;
    self.line = self.prefab.transform:Find("GameObject/LineChartPanel/Image/Scroll View/Viewport/Content/GameObject"):GetComponent("LineChart");
    local verts={
        Vector2.New(0.0, 0.4),
        Vector2.New(0.10, 0.3),
        Vector2.New(0.15, 0.2),
        Vector2.New(0.20, 0.1),
        Vector2.New(0.25, 0.2),
        Vector2.New(0.30, 0.3),
        Vector2.New(0.35, 0.4),
        Vector2.New(0.40, 0.5),
        Vector2.New(0.45, 0.6),
        Vector2.New(0.50, 0.7),
        Vector2.New(0.55, 0.8),
        Vector2.New(0.60, 0.3),
        Vector2.New(0.65, 0.4),
        Vector2.New(0.70, 0.5),
        Vector2.New(0.75, 0.6),
        Vector2.New(0.80, 0.7),
        Vector2.New(0.85, 0.8),
        Vector2.New(0.90, 0.6),
        Vector2.New(0.95, 0.7),
        Vector2.New(1.00, 0.6),
    }
    local verts1={
        Vector2.New(0.0, 0.1),
        Vector2.New(0.10, 0.1),
        Vector2.New(0.15, 0.3),
        Vector2.New(0.20, 0.2),
        Vector2.New(0.25, 0.4),
        Vector2.New(0.30, 0.6),
        Vector2.New(0.35, 0.8),
        Vector2.New(0.40, 0.4),
        Vector2.New(0.45, 0.2),
        Vector2.New(0.50, 0.3),
        Vector2.New(0.55, 0.8),
        Vector2.New(0.60, 0.9),
        Vector2.New(0.65, 0.3),
        Vector2.New(0.70, 0.3),
        Vector2.New(0.75, 0.4),
        Vector2.New(0.80, 0.7),
        Vector2.New(0.85, 0.9),
        Vector2.New(0.90, 0.2),
        Vector2.New(0.95, 0.8),
        Vector2.New(1.00, 0.1),
    }
    self.line :InjectDatas(verts,Color.New(1,1,1,1))
    self.line:InjectDatas(verts1,Color.New(0,1,0,1))
    self._initData(self.id)
end

--[[
function CityDataItem:OBgBtn(go)
    Event.Brocast("c_cityInfoBg",go)
end]]
--初始化
function CityDataItem:_initData(id)
    if id ==1 then
        self.cityName =  self.prefab.transform:Find("icon/cityName").gameObject:GetComponent("Text"); -- 城市名字
        self.cityScale =  self.prefab.transform:Find("cityScale/cityScaleText").gameObject:GetComponent("Text"); -- 城市规模
        self.citizenNum =  self.prefab.transform:Find("citizenNum/citizenNumText").gameObject:GetComponent("Text"); -- 市民数量
        self.man =  self.prefab.transform:Find("man/manText").gameObject:GetComponent("Text"); -- 男玩家数量
        self.woMan =  self.prefab.transform:Find("woMan/woManText").gameObject:GetComponent("Text"); -- 女玩家数量
        self.cityFund =  self.prefab.transform:Find("cityFund/cityFundText").gameObject:GetComponent("Text"); -- 城市资金

        self.cityName.text = CityInfoData[id].cityName;
        self.cityScale.text = CityInfoData[id].cityScale;
        self.citizenNum.text = CityInfoData[id].citizenNum;
        self.man.text = CityInfoData[id].man;
        self.woMan.text = CityInfoData[id].woMan;
        self.cityFund.text = CityInfoData[id].cityFund;
    elseif id == 2 then
        self.materialProfit =  self.prefab.transform:Find("buildingText/materialProfit/materialProfitText").gameObject:GetComponent("Text");
        self.commodityProfit =  self.prefab.transform:Find("buildingText/commodityProfit/commodityProfitText").gameObject:GetComponent("Text");
        self.scienceProfit =  self.prefab.transform:Find("buildingText/scienceProfit/scienceProfitText").gameObject:GetComponent("Text");
        self.materialProfit =  self.prefab.transform:Find("buildingText/talentsProfit/talentsProfitText").gameObject:GetComponent("Text");

        self.materialProfit.text = CityInfoData[id].materialProfit;
        self.commodityProfit.text = CityInfoData[id].commodityProfit;
        self.scienceProfit.text = CityInfoData[id].scienceProfit;
        self.materialProfit.text = CityInfoData[id].materialProfit;
    elseif id == 3 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.auctionMoney =  self.prefab.transform:Find("buildingText/auctionMoney/auctionMoneyText").gameObject:GetComponent("Text");
        self.landLeaseIncome =  self.prefab.transform:Find("buildingText/landLeaseIncome/landLeaseIncomeText").gameObject:GetComponent("Text");
        self.landSaleProfit =  self.prefab.transform:Find("buildingText/landSaleProfit/landSaleProfitText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.auctionMoney.text = CityInfoData[id].auctionMoney;
        self.landLeaseIncome.text = CityInfoData[id].landLeaseIncome;
        self.landSaleProfit.text = CityInfoData[id].landSaleProfit;
    elseif id == 4 then
        self.member =  self.prefab.transform:Find("buildingText/member/memberText").gameObject:GetComponent("Text");
        self.number =  self.prefab.transform:Find("buildingText/number/numberText").gameObject:GetComponent("Text");
        self.landArea =  self.prefab.transform:Find("buildingText/landArea/landAreaText").gameObject:GetComponent("Text");
        self.cash =  self.prefab.transform:Find("buildingText/cash/cashText").gameObject:GetComponent("Text");
        self.netasset =  self.prefab.transform:Find("buildingText/netasset/netassetText").gameObject:GetComponent("Text");
        self.resellProfit =  self.prefab.transform:Find("buildingText/resellProfit/resellProfitText").gameObject:GetComponent("Text");
        self.directSellProfit =  self.prefab.transform:Find("buildingText/directSellProfit/directSellProfitText").gameObject:GetComponent("Text");
        self.totalProfit =  self.prefab.transform:Find("buildingText/totalProfit/totalProfitText").gameObject:GetComponent("Text");

        self.mymember =  self.prefab.transform:Find("mybuildingText/mymember/mymemberText").gameObject:GetComponent("Text");
        self.mynumber =  self.prefab.transform:Find("mybuildingText/mynumber/mynumberText").gameObject:GetComponent("Text");
        self.mylandArea =  self.prefab.transform:Find("mybuildingText/mylandArea/mylandAreaText").gameObject:GetComponent("Text");
        self.mycash =  self.prefab.transform:Find("mybuildingText/mycash/mycashText").gameObject:GetComponent("Text");
        self.mynetasset =  self.prefab.transform:Find("mybuildingText/mynetasset/mynetassetText").gameObject:GetComponent("Text");
        self.myresellProfit =  self.prefab.transform:Find("mybuildingText/myresellProfit/myresellProfitText").gameObject:GetComponent("Text");
        self.mydirectSellProfit =  self.prefab.transform:Find("mybuildingText/mydirectSellProfit/mydirectSellProfitText").gameObject:GetComponent("Text");
        self.mytotalProfit =  self.prefab.transform:Find("mybuildingText/mytotalProfit/mytotalProfitText").gameObject:GetComponent("Text");

        self.member.text = CityInfoData[id].member;
        self.number.text = CityInfoData[id].number;
        self.landArea.text = CityInfoData[id].landArea;
        self.cash.text = CityInfoData[id].cash;
        self.netasset.text = CityInfoData[id].netasset;
        self.resellProfit.text = CityInfoData[id].resellProfit;
        self.directSellProfit.text = CityInfoData[id].directSellProfit;
        self.totalProfit.text = CityInfoData[id].totalProfit;

        self.mymember.text = CityInfoData[id].member;
        self.mynumber.text = CityInfoData[id].number;
        self.mylandArea.text = CityInfoData[id].landArea;
        self.mycash.text = CityInfoData[id].cash;
        self.mynetasset.text = CityInfoData[id].netasset;
        self.myresellProfit.text = CityInfoData[id].resellProfit;
        self.mydirectSellProfit.text = CityInfoData[id].directSellProfit;
        self.mytotalProfit.text = CityInfoData[id].totalProfit;
    elseif id == 5 then
        self.name =  self.prefab.transform:Find("buildingText/name/nameText").gameObject:GetComponent("Text");
        self.creator =  self.prefab.transform:Find("buildingText/creator/creatorText").gameObject:GetComponent("Text");
        self.creatTime =  self.prefab.transform:Find("buildingText/creatTime/creatTimeText").gameObject:GetComponent("Text");
        self.number =  self.prefab.transform:Find("buildingText/number/numberText").gameObject:GetComponent("Text");
        self.netasset =  self.prefab.transform:Find("buildingText/netasset/netassetText").gameObject:GetComponent("Text");
        self.profit =  self.prefab.transform:Find("buildingText/profit/profitText").gameObject:GetComponent("Text");
        self.profitAdd =  self.prefab.transform:Find("buildingText/profitAdd/profitAddText").gameObject:GetComponent("Text");

        self.myname =  self.prefab.transform:Find("mybuildingText/myname/mynameText").gameObject:GetComponent("Text");
        self.mycreator =  self.prefab.transform:Find("mybuildingText/mycreator/mycreatorText").gameObject:GetComponent("Text");
        self.mycreatTime =  self.prefab.transform:Find("mybuildingText/mycreatTime/mycreatTimeText").gameObject:GetComponent("Text");
        self.mynumber =  self.prefab.transform:Find("mybuildingText/mynumber/mynumberText").gameObject:GetComponent("Text");
        self.mynetasset =  self.prefab.transform:Find("mybuildingText/mynetasset/mynetassetText").gameObject:GetComponent("Text");
        self.myprofit =  self.prefab.transform:Find("mybuildingText/myprofit/myprofitText").gameObject:GetComponent("Text");
        self.myprofitAdd =  self.prefab.transform:Find("mybuildingText/myprofitAdd/myprofitAddText").gameObject:GetComponent("Text");

        self.name.text = CityInfoData[id].name;
        self.creator.text = CityInfoData[id].creator;
        self.creatTime.text = CityInfoData[id].creatTime;
        self.number.text = CityInfoData[id].number;
        self.netasset.text = CityInfoData[id].netasset;
        self.profit.text = CityInfoData[id].profit;
        self.profitAdd.text = CityInfoData[id].profitAdd;

        self.myname.text = CityInfoData[id].name;
        self.mycreator.text = CityInfoData[id].creator;
        self.mycreatTime.text = CityInfoData[id].creatTime;
        self.mynumber.text = CityInfoData[id].number;
        self.mynetasset.text = CityInfoData[id].netasset;
        self.myprofit.text = CityInfoData[id].profit;
        self.myprofitAdd.text = CityInfoData[id].profitAdd;
    elseif id == 6 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.staffNum =  self.prefab.transform:Find("buildingText/staffNum/staffNumText").gameObject:GetComponent("Text");
        self.buildProfit =  self.prefab.transform:Find("buildingText/buildProfit/buildProfitText").gameObject:GetComponent("Text");
        self.buildProfitAdd =  self.prefab.transform:Find("buildingText/buildProfitAdd/buildProfitAddText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.staffNum.text = CityInfoData[id].staffNum;
        self.buildProfit.text = CityInfoData[id].buildProfit;
        self.buildProfitAdd.text = CityInfoData[id].buildProfitAdd;
    elseif id == 7 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.staffNum =  self.prefab.transform:Find("buildingText/staffNum/staffNumText").gameObject:GetComponent("Text");
        self.allProfit =  self.prefab.transform:Find("buildingText/allProfit/allProfitText").gameObject:GetComponent("Text");
        self.allProfitAdd =  self.prefab.transform:Find("buildingText/allProfitAdd/allProfitAddText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.staffNum.text = CityInfoData[id].staffNum;
        self.allProfit.text = CityInfoData[id].allProfit;
        self.allProfitAdd.text = CityInfoData[id].allProfitAdd;
    elseif id == 8 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.staffNum =  self.prefab.transform:Find("buildingText/staffNum/staffNumText").gameObject:GetComponent("Text");
        self.processProfit =  self.prefab.transform:Find("buildingText/processProfit/processProfitText").gameObject:GetComponent("Text");
        self.retailProfit =  self.prefab.transform:Find("buildingText/retailProfit/retailProfitText").gameObject:GetComponent("Text");
        self.allProfit =  self.prefab.transform:Find("buildingText/allProfit/allProfitText").gameObject:GetComponent("Text");
        self.allProfitAdd =  self.prefab.transform:Find("buildingText/allProfitAdd/allProfitAddText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.staffNum.text = CityInfoData[id].staffNum;
        self.processProfit.text = CityInfoData[id].processProfit;
        self.retailProfit.text = CityInfoData[id].retailProfit;
        self.allProfit.text = CityInfoData[id].allProfit;
        self.allProfitAdd.text = CityInfoData[id].allProfitAdd;
    elseif id == 9 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.staffNum =  self.prefab.transform:Find("buildingText/staffNum/staffNumText").gameObject:GetComponent("Text");
        self.exchangeProfit =  self.prefab.transform:Find("buildingText/exchangeProfit/exchangeProfitText").gameObject:GetComponent("Text");
        self.exchangeProfittAdd =  self.prefab.transform:Find("buildingText/exchangeProfittAdd/exchangeProfittAddText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.staffNum.text = CityInfoData[id].staffNum;
        self.exchangeProfit.text = CityInfoData[id].exchangeProfit;
        self.exchangeProfittAdd.text = CityInfoData[id].exchangeProfittAdd;
    elseif id == 10 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.staffNum =  self.prefab.transform:Find("buildingText/staffNum/staffNumText").gameObject:GetComponent("Text");
        self.brandExpend =  self.prefab.transform:Find("buildingText/brandExpend/brandExpendText").gameObject:GetComponent("Text");
        self.brandExpendAdd =  self.prefab.transform:Find("buildingText/brandExpendAdd/brandExpendAddText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.staffNum.text = CityInfoData[id].staffNum;
        self.brandExpend.text = CityInfoData[id].brandExpend;
        self.brandExpendAdd.text = CityInfoData[id].brandExpendAdd;
    elseif id == 11 then
        self.companyNum =  self.prefab.transform:Find("buildingText/companyNum/companyNumText").gameObject:GetComponent("Text");
        self.staffNum =  self.prefab.transform:Find("buildingText/staffNum/staffNumText").gameObject:GetComponent("Text");
        self.talentExchangeProfit =  self.prefab.transform:Find("buildingText/talentExchangeProfit/talentExchangeProfitText").gameObject:GetComponent("Text");
        self.talentExchangeProfitAdd =  self.prefab.transform:Find("buildingText/talentExchangeProfitAdd/talentExchangeProfitAddText").gameObject:GetComponent("Text");

        self.companyNum.text = CityInfoData[id].companyNum;
        self.staffNum.text = CityInfoData[id].staffNum;
        self.talentExchangeProfit.text = CityInfoData[id].talentExchangeProfit;
        self.talentExchangeProfitAdd.text = CityInfoData[id].talentExchangeProfitAdd;
    elseif id == 12 then
        self.materialProfit =  self.prefab.transform:Find("buildingText/materialProfit/materialProfitText").gameObject:GetComponent("Text");
        self.commodityProfit =  self.prefab.transform:Find("buildingText/commodityProfit/commodityProfitText").gameObject:GetComponent("Text");
        self.brandProfit =  self.prefab.transform:Find("buildingText/brandProfit/brandProfitText").gameObject:GetComponent("Text");
        self.scienceProfit =  self.prefab.transform:Find("buildingText/scienceProfit/scienceProfitText").gameObject:GetComponent("Text");
        self.landProfit =  self.prefab.transform:Find("buildingText/landProfit/landProfitText").gameObject:GetComponent("Text");
        self.talentsProfit =  self.prefab.transform:Find("buildingText/talentsProfit/talentsProfitText").gameObject:GetComponent("Text");
        self.resellProfit =  self.prefab.transform:Find("buildingText/resellProfit/resellProfitText").gameObject:GetComponent("Text");
        self.totalProfit =  self.prefab.transform:Find("buildingText/totalProfit/totalProfitText").gameObject:GetComponent("Text");

        self.materialProfit.text = CityInfoData[id].materialProfit;
        self.commodityProfit.text = CityInfoData[id].commodityProfit;
        self.brandProfit.text = CityInfoData[id].brandProfit;
        self.scienceProfit.text = CityInfoData[id].scienceProfit;
        self.landProfit.text = CityInfoData[id].landProfit;
        self.talentsProfit.text = CityInfoData[id].talentsProfit;
        self.resellProfit.text = CityInfoData[id].resellProfit;
        self.totalProfit.text = CityInfoData[id].totalProfit;
    end
end
