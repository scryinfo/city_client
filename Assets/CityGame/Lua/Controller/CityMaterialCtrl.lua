---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/28 15:15
---城市信息
CityMaterialCtrl = class('CityMaterialCtrl',UIPage)
UIPage:ResgisterOpen(CityMaterialCtrl) --注册打开的方法
local CityInfoCtrlBehaviour;
local gameObject;
local close
local prefab
local data
local Sort = false

function  CityMaterialCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CityMaterialPanel.prefab"
end

function CityMaterialCtrl:initialize()
    --UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function CityMaterialCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
     ;
    close = nil
    if  self.titlePrefabs ~= nil then
        prefab = self.titlePrefabs[1]
    end
    CityInfoCtrlBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    CityInfoCtrlBehaviour:AddClick(CityMaterialPanel.backBtn,self.OnBackBtn,self);
    CityInfoCtrlBehaviour:AddClick(CityMaterialPanel.companyNumBtn,self.OnCompanyNumBtn,self);

    Event.AddListener("c_OnBtn",self.c_OnBtn,self)
    
end
function CityMaterialCtrl:Awake(go)
    self.gameObject = go
    data = self.m_data

    CityMaterialCtrl.CityMaterial = ct.deepCopy(CityMaterialData)

    CityMaterialCtrl.static.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')

    self.material = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.material.mProvideData = CityMaterialCtrl.static.MaterialProvideData
    self.material.mClearData = CityMaterialCtrl.static.MaterialClearData
    CityMaterialPanel.materialScroll:ActiveLoopScroll(self.material, #self.CityMaterial)

end

function CityMaterialCtrl:Refresh()
    CityMaterialPanel.time.text = os.date("%m月".."\n".."%d");
    --每次打开都是默认排序[[
    CityMaterialCtrl.CityMaterial = ct.deepCopy(CityMaterialData)
    CityMaterialPanel.materialScroll:ActiveLoopScroll(self.material, #self.CityMaterial)--]]
    if self.m_data == nil then
        return
    end
    --显示多个面板
    if self.m_data.Title ~= nil then
        self.titlePrefabs = tableSort( self.m_data.Title,CityMaterialPanel.title)
        self.titlePrefabs[1].transform:Find("Text"):GetComponent("Text").color = getColorByInt(255,255,255,255)
        self.titlePrefabs[1].transform:Find("bg").localScale = Vector3.zero
        self.titlePrefabs[1].transform:Find("bgSelect").localScale = Vector3.one
        CityMaterialPanel.toggle.transform.localScale = Vector3.one
        CityMaterialPanel.down.offsetMax = Vector2.New(0,-300)
        self.prefabs = tableSort(self.m_data.Jump[self.m_data.Title[1].data],CityMaterialPanel.company)  --生成cityinfoName表格
        for i, v in pairs(self.titlePrefabs) do
            v.gameObject:GetComponent("Button").onClick:AddListener(function ()
                local name = v.transform:Find("Text"):GetComponent("Text").text
                self:OnToggle(self.m_data.Jump[name],CityMaterialPanel.company,self.prefabs,v)
            end)
        end
    else
        --显示一个面板
        CityMaterialPanel.toggle.transform.localScale = Vector3.zero
        CityMaterialPanel.down.offsetMax = Vector2.New(0,-146)
        if CityMaterialPanel.company.transform:GetComponent("RectTransform").childCount == 0 then
            self.prefabs = tableSort(self.m_data.CityData,CityMaterialPanel.company)  --生成cityinfoName表格
             for i, v in ipairs(self.prefabs) do
                if v.gameObject:GetComponent("Button") ~=nil then
                    v.gameObject:GetComponent("Button").onClick:AddListener(function ()
                        CityMaterialCtrl:OnSortBtn(not Sort,i,v)
                    end)
                end
            end
        end
    end
end

function CityMaterialCtrl:ShowIcon(table)
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

--返回按钮
function CityMaterialCtrl:OnBackBtn(go)
    if CityMaterialPanel.company.transform:GetComponent("RectTransform").childCount > 0 then
        for i = 1, CityMaterialPanel.company:GetComponent("RectTransform").transform.childCount do
            destroy(CityMaterialPanel.company:GetComponent("RectTransform").transform:GetChild(i-1).gameObject)
        end
    end
    --UIPage.ClosePage();
    ct.OpenCtrl("CityInfoCtrl")
    ct.OpenCtrl("CityInfoDataCtrl")
end

--滑动互用
CityMaterialCtrl.static.MaterialProvideData = function(transform, idx)

    idx = idx + 1
    local iconTable = nil
    if data.Title == nil then
        iconTable = CityMaterialCtrl:ShowIcon(data.CityData)
    else
        iconTable = CityMaterialCtrl:ShowIcon(data.Jump[data.Title[1].data])
    end
    local item = CityMaterialItem:new(CityMaterialCtrl.CityMaterial[idx], transform,idx,iconTable,data)
    local materialItems = {}
    materialItems[idx] = item
end
CityMaterialCtrl.static.MaterialClearData = function(transform)
end

--排序
function CityMaterialCtrl:OnSortBtn(sort,i,transform)
    if sort ==true then
        table.sort( self.CityMaterial, function (m, n) return m[i] > n[i] end)
        transform:Find("Text/sort-default").localScale = Vector3.zero
        transform:Find("Text/sort-big").localScale = Vector3.one
        transform:Find("Text/sort-small").localScale = Vector3.zero

    else
        table.sort( self.CityMaterial, function (m, n) return m[i] < n[i] end)
        transform:Find("Text/sort-default").localScale = Vector3.zero
        transform:Find("Text/sort-big").localScale = Vector3.zero
        transform:Find("Text/sort-small").localScale = Vector3.one
    end
    CityMaterialPanel.materialScroll:ActiveLoopScroll(self.material, #self.CityMaterial)
    Sort = sort
end

function CityMaterialCtrl:c_OnBtn(go,isoppen)
    if close ~= nil then
        CityMaterialCtrl:Close(close)
    end
    if isoppen  then
        CityMaterialCtrl:Oppen(go)
    end
    close = go
end

function CityMaterialCtrl:OnToggle(table,gameObject,prefabs,go)
    if prefab ~= nil then
        prefab.transform:Find("Text"):GetComponent("Text").color = getColorByInt(90,118,213,255)
        prefab.transform:Find("bg").localScale = Vector3.one
        prefab.transform:Find("bgSelect").localScale = Vector3.zero
    end
    UpdataTable(table,gameObject,prefabs)
    go.transform:Find("Text"):GetComponent("Text").color = getColorByInt(255,255,255,255)
    go.transform:Find("bg").localScale = Vector3.zero
    go.transform:Find("bgSelect").localScale = Vector3.one
    prefab = go
end

--生成预制
function CityMaterialCtrl:_createCityInfoPab(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return rect
end
--打开曲线图
function CityMaterialCtrl:Oppen(go)
    go.transform.sizeDelta = Vector2.New(1920,560)
    go.change:Change(go.element,560)
    go.gameObject:SetActive(true)
end
--关闭曲线图
function CityMaterialCtrl:Close(go)
    go.transform.sizeDelta = Vector2.New(1920,130)
    go.change:Change(go.element,130)
    go.gameObject:SetActive(false)
end