ChooseWarehouseCtrl = class('ChooseWarehouseCtrl',UIPanel);
UIPanel:ResgisterOpen(ChooseWarehouseCtrl) --How to open the registration

--Sort type
ChooseWarehouseSortItemType = {
    Name = 1,      --name
    Quantity = 2,  --quantity
    Price = 3,     --price
    Score = 4      --score
}

local isShowList;
local buildingInfo;
local chooseWarehouse
local hide

function ChooseWarehouseCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function ChooseWarehouseCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ChooseWarehousePanel.prefab";
end

function ChooseWarehouseCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end
function ChooseWarehouseCtrl:Awake(go)
    self.insId = OpenModelInsID.ChooseWarehouseCtrl
    chooseWarehouse = self.gameObject:GetComponent('LuaBehaviour');
    chooseWarehouse:AddClick(ChooseWarehousePanel.returnBtn.gameObject,self.OnClick_returnBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.searchBtn.gameObject,self.OnClick_searchBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.arrowBtn.gameObject,self.OnClick_OnSorting,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.nameBtn.gameObject,self.OnClick_nameBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.quantityBtn.gameObject,self.OnClick_quantityBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.priceBtn.gameObject,self.OnClick_priceBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.timeBtn.gameObject,self.OnClick_timeBtn,self);
    chooseWarehouse:AddClick(ChooseWarehousePanel.bgBtn.gameObject,self.OnClick_bgBtn,self);

    Event.AddListener("c_Transport",self.c_Transport,self)

    self.WareHouseGoodsMgr = WareHouseGoodsMgr:new()

    self.gameObject = go;
    --self.buysBuildings = DataManager.GetMyAllBuildingDetail()  -- Get building details
    isShowList = false;

    --initialization
    local name = DataManager:GetName()
    ChooseWarehousePanel.nameText.text = name
    local faceId = DataManager.GetFaceId()
    AvatarManger.GetSmallAvatar(faceId,ChooseWarehousePanel.faceItem.transform,0.1)

end

function ChooseWarehouseCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_OnAddressListBG",self.c_OnAddressListBG,self)
    Event.AddListener("c_OnLinePanelBG",self.c_OnLinePanelBG,self)
    --Event.AddListener("c_Transport",self.c_Transport,self)
    Event.AddListener("c_OnQueryPlayerBuildings",self.c_OnQueryPlayerBuildings,self)
    Event.AddListener("c_OnCreatFriendsLinePanel",self.c_OnCreatFriendsLinePanel,self)
    Event.AddListener("CreateLinePanel",self.CreateLinePanel,self)
    self:_addListener()

    ChooseWarehousePanel.tipText.text = "暂无仓库"
    ChooseWarehousePanel.name.text = GetLanguage(25020015)
    ChooseWarehousePanel.mineName.text = GetLanguage(21030005)
    ChooseWarehousePanel.addresslist.text = GetLanguage(21030006)
end

function ChooseWarehouseCtrl:Refresh()
   -- WareHouseGoodsMgr:_clear()
    hide = true
    self:initInsData()
   -- self:GetMyFriends()
    ChooseWarehousePanel.boxImg:SetActive(true)

end

function ChooseWarehouseCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_OnAddressListBG",self.c_OnAddressListBG,self)
    Event.RemoveListener("c_OnLinePanelBG",self.c_OnLinePanelBG,self)
    --Event.RemoveListener("c_Transport",self.c_Transport,self)
    Event.RemoveListener("c_OnQueryPlayerBuildings",self.c_OnQueryPlayerBuildings,self)
    Event.RemoveListener("c_OnCreatFriendsLinePanel",self.c_OnCreatFriendsLinePanel,self)
    Event.RemoveListener("CreateLinePanel",self.CreateLinePanel,self)
    self:_removeListener()

    hide = false
    WareHouseGoodsMgr:_clear()
end

