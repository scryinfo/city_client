---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/23/023 11:29
---

require "Common/define"

require('Framework/UI/UIPage')


local class = require 'Framework/class'
ScienceSellHallCtrl = class('ScienceSellHallCtrl',UIPage)
UIPage:ResgisterOpen(ScienceSellHallCtrl) --注册打开的方法

--构建函数
function ScienceSellHallCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
    self.prefab = nil
end

function ScienceSellHallCtrl:bundleName()
    return "ScienceSellHallPanel";
end

function ScienceSellHallCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
end
local materialBehaviour
local panel
local Mgr

local orderList={}
local sortList={}

local materialOrderList={}
local materialSortList={}

local goodOrderList={}
local goodSortList={}

local top
local down
local redtop
local reddown
function ScienceSellHallCtrl:Awake(go)
    self.gameObject = go;
    panel=ScienceSellHallPanel

    Event.AddListener("c_RefreshHallItem",ScienceSellHallCtrl.c_RefreshHallItem,self)
    Event.AddListener("c_RefreshSortList",ScienceSellHallCtrl.c_RefreshSortList,self)
    Event.AddListener("c_IsSell",ScienceSellHallCtrl.c_IsSell,self)

    materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(panel.searchBtn.gameObject,self.OnClick_search,self);
    materialBehaviour:AddClick(panel.goodsBtn.gameObject,self.OnClick_goods,self);
    materialBehaviour:AddClick(panel.materialBtn.gameObject,self.OnClick_material,self);

    ---kind sort
    materialBehaviour:AddClick(panel.kindtop.gameObject,self.OnClick_kindsort,self)
    materialBehaviour:AddClick(panel.kinddown.gameObject,self.OnClick_kindsort,self)
    materialBehaviour:AddClick(panel.kindredtop.gameObject,self.OnClick_kindredtop,self)
    materialBehaviour:AddClick(panel.kindreddown.gameObject,self.OnClick_kindreddown,self)
    ---class sort
    materialBehaviour:AddClick(panel.classtop.gameObject,self.OnClick_classsort,self)
    materialBehaviour:AddClick(panel.classdown.gameObject,self.OnClick_classsort,self)
    materialBehaviour:AddClick(panel.classredtop.gameObject,self.OnClick_classredtop,self)
    materialBehaviour:AddClick(panel.classreddown.gameObject,self.OnClick_classreddown,self)
    ---owner sort
    materialBehaviour:AddClick(panel.ownertop.gameObject,self.OnClick_ownersort,self)
    materialBehaviour:AddClick(panel.ownerdown.gameObject,self.OnClick_ownersort,self)
    materialBehaviour:AddClick(panel.ownerredtop.gameObject,self.OnClick_ownerredtop,self)
    materialBehaviour:AddClick(panel.ownerreddown.gameObject,self.OnClick_ownerreddown,self)
    ---level sort
    materialBehaviour:AddClick(panel.leveltop.gameObject,self.OnClick_levelsort,self)
    materialBehaviour:AddClick(panel.leveldown.gameObject,self.OnClick_levelsort,self)
    materialBehaviour:AddClick(panel.levelredtop.gameObject,self.OnClick_levelredtop,self)
    materialBehaviour:AddClick(panel.levelreddown.gameObject,self.OnClick_levelreddown,self)
    ---mylevel sort
    materialBehaviour:AddClick(panel.myleveltop.gameObject,self.OnClick_mylevelsort,self)
    materialBehaviour:AddClick(panel.myleveldown.gameObject,self.OnClick_mylevelsort,self)
    materialBehaviour:AddClick(panel.mylevelredtop.gameObject,self.OnClick_mylevelredtop,self)
    materialBehaviour:AddClick(panel.mylevelreddown.gameObject,self.OnClick_mylevelreddown,self)
    ---score sort
    materialBehaviour:AddClick(panel.scoretop.gameObject,self.OnClick_scorelsort,self)
    materialBehaviour:AddClick(panel.scoredown.gameObject,self.OnClick_scorelsort,self)
    materialBehaviour:AddClick(panel.scoreredtop.gameObject,self.OnClick_scoreredtop,self)
    materialBehaviour:AddClick(panel.scorereddown.gameObject,self.OnClick_scorereddown,self)



    ---Create item
    Mgr=ScienceSellHallModel.Mgr
    for configID, configdata in pairs(Material) do
        Mgr:creatSciencehallItem(materialBehaviour,configdata)
        table.insert(materialOrderList,Mgr.materialInsList[configID])
        local data={}
        data.icon=Mgr.materialInsList[configID].iconImage.sprite
        data.name=Mgr.materialInsList[configID].nameText.text
        data.itemid=Mgr.materialInsList[configID].itemid
        data.class=Mgr.materialInsList[configID].classText.text
        data.kind=Mgr.materialInsList[configID].kindText.text
        data.owner=Mgr.materialInsList[configID].ownerText.text
        data.level=Mgr.materialInsList[configID].leveltext.text
        data.mylevel=Mgr.materialInsList[configID].myleveltext.text
        data.score=Mgr.materialInsList[configID].ScoreText.text
        materialSortList[#materialSortList+1]=data
    end

    for configID, configdata in pairs(Good) do
        Mgr:creatSciencehallItem1(materialBehaviour,configdata)
        table.insert(goodOrderList,Mgr.goodInsList[configID])
        local data={}
        data.icon=Mgr.goodInsList[configID].iconImage.sprite
        data.name=Mgr.goodInsList[configID].nameText.text
        data.itemid=Mgr.goodInsList[configID].itemid
        data.class=Mgr.goodInsList[configID].classText.text
        data.kind=Mgr.goodInsList[configID].kindText.text
        data.owner=Mgr.goodInsList[configID].ownerText.text
        data.level=Mgr.goodInsList[configID].leveltext.text
        data.mylevel=Mgr.goodInsList[configID].myleveltext.text
        data.score=Mgr.goodInsList[configID].ScoreText.text
        goodSortList[#goodSortList+1]=data
    end

end
---刷新排序数组数据
function ScienceSellHallCtrl:c_RefreshSortList()
        materialSortList={}
        goodSortList={}
    for metaId, materialIns in pairs(Mgr.materialInsList) do
        local data={}
        data.icon=materialIns.iconImage.sprite
        data.name=materialIns.nameText.text
        data.itemid=materialIns.itemid
        data.class=materialIns.classText.text
        data.kind=materialIns.kindText.text
        data.owner=materialIns.ownerText.text
        data.level=materialIns.leveltext.text
        data.mylevel=materialIns.myleveltext.text
        data.score=materialIns.ScoreText.text
        materialSortList[#materialSortList+1]=data
    end
    for i, goodIns in pairs(Mgr.goodInsList) do
        local data={}
        data.icon=goodIns.iconImage.sprite
        data.name=goodIns.nameText.text
        data.itemid=goodIns.itemid
        data.class=goodIns.classText.text
        data.kind=goodIns.kindText.text
        data.owner=goodIns.ownerText.text
        data.level=goodIns.leveltext.text
        data.mylevel=goodIns.myleveltext.text
        data.score=goodIns.ScoreText.text
        goodSortList[#goodSortList+1]=data
    end

end
---刷新大厅数据
function ScienceSellHallCtrl:c_RefreshHallItem(hallItemDataList)
    if not hallItemDataList then
        return
    end
    for i, hallData in pairs(hallItemDataList) do
        for k, materialIns in pairs(Mgr.materialInsList) do
            if materialIns.itemid==hallData.metaId then
                Mgr.materialInsList[k].leveltext.text=hallData.topLv
                Mgr.materialInsList[k].ownerText.text=hallData.ownerNum
                break
            end
        end

        for k, goodInsList in pairs(Mgr.goodInsList) do
            if goodInsList.itemid==hallData.metaId then
                Mgr.goodInsList[k].leveltext.text=hallData.topLv
                Mgr.goodInsList[k].ownerText.text=hallData.ownerNum
                break
            end
        end
    end
    Event.Brocast("c_RefreshSortList")
end

---排序赋值
function ScienceSellHallCtrl:SetValue()
    for i, materialIns in pairs(orderList) do
        ---显示
        materialIns.nameText.text=sortList[i].name
        materialIns.classText.text=sortList[i].class
        materialIns.kindText.text=sortList[i].kind
        materialIns.ownerText.text=sortList[i].owner
        materialIns.leveltext.text=sortList[i].level
        materialIns.myleveltext.text=sortList[i].mylevel
        materialIns.ScoreText.text=sortList[i].score
        materialIns.iconImage.sprite=sortList[i].icon
        materialIns.itemid=sortList[i].itemid
    end
end

--------------------------------------------------------------------------------------------score sort

---red mylevel down sort

function ScienceSellHallCtrl:OnClick_scorereddown(this)
    panel.scoreredtop.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.score >n.score end)
    this:SetValue()
end



---red mylevel top  sort
function ScienceSellHallCtrl:OnClick_scoreredtop(this)
    panel.scorereddown.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.score<n.score end)
    this:SetValue()
end


---grey score sort
function ScienceSellHallCtrl:OnClick_scorelsort(this)
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end
    top=panel.scoretop.gameObject
    down=panel.scoredown.gameObject
    reddown= panel.scorereddown.gameObject
    redtop=panel.scoreredtop.gameObject
    ---grey set false ,red down set true
    panel.scoretop.gameObject:SetActive(false)
    panel.scoredown.gameObject:SetActive(false)
    panel.scorereddown.gameObject:SetActive(true)
    ---排序
    table.sort(sortList, function (m, n) return m.score<n.score end)
    this:SetValue()
end

--------------------------------------------------------------------------------------------mylevel sort

---red mylevel down sort
function ScienceSellHallCtrl:OnClick_mylevelreddown(this)
    panel.mylevelredtop.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.mylevel >n.mylevel end)
    this:SetValue()
end

---red mylevel top  sort
function ScienceSellHallCtrl:OnClick_mylevelredtop(this)
    panel.mylevelreddown.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.mylevel <n.mylevel end)
    this:SetValue()
