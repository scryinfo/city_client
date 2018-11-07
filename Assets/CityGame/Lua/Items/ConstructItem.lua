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

--初始化界面
function ConstructItem:_initData()
    local data = self.data
    local itemNameRect = self.viewTrans:Find("namebar/NameText"):GetComponent("RectTransform")
    local itemNameText = self.viewTrans:Find("namebar/NameText"):GetComponent("Text")
    --设置名字（TODO：改为多语言）
    itemNameText.text = data.buildName
    --设置名字宽度（设置说明按钮位置）
    itemNameRect.sizeDelta = Vector2.New(itemNameText.preferredWidth,itemNameRect.sizeDelta.y)
    --TODO:此处应该根据种类多少动态增加长度
    for i, tempBuildID in ipairs(data.prefabRoute) do
        --临时根据策划需求写死为只有3种大小建筑
        if i > 3 then
            return
        end
        --根据图片地址路径，赋值按钮图片
        --[[
        local tempBtnIcon =  self.viewTrans:Find("Btn_".. i  .."/icon"):GetComponent("Image")
        local www = UnityEngine.WWW(PlayerBuildingBaseData[tempBuildID]["imgPath"])
        coroutine.www(www)
        tempBtnIcon.sprite = www.texture
        --]]
        --添加点击事件
        local tempBtn =  self.viewTrans:Find("Btn_".. i):GetComponent("Button")
        tempBtn.onClick:RemoveAllListeners();
        tempBtn.onClick:AddListener(function ()
            self:_clickConstructBtn(tempBuildID)
        end)
    end
end

--点击建筑按钮
function ConstructItem:_clickConstructBtn(tempID)

end

function  ConstructItem:Close()
    self.data = nil
    self = nil
end
