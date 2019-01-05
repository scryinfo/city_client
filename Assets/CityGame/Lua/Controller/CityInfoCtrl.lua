---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/22 17:04
---城市信息
CityInfoCtrl = class('CityInfoCtrl',UIPage)
UIPage:ResgisterOpen(CityInfoCtrl) --注册打开的方法
CityInfoCtrl.static.CityInfo_PATH = "View/CityInfoItem/CityInfoItem";
CityInfoPathType = {
    [1] = "View/CityInfoItem/basicInfoItem",--总览
    [2] = "View/CityInfoItem/resellItem",--转卖
    [3] = "View/CityInfoItem/groundItem",--土地
    [4] = "View/CityInfoItem/companyItem",--公司
    [5] = "View/CityInfoItem/coceralItem",--商会
    [6] = "View/CityInfoItem/buildingItem",--建筑
    [7] = "View/CityInfoItem/materialItem",--原料
    [8] = "View/CityInfoItem/commodityItem",--商品
    [9] = "View/CityInfoItem/scienceItem",--科技
    [10] = "View/CityInfoItem/brandItem",--品牌
    [11] = "View/CityInfoItem/talentItem",--人才
    [12] = "View/CityInfoItem/financeItem",--财务
}


local CityInfoCtrlBehaviour;
local gameObject;
local temp = nil;
local cityInfo ={};
local tempShow = nil;


function  CityInfoCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CityInfoPanel.prefab"
end

function CityInfoCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function CityInfoCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    CityInfoCtrlBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    CityInfoCtrlBehaviour:AddClick(CityInfoPanel.backBtn,self.OnBackBtn,self);
    CityInfoCtrlBehaviour:AddClick(CityInfoPanel.btn,self.OnBtn,self);

    Event.AddListener("c_cityInfoBg",self.c_cityInfoBg,self)
    CityInfoPanel.time.text = os.date("%m月".."\n".."%d");
    tempShow = CityInfoPanel.basicInfo;
    self:_initData();
end

--返回按钮
function CityInfoCtrl:OnBackBtn()
    UIPage.ClosePage();
end

--点击市民行为
function CityInfoCtrl:OnBtn()
    ct.OpenCtrl("CitizenBehaviorsCtrl")
end

--初始化
function CityInfoCtrl:_initData()
    --CityInfoCtrl:_createCityInfo(CityInfoPathType[1],CityInfoPanel.right,1)
    CityInfoPanel.cityName.text = CityInfoData[1].cityName;
    CityInfoPanel.citySize.text = CityInfoData[1].cityScale;
    CityInfoPanel.citizenNum.text = CityInfoData[1].citizenNum;
    CityInfoPanel.man.text = CityInfoData[1].man;
    CityInfoPanel.woMan.text = CityInfoData[1].woMan;
    CityInfoPanel.cityFund.text = CityInfoData[1].cityFund;
    for i, v in ipairs(CityInfoInHand) do
        --local cityInfo_prefab = self:_createCityInfoPab(CityInfoCtrl.static.CityInfo_PATH,CityInfoPanel.content)
        local cityInfo_prefab = CityInfoPanel.content:GetChild(i-1).gameObject;
        local cityInfoLuaItem = CityInfoItem:new(CityInfoCtrlBehaviour,cityInfo_prefab,self,v,i)
        if not self.cityInfo then
            self.cityInfo = {}
        end
        self.cityInfo[i] = cityInfoLuaItem
    end
    self.cityInfo[1].yellowBg:SetActive(true)
    temp = self.cityInfo[1].yellowBg

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

    CityInfoPanel.line :InjectDatas(verts,Color.New(1,1,1,1))
    CityInfoPanel.line:InjectDatas(verts1,Color.New(0,1,0,1))

end

--点击城市信息左边的背景
function CityInfoCtrl:c_cityInfoBg(go)
    if temp ~= nil then
        temp:SetActive(false)
    end
    go.yellowBg:SetActive(true)
    temp = go.yellowBg
    ct.log("system","人数不能为0000000000000")
    --生成实例
    local lenght = go.DataInfo.layout
    if lenght ~= nil then
        ct.OpenCtrl("CityInfoDataCtrl",go.DataInfo.layout)
        CityInfoPanel.basicInfo:SetActive(false)
        CityInfoPanel.citizen:SetActive(false)
    elseif go.DataInfo.name == "总览" then
        CityInfoPanel.basicInfo:SetActive(true)
        CityInfoPanel.citizen:SetActive(false)
        Event.Brocast("c_bacK")
    else
        CityInfoPanel.basicInfo:SetActive(false)
        CityInfoPanel.citizen:SetActive(true)
        Event.Brocast("c_bacK")
    end
end

--生成预制
function CityInfoCtrl:_createCityInfoPab(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return rect
end

--[[--生成实例
function CityInfoCtrl:_createCityInfo(id)
    --local cityInfo_prefab = self:_createCityInfoPab(path,parent)
    local cityInfo_prefab = CityInfoPanel.right:GetChild(id-1).gameObject;
    local cityInfoLuaItem = CityDataItem:new(CityInfoCtrlBehaviour,cityInfo_prefab,self,CityInfoData[id],id)
    cityInfo[id] = cityInfoLuaItem;
end]]
