---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/14 17:27
---
GAucHistoryItem = class('GAucHistoryItem')

function GAucHistoryItem:initialize(data, viewRect)
    self.viewRect = viewRect

    local viewTrans = self.viewRect
    self.firstbg = viewTrans:Find("firstbg")
    self.protaitImg = viewTrans:Find("protaitRoot/bg/protaitImg"):GetComponent("Image")
    self.protaitBtn = viewTrans:Find("protaitRoot/protaitBtn"):GetComponent("Button")
    self.nameText = viewTrans:Find("nameText"):GetComponent("Text")
    self.firstTran = viewTrans:Find("first")
    self.firstPriceText = viewTrans:Find("first/firstPriceText"):GetComponent("Text")
    self.otherTran = viewTrans:Find("other")
    self.otherPriceText = viewTrans:Find("other/otherPriceText"):GetComponent("Text")
    self.protaitBtn.onClick:AddListener(function ()
        self:_clickProtaitFunc()
    end)

    self:_initData(data)
end
function GAucHistoryItem:_initData(data)
    self.data = data
    if data.isFirst == true then
        self.firstbg.localScale = Vector3.one
        self.firstTran.localScale = Vector3.one
        self.otherTran.localScale = Vector3.zero
        self.firstPriceText.text = getPriceString(GetClientPriceString(data.price), 30, 24)
    else
        self.firstbg.localScale = Vector3.zero
        self.firstTran.localScale = Vector3.zero
        self.otherTran.localScale = Vector3.one
        self.otherPriceText.text = getPriceString(GetClientPriceString(data.price), 30, 24)
    end
    if data.biderId ~= nil then
        PlayerInfoManger.GetInfos({[1] = data.biderId}, self._getInfo, self)
    end
end
--点击头像
function GAucHistoryItem:_clickProtaitFunc()
    if self.playerInfo == nil then
        return
    end
    ct.OpenCtrl("PersonalHomeDialogPageCtrl", self.playerInfo)
end
--拿到信息
function GAucHistoryItem:_getInfo(data)
    local playerData = data[1]
    if playerData ~= nil and playerData.id == self.data.biderId then
        self.playerInfo = playerData
        self.nameText.text = playerData.name
        self.avatar = AvatarManger.GetSmallAvatar(playerData.faceId, self.protaitImg.transform,0.2)
    end
end

function GAucHistoryItem:close()
    if self.avatar ~= nil then
        AvatarManger.CollectAvatar(self.avatar)
    end
    Event.Brocast("c_ReturnGAucHistoryObj", self.viewRect.gameObject)  --回收item
    self.data = nil
    self.playerInfo = nil
    self = nil
end