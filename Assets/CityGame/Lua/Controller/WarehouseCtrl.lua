WarehouseCtrl = class('WarehouseCtrl',UIPage);
UIPage:ResgisterOpen(WarehouseCtrl) --注册打开的方法

--物品上架还是运输
ct.GoodsState =
{
    shelf  = 0,  --上架
    transport = 1,  --运输
}

--存放选中的物品,临时表
WarehouseCtrl.temporaryItems = {}
local temporaryInfo = {}  --临时储存选中goods的信息
local isShowList;
local switchIsShow;

function WarehouseCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function WarehouseCtrl:bundleName()
    return "WarehousePanel";
end

function WarehouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local warehouse = self.gameObject:GetComponent('LuaBehaviour');
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

    --初始化物品上架还是运输
    self.operation = nil;

    Event.AddListener("c_temporaryifNotGoods",self.c_temporaryifNotGoods, self)
    Event.AddListener("c_warehouseClick",self._selectedGoods, self)
    Event.AddListener("n_transports",self.n_transports,self)

    self.luabehaviour = warehouse
    self.m_data = {};
    self.m_data.buildingType = BuildingInType.Warehouse;
    self.ShelfGoodsMgr = ShelfGoodsMgr:new(self.luabehaviour, self.m_data)

end

function WarehouseCtrl:Awake(go)
    self.gameObject = go
    isShowList = false;
    switchIsShow = false;
end

function WarehouseCtrl:Refresh()
    local itemId = PlayerTempModel.roleData.buys.materialFactory[1].info.mId
    WarehousePanel.Warehouse_Slider.value = WarehouseCtrl:getNumber(MaterialModel.MaterialWarehouse);
    WarehousePanel.Warehouse_Slider.maxValue = PlayerBuildingBaseData[itemId].storeCapacity;
    WarehousePanel.numberText.text = WarehousePanel.Warehouse_Slider.value.."/<color=white>"..WarehousePanel.Warehouse_Slider.maxValue.."</color>"

end

function WarehouseCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--搜索
function WarehouseCtrl:OnClick_searchBtn(ins)

end

--选中物品
function WarehouseCtrl:_selectedGoods(id,itemId)
    if self.temporaryItems[id] == nil then
        self.temporaryItems[id] = id
        if self.operation == ct.GoodsState.shelf then
            self.ShelfGoodsMgr:_creatShelfGoods(id,self.luabehaviour,itemId)
        elseif self.operation == ct.GoodsState.transport then
            self.ShelfGoodsMgr:_creatTransportGoods(id,self.luabehaviour,itemId)
        end
        self.ShelfGoodsMgr.WarehouseItems[id].circleTickImg.transform.localScale = Vector3.one
    else
        self.temporaryItems[id] = nil;
        self.ShelfGoodsMgr.WarehouseItems[id].circleTickImg.transform.localScale = Vector3.zero
        if self.operation == ct.GoodsState.shelf then
            self.ShelfGoodsMgr:_deleteShelfItem(id);
        elseif self.operation == ct.GoodsState.transport then
            self.ShelfGoodsMgr:_deleteTransportItem(id);
        end
    end
end
--监听临时表里是否有这个物品
function WarehouseCtrl:c_temporaryifNotGoods(id)
    self.temporaryItems[id] = nil
    self.ShelfGoodsMgr.WarehouseItems[id].circleTickImg.transform.localScale = Vector3.zero
    if self.operation == ct.GoodsState.shelf then
        self.ShelfGoodsMgr:_deleteShelfItem(id);
    elseif self.operation == ct.GoodsState.transport then
        self.ShelfGoodsMgr:_deleteTransportItem(id);
    end
end
--获取仓库总数量
function WarehouseCtrl:getNumber(table)
    local number = 0
    if not table then
        return 0
    else
        for k,v in pairs(table) do
            number = number + v.n
        end
    end
    return number
end

--右边Shelf
function WarehouseCtrl:OnClick_shelfBtn()
    WarehouseCtrl:OnClick_rightInfo(not switchIsShow,0)
