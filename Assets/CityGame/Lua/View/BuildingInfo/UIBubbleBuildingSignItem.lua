---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/6/006 15:38
---


UIBubbleBuildingSignItem = class('UIBubbleBuildingSignItem')

UIBubbleBuildingSignItem.stopPath="Assets/CityGame/Resources/Atlas/UIBubble/icon-closedown.png"
UIBubbleBuildingSignItem.unNormalPath="Assets/CityGame/Resources/Atlas/UIBubble/icon-icon-abnormal.png"

local ctrl
local selfBoxwidth = 200    --给出200像素的富裕空间  其实只需要最大宽高的一半
local minAnchorX = nil
local maxAnchorX = nil
local minAnchorY = nil
local maxAnchorY = nil
local mainCamera = nil
---初始化方法   数据（读配置表）
function UIBubbleBuildingSignItem:initialize(prefab,data,ctr)
    ctrl=ctr
    self.prefab=prefab
    self.rect= prefab.transform:GetComponent("RectTransform")
    self.rect:SetParent(UIBubbleManager.BubbleParent.transform)
    self.prefab.transform.localScale = Vector3.one
    self.rect.transform.localPosition=Vector3.one
    self.data=data
    self.smallRec=prefab.transform:Find("small")
    self.smallBgBtn=prefab.transform:Find("small/bgBtn"):GetComponent("Button")
    self.smallIma=prefab.transform:Find("small/bgBtn/Image"):GetComponent("Image")
    self.ExIma=prefab.transform:Find("Expection")


    self.largeRec=prefab.transform:Find("large")
    self.largeBgBtn=prefab.transform:Find("large/bgBtn"):GetComponent("Button")
    self.largeIma=prefab.transform:Find("large/bgBtn/iconImg"):GetComponent("Image");
    self.headIma=prefab.transform:Find("large/bgBtn/playerInfo/protait/bg/protaitImg")
    self.nameText=prefab.transform:Find("large/bgBtn/playerInfo/nameText"):GetComponent("Text")
    self.desText=prefab.transform:Find("large/bgBtn/desText"):GetComponent("Text")

    self.smallBgBtn.onClick:AddListener(function ()
        self:c_OnClick_small()
    end)
    self.largeBgBtn.onClick:AddListener(function ()
        self:c_OnClick_large()
    end)

    self.x=PlayerBuildingBaseData[data.mId].deviationPos[1]
    self.y=PlayerBuildingBaseData[data.mId].deviationPos[2]
    self.z=PlayerBuildingBaseData[data.mId].deviationPos[3]
    ---
    Event.AddListener("c_RefreshLateUpdate", self.LateUpdate, self)
    Event.AddListener("c_BuildingBubbleShow", self.ShowBubble, self)
    Event.AddListener("c_BuildingBubbleHide", self.CloesBubble, self)

    self:updateData(data)
    if minAnchorX == nil then
        minAnchorX = - selfBoxwidth
        maxAnchorX = UnityEngine.Screen.width * Game.ScreenRatio + selfBoxwidth
        minAnchorY = - selfBoxwidth
        maxAnchorY = UnityEngine.Screen.height * Game.ScreenRatio + selfBoxwidth
        mainCamera = UnityEngine.Camera.main
    end
    if self.data ~= nil  then
        self.rect.anchoredPosition = ScreenPosTurnActualPos(mainCamera:WorldToScreenPoint( Vector3.New(self.data.x + self.x, self.y, self.data.y + self.z))) --Vector3.New(-0.1, 0, 2)))
    end
    self.m_anchoredPos =  self.rect.anchoredPosition
    self:ShowOrHideSelf(self:JudgeSelfIsShow())
    if BuilldingBubbleInsManger.type == BuildingBubbleType.close then
        self:CloesBubble()
    end
end


--判断是否在屏幕内
function UIBubbleBuildingSignItem:JudgeSelfIsShow()
    if  self.m_anchoredPos ~= nil then
        if self.m_anchoredPos.x >= minAnchorX and  self.m_anchoredPos.x <= maxAnchorX and self.m_anchoredPos.y >= minAnchorY and  self.m_anchoredPos.y <= maxAnchorY  then
            return true
        end
    end
    return false
end

--判断是否在屏幕内
function UIBubbleBuildingSignItem:IsMove()
    --先判断是否是在屏幕显示范围内，做显示/隐藏处理
    self:ShowOrHideSelf(self:JudgeSelfIsShow())
    --根据是否在屏幕范围内显示隐藏自身
    if self.IsShow then
        self.rect.anchoredPosition = self.m_anchoredPos
    end
end

function UIBubbleBuildingSignItem:ShowOrHideSelf(tempBool)
    if type(tempBool) == "boolean" and tempBool ~= self.IsShow then
        self.IsShow = tempBool
        self.prefab.gameObject:SetActive(self.IsShow)
    end
end

