---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/26 17:29
---GroundTransOthersCheckInfoCtrl
GroundTransOthersCheckInfoCtrl = class('GroundTransOthersCheckInfoCtrl',UIPanel)
UIPanel:ResgisterOpen(GroundTransOthersCheckInfoCtrl)

function GroundTransOthersCheckInfoCtrl:initialize()
    UIPanel.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function GroundTransOthersCheckInfoCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GroundTransOthersCheckInfoPanel.prefab"
end

function GroundTransOthersCheckInfoCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function GroundTransOthersCheckInfoCtrl:Awake(go)
    local groundAuctionBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    groundAuctionBehaviour:AddClick(GroundTransOthersCheckInfoPanel.bgBtn.gameObject, self._closeBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransOthersCheckInfoPanel.backBtn.gameObject, self._backBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransOthersCheckInfoPanel.AOwnerBtn.gameObject, self._ownerBtnFunc, self)
    groundAuctionBehaviour:AddClick(GroundTransOthersCheckInfoPanel.BRenterBtn.gameObject, self._renterBtnFunc, self)
end

function GroundTransOthersCheckInfoCtrl:Refresh()
    Event.AddListener("c_GroundTranReqPlayerInfo",self._showPersonalInfo, self)
    self:_initPanelData()
end

function GroundTransOthersCheckInfoCtrl:Active()
    UIPanel.Active(self)
    GroundTransOthersCheckInfoPanel.titleText01.text = GetLanguage(24060002)
    GroundTransOthersCheckInfoPanel.noneText02.text = GetLanguage(24060003)
    GroundTransOthersCheckInfoPanel.partAText03.text = GetLanguage(24060007)
    GroundTransOthersCheckInfoPanel.partBText04.text = GetLanguage(24060006)
end

function GroundTransOthersCheckInfoCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_GroundTranReqPlayerInfo",self._showPersonalInfo, self)
end

function GroundTransOthersCheckInfoCtrl:Close()
    UIPanel.Close(self)
end

---初始化
function GroundTransOthersCheckInfoCtrl:_initPanelData()
    if self.m_data and self.m_data.groundInfo then
        local ids = {[1] = self.m_data.groundInfo.ownerId}
        if self.m_data.groundInfo.rent and self.m_data.groundInfo.rent.renterId then
            ids[2] = self.m_data.groundInfo.rent.renterId
        end
        GroundTransModel.m_ReqPlayersInfo(ids)
        self:_setShowState(self.m_data.groundInfo)
    end
end
--根据状态显示界面
function GroundTransOthersCheckInfoCtrl:_setShowState(groundInfo)
    GroundTransOthersCheckInfoPanel.closeAllState()
    if groundInfo.ownerId == nil then
        GroundTransOthersCheckInfoPanel.noneOwnerTran.localScale = Vector3.one
        return
    end
    GroundTransOthersCheckInfoPanel.partATran.localScale = Vector3.one
    if groundInfo.rent ~= nil and groundInfo.rent.renterId ~= nil then
        GroundTransOthersCheckInfoPanel.partBTran.localScale = Vector3.one
    end
end

--显示头像+名字信息
function GroundTransOthersCheckInfoCtrl:_showPersonalInfo(tempInfo)
    local roleInfo = tempInfo.info
    if roleInfo ~= nil then
        for i, info in pairs(roleInfo) do
            if info.id == self.m_data.groundInfo.ownerId then
                self.ownerInfo = info
            end
            if self.m_data.groundInfo.rent and self.m_data.groundInfo.rent.renterId then
                if info.id == self.m_data.groundInfo.rent.renterId then
                    self.renterInfo = info
                end
            end
        end

        if self.ownerInfo ~= nil then
            GroundTransOthersCheckInfoPanel.ANameText.text = self.ownerInfo.name
            GroundTransOthersCheckInfoPanel.ACompanyText.text = self.ownerInfo.companyName
            LoadSprite(PlayerHead[self.ownerInfo.faceId].GroundTransSmallPath, GroundTransOthersCheckInfoPanel.APortraitImg, true)
        end
        --
        if self.renterInfo ~= nil then
            GroundTransOthersCheckInfoPanel.BNameText.text = self.renterInfo.name
            GroundTransOthersCheckInfoPanel.BCompanyText.text = self.renterInfo.companyName
            LoadSprite(PlayerHead[self.renterInfo.faceId].GroundTransSmallPath, GroundTransOthersCheckInfoPanel.BPortraitImg, true)
        end
    end
end

---按钮方法
--点其他地方则关闭整个堆栈，打开主界面
function GroundTransOthersCheckInfoCtrl:_closeBtnFunc()
    PlayMusEff(1002)
    --关闭所有界面
    GroundTransSetPriceCtrl._closeBackToMain()
end
--返回按钮
function GroundTransOthersCheckInfoCtrl:_backBtnFunc()
    PlayMusEff(1002)
    UIPanel:ClosePage()
end

--点击土地所有者头像
function GroundTransOthersCheckInfoCtrl:_ownerBtnFunc(ins)
    PlayMusEff(1002)
    if ins.ownerInfo then
        ct.OpenCtrl("PersonalHomeDialogPageCtrl", ins.ownerInfo)
    end
end
--点击土地租赁者头像
function GroundTransOthersCheckInfoCtrl:_renterBtnFunc(ins)
    PlayMusEff(1002)
    if ins.renterInfo then
        ct.OpenCtrl("PersonalHomeDialogPageCtrl", ins.renterInfo)
    end
end