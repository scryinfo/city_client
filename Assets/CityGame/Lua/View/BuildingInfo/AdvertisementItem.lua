---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/26/026 15:08
---


require('Framework/UI/UIPage')
local class = require 'Framework/class'

AdvertisementItem = class('AdvertisementItem')

---Initialization method data (read configuration table)
function AdvertisementItem:initialize(prefabData,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.ItemList=mgr.AdvertisementItemList
    if prefabData.metaId then
        self.metaId=prefabData.metaId
    end


    self.countText=prefab.transform:Find("bg/numImage/Text"):GetComponent("Text");
    self.nameText=prefab.transform:Find("nameImage/Text"):GetComponent("Text");
    self.icon=prefab.transform:Find("icon"):GetComponent("Image");
    self.ownerIma=prefab.transform:Find("bg/head/owner")
    self.dayText=prefab.transform:Find("bg/day (1)/dayText"):GetComponent("Text");
    self.peopleCountText=prefab.transform:Find("showPanel/peoplecount/peoplecountText"):GetComponent("Text");
    self.adName=prefab.transform:Find("showPanel/nameImage/nameText"):GetComponent("Text");

    if prefabData.personName then
        self.nameText.text=prefabData.personName
        LoadSprite(prefabData.path,self.icon,true)
        self.adName.text=prefabData.name
    end

    if prefabData.count then
        self.countText.text=prefabData.count;
    end

    if prefabData.npcFlow then
        --human traffic
        self.peopleCountText.text=prefabData.npcFlow
        --time
        local beginTs=tostring(prefabData.beginTs)
        beginTs=string.sub(beginTs,1,10)
        local passTime=os.time()-beginTs
        self.dayText.text=string.sub(getFormatUnixTime(passTime).day,2,2).."d"
    end

end
---delete
function AdvertisementItem:OnClicl_XBtn(go)
    go.manager:_deleteGoods(go)
end


function AdvertisementItem:OnClick_detailsBtn(go)
    local m_data={}
    m_data.id=go.id
    ct.OpenCtrl("AdvertisementPopCtrl",m_data)
end



