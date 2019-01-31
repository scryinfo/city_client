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
    Event.AddListener("deleteObjeCallback",self.deleteObjeCallback,self)
    Event.AddListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
end
function WarehouseCtrl:Refresh()
    self.luabehaviour = warehouse
    self.store = self.m_data.store
    self.store.type = BuildingInType.Warehouse
    self.store.buildingId = self.m_data.info.id
    WarehouseCtrl.playerId = self.m_data.info.id
    self.mId = self.m_data.info.mId
    self.warehouseTotalNum = WarehouseCtrl:getWarehouseCapacity(self.m_data.store);
    self.warehouseNum = WarehouseCtrl:getWarehouseNum(self.m_data.store);
    self.lockedNum = WarehouseCtrl:getLockedNum(self.m_data.store)
    WarehousePanel.Locked_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity;
    WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].storeCapacity;
    WarehousePanel.Locked_Slider.value = self.warehouseTotalNum
    WarehousePanel.Warehouse_Slider.value = self.warehouseNum;
    local numTab = {}
    numTab["num1"] = self.warehouseNum
    numTab["num2"] = WarehousePanel.Locked_Slider.maxValue
    numTab["num3"] = self.lockedNum
    numTab["col1"] = "Cyan"
    numTab["col2"] = "white"
    numTab["col3"] = "Teal"
    WarehousePanel.numberText.text = getColorString(numTab);
    self:isShowDetermineBtn()
    if WarehousePanel.Content.childCount <= 0 then
        self.GoodsUnifyMgr = GoodsUnifyMgr:new(self.luabehaviour, self.store)
    else
        return
    end
    if self.m_data.shelfOpen ~= nil then
        self:OnClick_rightInfo(not switchIsShow,0)
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
    Event.RemoveListener("deleteObjeCallback",self.deleteObjeCallback,self)
    Event.RemoveListener("deleteWarehouseItem",self.deleteWarehouseItem,self)
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
--获取锁着的数量
function WarehouseCtrl:getLockedNum(table)
    local lockedNum = 0
    if not table.inHand then
        return lockedNum
    end
    if not table.locked then
        return lockedNum
    end
    for i,v in pairs(table.locked) do
        lockedNum = lockedNum + v.n
    end
    return lockedNum
end

--Open shelf
function WarehouseCtrl:OnClick_shelfBtn(go)
    PlayMusEff(1002)
    if go.m_data.info.state == "OPERATE" then
        go:OnClick_rightInfo(not switchIsShow,0)
    else
        Event.Brocast("SmallPop","建筑尚未开业",300)
    end
end
--Open transpor
function WarehouseCtrl:OnClick_transportBtn(go)
    PlayMusEff(1002)
    if go.m_data.info.state == "OPERATE" then
        go:OnClick_rightInfo(not switchIsShow,1)
    else
        Event.Brocast("SmallPop","建筑尚未开业",300)
    end
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
function WarehouseCtrl.isValidShelfOp(go, v)
    local materialKey,goodsKey = 21,22 --道具类型
    local material,processing,retailStores = 11,12,13--建筑类型
    if GetServerPriceNumber(v.inputPrice.text) == 0 then
        return false
    end
    if v.inputNumber.text == "0" and v.inputNumber.text == "" then
        return false
    end

    if math.floor(go.mId / 100000) == material then
        if math.floor(v.itemId / 100000) ~= materialKey then
            return false
        end
    end

    if math.floor(go.mId / 100000) == processing then
        if math.floor(v.itemId / 100000) ~= goodsKey then
            return false
        end
    end

    if math.floor(go.mId / 100000) == retailStores then
        if math.floor(v.itemId / 100000) ~= goodsKey then
            return false
        end
    end
    return true
