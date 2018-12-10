---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/12/5 16:41
---
TestSliderCtrl = class('TestSliderCtrl',UIPage)
UIPage:ResgisterOpen(TestSliderCtrl) --这个是注册打开的类方法

TestSliderCtrl.static.staticData = {}

local _Icon_Prefab = nil

function TestSliderCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
    self.itemlist = {}

end

function TestSliderCtrl:bundleName()
    return "TestCycle/TestSliderPanel"
end

function TestSliderCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)

    self:_initPanelData()
end

function TestSliderCtrl:Awake(go)
    self.gameObject = go
    self.luaBehaviour = go:GetComponent('LuaBehaviour')
end

function TestSliderCtrl:Refresh()
    self:_initPanelData()
end

function TestSliderCtrl:Close()

end

---初始化界面
function TestSliderCtrl:_initPanelData()

    TestSliderCtrl.static.mainPanelLuaBehaviour = self.luaBehaviour

    local staticData = TestSliderCtrl.static.staticData
    staticData[1] = {text = 001}
    staticData[2] = {text = 002}
    staticData[3] = {text = 003}
    staticData[4] = {text = 004}
    staticData[5] = {text = 005}
    staticData[6] = {text = 006}
    staticData[7] = {text = 007}
    staticData[8] = {text = 008}
    staticData[9] = {text = 009}
    staticData[10] = {text = 010}
    --staticData[11] = {text = 011}
    --staticData[12] = {text = 012}
    --staticData[13] = {text = 013}
    --staticData[14] = {text = 014}
    --staticData[15] = {text = 015}
    --staticData[16] = {text = 016}
    --staticData[17] = {text = 017}
    TestSliderCtrl.static.sourceInfo = staticData

    local loopSource = UnityEngine.UI.LoopScrollDataSource.New()
    loopSource.mProvideData = TestSliderCtrl.static.ProvideData
    loopSource.mClearData = TestSliderCtrl.static.ClearData

    panelMgr:LoadPrefab_A("TestCycle/Icon_Prefab", nil, nil,function(self, obj )
        _Icon_Prefab = obj
        TestSliderPanel.loopScroll:ActiveLoopScroll(loopSource, 2);
    end)

end

--这里添加测试ICON
TestSliderCtrl.static.ProvideData = function(transform, idx)
    idx = idx + 1
    if not TestSliderCtrl.static.sourceInfo[idx] then
        return
    end
    ----[[
    TestSliderCtrl.static.sourceInfo[idx].transform = transform
    local trans = transform:Find("TestSliderPanel/root/LoopScroll")
    local subScroll = trans:GetComponent("ActiveLoopScrollRect");
    if subScroll ~= nil then
        local dataSource = UnityEngine.UI.LoopScrollDataSource.New()

        --加载 Icon_Prefab
            local funHorizontalSb = function(self, obj,i,trans)
            local loadedOjb = ct.InstantiatePrefab(obj);
            local Icon_Prefab =  loadedOjb.transform:GetComponent("Image")
            local go = Icon_Prefab
            local type = Icon_Prefab.GetType(Icon_Prefab.sprite)
            --加载图片，赋值给 Icon_Prefab 的 Image 组件的 sprite
            panelMgr:LoadPrefab_A("TempIcon/A"..i, type, go, function(staticData, obj )
                if obj ~= nil then
                    local texture = ct.InstantiatePrefab(obj)
                    local pngImage =  trans:GetComponent("Image")
                    pngImage.sprite = texture
                end
            end)
            --staticData[i] = {text = 001,image = go}
        end

        --TestSliderPanel 更新 item 时的回调，每次更新，都会更新该元素内部所有的 Icon_Prefab
        dataSource.mProvideData = function(trans, i)
            i = i + 1
            funHorizontalSb(nil, _Icon_Prefab, i,trans)
        end
        dataSource.mClearData = function(transform)
            local xxx = 0
        end

        local ptext = transform:Find("Text"):GetComponent("Text");
        ptext.text = TestSliderCtrl.static.staticData[idx].text
        subScroll:ActiveLoopScroll(dataSource, 11);

    end
    ----]]
end

TestSliderCtrl.static.ClearData = function(transform)
    --ct.log("cycle_w8_exchange01_loopScroll", "回收"..transform.name)
end