end
--右边Transpor
function WarehouseCtrl:OnClick_transportBtn()
    WarehouseCtrl:OnClick_rightInfo(not switchIsShow,1)
end

--根据名字排序
function WarehouseCtrl:OnClick_OnName(ins)
    WarehousePanel.nowText.text = "By name";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据数量排序
function WarehouseCtrl:OnClick_OnNumber(ins)
    WarehousePanel.nowText.text = "By quantity";
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end
--跳转选择仓库界面
function WarehouseCtrl:OnClick_transportopenBtn(ins)
    --UIPage:ShowPage(ChooseWarehouseCtrl);
    ct.OpenCtrl("ChooseWarehouseCtrl")
end
--确定上架
function WarehouseCtrl:OnClick_shelfConfirmBtn(go)
    local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    if not go.ShelfGoodsMgr.shelfPanelItem then
        return;
    else
        for i,v in pairs(go.ShelfGoodsMgr.shelfPanelItem) do
            if not MaterialModel.MaterialShelf then
                Event.Brocast("m_ReqShelfAdd",buildingId,v.itemId,v.inputNumber.text,v.inputPrice.text)
                return;
            else
                for k,t in pairs(MaterialModel.MaterialShelf) do
                    if v.itemId == t.k.id and tonumber(v.inputPrice.text) ~= t.price then
                        Event.Brocast("m_ReqModifyShelf",buildingId,v.itemId,v.inputNumber.text,v.inputPrice.text)
                    end
                end
            end
            Event.Brocast("m_ReqShelfAdd",buildingId,v.itemId,v.inputNumber.text,v.inputPrice.text)
        end
    end
end
--确定运输
function WarehouseCtrl:OnClick_transportConfirmBtn(go)
    local buildingId = PlayerTempModel.roleData.buys.materialFactory[1].info.id
    if not go.ShelfGoodsMgr.transportPanelItem then
        return;
    end
    for i,v in pairs(go.ShelfGoodsMgr.transportPanelItem) do
        Event.Brocast("m_ReqTransport",buildingId,PlayerTempModel.roleData.bagId,v.itemId,v.inputNumber.text)
    end
end
--运输回调后执行操作
function WarehouseCtrl:n_transports(msg)
    local table = self.ShelfGoodsMgr.WarehouseItems
    for i,v in pairs(table) do
        if v.itemId == msg.item.key.id then
            if v.goodsDataInfo.num == msg.item.n then
                self.ShelfGoodsMgr:_WarehousedeleteGoods(i)
            else
                v.numberText.text = v.goodsDataInfo.num - msg.item.n;
                v.goodsDataInfo.num = v.numberText.text
            end
            for i in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", i)
            end
        end
    end
end


function WarehouseCtrl:OnClick_OnSorting(ins)
    WarehouseCtrl:OnClick_OpenList(not isShowList);
end
--打开排序列表
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
--判断打开右侧货架还是运输
function WarehouseCtrl:OnClick_rightInfo(isShow,number)
    if isShow then
        WarehousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        if number == 0 then
            WarehousePanel.shelf:SetActive(true);
            self.operation = ct.GoodsState.shelf;
            Event.Brocast("c_GoodsItemChoose")
        else
            WarehousePanel.transport:SetActive(true);
            self.operation = ct.GoodsState.transport;
            Event.Brocast("c_GoodsItemChoose")
        end
        WarehousePanel.Content.offsetMax = Vector2.New(-810,0);
    else
        WarehousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        if number == 0 then
            WarehousePanel.shelf:SetActive(false);
            Event.Brocast("c_GoodsItemDelete")
            for i in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", i)
            end
            self.operation = nil;
        else
            WarehousePanel.transport:SetActive(false);
            Event.Brocast("c_GoodsItemDelete")
            for i in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", i)
            end
            self.operation = nil;
        end
        WarehousePanel.Content.offsetMax = Vector2.New(0,0);
    end
    switchIsShow = isShow;
end