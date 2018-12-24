---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/27 11:59
---
LabInventionItemPhaseState =
{
    Default = 0,
    Finish = 1,
    WillTo = 2,
    Null = 3,
}
LabInventionItemPhaseItems = class('LabInventionItemPhaseItems')
function LabInventionItemPhaseItems:initialize(transform, needShowNum)
    self.transform = transform
    self.needShowNum = needShowNum

    self.itemRects = {}
    local childCount = transform.childCount
    for i = 1, childCount do
        local itemData = {}
        itemData.itemRect = transform:Find("item0"..i)
        itemData.finish = itemData.itemRect:Find("finish")
        itemData.willTo = itemData.itemRect:Find("willTo")
        itemData.null = itemData.itemRect:Find("null")
        if self.needShowNum then
            itemData.text = itemData.itemRect:Find("Text"):GetComponent("Text")
        end
        self.itemRects[i] = itemData
    end
end
---显示
function LabInventionItemPhaseItems:showState(datas)
    if #datas ~= #self.itemRects then
        ct.log("cycle_w13_laboratory", "场景中的item个数与期望显示的个数不一致，或者传入的不是顺序表")
        return
    end

    for i, itemData in pairs(datas) do
        if itemData == LabInventionItemPhaseState.Finish then
            self.itemRects[i].finish.localScale = Vector3.one
            self.itemRects[i].willTo.localScale = Vector3.zero
            self.itemRects[i].null.localScale = Vector3.zero
            if self.itemRects[i].text ~= nil then
                self.itemRects[i].text.transform.localScale = Vector3.zero
            end
        elseif itemData == LabInventionItemPhaseState.WillTo then
            self.itemRects[i].finish.localScale = Vector3.zero
            self.itemRects[i].willTo.localScale = Vector3.one
            self.itemRects[i].null.localScale = Vector3.zero
            if self.itemRects[i].text ~= nil then
                self.itemRects[i].text.transform.localScale = Vector3.one
            end
        elseif itemData == LabInventionItemPhaseState.Null then
            self.itemRects[i].finish.localScale = Vector3.zero
            self.itemRects[i].willTo.localScale = Vector3.zero
            self.itemRects[i].null.localScale = Vector3.one
            if self.itemRects[i].text ~= nil then
                self.itemRects[i].text.transform.localScale = Vector3.one
            end

            --发明界面有种情况是只有null和finish状态的，而且当为null状态时，需要显示成功率
            --if itemData.percentData then
            --    itemData.text.text = tostring(itemData.percentData)
            --end
        end
    end
end