end

---exchange

---grey mylevel sort
function ScienceSellHallCtrl:OnClick_mylevelsort(this)
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end
    top=panel.myleveltop.gameObject
    down=panel.myleveldown.gameObject
    reddown= panel.mylevelreddown.gameObject
    redtop=panel.mylevelredtop.gameObject
    ---grey set false ,red down set true
    panel.myleveltop.gameObject:SetActive(false)
    panel.myleveldown.gameObject:SetActive(false)
    panel.mylevelreddown.gameObject:SetActive(true)
    ---排序
    table.sort(sortList, function (m, n) return m.mylevel <n.mylevel end)
    this:SetValue()
end
--------------------------------------------------------------------------------------------level sort
---red level down sort
function ScienceSellHallCtrl:OnClick_levelreddown(this)
    panel.levelredtop.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.level >n.level end)
    this:SetValue()
end

---red level top  sort
function ScienceSellHallCtrl:OnClick_levelredtop(this)
    panel.levelreddown.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.level<n.level end)
    this:SetValue()
end

---grey level sort
function ScienceSellHallCtrl:OnClick_levelsort(this)
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.leveltop.gameObject
    down=panel.leveldown.gameObject
    reddown= panel.levelreddown.gameObject
    redtop=panel.levelredtop.gameObject
    ---grey set false ,red down set true
    panel.leveltop.gameObject:SetActive(false)
    panel.leveldown.gameObject:SetActive(false)
    panel.levelreddown.gameObject:SetActive(true)
    ---排序
    table.sort(sortList, function (m, n) return m.level <n.level end)
    this:SetValue()