function UIBubbleBuildingSignItem:updateData(data)
    self.data=data
    if self.m_EmojiData == nil or self.m_EmojiData ~= BubbleMessageCtrl.configPath[data.emoticon].path then
        self.m_EmojiData = BubbleMessageCtrl.configPath[data.emoticon].path
        self.smallImageIsCreate = false
        self.largeImageIsCreate = false
    end
    --给小的赋值
    if data.emoticon  then
        if data.state~="OPERATE" then
            self.ExIma.gameObject:SetActive(true)
        else--没有异常
            self.ExIma.gameObject:SetActive(false)
        end
    end
    --赋值留言
    if data.des then
        self.desText.text=data.des
    end
    --赋值 姓名和 头像
    if not data.bubble then
        self:CloesBubble()
    else
        if BuilldingBubbleInsManger.type == BuildingBubbleType.close then
            self:changeSmall()
            self:CloesBubble()
        elseif BuilldingBubbleInsManger.type == BuildingBubbleType.show then
            self:changeSmall()
            self:ShowBubble()
        end
    end
end
---========================================================================点击函数============================================================/

function UIBubbleBuildingSignItem:c_OnClick_small()
    --另外一个变小
    if ctrl.largeRec then
        ctrl.largeRec.gameObject:SetActive(false)
        ctrl.smallRec.gameObject:SetActive(true)
    end
    --变大
    self:changeLarge()

    ctrl.largeRec= self.largeRec
    ctrl.smallRec= self.smallRec
end

function UIBubbleBuildingSignItem:c_OnClick_large()
    --if BuilldingBubbleInsManger.type == bui then
    --    return
    --end
    --变小
    self:changeSmall()
end

----------------------------------------------------------------------------------------------------------------------------------------
--关闭
function UIBubbleBuildingSignItem:CloesBubble()
    self.prefab.gameObject:SetActive(false)
end

--显示
function UIBubbleBuildingSignItem:ShowBubble()
    --需要额外判断自身是否是隐藏
    if not self.data.bubble then
        return
    end
    self.prefab.gameObject:SetActive(true)
end

--开始
function UIBubbleBuildingSignItem:Start()
    self:ShowBubble()
end

function UIBubbleBuildingSignItem:changeSmall()
    if not self.data.bubble then
        return
    end
    self:Start()
    self.largeRec.gameObject:SetActive(false)
    self.smallRec.gameObject:SetActive(true)
    if self.smallImageIsCreate == nil or self.smallImageIsCreate == false then
        BubbleMessageCtrl.SetEmojiIconSpite(self.m_EmojiData,self.smallIma)
        self.smallImageIsCreate = true
    end
end

function UIBubbleBuildingSignItem:changeLarge()
    if not self.data.bubble then
        return
    end
    if self.data.ownerId == DataManager.GetMyOwnerID() then
        self:LoadHeadImaAndName({[1] = {["name"] = DataManager.GetName(),["faceId"] = DataManager.GetFaceId()}})
    else
        PlayerInfoManger.GetInfos({self.data.ownerId},self.LoadHeadImaAndName,self)
    end
    self:Start()
    self.largeRec.gameObject:SetActive(true)
    self.smallRec.gameObject:SetActive(false)
    self.prefab.transform:SetAsLastSibling()
    if self.largeImageIsCreate == nil or self.largeImageIsCreate == false then
        if self.smallImageIsCreate ~= nil and self.smallImageIsCreate == true then --如果小头像已经加载了  直接拷贝一下
            self.largeIma.sprite = self.smallIma.sprite
        else
            BubbleMessageCtrl.SetEmojiIconSpite(self.m_EmojiData,self.largeIma)
        end
        self.largeImageIsCreate = true
    end
end

function UIBubbleBuildingSignItem:LoadHeadImaAndName(info)
    self.nameText.text=info[1].name
    if self.m_faceID == nil or self.m_faceID ~= info[1].faceId then
        self.m_faceID = info[1].faceId
        if self.avatarData ~= nil then
            AvatarManger.CollectAvatar(self.avatarData)
        end
        self.avatarData = AvatarManger.GetSmallAvatar(self.m_faceID,self.headIma,0.2)
    end
end

function UIBubbleBuildingSignItem:LateUpdate()
    if self.prefab ~= nil and BuilldingBubbleInsManger.type == BuildingBubbleType.show  then
        self.m_anchoredPos = ScreenPosTurnActualPos(mainCamera:WorldToScreenPoint( Vector3.New(self.data.x + self.x, self.y, self.data.y + self.z))) --Vector3.New(-0.1, 0, 2)))
        self:IsMove()
    end
end

--被销毁
function UIBubbleBuildingSignItem:Close()
    --回收GameObject
    DataManager.buildingBubblePool:RecyclingGameObjectToPool(self.prefab)
    --取消注册
    Event.RemoveListener("c_RefreshLateUpdate", self.LateUpdate, self)
    Event.RemoveListener("c_BuildingBubbleShow", self.ShowBubble, self)
    Event.RemoveListener("c_BuildingBubbleHide", self.CloesBubble, self)
    self = nil
end