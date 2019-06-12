---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/22 15:57
---推广队列item
local isUpdata
PromoteQueueItem = class('PromoteQueueItem')
function PromoteQueueItem:initialize(dataInfo,transform,luaBehaviour,ctrl)
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
    self.progress = self.transform:Find("details/Slider/progress"):GetComponent("Text")
    self.move = self.transform:Find("details/Slider/Fill Area/Fill/move"):GetComponent("RectTransform")
    self.moves = self.transform:Find("details/Slider/Fill Area/Fill/moves"):GetComponent("RectTransform")
    self.nowTime = self.transform:Find("details/Slider/time"):GetComponent("Text")
    self.timePrice = self.transform:Find("details/timePrice")
    self.time = self.transform:Find("details/timePrice/time/Text"):GetComponent("Text")
    self.priceBg = self.transform:Find("details/timePrice/price")
    self.price = self.transform:Find("details/timePrice/price/Text"):GetComponent("Text")
    self.startTime = self.transform:Find("startTime/time"):GetComponent("Text")
    self.delete = self.transform:Find("startTime/time/deleteBg").gameObject

    isUpdata = true

    self.waiting = 0
    self.speed = 0.4
    self.position = Vector3.New(-141,0,0)
    self.positions = Vector3.New(224,0,0)

    self.progress.text = GetLanguage(27040024)

    local playerId = DataManager.GetMyOwnerID()      --自己的唯一id
    self.delete.transform.localScale = Vector3.zero
    local ts = getFormatUnixTime(dataInfo.promStartTs/1000)
    self.startTime.text = ts.year .. "/" .. ts.month .. "/" .. ts.day .. " " .. ts.hour .. ":" .. ts.minute

    self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
    if self.currentTime >= dataInfo.promStartTs and self.currentTime <= dataInfo.promStartTs + dataInfo.promDuration then
        self.slider.value = (self.currentTime - dataInfo.promStartTs) /  dataInfo.promDuration
        local ts = getTimeBySec((self.currentTime - dataInfo.promStartTs)/1000)
        self.nowTime.text = ts.hour.. ":" .. ts.minute .. ":" .. ts.second .. "/" .. math.floor(self.dataInfo.promDuration/3600000 ).. "h"
        --更新队列数据
        local function UpData()
            if not isUpdata then
                if self.m_Timer ~= nil then
                    self.m_Timer:Stop()
                end
                return
            end
            if self.bg:Equals(nil) then
                if self.m_Timer ~= nil then
                    self.m_Timer:Stop()
                end
                return
            end
            self.waiting = self.waiting -1
            if self.waiting <= 0 then
                self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
                self.slider.value = (self.currentTime - self.dataInfo.promStartTs) /  self.dataInfo.promDuration
                local ts = getTimeBySec((self.currentTime - self.dataInfo.promStartTs)/1000)
                self.nowTime.text = ts.hour.. ":" .. ts.minute .. ":" .. ts.second .. "/" .. math.floor(self.dataInfo.promDuration/3600000 ).. "h"
                self.waiting = 1
            end
            self.move:Translate(Vector3.right  * self.speed * UnityEngine.Time.unscaledDeltaTime);
            self.moves:Translate(Vector3.right  * self.speed * UnityEngine.Time.unscaledDeltaTime);
            if self.move.localPosition.x >= self.position.x + 100 then
                self.move.localPosition = self.position
            end
            if self.moves.localPosition.x >= self.positions.x + 100 then
                self.moves.localPosition = self.positions
            end
        end
        ctrl:SetFunc(UpData)
        self.timePrice.localScale = Vector3.zero
        self.slider.transform.localScale = Vector3.one
    else
        self.timePrice.localScale = Vector3.one
        if playerId == dataInfo.sellerId then
            self.priceBg.localScale = Vector3.zero
        else
            self.priceBg.localScale = Vector3.one
            self.price.text = GetClientPriceString(dataInfo.transactionPrice * dataInfo.promDuration/3600000)
        end
        self.slider.transform.localScale = Vector3.zero
        self.time.text = dataInfo.promDuration/3600000 .. "h"
    end
    if dataInfo.buildingType == 1300 then
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-supermarket.png", self.goodsImage,true)
        self.goodsText.text = GetLanguage(42020003)
    elseif dataInfo.buildingType == 1400 then
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/icon-house.png", self.goodsImage,true)
        self.goodsText.text = GetLanguage(42020004)
    else
        LoadSprite("Assets/CityGame/Resources/Atlas/PromoteCompany/goods/".. dataInfo.productionType .. ".png", self.goodsImage,true)
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
        self.priceBg.localScale = Vector3.zero
    end

    luaBehaviour:AddClick(self.delete,self.OnDelete,self)

end

function PromoteQueueItem:OnDelete(go)
    local data={ins = go,content = GetLanguage(27040019),func = function()
        DataManager.DetailModelRpcNoRet(go.dataInfo.sellerBuildingId, 'm_RemovePromote',go.dataInfo.sellerBuildingId,go.id)
    end  }
    ct.OpenCtrl('ReminderCtrl',data)

end

function PromoteQueueItem:c_OnHead(info)
    AvatarManger.GetSmallAvatar(info[1].faceId,self.head.transform,0.15)
    self.name.text = info[1].name
end

--关闭界面后关闭更新
function PromoteQueueItem:CloseUpdata()
    isUpdata = false
end