---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---Minimap search type
MapSearchTypeNonePageItem = class('MapSearchTypeNonePageItem', MapSearchTypeItemBase)

function MapSearchTypeNonePageItem:_childInitFunc()
    self.pageState.localScale = Vector3.zero
end

--One of the types is selected
function MapSearchTypeNonePageItem:refreshShow(isSelect)
    if isSelect == true then
        if self.isSelect == false then
            self.selectFunc()  --Change from unselected to selected
        end
    end
    --self.loadBtnTran.transform.localScale = Vector3.one
    self.isSelect = isSelect
end
--Click event
function MapSearchTypeNonePageItem:_clickFunc()
    PlayMusEff(1002)
    if self.isSelect == true then
        Event.Brocast("c_MapSearchCancelSelect", self.data.typeId)  --Uncheck the state
    else
        Event.Brocast("c_MapSearchSelectType", self.data.typeId)  --Broadcast an event, select yourself
        Event.Brocast("c_ChooseTypeDetail", self.data.typeId)
    end

    self.isOpenState = not self.isOpenState
    if self.isOpenState == true then
        self.pageOpenImg.localScale = Vector3.one
    else
        self.pageOpenImg.localScale = Vector3.zero
    end
end
--
function MapSearchTypeNonePageItem:chooseTypeDetail(typeId, showStr)
    if typeId == self.data.typeId and showStr == nil then
        self.choose.localScale = Vector3.one
        self.disChoose.localScale = Vector3.zero
    else
        self.choose.localScale = Vector3.zero
        self.disChoose.localScale = Vector3.one
    end
end