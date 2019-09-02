---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 16:01
---

ResearchSaleDetailPart = class("ResearchSaleDetailPart", BasePartDetail)

function ResearchSaleDetailPart.PrefabName()
    return "ResearchSaleDetailPart"
end

function ResearchSaleDetailPart:_InitTransform()
    -- 货架有东西
    self.shelfScrollContentTF = self.transform:Find("Root/ShelfScroll")
    self.shelfScrollContent = self.transform:Find("Root/ShelfScroll/Viewport/Content")
    self.addBtnTF = self.transform:Find("Root/ShelfScroll/Viewport/Content/AddBtn").gameObject
    self.addBtn = self.transform:Find("Root/ShelfScroll/Viewport/Content/AddBtn"):GetComponent("Button")
    self.researchMaterialItem = self.transform:Find("Root/ShelfScroll/Viewport/Content/ResearchMaterialItem").gameObject

    -- 货架没东西
    self.noTip = self.transform:Find("Root/NoTip")
    self.TipText = self.transform:Find("Root/NoTip/TipText"):GetComponent("Text")
    self.noAddBtnTF = self.transform:Find("Root/NoTip/AddBtn")
end

--显示详情
function ResearchSaleDetailPart:Show(data)
    self.transform.localScale = Vector3.New(1,0,1)
    self.transform:DOScale(Vector3.one,BasePartDetail.static.OpenDetailPartTime):SetEase(BasePartDetail.static.OpenDetailPartEase)
    self:RefreshData(data)
    -- 监听获取科技资料仓库数据(研究所、推广公司)
    Event.AddListener("c_OnReceiveGetScienceStorageData",self.c_OnReceiveGetScienceStorageData,self)
end

-- 初始化的时候，监听事件
function  ResearchSaleDetailPart:_InitEvent()
    -- 监听查询出售的内容（_getDatabaseInfo）
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "getScienceShelfData", "gs.ScienceShelfData", self._getScienceShelfData, self)
    -- 监听上架内容
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "scienceShelfAdd", "gs.ShelfAdd", self.n_OnReceiveScienceShelfAdd, self)
    -- 监听下架内容
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "scienceShelfDel", "gs.ShelfDel", self.n_OnReceiveScienceShelfDel, self)
    -- 监听修改内容
    DataManager.ModelRegisterNetMsg(nil, "gscode.OpCode", "scienceShelfSet", "gs.ShelfSet", self.n_OnReceiveScienceShelfSet, self)
end

function ResearchSaleDetailPart:_InitClick(mainPanelLuaBehaviour)
    -- 给加号点击增加打开ResearchSaleChoiceCtrl的点击，把查询到的资料库的数据传进去
    mainPanelLuaBehaviour:AddClick(self.addBtn.gameObject, function ()
        ct.OpenCtrl("ResearchSaleChoiceCtrl", self.actualDataBaseTab)
    end , self)

    mainPanelLuaBehaviour:AddClick(self.noAddBtnTF.gameObject, function ()
        ct.OpenCtrl("ResearchSaleChoiceCtrl", self.actualDataBaseTab)
    end , self)
end

-- 销毁的时候，清除数据
function ResearchSaleDetailPart:_ResetTransform()
    if self.researchMaterialItems then
        for _, m in ipairs(self.researchMaterialItems) do
            destroy(m.prefab)
        end
    end
    self.researchMaterialItems = nil
end

-- 销毁的时候，清除事件
function ResearchSaleDetailPart:_RemoveEvent()
    -- 移除监听查询出售的内容
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "getScienceShelfData", self._getScienceShelfData, self)
    -- 移除获取科技资料仓库数据(研究所、推广公司)
    Event.RemoveListener("c_OnReceiveGetScienceStorageData", self.c_OnReceiveGetScienceStorageData, self)
    -- 移除监听上架内容
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "scienceShelfAdd", self.n_OnReceiveScienceShelfAdd, self)
    -- 移除监听下架内容
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "scienceShelfDel", self.n_OnReceiveScienceShelfDel, self)
    -- 移除监听修改内容
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "scienceShelfSet", self.n_OnReceiveScienceShelfSet, self)
end

function ResearchSaleDetailPart:RefreshData(data)
    self.m_data = data
    -- 获取科技资料仓库数据(研究所、推广公司)
    DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqGetScienceStorageData')
    -- 如果是本人打开，则需要查询仓库的内容
    -- 向服务器发消息查询出售的内容
    -- 向服务器发消息查询当前资料库的内容
    -- 如果是别人打开，监听使用事件
end

-- 销毁的时候，清除点击事件
function ResearchSaleDetailPart:_RemoveClick()

end