end
--------------------------------------------------------------------------------------------owner sort

---red owner down sort
function ScienceSellHallCtrl:OnClick_ownerreddown(this)
    panel.ownerredtop.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.owner >n.owner end)
    this:SetValue()
end

---red owner top  sort
function ScienceSellHallCtrl:OnClick_ownerredtop(this)
    panel.ownerreddown.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.owner <n.owner end)
    this:SetValue()
end


---grey owner sort
function ScienceSellHallCtrl:OnClick_ownersort(this)
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.ownertop.gameObject
    down=panel.ownerdown.gameObject
    reddown= panel.ownerreddown.gameObject
    redtop=panel.ownerredtop.gameObject
    ---grey set false ,red down set true
    panel.ownertop.gameObject:SetActive(false)
    panel.ownerdown.gameObject:SetActive(false)
    panel.ownerreddown.gameObject:SetActive(true)
    ---排序
    table.sort(sortList, function (m, n) return m.owner <n.owner end)
    this:SetValue()
end

--------------------------------------------------------------------------------------------class sort
---red class down sort
function ScienceSellHallCtrl:OnClick_classreddown(this)
    panel.classredtop.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.class >n.class end)
    this:SetValue()
end

---red class top  sort
function ScienceSellHallCtrl:OnClick_classredtop(this)
    panel.classreddown.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.class <n.class end)
    this:SetValue()
end