end
function WarehouseCtrl:OnClick_shelfConfirmBtn(go)
    PlayMusEff(1002)
    local noMatch ={}

    if not go.GoodsUnifyMgr.shelfPanelItem then
        return;
    else
        --shelfPanelItem 将要上架的道具列表
        for i,v in pairs(go.GoodsUnifyMgr.shelfPanelItem) do
            --local isvalidOp = true
            if not go.m_data.shelf.good then --未上架
                if WarehouseCtrl.isValidShelfOp(go,v) == true then
                    Event.Brocast("m_ReqShelfAdd",go.m_data.info.id,v.itemId,v.inputNumber.text,GetServerPriceNumber(v.inputPrice.text),v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                else
                    noMatch[#noMatch+1] = v
                end
            else
                --已上架
                for k,t in pairs(go.m_data.shelf.good) do
                    if v.itemId == t.k.id then
                        if WarehouseCtrl.isValidShelfOp(go,v) == true then
                            Event.Brocast("m_ReqModifyShelf",go.m_data.info.id,v.itemId,v.inputNumber.text,GetServerPriceNumber(v.inputPrice.text),v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                        else
                            noMatch[#noMatch+1] = v
                        end
                    end
                end
                if WarehouseCtrl.isValidShelfOp(go,v) == true then
                    Event.Brocast("m_ReqShelfAdd",go.m_data.info.id,v.itemId,v.inputNumber.text,GetServerPriceNumber(v.inputPrice.text),v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
                else
                    noMatch[#noMatch+1] = v
                end
            end
        end
    end
    if #noMatch > 0 then
        local noMatchstr = ''
        for i, v in pairs(noMatch) do
            noMatchstr = noMatchstr..","..v.itemId
        end
        Event.Brocast("SmallPop",noMatchstr.."等道具类型不符",300)
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
    if msg.item.key.producerId == nil and msg.item.key.qty == nil then
        if not self.m_data.shelf.good then
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good[#good + 1] = data
            self.m_data.shelf.good = good
        else
            for i,v in pairs(self.m_data.shelf.good) do
                if v.k.id == msg.item.key.id then
                    v.n = v.n + msg.item.n
                    v.price = msg.price
                    return
                end
            end
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good = data
            self.m_data.shelf.good[#self.m_data.shelf.good + 1] = good
        end
    else
        if not self.m_data.shelf.good then
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            k.producerId = msg.item.key.producerId
            k.qty = msg.item.key.qty
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good[#good + 1] = data
            self.m_data.shelf.good = good
        else
            for i,v in pairs(self.m_data.shelf.good) do
                if v.k.id == msg.item.key.id then
                    v.n = v.n + msg.item.n
                    v.price = msg.price
                    return
                end
            end
            local good = {}
            local data = {}
            local k = {}
            k.id = msg.item.key.id
            data.k = k
            data.n = msg.item.n
            data.price = msg.price
            good = data
            self.m_data.shelf.good[#self.m_data.shelf.good + 1] = good
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
    btransportListing.currentLocationName = go.m_data.info.name.."仓库"
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
    btransportListing.price = ChooseWarehouseCtrl:GetPrice()
    btransportListing.freight = GetClientPriceString(number * btransportListing.price)
    btransportListing.total = GetClientPriceString(number * btransportListing.price)
    btransportListing.capacity = ChooseWarehouseCtrl:GetCapacity()
    if number > btransportListing.capacity then
        Event.Brocast("SmallPop",GetLanguage(26040012),300)
        return
    end
    btransportListing.btnClick = function ()
        if number == 0 then
            Event.Brocast("SmallPop",GetLanguage(27020004),300)
            return
        else
            for i,v in pairs(GoodsUnifyMgr.transportPanelItem) do
                Event.Brocast("c_Transport",go.m_data.info.id,v.itemId,v.inputNumber.text,v.goodsDataInfo.key.producerId,v.goodsDataInfo.key.qty)
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
            WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - Data.item.n;
            local lockedNum = WarehouseCtrl:getLockedNum(self.m_data.store)
            local numTab = {}
            numTab["num1"] = WarehousePanel.Locked_Slider.value
            numTab["num2"] = WarehousePanel.Locked_Slider.maxValue
            numTab["num3"] = lockedNum
            numTab["col1"] = "Cyan"
            numTab["col2"] = "white"
            numTab["col3"] = "Teal"
            WarehousePanel.numberText.text = getColorString(numTab)
        end
    end
end
--点击删除物品
function WarehouseCtrl:deleteWarehouseItem(ins)
    local data = {}
    data.titleInfo = GetLanguage(30030001)
    data.contentInfo = GetLanguage(35030004)
    data.tipInfo = GetLanguage(30030002)
    data.btnCallBack = function ()
        local dataId = {}
        dataId.buildingId = self.m_data.insId
        dataId.id = ins.itemId
        Event.Brocast("mReqDelItem",ins.buildingId,ins.itemId,ins.producerId,ins.qty)
    end
    ct.OpenCtrl('ErrorBtnDialogPageCtrl',data)
end
--删除仓库物品回调
function WarehouseCtrl:deleteObjeCallback(msg)
    if not msg then
        return
    end
    for i,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
        if msg.item.id == v.itemId then
            v:closeEvent()
            WarehousePanel.Locked_Slider.value = WarehousePanel.Locked_Slider.value - v.n
            WarehousePanel.Warehouse_Slider.value = WarehousePanel.Warehouse_Slider.value - v.n
            local numTab = {}
            numTab["num1"] = WarehousePanel.Warehouse_Slider.value
            numTab["num2"] = WarehousePanel.Locked_Slider.maxValue
            numTab["num3"] = self.lockedNum
            numTab["col1"] = "Cyan"
            numTab["col2"] = "white"
            numTab["col3"] = "Teal"
            WarehousePanel.numberText.text = getColorString(numTab);
            destroy(v.prefab.gameObject);
            table.remove(self.GoodsUnifyMgr.warehouseLuaTab,i);
            Event.Brocast("SmallPop",GetLanguage(30030003),300)
        end
    end
    local i = 1
    for k,v in pairs(self.GoodsUnifyMgr.warehouseLuaTab) do
        self.GoodsUnifyMgr.warehouseLuaTab[i]:RefreshID(i)
        i = i + 1
    end
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
