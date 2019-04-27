---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/4/18 16:03
---

BuildingUpperItem = class('BuildingUpperItem')
BuildingUpperItem.static.NameColor = "#FFD562" -- 建筑名字颜色
BuildingUpperItem.static.BuildingTypeColor = "#EFEFEF" -- 建筑类型颜色

--初始化方法
function BuildingUpperItem:initialize(viewRect)
    self.viewRect = viewRect

    self.backBtn = self.viewRect.transform:Find("BackBtn"):GetComponent("Button")
    --self.buildingNameText = self.viewRect.transform:Find("titleBg/buildingTypeNameText"):GetComponent("Text")
    self.titleBgBtn = self.viewRect.transform:Find("TitleBg"):GetComponent("Button")
    self.nameText = self.viewRect.transform:Find("TitleBg/NameText"):GetComponent("Text")
    self.peopleNumberText = self.viewRect.transform:Find("RightBg/PeopleNumberText"):GetComponent("Text")
    self.gradeBg = self.viewRect.transform:Find("TitleBg/GradeBg")
    self.gradeText = self.viewRect.transform:Find("TitleBg/GradeBg/GradeText"):GetComponent("Text")
    --self.changeNameBtn = self.viewRect.transform:Find("titleBg/changeNameBtn"):GetComponent("Button")

    --self.iconImg = self.viewRect.transform:Find("right/messageBg/iconImg"):GetComponent("Image")
    --self.messageText = self.viewRect.transform:Find("right/messageBg/messageText"):GetComponent("Text")
    --self.changeSignBtn = self.viewRect.transform:Find("right/messageBg/changeSignBtn"):GetComponent("Button")
    --self.headImg = self.viewRect.transform:Find("right/headBg/headImg"):GetComponent("Image")

    self.backBtn.onClick:AddListener(function ()
        if self.closeCallBack ~= nil then
            --if self.avatar ~= nil then
            --    AvatarManger.CollectAvatar(self.avatar)
            --    self.avatar = nil
            --end
            self.closeCallBack()
        end
    end)

    self.titleBgBtn.onClick:AddListener(function ()
        Event.Brocast("c_openBuildingInfo",self.data)
    end)
    --self.changeSignBtn.onClick:AddListener(function ()
    --    PlayMusEff(1002)
        --if self.data.id ~= nil then
        --    ct.OpenCtrl("BubbleMessageCtrl", self.data.id)
        --end
    --end)
end
--
--function BuildingUpperItem:changeItemData(data)
--    if data ~= nil then
--        if data.des ~= nil then
--            self.messageText.text = data.des
--        end
--        if data.emoticon ~= nil then
--            local path = BubbleMessageCtrl.configPath[data.emoticon].path
--            LoadSprite(path, self.iconImg, true)
--        end
--    end
--end

--刷新数据
function BuildingUpperItem:refreshData(data, closeCallBack)
    if data == nil then
        return
    end
    --if self.avatar == nil and data.ownerId ~= nil then
    --    PlayerInfoManger.GetInfos({[1] = data.ownerId}, self.initPlayerInfo, self)
    --end
    Event.Brocast("c_GetBuildingInfo",data)
    self.data = data
    self.closeCallBack = closeCallBack
    local name = data.name or "SRCY CITY"
    --self.nameText.text = name .. GetLanguage(PlayerBuildingBaseData[data.mId].typeName)
    self.nameText.text = string.format("<color=%s>%s</color> <color=%s><b>%s</b></color>", BuildingUpperItem.static.NameColor, name, BuildingUpperItem.static.BuildingTypeColor, GetLanguage(PlayerBuildingBaseData[data.mId].typeName))
    self.peopleNumberText.text = tostring(data.todayVisitor)
    -- 建筑类型
    local type = string.sub(tostring(data.mId), 1, 2)
    if type == "13" or type == "14" then
        self.gradeBg.localScale = Vector3.one
        self.gradeText.text = math.ceil((data.brand + data.quality + 2) * 25)   -- 公式，必改
    else
        self.gradeBg.localScale = Vector3.zero
    end
    --self.buildingNameText.text = GetLanguage(PlayerBuildingBaseData[data.mId].sizeName)..GetLanguage(PlayerBuildingBaseData[data.mId].typeName)
    self.showBubble = data.showBubble

    --if data.emoticon ~= nil then
    --    local path = BubbleMessageCtrl.configPath[data.emoticon].path
    --    LoadSprite(path, self.iconImg, true)
    --end
    --if data.des == nil then
    --    self.messageText.text = "快来修改你的建筑签名吧"
    --else
    --    self.messageText.text = data.des
    --end
    --if data.ownerId ~= DataManager.GetMyOwnerID() then
    --    self.changeNameBtn.transform.localScale = Vector3.zero
    --    self.changeSignBtn.transform.localScale = Vector3.zero
    --    if data.des == nil then
    --        self.messageText.text = "玩家暂时没有设置建筑签名"
    --    end
    --else
    --    self.changeNameBtn.transform.localScale = Vector3.one
    --    self.changeSignBtn.transform.localScale = Vector3.one
    --end
end
--
--function BuildingUpperItem:changeBuildingName()
--    PlayMusEff(1002)
--    local data = {}
--    data.titleInfo = GetLanguage(25040001)
--    data.btnCallBack = function(name)
--        if self.data.id ~= nil then
--            DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingInfo","gs.SetBuildingInfo",{ id = self.data.id, name = name})
--            self.nameText.text = name
--        end
--    end
--    ct.OpenCtrl("InputDialogPageCtrl", data)
--end

--function BuildingUpperItem:initPlayerInfo(info)
--    local data = info[1]
--    if data ~= nil then
--        self.avatar = AvatarManger.GetSmallAvatar(data.faceId, self.headImg.transform,0.2)
--    end
--end