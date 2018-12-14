WarehouseCtrl = class('WarehouseCtrl',UIPage);
UIPage:ResgisterOpen(WarehouseCtrl) --注册打开的方法

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
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function WarehouseCtrl:bundleName()
    return "WarehousePanel";
end

function WarehouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
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
    warehouse:AddClick(WarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self)
    warehouse:AddClick(WarehousePanel.shelfConfirmBtn.gameObject,self.OnClick_shelfConfirmBtn,self);

    Event.AddListener("n_shelfAdd",self.n_shelfAdd,self)
    Event.AddListener("n_transports",self.n_transports,self)
    Event.AddListener("c_warehouseClick",self._selectedGoods, self)
    Event.AddListener("c_temporaryifNotGoods",self.c_temporaryifNotGoods, self)

end
function WarehouseCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
end
function WarehouseCtrl:Refresh()
    --初始化物品上架还是运输
    self.operation = nil;

    warehouse = self.gameObject:GetComponent('LuaBehaviour');
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        self.luabehaviour = warehouse
        self.data = {};
        self.data.type = BuildingInType.Warehouse
        self.data.buildingType = self.m_data.buildingType;
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.data)

        local numText = WarehouseCtrl:getWarehouseCapacity(MaterialModel.materialWarehouse);
        WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[MaterialModel.buildingCode].storeCapacity;
        WarehousePanel.Warehouse_Slider.value = numText;
        WarehousePanel.numberText.text = getColorString(WarehousePanel.Warehouse_Slider.value,WarehousePanel.Warehouse_Slider.maxValue,"cyan","white");
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        self.luabehaviour = warehouse
        self.data = {};
        self.data.type = BuildingInType.Warehouse
        self.data.buildingType = self.m_data.buildingType;
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.data)

        local numText = WarehouseCtrl:getWarehouseCapacity(ProcessingModel.processingWarehouse);
        WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[ProcessingModel.buildingCode].storeCapacity;
        WarehousePanel.Warehouse_Slider.value = numText;
        WarehousePanel.numberText.text = getColorString(WarehousePanel.Warehouse_Slider.value,WarehousePanel.Warehouse_Slider.maxValue,"cyan","white");
    end

end
function WarehouseCtrl:OnClick_returnBtn(go)
    go:deleteObjInfo()
    UIPage.ClosePage();
end
--搜索
function WarehouseCtrl:OnClick_searchBtn(ins)

end
--选中物品
function WarehouseCtrl:_selectedGoods(id,itemId)
    if self.temporaryItems[id] == nil then
        self.temporaryItems[id] = id
        if self.operation == ct.goodsState.shelf then
            self.GoodsUnifyMgr:_creatShelfGoods(id,self.luabehaviour,itemId)
        elseif self.operation == ct.goodsState.transport then
            self.GoodsUnifyMgr:_creatTransportGoods(id,self.luabehaviour,itemId)
        end
        self.GoodsUnifyMgr.WarehouseItems[id].circleTickImg.transform.localScale = Vector3.one
    else
        self.temporaryItems[id] = nil;
        self.GoodsUnifyMgr.WarehouseItems[id].circleTickImg.transform.localScale = Vector3.zero
        if self.operation == ct.goodsState.shelf then
            self.GoodsUnifyMgr:_deleteShelfItem(id);
        elseif self.operation == ct.goodsState.transport then
            self.GoodsUnifyMgr:_deleteTransportItem(id);
        end
    end
end
--临时表里是否有这个物品
function WarehouseCtrl:c_temporaryifNotGoods(id)
    self.temporaryItems[id] = nil
    self.GoodsUnifyMgr.WarehouseItems[id].circleTickImg.transform.localScale = Vector3.zero
    if self.operation == ct.goodsState.shelf then
        self.GoodsUnifyMgr:_deleteShelfItem(id);
    elseif self.operation == ct.goodsState.transport then
        self.GoodsUnifyMgr:_deleteTransportItem(id);
    end
end
--获取仓库总数量
function WarehouseCtrl:getWarehouseCapacity(table)
    local warehouseCapacity = 0
    if not table then
        warehouseCapacity = 0
        return warehouseCapacity;
    else
        for k,v in pairs(table) do
            warehouseCapacity = warehouseCapacity + v.n
        end
        return warehouseCapacity
    end
