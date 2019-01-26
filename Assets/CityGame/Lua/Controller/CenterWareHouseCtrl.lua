---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 11:11
---中心仓库
--排序type
CenterWareHouseSortItemType = {
    Name = 1,      --名字
    Quantity = 2,  --数量
    Level = 3,     --评分
    Score = 4      --等级
}
local isShowList;
local switchIsShow;
local isSelect;
local itemId = {}
local centerWareHousetBehaviour
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)

local class = require 'Framework/class'
CenterWareHouseCtrl = class('CenterWareHouseCtrl',UIPanel)
UIPanel:ResgisterOpen(CenterWareHouseCtrl) --注册打开的方法

function  CenterWareHouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CenterWareHousePanel.prefab"
end

function CenterWareHouseCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function CenterWareHouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function CenterWareHouseCtrl:Awake()
    centerWareHousetBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    isShowList = false;
    switchIsShow = false;

    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.backBtn,self.c_OnBackBtn,self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.addBtn,self.c_OnAddBtn,self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportBtn,self.c_TransportBtn,self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportCloseBtn,self.c_transportCloseBtn,self)
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportConfirmBtn,self.c_transportConfirmBtn,self)
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportopenBtn,self.c_transportopenBtn,self)

    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.arrowBtn.gameObject,self.OnClick_OnSorting, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.nameBtn,self.OnClick_OnName, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.quantityBtn,self.OnClick_OnNumber, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.levelBtn,self.OnClick_OnlevelBtn, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.scoreBtn,self.OnClick_OnscoreBtn, self);

    CenterWareHousePanel.tipText.text = 0
    isSelect = true;
    self. WareHouseGoodsMgr = WareHouseGoodsMgr:new()
    self.insId = OpenModelInsID.CenterWareHouseCtrl
    self.totalCapacity = self.m_data.bagCapacity;--仓库总容量
end

function CenterWareHouseCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_GsExtendBag",self.c_GsExtendBag,self);
    Event.AddListener("c_OnDelete",self.c_OnDelete,self);
    Event.AddListener("c_OnBGItem",self.c_OnBGItem,self);
    Event.AddListener("c_OnTransportBG",self.c_OnTransportBG,self);
    Event.AddListener("c_OnxBtn",self.c_OnxBtn,self);
    Event.AddListener("c_transport",self.c_transport,self);
    Event.AddListener("c_DelItem",self.c_DelItem,self);
    --Event.AddListener("c_DeleteItem",self.c_DeleteItem,self);

    CenterWareHousePanel.tip.text = GetLanguage(21020001)
    CenterWareHousePanel.warehouseNameText.text = GetLanguage(21020002)

    LoadSprite(GetSprite("CenterWareHouse"), CenterWareHousePanel.centrel, false)
end

function CenterWareHouseCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_GsExtendBag",self.c_GsExtendBag,self);
    Event.RemoveListener("c_OnDelete",self.c_OnDelete,self);
    Event.RemoveListener("c_OnBGItem",self.c_OnBGItem,self);
    Event.RemoveListener("c_OnTransportBG",self.c_OnTransportBG,self);
    Event.RemoveListener("c_OnxBtn",self.c_OnxBtn,self);
    Event.RemoveListener("c_transport",self.c_transport,self);
    Event.RemoveListener("c_DelItem",self.c_DelItem,self);
    --Event.RemoveListener("c_DeleteItem",self.c_DeleteItem,self);

end

--初始化
function CenterWareHouseCtrl:_initData()
    CenterWareHousePanel.number:GetComponent("Text").text = getColorString(self.number,self.totalCapacity,"cyan","white");
    CenterWareHousePanel.slider:GetComponent("Slider").maxValue = self.totalCapacity;
    CenterWareHousePanel.slider:GetComponent("Slider").value = self.number;
    CenterWareHousePanel.money:GetComponent("Text").text = self.money;
end

--点击删除物品
function CenterWareHouseCtrl:c_OnDelete(go)
    local buildingId = DataManager.GetBagId()
    local data = {}
    data.titleInfo = "提示"
    data.contentInfo = "确认销毁吗"
    data.tipInfo = "物品将永久消失"
    data.btnCallBack = function ()
        local dataId = {}
        dataId.buildingId = buildingId
        dataId.id = go.itemId
        DataManager.DetailModelRpcNoRet(self.insId , 'm_DeleteItem',dataId)
        go.manager:_deleteGoods(go.id)
    end
    ct.OpenCtrl('BtnDialogPageCtrl',data)
end

----删除物品回调
--function CenterWareHouseCtrl:c_DeleteItem(go)
--    go.manager:_deleteGoods(go.id)
--end
--删除物品回调
function CenterWareHouseCtrl:c_DelItem()
    local n = 0
    for i, v in pairs(WareHouseGoodsMgr.items) do
        n = n + v.n
    end
    self.number = n
    CenterWareHousePanel.number:GetComponent("Text").text = getColorString(self.number,self.totalCapacity,"cyan","white");
