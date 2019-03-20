---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/3/6/006 15:38
---


UIBubbleBuildingSignItem = class('UIBubbleBuildingSignItem')

UIBubbleBuildingSignItem.stopPath="Assets/CityGame/Resources/Atlas/UIBubble/icon-closedown.png"
UIBubbleBuildingSignItem.unNormalPath="Assets/CityGame/Resources/Atlas/UIBubble/icon-icon-abnormal.png"

local ctrl
---初始化方法   数据（读配置表）
function UIBubbleBuildingSignItem:initialize(prefab,luaBehaviour,data,ctr)
    ctrl=ctr
    self.prefab=prefab
    self.rect= prefab.transform:GetComponent("RectTransform")
    self.rect:SetParent(UIBubbleManager.BubbleParent.transform)
    self.rect.transform.localPosition=Vector3.zero

    self.data=data

    self.smallRec=prefab.transform:Find("small")
    self.smallBgBtn=prefab.transform:Find("small/bgBtn")
    self.smallIma=prefab.transform:Find("small/bgBtn/Image"):GetComponent("Image");
    self.smallExRec=prefab.transform:Find("small/Expection")
    self.smallExIma=prefab.transform:Find("small/Expection/icon"):GetComponent("Image");
  

    self.largeRec=prefab.transform:Find("large")
    self.largeBgBtn=prefab.transform:Find("large/bgBtn")
    self.largeIma=prefab.transform:Find("large/bgBtn/iconImg"):GetComponent("Image");
    self.largeExRec=prefab.transform:Find("large/Expection")
    self.largeExIma=prefab.transform:Find("large/Expection/icon"):GetComponent("Image");
    self.headIma=prefab.transform:Find("large/bgBtn/playerInfo/protait/bg/protaitImg")
    self.nameText=prefab.transform:Find("large/bgBtn/playerInfo/Image/nameText"):GetComponent("Text");
    self.desText=prefab.transform:Find("large/bgBtn/bg/desText"):GetComponent("Text");

    luaBehaviour:AddClick(self.smallBgBtn.gameObject,self.c_OnClick_small,self);
    luaBehaviour:AddClick(self.largeBgBtn.gameObject,self.c_OnClick_large,self);

    self.x=PlayerBuildingBaseData[data.mId].deviationPos[1]
    self.y=PlayerBuildingBaseData[data.mId].deviationPos[2]
    self.z=PlayerBuildingBaseData[data.mId].deviationPos[3]

    self:updateData(data)

end

function UIBubbleBuildingSignItem:updateData(data)
    self.data=data
    --给小的赋值
    if data.emoticon  then
        LoadSprite(BubbleMessageCtrl.configPath[data.emoticon].path,self.smallIma)
        if data.state~="OPERATE" then
            self.smallExRec.localScale=Vector3.one
            LoadSprite(UIBubbleBuildingSignItem.stopPath,self.smallExIma)
        else--没有异常
            self.smallExRec.localScale=Vector3.zero
        end

    end

    --给大的赋值
    if data.emoticon then
        LoadSprite(BubbleMessageCtrl.configPath[data.emoticon].path,self.largeIma)
        if data.state~="OPERATE" then    --停业
            self.largeExRec.localScale=Vector3.one
            LoadSprite(UIBubbleBuildingSignItem.stopPath,self.largeExIma)
        else                           --没有异常
            self.largeExRec.localScale=Vector3.zero
        end
    end
   --赋值留言
    if data.des then
       self. desText.text=data.des
    end
    --赋值 姓名和 头像
    if self .avatarData then
        AvatarManger.CollectAvatar(self .avatarData)
    end
       PlayerInfoManger.GetInfos({data.ownerId},self.LoadHeadImaAndName,self)

    if not data.bubble then
        self:CloesBubble()
    else
        if UnityEngine.PlayerPrefs.GetInt("BuildingBubble")==3 then
            self:CloesBubble()
        elseif UnityEngine.PlayerPrefs.GetInt("BuildingBubble")==2 then
            self:changeLarge()
        else
            self:changeSmall()
        end
    end

end
---========================================================================点击函数============================================================

function UIBubbleBuildingSignItem:c_OnClick_small(ins)
    --另外一个变小
    if ctrl.largeRec then
        ctrl.largeRec.localScale=Vector3.zero
        ctrl.smallRec.localScale=Vector3.one
    end
    --变大
    ins:changeLarge()

    ctrl.largeRec=ins.largeRec
    ctrl.smallRec=ins.smallRec
end

function UIBubbleBuildingSignItem:c_OnClick_large(ins)
    if UnityEngine.PlayerPrefs.GetInt("BuildingBubble")==2 then
        return
    end
    --变小
    ins:changeSmall()
end

----------------------------------------------------------------------------------------------------------------------------------------
--关闭
function UIBubbleBuildingSignItem:CloesBubble()
    self.prefab.transform.localScale=Vector3.zero
end
--开始
function UIBubbleBuildingSignItem:Start()
    self.prefab.transform.localScale=Vector3.one
end

function UIBubbleBuildingSignItem:changeSmall()
    if not self.data.bubble then
        return
    end

    self:Start()
    self.largeRec.localScale=Vector3.zero
    self.smallRec.localScale=Vector3.one
end

function UIBubbleBuildingSignItem:changeLarge()
    if not self.data.bubble then
        return
    end
    self:Start()
    self.largeRec.localScale=Vector3.one
    self.smallRec.localScale=Vector3.zero
end

function UIBubbleBuildingSignItem:LoadHeadImaAndName(info)
   self.nameText.text=info[1].name
   self.avatarData= AvatarManger.GetSmallAvatar(info[1].faceId,self.headIma,0.2)
end

function UIBubbleBuildingSignItem:Update()
    self.rect.anchoredPosition =
    ScreenPosTurnActualPos(UnityEngine.Camera.main:WorldToScreenPoint( Vector3.New(self.data.x, 0, self.data.y) +  Vector3.New(self.x,self.y,self.z))) --Vector3.New(-0.1, 0, 2)))
end

