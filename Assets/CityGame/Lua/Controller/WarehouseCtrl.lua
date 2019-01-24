WarehouseCtrl = class('WarehouseCtrl',UIPanel);
UIPanel:ResgisterOpen(WarehouseCtrl) --注册打开的方法

--物品上架还是运输
ct.goodsState =
{
    shelf  = 0,  --上架
    transport = 1,  --运输
}
ct.sortingItemType = {
    Name = 1,      --名字
    Quantity = 2,  --数量
    Level = 3,     --评分
    Score = 4,     --等级
    Price = 5      --价格
}
--存放选中的物品,临时表
WarehouseCtrl.temporaryItems = {}
local isShowList;
local switchIsShow;
local warehouse

function WarehouseCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function WarehouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WarehousePanel.prefab";
end

function WarehouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end
function WarehouseCtrl:Awake(go)
    warehouse = self.gameObject:GetComponent('LuaBehaviour');
    warehouse:AddClick(WarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    warehouse:AddClick(WarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    warehouse:AddClick(WarehousePanel.nameBtn.gameObject,self.OnClick_OnName,self);
    warehouse:AddClick(WarehousePanel.quantityBtn.gameObject,self.OnClick_OnNumber,self);
    warehouse:AddClick(WarehousePanel.shelfBtn.gameObject,self.OnClick_shelfBtn,self);
    warehouse:AddClick(WarehousePanel.shelfCloseBtn.gameObject,self.OnClick_shelfBtn,self)
    warehouse:AddClick(WarehousePanel.transportBtn.gameObject,self.OnClick_transportBtn,self);
    warehouse:AddClick(WarehousePanel.transportCloseBtn.gameObject,self.OnClick_transportBtn,self);
    warehouse:AddClick(WarehousePanel.transportopenBtn.gameObject,self.OnClick_transportopenBtn,self);
    warehouse:AddClick(WarehousePanel.transportConfirmBtn.gameObject,self.OnClick_transportConfirmBtn,self);
    --warehouse:AddClick(WarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self)
    warehouse:AddClick(WarehousePanel.shelfConfirmBtn.gameObject,self.OnClick_shelfConfirmBtn,self);

    --暂时放到Awake
    Event.AddListener("c_temporaryifNotGoods",self.c_temporaryifNotGoods, self)
    --WarehousePanel.nameText.text = GetLanguage(26040002)

    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
    --初始化物品上架还是运输
    self.operation = nil;
end
function WarehouseCtrl:Active()
    UIPanel.Active(self)
    LoadSprite(GetSprite("Warehouse"), WarehousePanel.warehouseImg:GetComponent("Image"), false)
    WarehousePanel.tipText.text = GetLanguage(26040002)
    Event.AddListener("n_shelfAdd",self.n_shelfAdd,self)
    Event.AddListener("n_transports",self.n_transports,self)
    Event.AddListener("c_warehouseClick",self._selectedGoods, self)
    Event.AddListener("warehousedeleteGoods",self.warehousedeleteGoods,self)
end
function WarehouseCtrl:Refresh()
    self.luabehaviour = warehouse
    self.store = self.m_data.store
    self.store.type = BuildingInType.Warehouse
    self.store.buildingId = self.m_data.info.id
    WarehouseCtrl.playerId = self.m_data.info.id
    local warehouseTotalNum = WarehouseCtrl:getWarehouseCapacity(self.m_data.store);
    local warehouseNum = WarehouseCtrl:getWarehouseNum(self.m_data.store);
    WarehousePanel.Locked_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity;
    WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity;
    WarehousePanel.Locked_Slider.value = warehouseTotalNum
    WarehousePanel.Warehouse_Slider.value = warehouseNum;
    WarehousePanel.numberText.text = getColorString(WarehousePanel.Locked_Slider.value,WarehousePanel.Locked_Slider.maxValue,"cyan","white");
    self:isShowDetermineBtn()
    if WarehousePanel.Content.childCount <= 0 then
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.store)
    else
        return
    end
end
function WarehouseCtrl:OnClick_returnBtn(go)
    go:deleteObjInfo()
    PlayMusEff(1002)
    UIPanel.ClosePage()
    if switchIsShow then
        go:OnClick_rightInfo(not switchIsShow,1)
    end
end
function WarehouseCtrl:Hide()
    Event.RemoveListener("n_shelfAdd",self.n_shelfAdd,self)
    Event.RemoveListener("n_transports",self.n_transports,self)
    Event.RemoveListener("c_warehouseClick",self._selectedGoods, self)
    --Event.RemoveListener("c_temporaryifNotGoods",self.c_temporaryifNotGoods, self)
    Event.RemoveListener("warehousedeleteGoods",self.warehousedeleteGoods,self)
    UIPanel.Hide(self)
    return {insId = self.m_data.info.id,self.m_data}
end
----搜索
--function WarehouseCtrl:OnClick_searchBtn(ins)
--
--end
--选中物品
function WarehouseCtrl:_selectedGoods(insData)
    if self.temporaryItems[insData.id] == nil then
        self.temporaryItems[insData.id] = insData.id
        if self.operation == ct.goodsState.shelf then
            self.GoodsUnifyMgr:_creatShelfGoods(insData,self.luabehaviour)
        elseif self.operation == ct.goodsState.transport then
            self.GoodsUnifyMgr:_creatTransportGoods(insData,self.luabehaviour)
            self:isShowDetermineBtn()
        end
        self.GoodsUnifyMgr.warehouseLuaTab[insData.id].circleTickImg.transform.localScale = Vector3.one
    else
        self.temporaryItems[insData.id] = nil;
        self.GoodsUnifyMgr.warehouseLuaTab[insData.id].circleTickImg.transform.localScale = Vector3.zero
        if self.operation == ct.goodsState.shelf then
            self.GoodsUnifyMgr:_deleteShelfItem(insData.id);
        elseif self.operation == ct.goodsState.transport then
            self.GoodsUnifyMgr:_deleteTransportItem(insData.id);
            self:isShowDetermineBtn()
        end
    end
end
--临时表里是否有这个物品
function WarehouseCtrl:c_temporaryifNotGoods(id)
    self.temporaryItems[id] = nil
    self.GoodsUnifyMgr.warehouseLuaTab[id].circleTickImg.transform.localScale = Vector3.zero
    if self.operation == ct.goodsState.shelf then
        self.GoodsUnifyMgr:_deleteShelfItem(id);
    elseif self.operation == ct.goodsState.transport then
        self.GoodsUnifyMgr:_deleteTransportItem(id);
        self:isShowDetermineBtn()
    end
end
--获取仓库总数量
function WarehouseCtrl:getWarehouseCapacity(table)
    local warehouseCapacity = 0  --仓库总容量
    local locked = 0             --仓库里锁着的
    if not table.inHand then
        warehouseCapacity = warehouseCapacity + locked
        return warehouseCapacity;
    else
        for k,v in pairs(table.inHand) do
            warehouseCapacity = warehouseCapacity + v.n
        end
        if not table.locked then
            locked = 0
        else
            for i,t in pairs(table.locked) do
                locked = locked + t.n
            end
        end
        warehouseCapacity = warehouseCapacity + locked
        return warehouseCapacity
    end
end
--获取仓库数量
function WarehouseCtrl:getWarehouseNum(table)
    local warehouseNum = 0
    if not table.inHand then
        return warehouseNum
    else
        for i,v in pairs(table.inHand) do
            warehouseNum = warehouseNum + v.n
        end
        return warehouseNum
    end
end

--Open shelf
function WarehouseCtrl:OnClick_shelfBtn(go)
    PlayMusEff(1002)
    go:OnClick_rightInfo(not switchIsShow,0)
end
--Open transpor
function WarehouseCtrl:OnClick_transportBtn(go)
    PlayMusEff(1002)
    go:OnClick_rightInfo(not switchIsShow,1)
end
--名字排序
function WarehouseCtrl:OnClick_OnName(ins)
    PlayMusEff(1002)
    WarehousePanel.nowText.text = "By name";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
    local nameType = ct.sortingItemType.Name
    WarehouseCtrl:_getSortItems(nameType,ins.GoodsUnifyMgr.WarehouseItems)
end
--数量排序
function WarehouseCtrl:OnClick_OnNumber(ins)
    PlayMusEff(1002)
    WarehousePanel.nowText.text = "By quantity";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
    local quantityType = ct.sortingItemType.Quantity
    WarehouseCtrl:_getSortItems(quantityType,ins.GoodsUnifyMgr.WarehouseItems)
end
--跳转选择仓库界面
function WarehouseCtrl:OnClick_transportopenBtn(go)
    --go:deleteObjInfo()
    PlayMusEff(1002)
    local data = {}
    data.pos = {}
    data.pos.x = go.m_data.info.pos.x
    data.pos.y = go.m_data.info.pos.y
    data.nameText = WarehousePanel.nameText
    data.buildingId = go.m_data.info.id
    ct.OpenCtrl("ChooseWarehouseCtrl",data)
end
--确定上架
function WarehouseCtrl:OnClick_shelfConfirmBtn(go)
    PlayMusEff(1002)
    if not go.GoodsUnifyMgr.shelfPanelItem then
        return;
    else
        for i,v in pairs(go.GoodsUnifyMgr.shelfPanelItem) do
            if not go.m_data.shelf.good then
                Event.Brocast("m_ReqShelfAdd",go.m_data.info.id,v.itemId,v.inputNumber.text,v.inputPrice.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                return;
            else
                for k,t in pairs(go.m_data.shelf.good) do
                    if v.itemId == t.k.id and tonumber(v.inputPrice.text) ~= t.price then
                        Event.Brocast("m_ReqModifyShelf",go.m_data.info.id,v.itemId,v.inputNumber.text,v.inputPrice.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                    end
                end
            end
            Event.Brocast("m_ReqShelfAdd",go.m_data.info.id,v.itemId,v.inputNumber.text,v.inputPrice.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
        end
    end
end
--上架回调执行
function WarehouseCtrl:n_shelfAdd(msg)
    if not msg then
        return;
    end
    local Data = self.GoodsUnifyMgr.warehouseLuaTab
    for i,v in pairs(Data) do
        if v.itemId == msg.item.key.id then
            if v.n == msg.item.n then
                self.GoodsUnifyMgr:_WarehousedeleteGoods(i)
                for i,v in pairs(WarehouseCtrl.temporaryItems) do
                    self.GoodsUnifyMgr:_deleteShelfItem(v)
                    self:isShowDetermineBtn()
                end
            else
                v.numberText.text = v.goodsDataInfo.n - msg.item.n;
                v.goodsDataInfo.n = tonumber(v.numberText.text)
                for i in pairs(WarehouseCtrl.temporaryItems) do
                    Event.Brocast("c_temporaryifNotGoods", i)
                end
            end
        end
    end

end
--确定运输
function WarehouseCtrl:OnClick_transportConfirmBtn(go)
    PlayMusEff(1002)
    if not GoodsUnifyMgr.transportPanelItem then
        return;
    end
    local btransportListing = {}
    btransportListing.currentLocationName = MaterialPanel.nameText.text.."仓库"
    btransportListing.targetLocationName = ChooseWarehouseCtrl:GetName().."仓库"
    local pos = {}
    pos.x = go.m_data.info.pos.x
    pos.y = go.m_data.info.pos.y
    btransportListing.distance = ChooseWarehouseCtrl:GetDistance(pos)
    local number = 0
    for i,v in pairs(GoodsUnifyMgr.transportPanelItem) do
        number = number + v.numberScrollbar.value
    end
    btransportListing.number = number
    btransportListing.freight = number * btransportListing.distance * BagPosInfo[1].postageCost
    btransportListing.total = number * btransportListing.distance * BagPosInfo[1].postageCost
    btransportListing.capacity = ChooseWarehouseCtrl:GetCapacity()
    if number > btransportListing.capacity then
        Event.Brocast("SmallPop","所选建筑仓库容量不足",300)
        return
    end
    btransportListing.btnClick = function ()
        if number == 0 then
            Event.Brocast("SmallPop","运输商品个数不能为0",300)
            return
        else
            for i,v in pairs(GoodsUnifyMgr.transportPanelItem) do
                Event.Brocast("c_Transport",go.m_data.info.id,v.itemId,v.inputNumber.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                --Event.Brocast("m_ReqTransport",go.m_data.info.id,v.itemId,v.inputNumber.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
            end
        end
    end
    ct.OpenCtrl("TransportBoxCtrl",btransportListing);
end
--运输回调执行
function WarehouseCtrl:n_transports(Data)
    local table = self.GoodsUnifyMgr.warehouseLuaTab
    for i,v in pairs(table) do
        if v.itemId == Data.item.key.id then
            if v.goodsDataInfo.n == Data.item.n then
                self.GoodsUnifyMgr:_WarehousedeleteGoods(i)
                for i,v in pairs(WarehouseCtrl.temporaryItems) do
                   self.GoodsUnifyMgr:_deleteTransportItem(v)
                   self:isShowDetermineBtn()
                end
            else
                v.numberText.text = v.goodsDataInfo.n - Data.item.n;
                v.goodsDataInfo.n = tonumber(v.numberText.text)
                for i in pairs(WarehouseCtrl.temporaryItems) do
                    Event.Brocast("c_temporaryifNotGoods", i)
                end
            end
            --WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - Data.item.n;
            WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - Data.item.n;
            --WarehousePanel.numberText.text = getColorString(WarehousePanel.Warehouse_Slider.value,WarehousePanel.Warehouse_Slider.maxValue,"cyan","white");
            WarehousePanel.numberText.text = getColorString(WarehousePanel.Locked_Slider.value,WarehousePanel.Locked_Slider.maxValue,"cyan","white")
        end
    end
end
--删除仓库物品
function WarehouseCtrl:warehousedeleteGoods(msg)
    if not msg then
        return
    end
    --for i,v in pairs(self.warehouseLuaTab) do
    --    if i == id then
    --        v:closeEvent()
    --        destroy(v.prefab.gameObject);
    --        table.remove(self.warehouseLuaTab,id);
    --    end
    --end
    --local i = 1
    --for k,v in pairs(self.warehouseLuaTab) do
    --    self.warehouseLuaTab[i]:RefreshID(i)
    --    i = i + 1
    --end
end
--刷新运输确定按钮
function WarehouseCtrl:isShowDetermineBtn()
    if not self.GoodsUnifyMgr then
        return
    end
    if not self.GoodsUnifyMgr.transportPanelItem then
        return
    end
    local num = 0
    for i,v in pairs(self.GoodsUnifyMgr.transportPanelItem) do
        num = num + i
    end
    if num ~= 0 and WarehousePanel.nameText.text ~= nil then
        WarehousePanel.transportConfirmBtn.localScale = Vector3.one
        WarehousePanel.transportUncheckBtn.localScale = Vector3.zero
    else
        WarehousePanel.transportConfirmBtn.localScale = Vector3.zero
        WarehousePanel.transportUncheckBtn.localScale = Vector3.one
    end
end
function WarehouseCtrl:OnClick_OnSorting(ins)
    PlayMusEff(1002)
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end
--打开排序
function WarehouseCtrl:OnClick_OpenList(isShow)
    if isShow then
        WarehousePanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        WarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        WarehousePanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        WarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end
--判断右侧是货架还是运输
function WarehouseCtrl:OnClick_rightInfo(isShow,number)
    if isShow then
        WarehousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        if number == 0 then
            WarehousePanel.shelf:SetActive(true);
            self.operation = ct.goodsState.shelf;
        else
            WarehousePanel.transport:SetActive(true);
            --WarehousePanel.nameText.text = "请选择仓库"
            --WarehousePanel.transportUncheckBtn.localScale = Vector3.one
            --WarehousePanel.transportConfirmBtn.localScale = Vector3.zero
            self:isShowDetermineBtn()
            self.operation = ct.goodsState.transport;
        end
        if self.GoodsUnifyMgr.warehouseLuaTab ~= nil then
            Event.Brocast("c_GoodsItemChoose")
        end
        WarehousePanel.Content.offsetMax = Vector2.New(-810,0);
    else
        WarehousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        if number == 0 then
            WarehousePanel.shelf:SetActive(false);
            for i in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", i)
            end
            self.operation = nil;
        else
            WarehousePanel.transport:SetActive(false);
            WarehousePanel.nameText.text = ""
            for i in pairs(WarehouseCtrl.temporaryItems) do
                self:c_temporaryifNotGoods(i)
            end
            self.operation = nil;
        end
        if self.GoodsUnifyMgr.warehouseLuaTab ~= nil then
            --for i,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
            --    v:c_GoodsItemDelete()
            --end
            Event.Brocast("c_GoodsItemDelete")
        end
        WarehousePanel.Content.offsetMax = Vector2.New(0,0);
    end
    switchIsShow = isShow;
end
--排序
function WarehouseCtrl:_getSortItems(type,sortingTable)
    if type == ct.sortingItemType.Name then
        table.sort(sortingTable, function (m, n) return m.name < n.name end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(WarehousePanel.ScrollView.transform);
            v.prefab.gameObject.transform:SetParent(WarehousePanel.Content.transform);
            v.id = i
            WarehouseItem:RefreshData(v.goodsDataInfo,i)
        end
    end
    if type == ct.sortingItemType.Quantity then
        table.sort(sortingTable, function (m, n) return m.n < n.n end )
        for i, v in ipairs(sortingTable) do
            v.prefab.gameObject.transform:SetParent(WarehousePanel.ScrollView.transform);
            v.prefab.gameObject.transform:SetParent(WarehousePanel.Content.transform);
            v.id = i
            WarehouseItem:RefreshData(v.goodsDataInfo,i)
        end
    end
end

--关闭面板时清空UI信息，以备其他模块调用
function WarehouseCtrl:deleteObjInfo()
    if not self.GoodsUnifyMgr.warehouseLuaTab then
        return;
    else
        for i,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
            v:closeEvent();
            destroy(v.prefab.gameObject);
        end
    end
end
