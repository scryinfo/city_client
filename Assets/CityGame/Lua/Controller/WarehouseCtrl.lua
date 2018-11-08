WarehouseCtrl = class('WarehouseCtrl',UIPage);

--物品上架还是运输
ct.GoodsState =
{
    shelf  = 0,  --上架
    transport = 1,  --运输
}

--存放选中的物品,临时表
WarehouseCtrl.temporaryItems = {}
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

end

function WarehouseCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--搜索
function WarehouseCtrl:OnClick_searchBtn(ins)

end

--选中物品
function WarehouseCtrl:_selectedGoods(id)
    if self.temporaryItems[id] == nil then
        self.temporaryItems[id] = id
        if self.operation == ct.GoodsState.shelf then
            self.ShelfGoodsMgr:_creatShelfGoods(id,self.luabehaviour)
        elseif self.operation == ct.GoodsState.transport then
            self.ShelfGoodsMgr:_creatTransportGoods(id,self.luabehaviour)
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

--右边Shelf
function WarehouseCtrl:OnClick_shelfBtn(ins)
    WarehouseCtrl:OnClick_rightInfo(not switchIsShow,0)
end
--右边Transpor
function WarehouseCtrl:OnClick_transportBtn(ins)
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
    UIPage:ShowPage(ChooseWarehouseCtrl);
end
--确定上架
function WarehouseCtrl:OnClick_shelfConfirmBtn()

end
--确定运输
function WarehouseCtrl:OnClick_transportConfirmBtn()
    UIPage:ShowPage(TransportBoxCtrl);
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
            for k in pairs(WarehouseCtrl.temporaryItems) do
                Event.Brocast("c_temporaryifNotGoods", k)
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