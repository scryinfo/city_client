---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:14
---
MapMatGoodSearchItem = class('MapMatGoodSearchItem')

--初始化方法
function MapMatGoodSearchItem:initialize(data, viewRect)
    self.viewRect = viewRect
    self.data = data

    self.iconImg = self.viewRect.transform:Find("bg/iconImg"):GetComponent("Image")
    self.selectImg = self.viewRect.transform:Find("selectImg")
    self.nameText = self.viewRect.transform:Find("nameText"):GetComponent("Text")
    --LoadSprite(data.selectIconPath, self.iconImg, true)

    self.toggle = self.viewRect.transform:GetComponent("Toggle")
    self:_setToggleGroup()
    self.toggle.onValueChanged:AddListener(function(isOn)
        self:_toggle(isOn)
    end)

    --Event.AddListener("c_SearchEndLoading", self._endLoading, self)  --结束loading
    self:resetState()
end
--重置状态
function MapMatGoodSearchItem:resetState()
    self.selectImg.transform.localScale = Vector3.zero
    self.toggle.isOn = false
    self:_language()
end
--多语言
function MapMatGoodSearchItem:_language()
    --self.nameText.text = GetLanguage(self.data.languageId)
    self.nameText.text = "wait"
end
--
function MapMatGoodSearchItem:_toggle(isOn)
    if isOn == true then
        self.selectImg.localScale = Vector3.one
        Event.Brocast("c_MapSearchSelectDetail", self)  --选中item，关闭详情界面
    else
        self.selectImg.localScale = Vector3.zero
        Event.Brocast("c_MapSearchSelectDetail")  --取消选中
    end
end
--设置对应的toggleGroup
function MapMatGoodSearchItem:_setToggleGroup()
    if self.data.mapSearchType == EMapSearchType.Material then
        self.toggle.group = MapPanel.matPageToggleGroup
    elseif self.data.mapSearchType == EMapSearchType.Goods then
        self.toggle.group = MapPanel.goodsPageToggleGroup
    end
end
--
function MapMatGoodSearchItem:getTypeId()
    return self.data.mapSearchType
end
function MapMatGoodSearchItem:getItemId()
    return self.data.itemId
end
function MapMatGoodSearchItem:getNameStr()
    return "wait"
    --return GetLanguage(self.data.languageId)
end