---grey class sort
function ScienceSellHallCtrl:OnClick_classsort(this)
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.classtop.gameObject
    down=panel.classdown.gameObject
    reddown= panel.classreddown.gameObject
    redtop=panel.classredtop.gameObject
    ---grey set false ,red down set true
    panel.classtop.gameObject:SetActive(false)
    panel.classdown.gameObject:SetActive(false)
    panel.classreddown.gameObject:SetActive(true)
    ---排序
    table.sort(sortList, function (m, n) return m.class <n.class end)
    this:SetValue()
end
--------------------------------------------------------------------------------------------- kind  sort
---red kind down sort
function ScienceSellHallCtrl:OnClick_kindreddown(this)
    panel.kindredtop.gameObject:SetActive(true)
    self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.kind >n.kind end)
    this:SetValue()
end

---red kind top  sort
function ScienceSellHallCtrl:OnClick_kindredtop(this)
       panel.kindreddown.gameObject:SetActive(true)
       self:SetActive(false)
    ---排序
    table.sort(sortList, function (m, n) return m.kind <n.kind end)
    this:SetValue()
end

---grey kind sort
function ScienceSellHallCtrl:OnClick_kindsort(this)
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.kindtop.gameObject
    down=panel.kinddown.gameObject
    reddown= panel.kindreddown.gameObject
    redtop=panel.kindredtop.gameObject
   ---grey set false ,red down set true
    panel.kindtop.gameObject:SetActive(false)
    panel.kinddown.gameObject:SetActive(false)
    panel.kindreddown.gameObject:SetActive(true)
    ---排序
    table.sort(sortList, function (m, n) return m.kind <n.kind end)
    this:SetValue()
end
---------------------------------------------------------------------------------------------
---material
function ScienceSellHallCtrl:OnClick_material()
    ---btn
    panel.goodsBtn.gameObject:SetActive(true)
    panel.goodsBtngtey.gameObject:SetActive(false)
    panel.materialBtngrey.gameObject:SetActive(true)
    panel.materialBtn.gameObject:SetActive(false)
    ---scroll gameObject
    panel.goodsScroll.gameObject:SetActive(false)
    panel.materialScroll.gameObject:SetActive(true)

    orderList=materialOrderList
    sortList=materialSortList
end

---goods
function ScienceSellHallCtrl:OnClick_goods()
    ---btn
    panel.goodsBtn.gameObject:SetActive(false)
    panel.goodsBtngtey.gameObject:SetActive(true)
    panel.materialBtngrey.gameObject:SetActive(false)
    panel.materialBtn.gameObject:SetActive(true)
    ---scroll gameObject
    panel.goodsScroll.gameObject:SetActive(true)
    panel.materialScroll.gameObject:SetActive(false)

    orderList=goodOrderList
    sortList=goodSortList

end

------------------------------------------------------------------------------------------------

--返回
function ScienceSellHallCtrl:OnClick_backBtn()
    UIPage.ClosePage();
end

--搜索
function ScienceSellHallCtrl:OnClick_search()

end
--刷新
function ScienceSellHallCtrl:Refresh()
    ---服务器请求大厅数据
    Event.Brocast("m_techTradeGetSummary")
    ScienceSellHallModel.ownerId=PlayerTempModel.roleData.id
    ScienceSellHallModel.money=PlayerTempModel.roleData.money
    self:OnClick_material()
end

function ScienceSellHallCtrl:c_IsSell(sellDataList)
    if sellDataList then
        for i, sellData in pairs(sellDataList) do
            if sellData.ownerId==ScienceSellHallModel.ownerId then
                Mgr.scienceItemList[1]:SetActive(true)
                Mgr.scienceInsList[1].levelText.text=sellData.lv
                Mgr.scienceInsList[1].priceText.text= getPriceString(sellData.price..".0000",30,24)
                ScienceSellHallModel.sellitemId=sellData.id
                table.remove(sellDataList,i)
                for k, sellData in pairs(sellDataList) do
                    if Mgr.scienceItemList[sellData.id] then
                        Mgr.scienceItemList[sellData.id]:SetActive(true)
                    else
                        local data={}
                        data.itemId=sellData.id
                        data.price=sellData.price
                        data.level=sellData.lv
                        Mgr:creatSciencetradeItem2(materialBehaviour,data)
                    end
            end
                return
            end
        end


        for i, sellData in pairs(sellDataList) do

            if Mgr.scienceItemList[sellData.id] then
                Mgr.scienceItemList[sellData.id]:SetActive(true)
            else
                local data={}
                data.itemId=sellData.id
                data.price=sellData.price
                data.level=sellData.lv
                Mgr:creatSciencetradeItem2(materialBehaviour,data)
            end
    end

end
end