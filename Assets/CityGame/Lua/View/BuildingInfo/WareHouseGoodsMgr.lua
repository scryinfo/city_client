---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 11:31
---仓库商品管理

require "View/BuildingInfo/WareHouseGoodsItem"
local class = require 'Framework/class'
WareHouseGoodsMgr = class('WareHouseGoodsMgr')

WareHouseGoodsMgr.static.Goods_PATH = "View/GoodsItem/CenterWareHouseItem"
WareHouseGoodsMgr.static.TspGoods_PATH = "View/GoodsItem/TransportGoodsItem"
WareHouseGoodsMgr.static.AddressList_PATH = "View/FriendsLineItem";
--WareHouseGoodsMgr.static.Line_PATH = "View/ChooseLineItem";

function WareHouseGoodsMgr:initialize()

end

--创建商品
function WareHouseGoodsMgr:_creatItemGoods(insluabehaviour,isSelect)
    self.behaviour = insluabehaviour
    --测试数据
    self.ModelDataList={}
    --配置表数据模拟
    local configTable = {}
    if PlayerTempModel.roleData.bag.inHand == nil then
        return
    end
    for i, v in pairs(PlayerTempModel.roleData.bag.inHand) do
        local uiTab = {}
        uiTab.name = Material[v.key.id].name
        uiTab.number = v.n
        uiTab.itemId = v.key.id
--[[        uiTab.producerId = v.key.producerId
        uiTab.qty = v.key.qty]]
        configTable[i] = uiTab
        --预制的信息`
        local prefabData={}
        prefabData.state = 'idel'
        prefabData.uiData = configTable[i]
        prefabData._prefab = self:_creatGoods(WareHouseGoodsMgr.static.Goods_PATH,CenterWareHousePanel.content)
        self.ModelDataList[i] = prefabData

        local WareHouseLuaItem = WareHouseGoodsItem:new(self.ModelDataList[i].uiData,self.ModelDataList[i]._prefab,self.behaviour, self, i)
        if not self.items then
            self.items = {}
        end
        self.items[i] = WareHouseLuaItem
        --self.items  存的是Lua实例
        self.items[i]:setActiva(isSelect)
    end
end

--创建运输商品
function WareHouseGoodsMgr:_creatTransportGoods(goodsData)
     ct.log("rodger_w8_GameMainInterface","[test_creatTransportGoods]  测试完毕")
     local goods_prefab = self:_creatGoods(WareHouseGoodsMgr.static.TspGoods_PATH,CenterWareHousePanel.tspContent)
     local TransportLuaItem = TransportGoodsItem:new(goodsData,goods_prefab,self.behaviour,self,goodsData.id,goodsData.itemId)
    if not self.allTspItem then
        self.allTspItem = {}
    end
    self.allTspItem[goodsData.id] = TransportLuaItem;
    for i, v in pairs(self.allTspItem) do
        self.allTspItem[i].inputText.onValueChanged:AddListener(function ()
            if self.allTspItem[i].inputText.text =="" then
                return
            end
            self.allTspItem[i].scrollbar.value =  self.allTspItem[i].inputText.text
        end);
    end
    UpdateBeat:Add(self._update, self);
end

--创建通讯录
function WareHouseGoodsMgr:_creatAddressList(insluabehaviour,data)
    self.AddressListIns =insluabehaviour
    self.lastBox =nil;
    for i = 1, 15 do
        local addressList_prefab = self:_creatGoods(WareHouseGoodsMgr.static.AddressList_PATH,ChooseWarehousePanel.leftcontent)
        local AddressListLuaItem = AddressListItem:new(data,addressList_prefab,self.AddressListIns,self)
        if not self.ipaItems then
            self.ipaItems = {}
        end
        self.ipaItems[i] = AddressListLuaItem
    end

end

--创建路线面板
function WareHouseGoodsMgr:_creatLinePanel(data)
    --local line_prefab = self:_creatGoods(WareHouseGoodsMgr.static.Line_PATH,ChooseWarehousePanel.rightContent)


end

--删除商品
function WareHouseGoodsMgr:_deleteGoods(id)
    --清空之前的旧数据
    destroy(self.items[id].prefab.gameObject);
    table.remove(self.ModelDataList, id)
    table.remove(self.items, id)
    local i = 1
    for k,v in pairs(self.items)  do
        self.items[i]:RefreshID(i)
        i = i + 1
    end
end

--删除运输商品
function WareHouseGoodsMgr:_deleteTspGoods(id)
    if UpdateBeat then
        UpdateBeat:Remove(self._update, self);
    end
    self.items[id].select_while:SetActive(true);
    destroy(self.allTspItem[id].prefab.gameObject);
   self.allTspItem[id] = nil;
end

function WareHouseGoodsMgr:_setActiva(isSelect)
    if self.items == nil then
       return
    end
    for i = 1, #self.items do
        self.items[i]:setActiva(isSelect)
    end
end

--生成预制
function WareHouseGoodsMgr:_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return go
end

function WareHouseGoodsMgr:_update()
    for i, v in pairs(self.allTspItem) do
        if self.allTspItem[i].inputText.text =="" then
            return
        end
       -- ct.log("rodger_w8_GameMainInterface","[test__update]  测试完毕",self.allTspItem[i].scrollbar.value)
        self.allTspItem[i].inputText.text =  self.allTspItem[i].scrollbar.value;
    end
end

--通讯录选框
function WareHouseGoodsMgr:SelectBox(go)
    if self.lastBox ~= nil then
        self.lastBox:SetActive(false);
    end
    go.box:SetActive(true);
    self.lastBox = go.box;
end

--清空运输数据
function WareHouseGoodsMgr:ClearAll()
    for i, v in pairs(self.allTspItem) do
        destroy(self.allTspItem[i].prefab.gameObject)
    end
    self.allTspItem = {};
end

--显示所有商品BG,使其都能点击
function WareHouseGoodsMgr:EnabledAll()
    for i = 1, #self.items do
        self.items[i]:Enabled();
    end
end

--显示运输按钮使其可以点击
function WareHouseGoodsMgr:TransportConfirm(isOnClick)
    if CenterWareHousePanel.tspContent.childCount>=1 and isOnClick then
        CenterWareHousePanel.transportConfirm:SetActive(false);
    end
end