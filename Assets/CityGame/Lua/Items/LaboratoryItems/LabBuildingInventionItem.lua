---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/28 17:36
---
LabBuildingInventionItem = class('LabBuildingInventionItem')
LabBuildingInventionItem.static.CHANGE_GREEN = "#0B7B16"  --改变量的绿色数值
LabBuildingInventionItem.static.CHANGE_RED = "#E42E2E"

function LabBuildingInventionItem:initialize(data, viewRect)
    self.viewRect = viewRect
    self.data = data

    local viewTrans = self.viewRect
    self.nameText = viewTrans:Find("topRoot/nameText"):GetComponent("Text")
    self.iconImg = viewTrans:Find("mainRoot/iconImg"):GetComponent("Image")
    self.bulbImg = viewTrans:Find("mainRoot/progressRoot/bulbImg"):GetComponent("Image")
    self.timeDownText = viewTrans:Find("mainRoot/progressRoot/progressSlider/bg/timeDownText"):GetComponent("Text")
    self.progressCountText = viewTrans:Find("mainRoot/progressRoot/right/bulbImg/progressCountText"):GetComponent("Text")
    self.phaseItems = LabInventionItemPhaseItems:new(viewTrans:Find("mainRoot/successItems"))
    self.progressSlider = viewTrans:Find("mainRoot/progressRoot/progressSlider"):GetComponent("Slider")

    self:_initData()
    --Event.AddListener("c_RefreshLateUpdate", self._updateInfo, self)
end

--初始化界面
function LabBuildingInventionItem:_initData()
    local itemInfo = {}
    if self.isMaterial then
        itemInfo = Material[self.data.itemId]
    else
        itemInfo = Good[self.data.itemId]
    end
    if not itemInfo.name then
        ct.log("", "找不到itemId对应的数据"..self.itemId.." 是否为原料："..self.isMaterial)
        return
    end

    self.nameText.text = itemInfo.name
    self.iconImg = itemInfo.img
    self.phaseItems:showState(self.phaseState)  --显示5个阶段的状态
    self.staffText.text = 0
    self.staffScrollbar.value = 0
    self.progressImgRect.sizeDelta = Vector2.New(self.progressImgRect.sizeDelta.x, 0)
    self.progressCountText.text = ""
    self.bulbImg.color = getColorByVector3(LabBuildingInventionItem.static.BulbNullColor)
    self.timeDownText.text = ""

end
--消息更新
function LabBuildingInventionItem:_updateInfo(updateInfo)

end