function ChooseWarehouseCtrl:CreateLinePanel()   --Generate your own building details
    self.buysBuildings = DataManager.GetMyAllBuildingDetail()  -- Get building details
    WareHouseGoodsMgr:_creatLinePanel(self.buysBuildings,self.m_data.pos,self.m_data.buildingId,self.m_data.number)  --创建运输线Create a transportation line
    --if not self.WareHouseGoodsMgr.ipaItems or next(self.WareHouseGoodsMgr.ipaItems) == nil then
    --    ChooseWarehousePanel.tipImg.transform.localScale = Vector3.one
    --else
    --    ChooseWarehousePanel.tipImg.transform.localScale = Vector3.zero
    --end
end

-- Listen to the model layer network callback
function ChooseWarehouseCtrl:_addListener()
    Event.AddListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self) --Player Information Network Callback
end

--Cancel the model layer network callback
function ChooseWarehouseCtrl:_removeListener()
    Event.RemoveListener("c_OnReceivePlayerInfo", self.c_OnReceivePlayerInfo, self)--Player Information Network Callback
end

function ChooseWarehouseCtrl:c_OnReceivePlayerInfo(playerData)
    if hide then
        self.data = playerData.info
        self:_creatAddressList()
    end
end

--Get player friend list
function ChooseWarehouseCtrl:GetMyFriends()
    local ids = DataManager.GetMyFriends()  --Get friend id--
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

--Get friend information
function ChooseWarehouseCtrl:GetMyFriendsInfo(friendsIds)
    DataManager.DetailModelRpcNoRet(self.insId , 'm_GetMyFriendsInfo',friendsIds)--Get friend information
end

--Generate friend list
function ChooseWarehouseCtrl:_creatAddressList()
    local WareHouseGoodsMgr = WareHouseGoodsMgr:new()
    WareHouseGoodsMgr:_creatAddressList(self.data) --Create friend list
end

function ChooseWarehouseCtrl:initInsData()
    DataManager.OpenDetailModel(ChooseWarehouseModel,self.insId )
    DataManager.DetailModelRpcNoRet(self.insId , 'm_ReqAllBuildingDetail')      --Get your own building details
    DataManager.DetailModelRpcNoRet(self.insId , 'm_ReqRentBuildingDetail')     --Get details on renting your own building
end


--return
function ChooseWarehouseCtrl:OnClick_returnBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage();
end
--search
function ChooseWarehouseCtrl:OnClick_searchBtn()
    PlayMusEff(1002)
end
--Click ming BG
function ChooseWarehouseCtrl:OnClick_bgBtn(go)
    PlayMusEff(1002)
    if go.onClick then
        WareHouseGoodsMgr:_deleteLinePanel()
        ChooseWarehousePanel.boxImg:SetActive(true)
        local item = go.WareHouseGoodsMgr:GetItem()
        if item ~= nil then
            item.box:SetActive(false)
            item.onClick = true
        end
        WareHouseGoodsMgr:_creatLinePanel(go.buysBuildings,go.m_data.pos,go.m_data.buildingId,go.m_data.number)  --Create a transportation line
    end
    go.onClick = false
end

--Click on Address Book BG
function ChooseWarehouseCtrl:c_OnAddressListBG(go)
    self.onClick = true
    if go.onClick then
        WareHouseGoodsMgr:_deleteLinePanel()
        DataManager.DetailModelRpcNoRet(go.insId , 'm_QueryPlayerBuildings',go.id)--Check player building details
        ChooseWarehousePanel.boxImg:SetActive(false)
        go.manager:SelectBox(go)
    end
    go.onClick = false  --First click

end

--Friends building details callback
function ChooseWarehouseCtrl:c_OnQueryPlayerBuildings(info)
    ChooseWarehouseCtrl:c_OnCreatFriendsLinePanel(info)
end

--Create Buddy Transport Line
function ChooseWarehouseCtrl:c_OnCreatFriendsLinePanel(buysBuildings)
    WareHouseGoodsMgr:_creatFriendsLinePanel(buysBuildings,self.m_data.pos)
end

--Click on the transported place
function ChooseWarehouseCtrl:c_OnLinePanelBG(info)
    buildingInfo = info
    self:SelectWarehouseName(info.name)
end

