
ToggleBtnItem = class('ToggleBtnItem')

local optionTwoScript = {}
local volumeBehaviour
local playerdata = {}
local state = true
local this = ToggleBtnItem
local firstshow = nil
---初始化方法   数据（读配置表）
function ToggleBtnItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab = prefab
    volumeBehaviour = luaBehaviour
    self.data = data
    self.ctrl = ctrl

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    --self.deleteBtn=prefab.transform:Find("Button")
    this.foodtext = prefab.transform:Find("food/foodText"):GetComponent("Text")
    self.bgBtn = prefab.transform:Find("bgBtn")
    self.highlight = prefab.transform:Find("highlight")

    self.playerTwoInfo = UnityEngine.UI.LoopScrollDataSource.New()
    self.playerTwoInfo.mProvideData = ToggleBtnItem.static.OptionTwoData
    self.playerTwoInfo.mClearData = ToggleBtnItem.static.OptionTwoClearData

    --luaBehaviour:AddClick(self.bgBtn.gameObject,self.c_OnClick_Delete,self)
    self:Refresh(data)
end

---==========================================================================================点击函数=============================================================================
--删除
function ToggleBtnItem:c_OnClick_Delete(ins)
    local item = {}
    local type = ins.data.childs
    VolumePanel.strade.localScale = Vector3.zero
    VolumePanel.secondScroll:ActiveLoopScroll(ins.playerTwoInfo, #ins.data.childs,"View/Laboratory/ToggleBtnTwoItem")
    prints("ToggleBtnItem====================")
end

--删除2
function ToggleBtnItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
end

---==========================================================================================业务逻辑=============================================================================

function ToggleBtnItem:updateData( data )
    self.data = data
    this.foodtext.text = GetLanguage(self.data.name)
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
    if playerdata.childs == nil then
        optionTwoScript[idx] = ToggleBtnTwoItem:new(transform, volumeBehaviour, DealConfig[1].childs[idx], idx)       --第一次点击初始化显示第二层第一个（土地租赁）
        if idx == 1 then
            optionTwoScript[idx].highlight.localScale  = Vector3.one
            optionTwoScript[1]:_firstclose(optionTwoScript[1].highlight)                                                --第一次点击初始化关闭第二层第一个（土地租赁）
        end
    else
        optionTwoScript[idx] = ToggleBtnTwoItem:new(transform, volumeBehaviour, playerdata.childs[idx], idx)
        optionTwoScript[1].highlight.localScale = Vector3.zero
        ToggleBtnItem.city = optionTwoScript[idx]
        optionTwoScript[idx].highlight.localScale = Vector3.zero
    end

end

ToggleBtnItem.static.OptionTwoClearData = function(transform)
end

function ToggleBtnItem:Aaa(data)
    playerdata = data
end