---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/24 10:37
---土地详情界面
GroundTransState =
{
    None = 0,
    Sell = 1,
    Rent = 2,
    Renting = 3,
}
GroundTransDetailCtrl = class('GroundTransDetailCtrl',UIPanel)
UIPanel:ResgisterOpen(GroundTransDetailCtrl)

function GroundTransDetailCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundTransDetailCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GroundTransDetailPanel.prefab"
end

function GroundTransDetailCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function GroundTransDetailCtrl:Awake(go)
    local groundAuctionBehaviour =  self.gameObject:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundTransDetailPanel.bgBtn.gameObject, self._closeBtnFunc, self)
    --groundAuctionBehaviour:AddClick(GroundTransDetailPanel.rentBtnTran.gameObject, self._rentFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransDetailPanel.sellBtnTran.gameObject, self._sellFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransDetailPanel.sellingBtnTran.gameObject, self._sellingFunc, self)
    --groundAuctionBehaviour:AddClick(GroundTransDetailPanel.rentingBtnTran.gameObject, self._rentingFunc, self)
    --groundAuctionBehaviour:AddClick(GroundTransDetailPanel.selfCheckBtnTran.gameObject, self._selfCheckFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransDetailPanel.otherCheckBtnTran.gameObject, self._otherCheckFunc, self)
end

function GroundTransDetailCtrl:Refresh()
    self:_initPanelData()
end

function GroundTransDetailCtrl:Active()
    UIPanel.Active(self)
    GroundTransDetailPanel.titleText01.text = GetLanguage(22010001)
    --GroundTransDetailPanel.averageText02.text = GetLanguage(24010002)
    --GroundTransDetailPanel.buildingText03.text = GetLanguage(24010003)
    --GroundTransDetailPanel.areaText04.text = GetLanguage(22010002)
    GroundTransDetailPanel.rentText05.text = GetLanguage(22010003)
    GroundTransDetailPanel.sellText06.text = GetLanguage(22010004)
    GroundTransDetailPanel.sellingText07.text = GetLanguage(22010006)
    GroundTransDetailPanel.rentingText08.text = GetLanguage(22010005)
    GroundTransDetailPanel.ownerText.text = "所有者:"
    GroundTransDetailPanel.prosperityText.text = GetLanguage(20170003)
    Event.AddListener("_saveGroundProsperity",self._saveGroundProsperity,self)
    self.blockData = {}
    self:getBlockData()
end

function GroundTransDetailCtrl:Hide()
    UIPanel.Hide(self)
    self.blockData = {}
    Event.RemoveListener("_saveGroundProsperity",self._saveGroundProsperity,self)
    if self.avatarData then
        AvatarManger.CollectAvatar(self.avatarData)
    end
end

function GroundTransDetailCtrl:Close()
    UIPanel.Close(self)
end
--获取当前1*1地块主人信息
function GroundTransDetailCtrl:getBlockData()
    self.groundInfo = DataManager.GetGroundDataByID(self.m_data.blockId).Data
    local ownerId = {}
    table.insert(ownerId,self.groundInfo.ownerId)
    PlayerInfoManger.GetInfos(ownerId,self._saveData,self)
end
---初始化
function GroundTransDetailCtrl:_initPanelData()
    if self.m_data then
        --local groundInfo = DataManager.GetGroundDataByID(self.m_data.blockId).Data
        if self.groundInfo then
            GroundTransModel.SetGroundBlockId(self.m_data.blockId)  --设置地块Id
            self.m_data.groundInfo = self.groundInfo
            self:_setShowState(self.m_data.groundInfo)
        end
    end
end
--根据状态显示界面
--rent和sell不会同时出现
--如果有sell，则证明这块地是出售状态，此时需要判断ownerId
--1、如果是自己，则打开GroundTransSetPriceCtrl界面，可调整售价
--2、不是自己，则打开sellingBtnTran按钮的显示，玩家点击之后可跳转到购买合约界面
--如果没有ownerId，则这块地是系统地，显示还未拍卖
--其他状态都是出租状态，不做解释
function GroundTransDetailCtrl:_setShowState(groundInfo)
    GroundTransDetailPanel._closeAllBtnTran()
    if not groundInfo.ownerId then  --判断是否有owner
        --显示标签icon，打开attribution界面，显示还未拍卖
        GroundTransDetailPanel.otherCheckBtnTran.localScale = Vector3.one
        return
    end

    --groundState需要传到下个界面，判断是应该打开出租还是出售部分
    self.groundState = GroundTransState.None
    if groundInfo.rent then
        self.groundState = GroundTransState.Rent
    end
    if groundInfo.sell then
        self.groundState = GroundTransState.Sell
    end

    if groundInfo.ownerId == DataManager.GetMyOwnerID() then  --如果是自己打开
        --判断状态
        local tempPageType
        if self.groundState == GroundTransState.None then
            GroundTransDetailPanel.noneStateTran.localScale = Vector3.one
            return

        elseif self.groundState == GroundTransState.Sell then
            tempPageType = GroundTransState.Sell
            GroundTransDetailPanel.sellingBtnTran.localScale = Vector3.one

        elseif self.groundState == GroundTransState.Rent then
            if groundInfo.rent.renterId then  --是否已经租出去了
                GroundTransDetailPanel.selfCheckBtnTran.localScale = Vector3.one
                return
            end

            tempPageType = GroundTransState.Rent
            GroundTransDetailPanel.rentingBtnTran.localScale = Vector3.one
        end
        if self.hasOpened == nil or self.hasOpened == false then
            if tempPageType == nil then
                return
            end
            local info = {groundInfo = groundInfo, groundState = self.groundState, showPageType = tempPageType}
            --打开设置租金/售卖金额界面，参数为info
            ct.OpenCtrl("GroundTransSetPriceCtrl", info)
            self.hasOpened = true
            ct.log("cycle_w19_groundTrans", "打开调整价格界面")
        end

    else
        --判断状态
        if self.groundState == GroundTransState.None then
            --显示标签icon，打开attribution界面，显示owner
            GroundTransDetailPanel.otherCheckBtnTran.localScale = Vector3.one

        elseif self.groundState == GroundTransState.Sell then
            --显示selling按钮
            GroundTransDetailPanel.sellingBtnTran.localScale = Vector3.one

        elseif self.groundState == GroundTransState.Rent then
            if groundInfo.rent.renterId then
                if groundInfo.rent.renterId == DataManager.GetMyOwnerID() then  --如果自己是租房子的人
                    --显示查看状态
                    GroundTransDetailPanel.selfCheckBtnTran.localScale = Vector3.one
                else
                    --显示标签icon，打开attribution界面，显示renter和owner
                    GroundTransDetailPanel.otherCheckBtnTran.localScale = Vector3.one
                end
            else
                --显示renting按钮
                --没有租出去，则可以点击按钮跳转到租的界面
                GroundTransDetailPanel.rentingBtnTran.localScale = Vector3.one
            end
        end
    end
