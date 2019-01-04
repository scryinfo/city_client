---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/14 16:52
---城市信息市民行为
CitizenBehaviorsCtrl = class('CitizenBehaviorsCtrl',UIPage)
UIPage:ResgisterOpen(CitizenBehaviorsCtrl) --注册打开的方法
local CitizenBehaviour;
local gameObject;
local leftBg
local rightBg
local supermaketConsumptionBg

function  CitizenBehaviorsCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CitizenBehaviorsPanel.prefab"
end

function CitizenBehaviorsCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function CitizenBehaviorsCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    leftBg = CitizenBehaviorsPanel.adultMorningBg
    rightBg = CitizenBehaviorsPanel.homeBg
    supermaketConsumptionBg = CitizenBehaviorsPanel.food
    local leftprefab = {}
    local rightprefab = {}
    local supermaketConsumptionprefab = {}
    CitizenBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    CitizenBehaviour:AddClick(CitizenBehaviorsPanel.backBtn,self.OnBackBtn,self);
    for i = 1, CitizenBehaviorsPanel.left.transform:GetComponent("RectTransform").childCount do
        leftprefab[i] = CitizenBehaviorsPanel.left.transform:GetComponent("RectTransform"):GetChild(i-1)
    end
    for i, v in pairs(leftprefab) do
        v:GetComponent("Button").onClick:AddListener(function ()
            self:OnLeftBtn(v)
        end)
    end
    for i = 1, CitizenBehaviorsPanel.rightTop.transform:GetComponent("RectTransform").childCount do
         rightprefab[i] = CitizenBehaviorsPanel.rightTop.transform:GetComponent("RectTransform"):GetChild(i-1)
    end
    for i, v in pairs(rightprefab) do
        v:GetComponent("Button").onClick:AddListener(function ()
            self:OnRightBtn(v)
        end)
    end
    for i = 1, CitizenBehaviorsPanel.supermaketConsumption.transform:GetComponent("RectTransform").childCount-1 do
        supermaketConsumptionprefab[i] = CitizenBehaviorsPanel.supermaketConsumption.transform:GetComponent("RectTransform"):GetChild(i-1)
    end
    for i, v in pairs(supermaketConsumptionprefab) do
        v:GetComponent("Button").onClick:AddListener(function ()
            self:OnsupermaketConsumptionBtn(v)
        end)
    end
end

--返回按钮
function CitizenBehaviorsCtrl:OnBackBtn()
    UIPage.ClosePage();
end

--点击左边Btn
function CitizenBehaviorsCtrl:OnLeftBtn(go)
    leftBg.localScale = Vector3.zero
     go.transform:Find("bg").localScale = Vector3.one
    leftBg = go.transform:Find("bg")
end
--点击右边Btn
function CitizenBehaviorsCtrl:OnRightBtn(go)
    rightBg.localScale = Vector3.zero
    go.transform:Find("Image").localScale = Vector3.one
    rightBg = go.transform:Find("Image")
    if go.transform:Find("Text"):GetComponent("Text").text == "Supermarket consumption" then
        CitizenBehaviorsPanel.supermaketConsumption.localScale = Vector3.one
    else
        CitizenBehaviorsPanel.supermaketConsumption.localScale = Vector3.zero
    end
end
--点击OnsupermaketConsumption Btn
function CitizenBehaviorsCtrl:OnsupermaketConsumptionBtn(go)
    supermaketConsumptionBg.localScale = Vector3.zero
    go.transform:Find("bg").localScale = Vector3.one
    supermaketConsumptionBg = go.transform:Find("bg")
end

