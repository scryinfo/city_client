ChooseWarehouseCtrl = class('ChooseWarehouseCtrl',UIPage);
UIPage:ResgisterOpen(ChooseWarehouseCtrl) --注册打开的方法

local isShowList;
local buildingInfo;

function ChooseWarehouseCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ChooseWarehouseCtrl:bundleName()
    return "ChooseWarehousePanel";
end

function ChooseWarehouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    local chooseWarehouse = self.gameObject:GetComponent('LuaBehaviour');
    chooseWarehouse:AddClick(ChooseWarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.nameBtn.gameObject,self.OnClick_nameBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.quantityBtn.gameObject,self.OnClick_quantityBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.priceBtn.gameObject,self.OnClick_priceBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.timeBtn.gameObject,self.OnClick_timeBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.bgBtn.gameObject,self.OnClick_bgBtn,self);

    ChooseWarehousePanel.boxImg:SetActive(true)

    WareHouseGoodsMgr:_creatAddressList(chooseWarehouse,nil)
    WareHouseGoodsMgr:_creatLinePanel()
    self.WareHouseGoodsMgr = WareHouseGoodsMgr:new()
    Event.AddListener("c_OnAddressListBG",self.c_OnAddressListBG,self)
    Event.AddListener("c_OnLinePanelBG",self.c_OnLinePanelBG,self)
    Event.AddListener("c_Transport",self.c_Transport,self)
end
function ChooseWarehouseCtrl:Awake(go)
    self.gameObject = go;
    isShowList = false;
end
--返回
function ChooseWarehouseCtrl:OnClick_returnBtn()
    UIPage.ClosePage();
end
--搜索
function ChooseWarehouseCtrl:OnClick_searchBtn()

end
--点击ming BG
function ChooseWarehouseCtrl:OnClick_bgBtn(go)
    ChooseWarehousePanel.boxImg:SetActive(true)
    if go.WareHouseGoodsMgr.lastBox == nil then
        return
    end
    go.WareHouseGoodsMgr.lastBox:SetActive(false)
end

--点击通讯录BG
function ChooseWarehouseCtrl:c_OnAddressListBG(go)
    ChooseWarehousePanel.boxImg:SetActive(false)
    go.manager:SelectBox(go)
    --go.manager:TransportConfirm(true)
    CenterWareHousePanel.nameText.text = go.name;
end

--点击所运输的地方
function ChooseWarehouseCtrl:c_OnLinePanelBG(info)
    buildingInfo = info
end

--运输
function ChooseWarehouseCtrl:c_Transport(src, itemId, n)

    Event.Brocast("m_ReqTransport",src,buildingInfo.buildingId,itemId,n)
end

--计算距离
function ChooseWarehouseCtrl:GetDistance(pos)
    local distance
    distance = math.sqrt(math.pow((pos.x-buildingInfo.posX),2)+math.pow((pos.y-buildingInfo.posY),2))
    return distance
end

--点击建筑的名字
function ChooseWarehouseCtrl:GetName()
    local name
    name = buildingInfo.name
    return name
end

--根据名字排序
function ChooseWarehouseCtrl:OnClick_nameBtn()
    ChooseWarehousePanel.nowText.text = "By name";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据数量排序
function ChooseWarehouseCtrl:OnClick_quantityBtn()
    ChooseWarehousePanel.nowText.text = "By quantity";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据价格排序
function ChooseWarehouseCtrl:OnClick_priceBtn()
    ChooseWarehousePanel.nowText.text = "By price";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end
--根据时间排序
function ChooseWarehouseCtrl:OnClick_timeBtn()
    ChooseWarehousePanel.nowText.text = "By time";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end

function ChooseWarehouseCtrl:OnClick_OnSorting()
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end

function ChooseWarehouseCtrl:OnClick_OpenList(isShow)
    if isShow then
        ChooseWarehousePanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ChooseWarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        ChooseWarehousePanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        ChooseWarehousePanel.arrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

function ChooseWarehouseCtrl:Refresh()

end