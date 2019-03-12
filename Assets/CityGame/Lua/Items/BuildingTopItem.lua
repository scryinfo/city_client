---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/3/11 11:51
---建筑顶部通用
BuildingTopItem = class('BuildingTopItem')

--初始化方法
function BuildingTopItem:initialize(viewRect)
    self.viewRect = viewRect

    self.backBtn = self.viewRect.transform:Find("backBtn"):GetComponent("Button")
    self.buildingNameText = self.viewRect.transform:Find("titleBg/buildingTypeNameText"):GetComponent("Text")
    self.nameText = self.viewRect.transform:Find("titleBg/nameText"):GetComponent("Text")
    self.changeNameBtn = self.viewRect.transform:Find("titleBg/changeNameBtn"):GetComponent("Button")

    self.iconImg = self.viewRect.transform:Find("right/messageBg/iconImg"):GetComponent("Image")
    self.messageText = self.viewRect.transform:Find("right/messageBg/messageText"):GetComponent("Text")
    self.changeSignBtn = self.viewRect.transform:Find("right/messageBg/changeSignBtn"):GetComponent("Button")
    self.headImg = self.viewRect.transform:Find("right/headBg/headImg"):GetComponent("Image")

    self.backBtn.onClick:AddListener(function ()
        if self.closeCallBack ~= nil then
            self.closeCallBack()
        end
    end)
    self.changeNameBtn.onClick:AddListener(function ()
        self:changeBuildingName()
    end)
    self.changeSignBtn.onClick:AddListener(function ()
        PlayMusEff(1002)
        if self.data.id ~= nil then
            ct.OpenCtrl("BubbleMessageCtrl", self.data.id)
        end
    end)
end

--

--刷新数据
function BuildingTopItem:refreshData(data, closeCallBack)
    if self.data ~= nil then
        if self.data.id ~= data.id then  --判断是否为同一个建筑
            return
        end
    end
    self.data = data
    self.closeCallBack = closeCallBack
    self.nameText.text = data.name or "SRCY CITY"
    self.buildingNameText.text = GetLanguage(PlayerBuildingBaseData[data.mId].sizeName)..GetLanguage(PlayerBuildingBaseData[data.mId].typeName)
    self.showBubble = data.showBubble

    if data.emoticon ~= nil then
        local path = BubbleMessageCtrl.configPath[data.emoticon].path
        LoadSprite(path, self.iconImg, true)
    end
    if data.des == nil then
        self.messageText.text = "快来修改你的建筑签名吧"
    else
        self.messageText.text = data.des
    end
    if data.ownerId ~= DataManager.GetMyOwnerID() then
        self.changeNameBtn.transform.localScale = Vector3.zero
        self.changeSignBtn.transform.localScale = Vector3.zero
        if data.des == nil then
            self.messageText.text = "玩家暂时没有设置建筑签名"
        end
    else
        self.changeNameBtn.transform.localScale = Vector3.one
        self.changeSignBtn.transform.localScale = Vector3.one
    end
end
--
function BuildingTopItem:changeBuildingName()
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(25040001)
    data.btnCallBack = function(name)
        if self.data.id ~= nil then
            DataManager.DetailModelRpcNoRet(self.data.id, 'm_ReqChangeHouseName', self.data.id, name)
            self.nameText.text = name
        end
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end
--
function BuildingTopItem:close()

end