end
--Open shelf
function WarehouseCtrl:OnClick_shelfBtn(go)
    go:OnClick_rightInfo(not switchIsShow,0)
end
--Open transpor
function WarehouseCtrl:OnClick_transportBtn(go)
    go:OnClick_rightInfo(not switchIsShow,1)
end
--名字排序
function WarehouseCtrl:OnClick_OnName(ins)
    WarehousePanel.nowText.text = "By name";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
    local nameType = ct.sortingItemType.Name
    WarehouseCtrl:_getSortItems(nameType,ins.GoodsUnifyMgr.WarehouseItems)
end
--数量排序
function WarehouseCtrl:OnClick_OnNumber(ins)
    WarehousePanel.nowText.text = "By quantity";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
    local quantityType = ct.sortingItemType.Quantity
    WarehouseCtrl:_getSortItems(quantityType,ins.GoodsUnifyMgr.WarehouseItems)
end
--跳转选择仓库界面
function WarehouseCtrl:OnClick_transportopenBtn(ins)
    ct.OpenCtrl("ChooseWarehouseCtrl")
end
--确定上架
function WarehouseCtrl:OnClick_shelfConfirmBtn(go)
    if not go.GoodsUnifyMgr.shelfPanelItem then
        return;
    else
        for i,v in pairs(go.GoodsUnifyMgr.shelfPanelItem) do
            if not MaterialModel.materialShelf then
                Event.Brocast("m_ReqShelfAdd",MaterialModel.buildingId,v.itemId,v.inputNumber.text,v.inputPrice.text)
                return;
            else
                for k,t in pairs(MaterialModel.materialShelf) do
                    if v.itemId == t.k.id and tonumber(v.inputPrice.text) ~= t.price then
                        Event.Brocast("m_ReqModifyShelf",MaterialModel.buildingId,v.itemId,v.inputNumber.text,v.inputPrice.text)
                    end
                end
            end
            Event.Brocast("m_ReqShelfAdd",MaterialModel.buildingId,v.itemId,v.inputNumber.text,v.inputPrice.text)
        end
    end
end
--上架回调执行
function WarehouseCtrl:n_shelfAdd(msg)
    if not msg then
        return;
    end
    for i in pairs(WarehouseCtrl.temporaryItems) do
        Event.Brocast("c_temporaryifNotGoods", i)
    end
end
--确定运输
function WarehouseCtrl:OnClick_transportConfirmBtn(go)
    if not go.GoodsUnifyMgr.transportPanelItem then
        return;
    end
    for i,v in pairs(go.GoodsUnifyMgr.transportPanelItem) do
        Event.Brocast("m_ReqTransport",MaterialModel.buildingId,PlayerTempModel.roleData.bagId,v.itemId,v.inputNumber.text)
    end
end
--运输回调执行
function WarehouseCtrl:n_transports(msg)
    local table = self.GoodsUnifyMgr.WarehouseItems
    for i,v in pairs(table) do
        if v.itemId == msg.item.key.id then
            if v.goodsDataInfo.num == msg.item.n then
                self.GoodsUnifyMgr:_WarehousedeleteGoods(i)
                for i,v in pairs(WarehouseCtrl.temporaryItems) do
                   self.GoodsUnifyMgr:_deleteTransportItem(v)
                end
            else
                v.numberText.text = v.goodsDataInfo.num - msg.item.n;
                v.goodsDataInfo.num = v.numberText.text
                for i in pairs(WarehouseCtrl.temporaryItems) do
                    Event.Brocast("c_temporaryifNotGoods", i)
                end
            end
        end
    end
end
function WarehouseCtrl:OnClick_OnSorting(ins)
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
            self.operation = ct.goodsState.transport;
        end
        if self.GoodsUnifyMgr.WarehouseItems ~= nil then
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
            for i in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", i)
            end
            self.operation = nil;
        end
        if self.GoodsUnifyMgr.WarehouseItems ~= nil then
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
    if not self.GoodsUnifyMgr.WarehouseItems then
        return;
    else
        for i,v in pairs(self.GoodsUnifyMgr.WarehouseItems) do
            v:closeEvent()
            destroy(v.prefab.gameObject);
        end
        self.GoodsUnifyMgr.WarehouseItems = {};
        self.GoodsUnifyMgr.WarehouseModelData = {};
    end
end
