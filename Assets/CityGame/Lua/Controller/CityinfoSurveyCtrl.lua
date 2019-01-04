---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/12/5 17:55
---城市信息选择框
CityinfoSurveyCtrl = class('CityinfoSurveyCtrl',UIPage)
UIPage:ResgisterOpen(CityinfoSurveyCtrl) --注册打开的方法
local CityinfoSurveyBehaviour;
local gameObject;
local close
local data

function  CityinfoSurveyCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CityinfoSurveyPanel.prefab"
end

function CityinfoSurveyCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function CityinfoSurveyCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    close = nil
    CityinfoSurveyBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    CityinfoSurveyBehaviour:AddClick(CityinfoSurveyPanel.backBtn,self.OnBackBtn,self);
    CityinfoSurveyBehaviour:AddClick(CityinfoSurveyPanel.companyNumBtn,self.OnCompanyNumBtn,self);
    CityinfoSurveyPanel.time.text = os.date("%m月".."\n".."%d");

    Event.AddListener("c_OnBtn",self.c_OnBtn,self)

end
function CityinfoSurveyCtrl:Awake(go)
    self.gameObject = go
    data = self.m_data
    CityinfoSurveyCtrl.CityMaterial = {}
    CityinfoSurveyCtrl.CityMaterial = CityMaterialData
    CityinfoSurveyCtrl.static.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.material = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.material.mProvideData = CityinfoSurveyCtrl.static.MaterialProvideData
    self.material.mClearData = CityinfoSurveyCtrl.static.MaterialClearData
    CityinfoSurveyPanel.Scroll:ActiveLoopScroll(self.material, #self.CityMaterial)

end

function CityinfoSurveyCtrl:Refresh()
    if self.m_data.LineData ~=nil then
        tableSort(self.m_data.LineData.pandect,CityinfoSurveyPanel.name) --生成name
        tableSort(self.m_data.LineData.pandect,CityinfoSurveyPanel.data) --生成data
        tableSort(self.m_data.LineData.lineNmae,CityinfoSurveyPanel.company)   --生成cityinfoName表格
        local lineName = CityinfoSurveyPanel.name:GetComponent("RectTransform")
        local lineData = CityinfoSurveyPanel.data:GetComponent("RectTransform")
        local linecompany = CityinfoSurveyPanel.company:GetComponent("RectTransform")
        destroy(lineName:GetChild(lineName.childCount-1):Find("line").gameObject)
        destroy(lineData:GetChild(lineData.childCount-1):Find("line").gameObject)
        destroy(linecompany:GetChild(linecompany.childCount-1):Find("line").gameObject)
    end
    end

--返回按钮
function CityinfoSurveyCtrl:OnBackBtn()
    UIPage.ClosePage();
end

--滑动互用
CityinfoSurveyCtrl.static.MaterialProvideData = function(transform, idx)

    idx = idx + 1
    local iconTable = nil
    if data.Title == nil then
        iconTable = CityinfoSurveyCtrl:ShowIcon(data.CityData)
    else
        iconTable = CityinfoSurveyCtrl:ShowIcon(data.Jump[data.Title[1].data])
    end
    local item = CityToggleItem:new(CityinfoSurveyCtrl.CityMaterial[idx], transform,idx,iconTable)
    local materialItems = {}
    materialItems[idx] = item
end
CityinfoSurveyCtrl.static.MaterialClearData = function(transform)
end
function CityinfoSurveyCtrl:ShowIcon(table)
    local iconTable ={}
    iconTable = ct.deepCopy(table)
    for i, v in pairs(iconTable) do
        for k, n in pairs(ShowIcon) do
            if v.data == k then
                v.path = n.path
                v.itemPath = n.itemPath
            end
        end
        iconTable[i].color = {r = 255, b = 255, g = 255, a = 255}
        iconTable[i].itemColor = {r = 255, b = 255, g = 255, a = 255}
    end
    return iconTable
end
--排序
function CityinfoSurveyCtrl:OnCompanyNumBtn(go)
    table.sort( go.CityMaterial, function (m, n) return m.companyNum > n.companyNum end)
    CityTogglePanel.materialScroll:ActiveLoopScroll(go.material, #go.CityMaterial)
end
--点击曲线图
function CityinfoSurveyCtrl:c_OnBtn(go,isoppen)
    if close ~= nil then
        CityinfoSurveyCtrl:Close(close)
    end
    if isoppen  then
        CityinfoSurveyCtrl:Oppen(go)
    end
    close = go
end

--排序方法
--生成预制
function CityinfoSurveyCtrl:_createCityInfoPab(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return rect
end
--打开曲线图
function CityinfoSurveyCtrl:Oppen(go)
    go.transform.sizeDelta = Vector2.New(1920,560)
    go.change:Change(go.element,560)
    go.gameObject:SetActive(true)
end
--关闭曲线图
function CityinfoSurveyCtrl:Close(go)
    go.transform.sizeDelta = Vector2.New(1920,130)
    go.change:Change(go.element,130)
    go.gameObject:SetActive(false)
end