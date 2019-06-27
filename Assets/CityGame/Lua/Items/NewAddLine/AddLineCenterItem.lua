---
---中间合成的Item
---
AddLineCenterItem = class('AddLineCenterItem')
AddLineCenterItem.static.ChooseColor = Vector3.New(78, 111, 189)  --选中时显示的颜色
AddLineCenterItem.static.NomalColor = Vector3.New(230, 226, 205)  --未选中时显示的颜色
--
function AddLineCenterItem:initialize(viewRect)
    self.viewRect = viewRect
    self.iconImg = viewRect:Find("iconImg"):GetComponent("Image")
    self.borderImg = viewRect:Find("borderImg"):GetComponent("Image")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")
    self.countText = viewRect:Find("Image/countText"):GetComponent("Text")
end

--初始化
function AddLineCenterItem:initData(data)
    local type = ct.getType(UnityEngine.Sprite)
    if Material[data.itemId] then
        self.nameText.text = GetLanguage(data.itemId)
        AddProductionLineMgr.SetBuildingIconSpite(Material[data.itemId].img, self.iconImg)
    else
        self.nameText.text = GetLanguage(data.itemId)
        AddProductionLineMgr.SetBuildingIconSpite(Good[data.itemId].img, self.iconImg)
    end
    self.countText.text = data.num
    --self:setObjState(true)
end
--隐藏显示场景中的obj
function AddLineCenterItem:setObjState(show)
    if show then
        self.viewRect.localScale = Vector3.one
    else
        self.viewRect.localScale = Vector3.zero
    end
end