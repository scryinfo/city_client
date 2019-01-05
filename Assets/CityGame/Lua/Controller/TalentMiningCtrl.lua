---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/22 16:03
---人才挖掘ctrl
TalentMiningCtrl = class('TalentMiningCtrl',UIPage)
UIPage:ResgisterOpen(TalentMiningCtrl) --注册打开的方法
local gameObject;
local TalentMiningBehaviour
local talentTypeLuaItem = {}
TalentMiningCtrl.static.Building_PATH = "View/TalentCenterItem/BuildingTalentsItem"

function  TalentMiningCtrl:bundleName()
    return "Assets/CityGame/Resources/View/TalentMiningPanel.prefab"
end

function TalentMiningCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function TalentMiningCtrl:Awake()

    TalentMiningBehaviour = self.gameObject:GetComponent('LuaBehaviour');
end

--启动事件--
function TalentMiningCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    --初始化
    self:_initData();
     ;
    TalentMiningBehaviour:AddClick(TalentMiningPanel.backBtn,self.OnBackBtn,self);
    TalentMiningBehaviour:AddClick(TalentMiningPanel.add,self.OnAddBtn,self);


end

function TalentMiningCtrl:Refresh()
    --打开通知Model
   -- self:initializeData()
end

function TalentMiningCtrl:initializeData()
    if self.m_data then
        DataManager.OpenDetailModel(GameNoticeModel,5)
    end
end

--初始化
function TalentMiningCtrl:_initData()
    for i = 1, 5 do
        --local prefab = self:_creatTalentLine(TalentMiningCtrl.static.Building_PATH,TalentMiningPanel.content)
        --local talentTypeLuaItem = BuildingTalentItem:new(prefab,TalentMiningBehaviour)
        self:_creatTalent(TalentMiningCtrl.static.Building_PATH,TalentMiningPanel.content,i)
    end
end

--点击返回按钮
function TalentMiningCtrl:OnBackBtn()
    UIPage.ClosePage()
end

--点击添加
function TalentMiningCtrl:OnAddBtn()
     ct.OpenCtrl("TalentSelectCtrl")
end

--生成一条人才线
function TalentMiningCtrl:_creatTalent(path,parent,id)
    local prefab = self:_creatTalentLine(path,parent)
    talentTypeLuaItem[id] = BuildingTalentItem:new(prefab,TalentMiningBehaviour,id)
end

--删除一条人才线
function TalentMiningCtrl:_delTalent(id)
    if talentTypeLuaItem[id] == nil then
        return
    end
    destroy(talentTypeLuaItem[id].prefab.gameObject);
    table.remove(talentTypeLuaItem, id)
    local i = 1
    for k,v in pairs(talentTypeLuaItem)  do
       v:RefreshID(i)
        i = i + 1
    end
    --删除主界面的lineItem
    ExcavateItem:m_delTalents(id)
end

--生成预制
function TalentMiningCtrl:_creatTalentLine(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return go
end
