---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---Minimap search type
MapSearchTypePageItem = class('MapSearchTypePageItem', MapSearchTypeItemBase)

--One of the types is selected
function MapSearchTypePageItem:refreshShow(isSelect)
    if isSelect == true then
        if self.isSelect == false then
            self.selectFunc()  --Change from unselected to selected
        end
        self.pageOpenImg.localScale = Vector3.one
    else
        self.pageOpenImg.localScale = Vector3.zero
    end
    --self.loadBtnTran.transform.localScale = Vector3.one
    self.isSelect = isSelect
end
--Click event
function MapSearchTypePageItem:_clickFunc()
    if self.isSelect == true then
        --Event.Brocast("c_MapCloseDetailPage", self.data.typeId, false)  --Close the right interface
    else
        self.isOpenState = true
        self.pageOpenImg.localScale = Vector3.one
        Event.Brocast("c_MapSearchSelectType", self.data.typeId)  --Broadcast an event, select yourself
        Event.Brocast("c_MapCloseDetailPage", self.data.typeId, self.isOpenState)  --Close the right interface
        return
    end

    --Expand right or close right
    self.isOpenState = not self.isOpenState
    if self.isOpenState == true then
        self.pageOpenImg.localScale = Vector3.one
    else
        self.pageOpenImg.localScale = Vector3.zero
    end
    Event.Brocast("c_MapCloseDetailPage", self.data.typeId, self.isOpenState)  --Close the right interface
end
--
function MapSearchTypePageItem:setShowName(str)
    if str ~= nil and str ~= "" then
        self.chooseShowNameText.text = str
    end
    if str == nil then
        self:_language()
    end
end
--
function MapSearchTypePageItem:chooseTypeDetail(typeId, showStr)
    if typeId == self.data.typeId and showStr ~= nil then
        if #showStr > 9 then
            showStr = showStr..""
        end
        self.chooseShowNameText.text = showStr
        --local sizeDelta = self.chooseShowNameText.rectTransform.sizeDelta
        --local width = self.chooseShowNameText.preferredWidth
        --self.chooseShowNameText.rectTransform.sizeDelta = Vector2.New(width, sizeDelta.y)
        --if width > 125 then
        --
        --end
        self.choose.localScale = Vector3.one
        self.disChoose.localScale = Vector3.zero
    else
        self.choose.localScale = Vector3.zero
        self.disChoose.localScale = Vector3.one
        self:_language()
    end
end