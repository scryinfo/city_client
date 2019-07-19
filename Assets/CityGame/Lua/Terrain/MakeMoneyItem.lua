MakeMoneyItem = class('MakeMoneyItem')

local mainCamera = nil
---初始化函数
--prefab：赚钱气泡Prefab
--data：赚钱气泡数据
function MakeMoneyItem:initialize(prefab,data)
    self.prefab = prefab
    self.rect = prefab.transform:GetComponent("RectTransform")
    self.rect:SetParent(UIBubbleManager.BubbleParent.transform)
    self.prefab.transform.localScale = Vector3.one
    self.rect.transform.localPosition=Vector3.one

    self.data = data
    self.moneyText = prefab.transform:Find("MoneyText"):GetComponent("Text")
    self.moneyText.text = GetClientPriceString(data.money)
    self.canvasGroup = prefab.transform:GetComponent("CanvasGroup")
    self.canvasGroup.alpha = 0
    --设置位置
    local tempBuildBlockID =  TerrainManager.GridIndexTurnBlockID(data.pos)
    local tempPosition = TerrainManager.BlockIDTurnPosition(tempBuildBlockID)
    local basebuildData =  DataManager.GetBaseBuildDataByID(tempBuildBlockID)
    if basebuildData ~= nil and basebuildData.Data ~= nil and basebuildData.Data.buildingID ~= nil then
        tempPosition.x = tempPosition.x + PlayerBuildingBaseData[basebuildData.Data.buildingID].x / 2
        tempPosition.z = tempPosition.z + PlayerBuildingBaseData[basebuildData.Data.buildingID].y / 2
    end
    self.rect.anchoredPosition = UnityEngine.Camera.main:WorldToScreenPoint(tempPosition)
    self.icon = prefab.transform:Find("Icon")
    self.icon.transform.localScale = Vector3.zero
    --设置图片Icon
    if data.itemId ~= nil then
        local tempSprite = SpriteManager.GetSpriteByPool(data.itemId)
        if tempSprite ~= nil then
            self.iconSprite = self.icon:GetComponent("Image")
            self.iconSprite.sprite = tempSprite
            self.icon.transform.localScale = Vector3.one
        end
    end
    self:Show()
end

--数据初始化完成后，展示
function MakeMoneyItem:Show()
    local sequence = DG.Tweening.DOTween.Sequence()
    sequence:Append( self.canvasGroup:DOFade(1,0.3):SetEase(DG.Tweening.Ease.OutCubic) )
    sequence:AppendInterval(0.3)
    sequence:Append( self.canvasGroup:DOFade(0,1):SetEase(DG.Tweening.Ease.Linear) )
    sequence:OnComplete( function()
        MakeMoneyManager.RecyclingGameObject(self.prefab)
        self.prefab = nil
        self.data = nil
        self = nil
    end)
end