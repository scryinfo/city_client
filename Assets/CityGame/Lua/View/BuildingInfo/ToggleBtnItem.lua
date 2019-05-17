
ToggleBtnItem = class('ToggleBtnItem')

local optionTwoScript = {}
local volumeBehaviour
local playerdata = {}
---初始化方法   数据（读配置表）
function ToggleBtnItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab = prefab
    volumeBehaviour = luaBehaviour
    self.data = data
    self.ctrl = ctrl

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    --self.deleteBtn=prefab.transform:Find("Button")
    self.foodtext = prefab.transform:Find("food/foodText"):GetComponent("Text")
    self.bgBtn = prefab.transform:Find("bgBtn")

    self.playerTwoInfo = UnityEngine.UI.LoopScrollDataSource.New()
    self.playerTwoInfo.mProvideData = ToggleBtnItem.static.OptionTwoData
    self.playerTwoInfo.mClearData = ToggleBtnItem.static.OptionTwoClearData

    luaBehaviour:AddClick(self.bgBtn.gameObject,self.c_OnClick_Delete,self)
    self:Refresh(data)
end

---==========================================================================================点击函数=============================================================================
--删除
function ToggleBtnItem:c_OnClick_Delete(ins)
    local item = {}
    local type = ins.data.childs
    VolumePanel.strade.localScale = Vector3.zero
    VolumePanel.secondScroll:ActiveLoopScroll(ins.playerTwoInfo, #ins.data.childs,"View/Laboratory/ToggleBtnTwoItem")
    prints("ToggleBtnItem")
end

--删除2
function ToggleBtnItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
end

---==========================================================================================业务逻辑=============================================================================
-- 第二层信息展示

function ToggleBtnItem:updateData( data )
    self.data = data
    self.foodtext.text = self.data.name
end

function ToggleBtnItem:updateUI( data )
    --LoadSprite()
    if data.beginProcessTs > 0 then
        local curTime = TimeSynchronized.GetTheCurrentServerTime()
        local hasRunTime = curTime - data.beginProcessTs
    end
end

function ToggleBtnItem:Refresh(data)
    self:updateData(data)
    --self:updateUI(data)
end

-- 第二层信息显示
ToggleBtnItem.static.OptionTwoData = function(transform, idx)
    ToggleBtnItem.city = {}
    idx = idx + 1
    optionTwoScript[idx] = ToggleBtnTwoItem:new(transform, volumeBehaviour, playerdata.childs[idx], idx)
    ToggleBtnItem.city = optionTwoScript[idx]
end

ToggleBtnItem.static.OptionTwoClearData = function(transform)
end

function ToggleBtnItem:Aaa(data)
    playerdata = data
end