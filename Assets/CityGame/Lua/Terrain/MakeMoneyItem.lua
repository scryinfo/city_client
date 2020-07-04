MakeMoneyItem = class('MakeMoneyItem')

local mainCamera = nil
---Initialization function
--prefab: Make money bubble Prefab
--data: Make money bubble data
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
    --set position 
    local tempBuildBlockID =  TerrainManager.GridIndexTurnBlockID(data.pos)
    local tempPosition = TerrainManager.BlockIDTurnPosition(tempBuildBlockID)
    local basebuildData =  DataManager.GetBaseBuildDataByID(tempBuildBlockID)
    if basebuildData ~= nil and basebuildData.Data ~= nil and basebuildData.Data.buildingID ~= nil then
        tempPosition.x = tempPosition.x + PlayerBuildingBaseData[basebuildData.Data.buildingID].x / 2
        tempPosition.z = tempPosition.z + PlayerBuildingBaseData[basebuildData.Data.buildingID].y / 2
    end
    self.Pos = tempPosition
    self.rect.anchoredPosition = ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint(tempPosition))
    self.icon = prefab.transform:Find("Icon")
    self.icon.transform.localScale = Vector3.zero
    --Set picture Icon
    if data.itemId ~= nil then
        local tempSprite = SpriteManager.GetSpriteByPool(data.itemId)
        if tempSprite ~= nil then
            self.iconSprite = self.icon:GetComponent("Image")
            self.iconSprite.sprite = tempSprite
            self.icon.transform.localScale = Vector3.one
        end
    end
    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
    self:Show()
end

--After data initialization is complete, show
function MakeMoneyItem:Show()
    local sequence = DG.Tweening.DOTween.Sequence()
    sequence:Append( self.canvasGroup:DOFade(1,0.3):SetEase(DG.Tweening.Ease.OutCubic) )
    sequence:AppendInterval(0.3)
    sequence:Insert(0.6, self.rect:DOScale(Vector3.zero,1):SetEase(DG.Tweening.Ease.OutCirc))
    sequence:Append( self.canvasGroup:DOFade(0,1):SetEase(DG.Tweening.Ease.Linear) )
    sequence:OnComplete( function()
        MakeMoneyManager.RecyclingGameObject(self.prefab)
        Event.RemoveListener("c_RefreshLateUpdate", self.LateUpdate, self)
        self.prefab = nil
        self.data = nil
        self = nil
    end)
end

--Refresh location
function MakeMoneyItem:LateUpdate()
    if self.prefab ~= nil and self.Pos ~= nil then
        self.rect.anchoredPosition =ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint(self.Pos))
    end
end