function ResearchSaleDetailPart:_ChildHide()
    -- 移除获取科技资料仓库数据(研究所、推广公司)
    Event.RemoveListener("c_OnReceiveGetScienceStorageData", self.c_OnReceiveGetScienceStorageData, self)
end

function ResearchSaleDetailPart:_getScienceShelfData(data)
    self.scienceShelfData = data
    self.actualDataBaseTab = self.scienceStorageData
    -- 如果是自己打开，加号需要显示
    if self.researchMaterialItems then
        for _, m in ipairs(self.researchMaterialItems) do
            destroy(m.prefab)
        end
    end
    self.researchMaterialItems = {}
    if self.m_data.info.ownerId == DataManager.GetMyOwnerID() then
        self.addBtnTF:SetActive(true)
        self.shelfScrollContentTF.localScale = Vector3.one
        self.noTip.localScale = Vector3.zero
        if data.shelf and data.shelf.good and #data.shelf.good >= 1 then
            local actualShelfTab = {}
            for x, y in ipairs(data.shelf.good) do
                for a, b in ipairs(self.scienceStorageData.store) do
                    if y.k.id == b.itemKey.id then
                        y.storeNum = b.storeNum
                        y.lockedNum = b.lockedNum
                        table.insert(actualShelfTab, y)
                        break
                    end
                end
            end
            self.actualDataBaseTab = {}
            self.actualDataBaseTab.store = {}
            self.actualDataBaseTab.buildingId = self.scienceStorageData.buildingId
            for c, d in ipairs(self.scienceStorageData.store) do
                local isAddDatabase = true
                for e, f in ipairs(actualShelfTab) do
                    if f.k.id == d.itemKey.id then
                        isAddDatabase = false
                        break
                    end
                end
                if isAddDatabase then
                    table.insert(self.actualDataBaseTab.store, d)
                end
            end

            for i, v in ipairs(actualShelfTab) do
                local go = ct.InstantiatePrefab(self.researchMaterialItem)
                local rect = go.transform:GetComponent("RectTransform")
                go.transform:SetParent(self.shelfScrollContent)
                rect.transform.localScale = Vector3.one
                rect.transform.localPosition = Vector3.zero
                go:SetActive(true)

                self.researchMaterialItems[i] = ResearchMaterialItem:new(go, v, 3, data.buildingId, true)
            end
        else
            --self.addBtnTF.localScale = Vector3.zero
            self.shelfScrollContentTF.localScale = Vector3.zero
            self.noTip.localScale = Vector3.one
            self.TipText.text = GetLanguage(28060001)
            self.noAddBtnTF.localScale = Vector3.one
        end
    else
        if data.shelf and data.shelf.good and #data.shelf.good >= 1 then
            self.shelfScrollContentTF.localScale = Vector3.one
            self.addBtnTF:SetActive(false)
            self.noTip.localScale = Vector3.zero

            for i, v in ipairs(data.shelf.good) do
                local go = ct.InstantiatePrefab(self.researchMaterialItem)
                local rect = go.transform:GetComponent("RectTransform")
                go.transform:SetParent(self.shelfScrollContent)
                rect.transform.localScale = Vector3.one
                rect.transform.localPosition = Vector3.zero
                go:SetActive(true)

                self.researchMaterialItems[i] = ResearchMaterialItem:new(go, v, 4, data.buildingId)
            end
        else
            self.shelfScrollContentTF.localScale = Vector3.zero
            self.noTip.localScale = Vector3.one
            self.noAddBtnTF.localScale = Vector3.zero
            self.TipText.text = "There is no goods yet!"
        end
    end
end

function ResearchSaleDetailPart:c_OnReceiveGetScienceStorageData(scienceStorageData)
    self.scienceStorageData = scienceStorageData
    -- 获取货架数据(研究所、推广公司)
    DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqGetScienceShelfData')
end

-- 上架(研究所、推广公司)
function ResearchSaleDetailPart:n_OnReceiveScienceShelfAdd(shelfAdd)
    FlightMainModel.CloseFlightLoading()
    UIPanel.ClosePage()

    -- 获取科技资料仓库数据(研究所、推广公司)
    DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqGetScienceStorageData')
end

-- 全部下架该科技(研究所、推广公司)
function ResearchSaleDetailPart:n_OnReceiveScienceShelfDel(shelfDel)
    -- 获取科技资料仓库数据(研究所、推广公司)
    DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqGetScienceStorageData')
end

-- 修改上架信息(研究所、推广公司)
function ResearchSaleDetailPart:n_OnReceiveScienceShelfSet(shelfSet)
    -- 获取科技资料仓库数据(研究所、推广公司)
    DataManager.DetailModelRpcNoRet(self.m_data.info.id, 'm_ReqGetScienceStorageData')
end