end

--点击BG
function CenterWareHouseCtrl:c_OnBGItem()
    local data = {}
    data.madeBy = "来自Rodger公司"
    data.playerName = " rodger"
    ct.OpenCtrl('MessageTooltipCtrl',data)
end

--点击运输后的BG
function CenterWareHouseCtrl:c_OnTransportBG(go)
    if itemId[go.id] == nil then
        itemId[go.id] = go.id
        local goodsDataInfo = {};
        goodsDataInfo.name =  go.goodsDataInfo.name;
        goodsDataInfo.number = go.goodsDataInfo.number;
        goodsDataInfo.id = go.id;
        goodsDataInfo.itemId = go.itemId
        goodsDataInfo.producerId = go.producerId
        goodsDataInfo.qty = go.qty
        go.manager:_creatTransportGoods(goodsDataInfo);
        go.select_while:SetActive(false);
    else
        go.manager:_deleteTspGoods(go.id);
        itemId[go.id] = nil
    end
end

--点击删除运输物品
function CenterWareHouseCtrl:c_OnxBtn(go)
    go.manager:_deleteTspGoods(go.id);
    itemId[go.id] = nil
    local n = 0
    for i, v in pairs(self. WareHouseGoodsMgr.allTspItem) do
        n = n + tonumber(v.inputText.text)
    end
    CenterWareHousePanel.tipText.text = n
end

--返回按钮
function CenterWareHouseCtrl:c_OnBackBtn()
    --清空内容
    if not isSelect then
        CenterWareHouseCtrl:c_transportCloseBtn()
    end
    WareHouseGoodsMgr:ClearAllItem()
    UIPanel.ClosePage();
end

function CenterWareHouseCtrl:Refresh()
    if self.m_data == nil then
        return
    end
    self.number = 0;--商品个数
    local inHand = DataManager.GetBagInfo()
    if inHand ~= nil then
        for i, v in pairs(inHand) do
            self.number =  self.number + tonumber(v.n)
        end
    end
    self.money = 1000;--扩容所需金额
    if WareHouseGoodsMgr.items == nil then
        WareHouseGoodsMgr:_creatItemGoods(centerWareHousetBehaviour,isSelect);
    end
    self:_initData();
    self:initInsData()
    --CenterWareHousePanel.tipText.text = 0
end

function CenterWareHouseCtrl:initInsData()
    DataManager.OpenDetailModel(CenterWareHouseModel,self.insId )
end

--扩容按钮
function CenterWareHouseCtrl:c_OnAddBtn(go)
    local money = DataManager.GetMoney()
    if money<go.money then
        Event.Brocast("SmallPop","扩容金额不足",300)
    else
        DataManager.DetailModelRpcNoRet(go.insId , 'm_ExtendBag')
    end
end

function CenterWareHouseCtrl:c_GsExtendBag()
    self.totalCapacity = self.totalCapacity+100
    self.money = self.money*2;
    self:_initData();
end

--运输按钮
function CenterWareHouseCtrl:c_TransportBtn(go)
    CenterWareHousePanel.addItem:SetActive(false);
    isSelect = false;
    WareHouseGoodsMgr:_setActiva(isSelect)
    CenterWareHouseCtrl:OnClick_transportBtn(not switchIsShow);
end

--选择仓库按钮
function CenterWareHouseCtrl:c_transportopenBtn()
    local data = {}
    data.pos = {}
    data.pos.x = BagPosInfo[1].bagX
    data.pos.y =BagPosInfo[1].bagY
    data.nameText = CenterWareHousePanel.nameText
    data.buildingId = DataManager.GetBagId()
    ct.OpenCtrl('ChooseWarehouseCtrl',data);
end

--开始运输按钮
function CenterWareHouseCtrl:c_transportConfirmBtn(go)
    local data = {}
    data.currentLocationName = GetLanguage(21010001)--起始地址
    data.targetLocationName =ChooseWarehouseCtrl:GetName()--目标地址
    local pos ={}
    pos.x = BagPosInfo[1].bagX
    pos.y = BagPosInfo[1].bagY
    data.distance = ChooseWarehouseCtrl:GetDistance(pos)--距离
    local n = 0
    for i, v in pairs(WareHouseGoodsMgr.allTspItem) do
        n = n + v.inputText.text
    end
    data.number = n--数量
    data.price = ChooseWarehouseCtrl:GetPrice() --运输单价
    data.freight = GetClientPriceString(n*data.price)--运费
    data.total =  GetClientPriceString(n*data.price)--总运费
    data.capacity = ChooseWarehouseCtrl:GetCapacity()   --所选仓库容量
    if data.capacity < tonumber(CenterWareHousePanel.tipText.text) then
        Event.Brocast("SmallPop","所选建筑仓库容量不足",300)
        return
    end
    data.btnClick = function()
        for i, v in pairs(WareHouseGoodsMgr.allTspItem) do
            if v.inputText.text == "0" then
                Event.Brocast("SmallPop","运输商品个数不能为0",300)
                return
            end
        end
        for i, v in pairs(WareHouseGoodsMgr.allTspItem) do
                local bagId = DataManager.GetBagId()
                Event.Brocast("c_Transport", bagId,v.itemId,v.inputText.text,v.goodsDataInfo.producerId,v.goodsDataInfo.qty)
        end
        CenterWareHouseCtrl:clearAllData()
    end
    ct.OpenCtrl('TransportBoxCtrl',data)
