ConstructItem = class('ConstructItem')


function ConstructItem:initialize(data, viewTrans , contentWidth)
    self.data = data
    self.viewTrans = viewTrans
    local viewRect = self.viewTrans:GetComponent("RectTransform");
    viewRect.anchoredPosition = Vector2.New(contentWidth,0)
    self:_initData()
    --[[
    self.collectBtn.onClick:RemoveAllListeners();
    self.collectBtn.onClick:AddListener(function ()
        self:_clickCollectBtn()
    end)--]]
    self.sizeDeltaX = (viewRect.sizeDelta.x + contentWidth  + 12)
end

--Initialize the interface
function ConstructItem:_initData()
    local data = self.data
    local itemNameRect = self.viewTrans:Find("namebar/NameText"):GetComponent("RectTransform")
    local itemNameText = self.viewTrans:Find("namebar/NameText"):GetComponent("Text")
    --Set the name (TODO: change to multiple languages)
    itemNameText.text = GetLanguage(data.buildName)
    --Set name width (set description button position)
    itemNameRect.sizeDelta = Vector2.New(itemNameText.preferredWidth,itemNameRect.sizeDelta.y)
    --TODO: The length should be increased dynamically according to the type
    local type = ct.getType(UnityEngine.Sprite)
    for i, tempBuildID in ipairs(data.prefabRoute) do
        --Temporarily write down to only three types of buildings according to planning needs
        if i > 3 then
            return
        end
        --According to the picture address path, assign the button picture
        --[[
        local tempBtnIcon =  self.viewTrans:Find("Btn_".. i  .."/icon"):GetComponent("Image")
        local www = UnityEngine.WWW(PlayerBuildingBaseData[tempBuildID]["imgPath"])
        coroutine.www(www)
        tempBtnIcon.sprite = www.texture
        --]]
        local tempBtnIcon =  self.viewTrans:Find("Btn_".. i  .."/icon"):GetComponent("Image")
        panelMgr:LoadPrefab_A(PlayerBuildingBaseData[tempBuildID]["imgPath"], type, nil, function(staticData, obj )
            if obj ~= nil then
                local texture = ct.InstantiatePrefab(obj)
                tempBtnIcon.sprite = texture
                --display image
                tempBtnIcon.transform.localScale = Vector3.one
            end
        end)
        --Add click event
        local tempBtn =  self.viewTrans:Find("Btn_".. i):GetComponent("Button")
        tempBtn.onClick:RemoveAllListeners();
        tempBtn.onClick:AddListener(function ()
            self:_clickConstructBtn(tempBuildID)
        end)
    end
end

--Click the building button
function ConstructItem:_clickConstructBtn(tempID)
    PlayMusEff(1002)
    local tempVec = rayMgr:GetCoordinateByVector3(Vector3.New(UnityEngine.Screen.width / 2, UnityEngine.Screen.height / 2,0))
    TerrainManager.ConstructBuild(tempID,tempVec)
end

function  ConstructItem:Close()
    self.data = nil
end
