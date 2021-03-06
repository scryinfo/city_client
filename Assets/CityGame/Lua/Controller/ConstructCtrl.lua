---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by allen.
--- DateTime: 2018/11/2 17:01
---Construction panel
-----

ConstructCtrl = class('ConstructCtrl',UIPanel)
UIPanel:ResgisterOpen(ConstructCtrl)

function ConstructCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ConstructCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ConstructPanel.prefab"
end

function ConstructCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
    --Close panel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(ConstructPanel.btn_back.gameObject, function()
        PlayMusEff(1002)
        UIPanel.CloseAllPageExceptMain()
    end )
end

function ConstructCtrl:Awake(go)
    self.gameObject = go
    self.contentTrans = self.gameObject.transform:Find("bottomScroll/Viewport/Content")
    self:_initPanelData()
end

function ConstructCtrl:Refresh()
    Event.Brocast("c_HideGroundBubble")
end

function ConstructCtrl:ClearAllItem()
    if self.contentTrans.childCount > 0 then
        for i = 0, self.contentTrans.childCount - 1 do
            destroy(self.contentTrans:GetChild(i).gameObject)
        end
        --ConstructCtrl:ClearItemData()
    end
end

function ConstructCtrl:_initPanelData()
    --Generate items according to the configuration table
    local path = 'View/Items/ConstructItem'
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        return
    end
    local contentWidth = 0
    self.Items  = {}
    for key, item in ipairs(ConstructConfig) do
        local itemObj = UnityEngine.GameObject.Instantiate(prefab,self.contentTrans)
        self.Items[key] = ConstructItem:new(item, itemObj.transform ,contentWidth)
        contentWidth =  self.Items[key].sizeDeltaX
    end
    contentWidth  =  contentWidth - 12
    self.contentTrans:GetComponent("RectTransform").sizeDelta = Vector2.New(contentWidth,self.contentTrans:GetComponent("RectTransform").sizeDelta.y)
end

function ConstructCtrl:ClearItemData()
    if self.Items ~= nil then
        for i, v in pairs(self.Items) do
            v:Close()
            v = nil
        end
        self.Items = nil
    end
end

function ConstructCtrl:Hide()
    UIPanel.Hide(self)
    CameraMove.ChangeCameraState(TouchStateType.NormalState)
    Event.Brocast("m_abolishConstructBuild")
    Event.Brocast("c_ShowGroundBubble")
end