end

--开始运输回调
function CenterWareHouseCtrl:c_transport(msg)
    local table = self.WareHouseGoodsMgr.items
    self.number = self.number - msg.item.n;
    self:_initData()
    for i,v in pairs(table) do
        if v.itemId == msg.item.key.id then
            if v.goodsDataInfo.number == msg.item.n then
                WareHouseGoodsMgr:_deleteGoods(i)
            else
                v.numberText.text = v.goodsDataInfo.number - msg.item.n;
                v.goodsDataInfo.number = v.numberText.text;
            end
        end
    end
    --local data = {}
    --data.titleInfo = "提示"
    --data.contentInfo = "商品开始运输"
    --data.tipInfo = "可在运输线查看详情"
    --ct.OpenCtrl('BtnDialogPageCtrl',data)
    CenterWareHousePanel.transportConfirm:SetActive(true);
    Event.Brocast("SmallPop",GetLanguage(21040003),300)
end

--关闭运输按钮
function CenterWareHouseCtrl:c_transportCloseBtn()
    --CenterWareHousePanel.addItem:SetActive(true);
    isSelect = true;
    WareHouseGoodsMgr:_setActiva(isSelect)
    CenterWareHouseCtrl:OnClick_transportBtn(not switchIsShow);
    CenterWareHouseCtrl:clearAllData()
end

function CenterWareHouseCtrl.OnClick_OnSorting(go)
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end

--根据名字排序
function CenterWareHouseCtrl.OnClick_OnName(go)
    CenterWareHousePanel.nowText.text = "By name";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
    local type = CenterWareHouseSortItemType.Name
    CenterWareHouseCtrl:_getSortItems(type)
end
--根据数量排序
function CenterWareHouseCtrl.OnClick_OnNumber(go)
    CenterWareHousePanel.nowText.text = "By quantity";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
    CenterWareHouseCtrl:_getSortItems(CenterWareHouseSortItemType.Quantity)
end
--根据水平排序
function CenterWareHouseCtrl.OnClick_OnlevelBtn(go)
    CenterWareHousePanel.nowText.text = "By level";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end
--根据分数排序
function CenterWareHouseCtrl.OnClick_OnscoreBtn(go)
    CenterWareHousePanel.nowText.text = "By score";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end
function CenterWareHouseCtrl.OnClick_OpenList(isShow)
    if isShow then
        --ShelfPanel.list:SetActive(true);
        CenterWareHousePanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        --ShelfPanel.list:SetActive(false);
        CenterWareHousePanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

--打开运输面板
function CenterWareHouseCtrl:OnClick_transportBtn(isShow)
    if isShow then
        CenterWareHousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.transport:SetActive(true);
        CenterWareHousePanel.content.offsetMax = Vector2.New(-770,0);
    else

        CenterWareHousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.transport:SetActive(false);
        CenterWareHousePanel.content.offsetMax = Vector2.New(0,0);
    end
    switchIsShow = isShow;
end

--排序
function CenterWareHouseCtrl:_getSortItems(type)
    if WareHouseGoodsMgr.items == nil then
        return
    end
    if type == CenterWareHouseSortItemType.Name then
        table.sort(WareHouseGoodsMgr.items, function (m, n) return m.name < n.name end )
        for i, v in ipairs(WareHouseGoodsMgr.items) do
            v.prefab.gameObject.transform:SetParent(CenterWareHousePanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(CenterWareHousePanel.content.transform);
            v.id = i
            WareHouseGoodsItem:RefreshData(v.goodsDataInfo,i)
        end
    end
    if type == CenterWareHouseSortItemType.Quantity then
        table.sort(WareHouseGoodsMgr.items, function (m, n) return m.n < n.n end )
        for i, v in ipairs(WareHouseGoodsMgr.items) do
            v.prefab.gameObject.transform:SetParent(CenterWareHousePanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(CenterWareHousePanel.content.transform);
            v.id = i
            WareHouseGoodsItem:RefreshData(v.goodsDataInfo,i)
        end
    end

end

--清空运输框里的内容
function CenterWareHouseCtrl:clearAllData()
    CenterWareHousePanel.tipText.text = 0
    WareHouseGoodsMgr:ClearAll()
    itemId = {}
    WareHouseGoodsMgr:EnabledAll()
    CenterWareHousePanel.transportConfirm:SetActive(true);
end