--Selected warehouse name
function ChooseWarehouseCtrl:SelectWarehouseName(name)
    if self.m_data.nameText == nil then
        return
    end
    self.m_data.nameText.text = name
end

--transport
function ChooseWarehouseCtrl:c_Transport(src, itemId, n,producerId,qty)

    Event.Brocast("m_ReqTransport",src,buildingInfo.buildingId,itemId,n,producerId,qty)
end

--Calculate distance
function ChooseWarehouseCtrl:GetDistance(pos)
    local distance
    distance = math.sqrt(math.pow((pos.x-buildingInfo.posX),2)+math.pow((pos.y-buildingInfo.posY),2))
    return distance
end
--Get building ID
function ChooseWarehouseCtrl:GetBuildingId()
    if buildingInfo == nil then
        return nil
    end
    return buildingInfo.buildingId
end
--Get the name of the building
function ChooseWarehouseCtrl:GetName()
    local name
    name = buildingInfo.name
    return name
end

--Get building capacity
function ChooseWarehouseCtrl:GetCapacity()
    local Capacity
    Capacity = buildingInfo.spareCapacity
    return Capacity
end

--Get shipping unit price
function ChooseWarehouseCtrl:GetPrice()
    if buildingInfo == nil then
        return 0
    end
    return buildingInfo.price
end

--Sort by name
function ChooseWarehouseCtrl:OnClick_nameBtn()
    PlayMusEff(1002)
    ChooseWarehousePanel.nowText.text = "By name";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
    local type = ChooseWarehouseSortItemType.Name
    --ChooseWarehouseCtrl:_getSortItems(type)
end
--Sort by quantity
function ChooseWarehouseCtrl:OnClick_quantityBtn()
    PlayMusEff(1002)
    ChooseWarehousePanel.nowText.text = "By quantity";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
    local type = ChooseWarehouseSortItemType.Quantity
    --ChooseWarehouseCtrl:_getSortItems(type)
end
--Sort by price
function ChooseWarehouseCtrl:OnClick_priceBtn()
    PlayMusEff(1002)
    ChooseWarehousePanel.nowText.text = "By price";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
    local type = ChooseWarehouseSortItemType.Price
    --ChooseWarehouseCtrl:_getSortItems(type)
end
--Sort by time
function ChooseWarehouseCtrl:OnClick_timeBtn()
    PlayMusEff(1002)
    ChooseWarehousePanel.nowText.text = "By time";
    ChooseWarehouseCtrl:OnClick_OpenList(not isShowList);
end

function ChooseWarehouseCtrl:OnClick_OnSorting()
    PlayMusEff(1002)
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

--Sort
function ChooseWarehouseCtrl:_getSortItems(type)
    if WareHouseGoodsMgr.ipaItems == nil then
        return
    end
    if type == ChooseWarehouseSortItemType.Name then
        table.sort(WareHouseGoodsMgr.ipaItems, function (m, n)
            if m.sizeName == n.sizeName then
                return
            else
                return m.sizeName < n.sizeName
            end
            end )
        for i, v in ipairs(WareHouseGoodsMgr.ipaItems) do
            v.prefab.gameObject.transform:SetParent(ChooseWarehousePanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(ChooseWarehousePanel.rightContent.transform);
        end
    end
    if type == ChooseWarehouseSortItemType.Price then
        table.sort(WareHouseGoodsMgr.ipaItems, function (m, n) return m.price < n.price end )
        for i, v in ipairs(WareHouseGoodsMgr.ipaItems) do
            v.prefab.gameObject.transform:SetParent(ChooseWarehousePanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(ChooseWarehousePanel.rightContent.transform);
        end
    end
    if type == ChooseWarehouseSortItemType.Quantity then
        table.sort(WareHouseGoodsMgr.ipaItems, function (m, n) return m.num < n.num end )
        for i, v in ipairs(WareHouseGoodsMgr.ipaItems) do
            v.prefab.gameObject.transform:SetParent(ChooseWarehousePanel.scrollView.transform);
            v.prefab.gameObject.transform:SetParent(ChooseWarehousePanel.rightContent.transform);
        end
    end

end
