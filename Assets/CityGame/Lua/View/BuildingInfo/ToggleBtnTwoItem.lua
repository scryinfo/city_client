---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by ljw.
--- DateTime: 2019/5/13 17:34
---

ToggleBtnTwoItem = class('ToggleBtnTwoItem')

local optionTwoScript = {}
local volumeBehaviour
local insId
local playerdata = {}
local optionOneScript = {}
local maxValue = 0
local state
local firstshow = nil
local type = true
---初始化方法   数据（读配置表）
function ToggleBtnTwoItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab = prefab
    volumeBehaviour = luaBehaviour
    self.data = data
    self.ctrl = ctrl

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    --self.deleteBtn=prefab.transform:Find("Button")
    self.foodtext = prefab.transform:Find("food/foodText"):GetComponent("Text")
    self.bgBtn = prefab.transform:Find("bgBtn")
    self.highlight = prefab.transform:Find("highlight")

    self.ToggleBtnTwoItem = UnityEngine.UI.LoopScrollDataSource.New()
    self.ToggleBtnTwoItem.mProvideData = ToggleBtnTwoItem.static.OptionThreeData
    self.ToggleBtnTwoItem.mClearData = ToggleBtnTwoItem.static.OptionThreeClearData

    insId = OpenModelInsID.VolumeCtrl
    self:Refresh(data)
    luaBehaviour:AddClick(self.bgBtn.gameObject,self._tradingOpenFunc,self)
end

---==========================================================================================点击函数=============================================================================
function ToggleBtnTwoItem:_firstclose(ins)
    state = ins
end
--打开交易折线图
function ToggleBtnTwoItem:_tradingOpenFunc(ins)

    if state ~= nil then
        state.localScale = Vector3.zero
    end

    state = ins.highlight
    ins.highlight.localScale = Vector3.one
    --optionTwoScript[ins.ctrl] = ToggleBtnThreeItem:new(transform, volumeBehaviour, DealConfig[idx].childs, idx)
    if ins.data.childs ~= nil then
        ins:Abb(ins.data)
        VolumePanel.threeScroll:ActiveLoopScroll(ins.ToggleBtnTwoItem, #ins.data.childs,"View/Laboratory/ToggleBtnThreeItem")
    else
        VolumePanel.threeScroll:ActiveLoopScroll(ins.ToggleBtnTwoItem, 0,"View/Laboratory/ToggleBtnThreeItem")

        local info = {}
        info.id = ins.data.typeId
        info.exchangeType = ins.data.EX
        info.type = type
        DataManager.DetailModelRpcNoRet(insId , 'm_PlayerNumCurve',info)
        VolumePanel.trade.localScale = Vector3.one
    end
end

--删除2
function ToggleBtnTwoItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
end

---==========================================================================================业务逻辑=============================================================================

function ToggleBtnTwoItem:updateData( data )
    self.data = data
    --self.foodtext.text = self.data.name
    self.foodtext.text = GetLanguage(self.data.name)
end

function ToggleBtnTwoItem:updateUI( data )
    --LoadSprite()
    if data.beginProcessTs > 0 then
        local curTime = TimeSynchronized.GetTheCurrentServerTime()
        local hasRunTime = curTime - data.beginProcessTs
    end
end

function ToggleBtnTwoItem:Refresh(data)

    self:updateData(data)
    DataManager.DetailModelRpcNoRet(data.insId , 'm_GoodsplayerTypeNum')
    --self:updateUI(data)
end

-- 第三层信息显示
ToggleBtnTwoItem.static.OptionThreeData = function(transform, idx)
    idx = idx + 1
    optionTwoScript[idx] = ToggleBtnThreeItem:new(transform, volumeBehaviour, playerdata.childs[idx], idx)
end

ToggleBtnTwoItem.static.OptionThreeClearData = function(transform)
end
function ToggleBtnTwoItem:Abb(data)
    playerdata = data
end

function ToggleBtnTwoItem:_close()
    VolumePanel.threeScroll:ActiveLoopScroll(self.ToggleBtnTwoItem, 0,"View/Laboratory/ToggleBtnThreeItem")
end

















