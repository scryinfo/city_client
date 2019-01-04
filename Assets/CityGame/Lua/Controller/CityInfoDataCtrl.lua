---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/7 14:41
---城市信息一级跳转面板
CityInfoDataCtrl = class('CityInfoDataCtrl',UIPage)
UIPage:ResgisterOpen(CityInfoDataCtrl) --注册打开的方法

local CityInfoDataCtrlBehaviour;
local gameObject;

function  CityInfoDataCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CityInfoDataPanel.prefab"
end

function CityInfoDataCtrl:initialize()
    --UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function CityInfoDataCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    CityInfoDataCtrlBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    CityInfoDataCtrlBehaviour:AddClick(CityInfoDataPanel.btn,self.OnBtn,self);
    Event.AddListener("c_bacK",self.c_bacK,self)
    --self:_initData()
end

--初始化
function CityInfoDataCtrl:_initData()
    tableSort(self.m_data.name,CityInfoDataPanel.name)
    tableSort(self.m_data.data,CityInfoDataPanel.data)
    tableSort(self.m_data.label,CityInfoDataPanel.label)
    local lineName = CityInfoDataPanel.name:GetComponent("RectTransform")
    local lineData = CityInfoDataPanel.data:GetComponent("RectTransform")
    local lineLabel = CityInfoDataPanel.label:GetComponent("RectTransform")
    destroy(lineName:GetChild(lineName.childCount-1):Find("line").gameObject)
    destroy(lineData:GetChild(lineData.childCount-1):Find("line").gameObject)
    destroy(lineLabel:GetChild(lineLabel.childCount-1):Find("line").gameObject)
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

    CityInfoDataPanel.line :InjectDatas(verts,Color.New(1,1,1,1))
    CityInfoDataPanel.line:InjectDatas(verts1,Color.New(0,1,0,1))

end

function CityInfoDataCtrl:c_bacK()
    --UIPage.ClosePage();
    ct.OpenCtrl("CityInfoCtrl")
end

function CityInfoDataCtrl:OnBtn(go)
   ct.OpenCtrl("CityMaterialCtrl",go.data.database)
end
function CityInfoDataCtrl:Refresh()
    if self.m_data == nil then
        return
    end
    self.data = self.m_data
    if CityInfoDataPanel.name:GetComponent("RectTransform").childCount > 0 then
        for i = 1, CityInfoDataPanel.name:GetComponent("RectTransform").childCount do
            destroy(CityInfoDataPanel.name:GetComponent("RectTransform"):GetChild(i-1).gameObject)
        end
    end
    if CityInfoDataPanel.data:GetComponent("RectTransform").childCount > 0 then
        for i = 1, CityInfoDataPanel.data:GetComponent("RectTransform").childCount do
            destroy(CityInfoDataPanel.data:GetComponent("RectTransform"):GetChild(i-1).gameObject)
        end
    end
    if CityInfoDataPanel.label:GetComponent("RectTransform").childCount > 0 then
        for i = 1, CityInfoDataPanel.label:GetComponent("RectTransform").childCount do
            destroy(CityInfoDataPanel.label:GetComponent("RectTransform"):GetChild(i-1).gameObject)
        end
    end


    self:_initData()
end

