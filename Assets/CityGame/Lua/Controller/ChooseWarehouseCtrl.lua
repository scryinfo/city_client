ChooseWarehouseCtrl = class('ChooseWarehouseCtrl',UIPage);
UIPage:ResgisterOpen(ChooseWarehouseCtrl) --注册打开的方法

local isShowList;
local buildingInfo;
local chooseWarehouse
local onClick = true

function ChooseWarehouseCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ChooseWarehouseCtrl:bundleName()
    return "ChooseWarehousePanel";
end

function ChooseWarehouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
    chooseWarehouse:AddClick(ChooseWarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.nameBtn.gameObject,self.OnClick_nameBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.quantityBtn.gameObject,self.OnClick_quantityBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.priceBtn.gameObject,self.OnClick_priceBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.timeBtn.gameObject,self.OnClick_timeBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.bgBtn.gameObject,self.OnClick_bgBtn,self);

    self.WareHouseGoodsMgr = WareHouseGoodsMgr:new()

    Event.AddListener("c_OnAddressListBG",self.c_OnAddressListBG,self)
    Event.AddListener("c_OnLinePanelBG",self.c_OnLinePanelBG,self)
    Event.AddListener("c_Transport",self.c_Transport,self)
    Event.AddListener("c_OnQueryPlayerBuildings",self.c_OnQueryPlayerBuildings,self)
end
function ChooseWarehouseCtrl:Awake(go)
    chooseWarehouse = self.gameObject:GetComponent('LuaBehaviour');
    self.gameObject = go;
    self:_addListener()
    self.buysBuildings = DataManager.GetMyAllBuildingDetail()  -- 获取建筑详情
    isShowList = false;
end

function ChooseWarehouseCtrl:Refresh()
    ChooseWarehousePanel.boxImg:SetActive(true)
    local name = DataManager:GetName()
    ChooseWarehousePanel.nameText.text = name
    WareHouseGoodsMgr:_creatLinePanel(self.buysBuildings)  --创建运输线
    self:initInsData()
    self:GetMyFriends()
end

-- 监听Model层网络回调
function ChooseWarehouseCtrl:_addListener()
    Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self) --玩家信息网络回调
end

--注销model层网络回调
function ChooseWarehouseCtrl:_removeListener()
    Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)--玩家信息网络回调
end

function ChooseWarehouseCtrl:c_OnReceivePlayerInfo(playerData)
    self.data = {}   --好友信息
    self.data = playerData.info
    self:_creatAddressList()
end

--获取玩家好友列表
function ChooseWarehouseCtrl:GetMyFriends()
    local ids = DataManager.GetMyFriends()  --获取好友id
    if ids == nil then
        return
    end
    local friendsId = {}
    for id, v in pairs(ids) do
        if id ~= nil then
            table.insert(friendsId, id)
        end
    end
    self:GetMyFriendsInfo(friendsId)
end

--获取好友信息
function ChooseWarehouseCtrl:GetMyFriendsInfo(friendsIds)
    DataManager.DetailModelRpcNoRet(8, 'm_GetMyFriendsInfo',friendsIds)--获取好友信息
end

--生成好友列表
function ChooseWarehouseCtrl:_creatAddressList()
    local WareHouseGoodsMgr = WareHouseGoodsMgr:new()
    WareHouseGoodsMgr:_creatAddressList(chooseWarehouse, self.data) --创建好友列表
end

function ChooseWarehouseCtrl:initInsData()
    DataManager.OpenDetailModel(ChooseWarehouseModel,8)
end


--返回
function ChooseWarehouseCtrl:OnClick_returnBtn()
    WareHouseGoodsMgr:_clear()
    ChooseWarehouseCtrl:_removeListener()
    UIPage.ClosePage();
end
--搜索
function ChooseWarehouseCtrl:OnClick_searchBtn()

end
--点击ming BG
function ChooseWarehouseCtrl:OnClick_bgBtn(go)
    WareHouseGoodsMgr:_deleteLinePanel()
    if go.onClick then
        ChooseWarehousePanel.boxImg:SetActive(true)
        local item = go.WareHouseGoodsMgr:GetItem()
        if item ~= nil then
            item.box:SetActive(false)
            item.onClick = true
        end
        WareHouseGoodsMgr:_creatLinePanel(go.buysBuildings)  --创建运输线
    end
    go.onClick = false
end

--点击通讯录BG
function ChooseWarehouseCtrl:c_OnAddressListBG(go)
    self.onClick = true
    WareHouseGoodsMgr:_deleteLinePanel()
    if go.onClick then
        DataManager.DetailModelRpcNoRet(8, 'm_QueryPlayerBuildings',go.id)--查询玩家建筑详情
    end
    ChooseWarehousePanel.boxImg:SetActive(false)
    go.onClick = false  --第一次点击
    go.manager:SelectBox(go)
    --go.manager:TransportConfirm(true)
    --CenterWareHousePanel.nameText.text = go.name;
end

--好友建筑详情回调
function ChooseWarehouseCtrl:c_OnQueryPlayerBuildings(info)
    WareHouseGoodsMgr:_creatFriendsLinePanel(info)
end

--点击所运输的地方
function ChooseWarehouseCtrl:c_OnLinePanelBG(info)
    buildingInfo = info
end

--运输
function ChooseWarehouseCtrl:c_Transport(src, itemId, n,producerId,qty)

    Event.Brocast("m_ReqTransport",src,buildingInfo.buildingId,itemId,n,producerId,qty)
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
