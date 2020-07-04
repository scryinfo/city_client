---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/29 18:02
---
LabFormulaItem = class('LabFormulaItem')
LabFormulaItem.static.Red_Color = "#D81F1F"  --red

function LabFormulaItem:initialize(transform)
    self.transform = transform

    self.itemRects = {}
    local childCount = transform.childCount - 1
    for i = 1, childCount do
        local itemData = {}
        itemData.itemRect = transform:Find("mat0"..i)
        itemData.matImg = itemData.itemRect:Find("matImg"):GetComponent("Image")
        itemData.matCountText = itemData.itemRect:Find("matCountText"):GetComponent("Text")
        self.itemRects[i] = itemData
    end
end
---display
function LabFormulaItem:showState(datas)
    if #datas ~= #self.itemRects then
        ct.log("cycle_w15_laboratory03", "场景中的item个数与期望显示的个数不一致，或者传入的不是顺序表")
        return
    end

    local success = true
    for i, itemData in pairs(datas) do
        if type(itemData) ~= "function" then
            local showStr
            if itemData.haveCount < itemData.matCount then
                showStr = string.format("<color=%s>%d</color>/%d", LabFormulaItem.static.Red_Color, itemData.haveCount, itemData.matCount)
                success = false
            else
                showStr = string.format("%d/%d", itemData.haveCount, itemData.matCount)
            end
            self.itemRects[i].matCountText.text = showStr
            if Material[itemData.matId] then
                LoadSprite(Material[itemData.matId].img, self.itemRects[i].matImg,true)
                self.itemRects[i].matImg:SetNativeSize()
            end
        end
    end
    if datas.backFunc then
        datas.backFunc(success)
    end
end