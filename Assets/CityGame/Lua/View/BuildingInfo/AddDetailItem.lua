AddDetailItem = class('AddDetailItem')
AddDetailItem.static.ChooseColor = Vector3.New(78, 111, 189)  --选中时显示的颜色
AddDetailItem.static.NomalColor = Vector3.New(230, 226, 205)  --未选中时显示的颜色

--中间合成的Item
function AddDetailItem:initialize(viewRect)
    self.viewRect = viewRect
    self.btn = viewRect:Find("btn"):GetComponent("Button")
    self.iconImg = viewRect:Find("iconImg"):GetComponent("Image")
    self.borderImg = viewRect:Find("borderImg"):GetComponent("Image")
    self.nameText = viewRect:Find("nameText"):GetComponent("Text")
    self.stateRoot = viewRect:Find("stateRoot")
    self.stateText = viewRect:Find("stateRoot/stateText"):GetComponent("Text")
    self.countText = viewRect:Find("Image/countText"):GetComponent("Text")
    self.numberText = viewRect:Find("inventory/numberText"):GetComponent("Text")


    self.selectSelf = false
    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        self:_clickBtn()
    end)
end

--初始化
function AddDetailItem:initData(data)
    local type = ct.getType(UnityEngine.Sprite)
    if Material[data.itemId] then
        self.nameText.text = GetLanguage(data.itemId)
        AddProductionLineMgr.SetBuildingIconSpite(Material[data.itemId].img, self.iconImg)
        --panelMgr:LoadPrefab_A(Material[data.itemId].img,type,nil,function(goodData,obj)
        --    if obj ~= nil then
        --        local texture = ct.InstantiatePrefab(obj)
        --        self.iconImg.sprite = texture
        --    end
        --end)
    else
        self.nameText.text = GetLanguage(data.itemId)
        AddProductionLineMgr.SetBuildingIconSpite(Good[data.itemId].img, self.iconImg)
        --panelMgr:LoadPrefab_A(Good[data.itemId].img,type,nil,function(goodData,obj)
        --    if obj ~= nil then
        --        local texture = ct.InstantiatePrefab(obj)
        --        self.iconImg.sprite = texture
        --    end
        --end)
    end
    self.countText.text = data.num
    self:setObjState(true)
    self:showSelectState(false)
end

--点击按钮
function AddDetailItem:_clickBtn()
    --如果是已经选中了自己，再点击，则是切换路线
    if self.selectSelf then

    else
        --如果是由其他item点击切换到自己，则显示默认

        self.selectSelf = true
    end
end
--显示选中/未选中状态
function AddDetailItem:showSelectState(select)
    if select then
        self.borderImg.color = getColorByVector3(AddDetailItem.static.ChooseColor)
    else
        self.borderImg.color = getColorByVector3(AddDetailItem.static.NomalColor)
    end
end
--隐藏显示场景中的obj
function AddDetailItem:setObjState(show)
    if show then
        self.viewRect.localScale = Vector3.one
    else
        self.viewRect.localScale = Vector3.zero
    end
end