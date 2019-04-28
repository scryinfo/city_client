---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/22 15:57
---推广队列item
PromoteQueueItem = class('PromoteQueueItem')
function PromoteQueueItem:initialize(dataInfo,transform,luaBehaviour)
    self.transform = transform;
    self.dataInfo = dataInfo;
    self.id = dataInfo.promotionId
    self.bg = self.transform:Find("bg")
    self.myBg = self.transform:Find("myBg")
    self.head = self.transform:Find("player/head/headBg")
    self.name = self.transform:Find("player/head/headBg/name"):GetComponent("Text")
    self.goodsImage = self.transform:Find("goods/goodsImage"):GetComponent("Image")
    self.goodsText = self.transform:Find("goods/goodsImage/goodsText"):GetComponent("Text")
    self.slider = self.transform:Find("details/Slider"):GetComponent("Slider")
    self.nowTime = self.transform:Find("details/Slider/time"):GetComponent("Text")
    self.timePrice = self.transform:Find("details/timePrice")
    self.time = self.transform:Find("details/timePrice/time/Text"):GetComponent("Text")
    self.priceBg = self.transform:Find("details/timePrice/price")
    self.price = self.transform:Find("details/timePrice/price/Text"):GetComponent("Text")
    self.startTime = self.transform:Find("startTime/time"):GetComponent("Text")
    self.delete = self.transform:Find("startTime/time/deleteBg").gameObject

    local playerId = DataManager.GetMyOwnerID()      --自己的唯一id
    self.delete.transform.localScale = Vector3.zero
    local ts = getFormatUnixTime(dataInfo.promStartTs/1000)
    self.startTime.text = ts.year .. "/" .. ts.month .. "/" .. ts.day .. " " .. ts.hour .. " " .. ts.minute

    local currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
    if currentTime >= dataInfo.promStartTs and currentTime <= dataInfo.promStartTs + dataInfo.promDuration then
        self.timePrice.localScale = Vector3.zero
        self.slider.transform.localScale = Vector3.one
        self.slider.value = (currentTime - dataInfo.promStartTs) /  dataInfo.promDuration
        self.nowTime.text = math.floor(dataInfo.promProgress/3600000) .. "/" .. math.ceil(dataInfo.promDuration/3600000 ).. "h"
    else
        self.timePrice.localScale = Vector3.one
        if playerId == dataInfo.sellerId then
            self.priceBg.localScale = Vector3.zero
        else
            self.priceBg.localScale = Vector3.one
            self.price.text = GetClientPriceString(dataInfo.transactionPrice * dataInfo.promDuration/3600000)
        end
        self.slider.transform.localScale = Vector3.zero
        self.time.text = dataInfo.promDuration/3600000
    end
    if dataInfo.buildingType == 1300 then
        self.goodsText.text = GetLanguage(18030001)
    elseif dataInfo.buildingType == 1400 then
        self.goodsText.text = GetLanguage(18030007)
    else
        self.goodsText.text = GetLanguage(dataInfo.productionType)
    end

    PlayerInfoManger.GetInfos({dataInfo.buyerId}, self.c_OnHead, self)
    if playerId == dataInfo.buyerId then
        self.myBg.localScale = Vector3.one
        if playerId == dataInfo.sellerId then
            self.delete.transform.localScale = Vector3.one
        end
    else
        self.myBg.localScale = Vector3.zero
    end

    luaBehaviour:AddClick(self.delete,self.OnDelete,self)
end

function PromoteQueueItem:OnDelete(go)
    local data={ins = go,content = "Make sure to take down all of the goods.",func = function()
        DataManager.DetailModelRpcNoRet(go.dataInfo.sellerBuildingId, 'm_RemovePromote',go.dataInfo.sellerBuildingId,go.id)
    end  }
    ct.OpenCtrl('ReminderCtrl',data)

end

function PromoteQueueItem:c_OnHead(info)
    AvatarManger.GetSmallAvatar(info[1].faceId,self.head.transform,0.15)
    self.name.text = info[1].name
end