end

---按钮方法
function GroundTransDetailCtrl:_closeBtnFunc(ins)
    PlayMusEff(1002)
    ins.hasOpened = false
    UIPanel.ClosePage()
end
--owner出租按钮
--function GroundTransDetailCtrl:_rentFunc(ins)
--    PlayMusEff(1002)
--    local info = {groundInfo = ins.m_data.groundInfo, groundState = ins.groundState, showPageType = GroundTransState.Rent}
--    --打开设置租金/售卖金额界面，参数为info
--    ct.OpenCtrl("GroundTransSetPriceCtrl", info)
--end
--owner出售按钮
function GroundTransDetailCtrl:_sellFunc(ins)
    PlayMusEff(1002)
    --groundState和showPageType值都为GroundTransState枚举值，用于下个界面的状态显示，不需要重新判断状态
    local info = {groundInfo = ins.m_data.groundInfo, groundState = ins.groundState, showPageType = GroundTransState.Sell,prosperity = ins.blockData[1].prosperity}

    --打开设置租金/售卖金额界面，参数为info
    ct.OpenCtrl("GroundTransSetPriceCtrl", info)
end
--正在出售按钮
function GroundTransDetailCtrl:_sellingFunc(ins)
    PlayMusEff(1002)
    if ins.m_data.groundInfo.ownerId == DataManager.GetMyOwnerID() then
        --打开调整出租出售价格界面
        local info = {groundInfo = ins.m_data.groundInfo, groundState = ins.groundState, showPageType = GroundTransState.Sell}
        --打开设置租金/售卖金额界面，参数为info
        ct.OpenCtrl("GroundTransSetPriceCtrl", info)
    else
        --打开租赁购买界面
        local info = {groundInfo = ins.m_data.groundInfo, groundState = GroundTransState.Sell,prosperity = ins.blockData[1].prosperity}
        ct.OpenCtrl("GroundTransRentAndBuyCtrl", info)
    end
end
--缓存1*1土地信息
function GroundTransDetailCtrl:_saveData(ownerData)
    if self.blockData then
        table.insert(self.blockData,ownerData[1])
    end
    GAucModel.m_ReqQueryOneGoundInfo(self.groundInfo.x,self.groundInfo.y)
end
--缓存1*1土地繁荣度
function GroundTransDetailCtrl:_saveGroundProsperity(data)
    if data then
        self.blockData[1].prosperity = data.num
    end
    --收到数据后更新UI土地主人信息加繁荣度
    GroundTransDetailPanel.nameText.text = self.blockData[1].name
    GroundTransDetailPanel.companyText.text = self.blockData[1].companyName
    GroundTransDetailPanel.prosperityValue.text = self.blockData[1].prosperity
    self.avatarData = AvatarManger.GetSmallAvatar(self.blockData[1].faceId,GroundTransDetailPanel.headImg.transform,0.14)
end
--正在出租按钮
--function GroundTransDetailCtrl:_rentingFunc(ins)
--    PlayMusEff(1002)
--    if ins.m_data.groundInfo.ownerId == DataManager.GetMyOwnerID() then
--        --打开调整出租出售价格界面
--        local info = {groundInfo = ins.m_data.groundInfo, groundState = ins.groundState, showPageType = GroundTransState.Rent}
--        --打开设置租金/售卖金额界面，参数为info
--        ct.OpenCtrl("GroundTransSetPriceCtrl", info)
--    else
--        --打开租赁购买界面
--        local info = {groundInfo = ins.m_data.groundInfo, groundState = GroundTransState.Rent}
--        ct.OpenCtrl("GroundTransRentAndBuyCtrl", info)
--    end
--end
--租赁者/土地拥有者查看土地
--function GroundTransDetailCtrl:_selfCheckFunc(ins)
--    PlayMusEff(1002)
--    --打开租赁详情界面
--    ct.OpenCtrl("GroundTransSelfCheckInfoCtrl", {groundInfo = ins.m_data.groundInfo})
--end
--其他人查看土地
function GroundTransDetailCtrl:_otherCheckFunc(ins)
    PlayMusEff(1002)
    --打开attribution界面
    ct.OpenCtrl("GroundTransOthersCheckInfoCtrl", {groundInfo = ins.m_data.groundInfo})
end
