---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/22/022 15:03
---
--

require('Framework/UI/UIPage')
local class = require 'Framework/class'

ScienceItem = class('ScienceItem')

---初始化方法   数据（读配置表）
function ScienceItem:initialize(prefabData,prefab,inluabehaviour,mgr, itemid)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = itemid
    self.ItemList=mgr.scienceItemList

    self.avtarImage=prefab.transform:Find("avtarBG/avtar"):GetComponent("Image")
    self.nameText=prefab.transform:Find("content/nameText"):GetComponent("Text")
    self.levelText=prefab.transform:Find("content/middleRoot/levelIcon/Text"):GetComponent("Text")
    self.ScoreText=prefab.transform:Find("content/middleRoot/scoreIcon/Text"):GetComponent("Text")
    self.priceText=prefab.transform:Find("content/priceText"):GetComponent("Text")

    self.deleteBtn=prefab.transform:Find("rightroot/delete")
    self.buyBtn=prefab.transform:Find("rightroot/buy")

    if prefabData.price then
        self:InitData()
    end
    self:start()
end

function ScienceItem:InitData()
    self.levelText.text=self.prefabData.level
    self.priceText.text=getPriceString(self.prefabData.price..".0000",30,24)
end

---delete
function ScienceItem:OnClicl_XBtn(go)
    go.price=nil
    go.func=go.callback
    ct.OpenCtrl("SciencePopCtrl",go)
end

---detail
function ScienceItem:OnClick_detailsBtn(ins)

end

---buy
function ScienceItem:OnClick_buyBtn(ins)
     ins.price=ins.prefabData.price
     ins.func=ins.callback1
     ct.OpenCtrl("SciencePopCtrl",ins)

end

function ScienceItem:start()

    if self.deleteBtn then
        self._luabehaviour:AddClick(self.deleteBtn.gameObject,self.OnClicl_XBtn,self)
    end

    if self.buyBtn then
        self._luabehaviour:AddClick(self.buyBtn.gameObject,self.OnClick_buyBtn,self)
    end
end


function ScienceItem:callback1()
    if ScienceSellHallModel.money>=tonumber(self.prefabData.price) then
        Event.Brocast("SmallPop","Succsee")
        Event.Brocast("m_techTradeBuy",self.id)

    end
end

function ScienceItem:callback()
    self.manager:_deleteGood(self)
    Event.Brocast("m_techTradeDel",ScienceSellHallModel.sellitemId)
end
