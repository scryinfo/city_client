---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/1/15 15:28
---

CompanyCtrl = class("CompanyCtrl", UIPanel)
UIPanel:ResgisterOpen(CompanyCtrl)

function CompanyCtrl:initialize()
    ct.log("tina_w22_friends", "CompanyCtrl:initialize()")
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function CompanyCtrl:bundleName()
    ct.log("tina_w22_friends", "CompanyCtrl:bundleName()")
    return "Assets/CityGame/Resources/View/CompanyPanel.prefab"
end

function CompanyCtrl:OnCreate(obj)
    ct.log("tina_w22_friends", "CompanyCtrl:OnCreate()")
    UIPage.OnCreate(self, obj)
end

function CompanyCtrl:Awake()
    ct.log("tina_w22_friends", "CompanyCtrl:Awake()")
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(CompanyPanel.backBtn, self.OnBack, self)

    self.businessRecordsSource = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.businessRecordsSource.mProvideData = CompanyCtrl.static.businessRecordsData
    self.businessRecordsSource.mClearData = CompanyCtrl.static.businessRecordsClearData



    --this._networkInterface:connectTo(this.ip, this.port, this.onConnectTo_loginapp_callback, nil)
end

function CompanyCtrl:_allItemType()
    CompanyCtrl.static.AllItem = {
        SELL_GROUND = {itemId = 1000, income = 0, expenses = 0}, -- 土地买卖
        RENT_GROUND = {itemId = 1001, income = 0, expenses = 0}, -- 土地租赁
        TRANSFER = {itemId = 1002, expenses = 0}, -- 运输费用
        SALARY = {itemId = 1003, expenses = 0}, -- 员工工资
        RENT_ROOM = {itemId = 1004, income = 0} -- 住宅房租
    }
    CompanyCtrl.static.AllItemId = {"SELL_GROUND", "RENT_GROUND", "TRANSFER","SALARY","RENT_ROOM",}
    for k, v in pairs(Material) do
        CompanyCtrl.static.AllItem[k] = {itemId = v.itemId, name = v.name, income = 0, expenses = 0}
        table.insert(CompanyCtrl.static.AllItemId, k)
    end
    for i, j in pairs(Good) do
        CompanyCtrl.static.AllItem[i] = {itemId = j.itemId, name = j.name, income = 0, expenses = 0}
        table.insert(CompanyCtrl.static.AllItemId, i)
    end
end

function CompanyCtrl:OnBack(go)
    go:_removeListener()
    go:Hide()
end

function CompanyCtrl:Refresh()
    self:_allItemType()
    self:_addListener()
    self:_updateData()
end

-- 监听Model层网络回调
function CompanyCtrl:_addListener()
    Event.AddListener("c_OnReceivePlayerEconomy", self.c_OnReceivePlayerEconomy, self)
end

--注销model层网络回调h
function CompanyCtrl:_removeListener()
    Event.RemoveListener("c_OnReceivePlayerEconomy", self.c_OnReceivePlayerEconomy, self)
end

function CompanyCtrl:initInsData()
    DataManager.OpenDetailModel(CompanyModel, OpenModelInsID.CompanyCtrl)
    DataManager.DetailModelRpcNoRet(OpenModelInsID.CompanyCtrl, 'm_QueryPlayerEconomy', self.m_data.id)
end

function CompanyCtrl:_updateData()
    if self.m_data.id == DataManager.GetMyOwnerID() then
        CompanyPanel.titleText.text = "MY COMPANY"
        CompanyPanel.coinBg:SetActive(true)
        CompanyPanel.coinText.text = DataManager.GetMoney()
    else
        CompanyPanel.titleText.text = "COMPANY"
        CompanyPanel.coinBg:SetActive(false)
    end
    LoadSprite(PlayerHead[self.m_data.faceId].MainPath, CompanyPanel.headImage, true)
    CompanyPanel.companyText.text = self.m_data.companyName
    CompanyPanel.nameText.text = self.m_data.name
    local timeTable = getFormatUnixTime(self.m_data.createTs/1000)
    CompanyPanel.foundingTimeText.text = string.format("founding time:%s", timeTable.year .. "/" .. timeTable.month .. "/" ..timeTable.day)

    CompanyPanel.businessRecordsScroll:RefillCells()
    --CompanyPanel.businessRecordsScroll:ActiveLoopScroll(self.businessRecordsSource, #CompanyCtrl.static.AllItemId)

    self:initInsData()
end

function CompanyCtrl:_showAllItem()

end

-- 交易记录
CompanyCtrl.static.businessRecordsData = function(transform, idx)
    idx = idx + 1
    local item = BusinessRecordsItem:new(transform, CompanyCtrl.static.AllItem[CompanyCtrl.static.AllItemId[idx]])
    --ExchangeCtrl.quoteItems[idx] = item
end

CompanyCtrl.static.businessRecordsClearData = function(transform)
end

-- 网络回调
function CompanyCtrl:c_OnReceivePlayerEconomy(economyInfos)
    if economyInfos then
        CompanyPanel.tipsText:SetActive(false)
        local allIncome = 0
        local allExpenses = 0
        for _, v in ipairs(economyInfos.infos) do
            if v.type == "MATERIAL" or v.type == "GOODS" then
                if v.income then
                    CompanyCtrl.static.AllItem[v.id].income = v.income
                    allIncome = allIncome + v.income
                end
                if v.pay then
                    CompanyCtrl.static.AllItem[v.id].expenses = v.pay
                    allExpenses = allExpenses + v.pay
                end
            else
                if v.income then
                    CompanyCtrl.static.AllItem[v.type].income = v.income
                    allIncome = allIncome + v.income
                end
                if v.pay then
                    CompanyCtrl.static.AllItem[v.type].expenses = v.pay
                    allExpenses = allExpenses + v.pay
                end
            end
        end
        CompanyPanel.incomeText.text = tostring(allIncome)
        CompanyPanel.expenditureText.text = tostring(allExpenses)
        CompanyPanel.businessRecordsScroll:ActiveLoopScroll(self.businessRecordsSource, #CompanyCtrl.static.AllItemId)
    else
        CompanyPanel.incomeText.text = "0"
        CompanyPanel.expenditureText.text = "0"
        CompanyPanel.tipsText:SetActive(true)
        CompanyPanel.businessRecordsScroll:ActiveLoopScroll(self.businessRecordsSource, 0)
    end
end