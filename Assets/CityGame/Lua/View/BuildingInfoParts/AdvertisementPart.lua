---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/1 16:48
---建筑主界面底部广告推广
AdvertisementPart = class('AdvertisementPart', BasePart)
--

function AdvertisementPart:PrefabName()
    return "AdvertisementPart"
end
--
function AdvertisementPart:GetDetailClass()
    return AdvertisementPartDetail
end
--
function AdvertisementPart:_InitTransform()
    self:_getComponent(self.transform)
end
--
function AdvertisementPart:_ResetTransform()
    self.price.text = "E0.0000"
    self.waitingTime.text = "00"
end
--
function AdvertisementPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
--
function AdvertisementPart:ShowDetail(data)
    if data.info.ownerId ~= DataManager.GetMyOwnerID() then
        if not data.takeOnNewOrder then
            Event.Brocast("SmallPop","广告商未开启推广",300)
            return
        end
    end
    BasePart.ShowDetail(self,data)
end
--
function AdvertisementPart:_getComponent(transform)
    self.price = transform:Find("top/price/priceText"):GetComponent("Text")
    self.waitingTime = transform:Find("top/waitingTime/waitingTimeText"):GetComponent("Text")
end
--
function AdvertisementPart:_initFunc()
    self.price.text = GetClientPriceString(self.m_data.curPromPricePerHour)
    self.waitingTime.text = math.floor(self.m_data.promRemainTime/3600000)
end
