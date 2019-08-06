---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/25 14:58
---

ResearchOpenBoxCtrl = class("ResearchOpenBoxCtrl", UIPanel)
ResearchOpenBoxCtrl:ResgisterOpen(ResearchOpenBoxCtrl)

function ResearchOpenBoxCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function ResearchOpenBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ResearchOpenBoxPanel.prefab"
end

function ResearchOpenBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end

function ResearchOpenBoxCtrl:Awake(go)
    local luaBehaviour = self.gameObject:GetComponent("LuaBehaviour")

    luaBehaviour:AddClick(ResearchOpenBoxPanel.backBtn, self.OnBack, self)
    luaBehaviour:AddClick(ResearchOpenBoxPanel.openBtn, self.OnOpen, self)

    ResearchOpenBoxPanel.inputField.onEndEdit:AddListener(function (inputValue)
        if inputValue == nil or inputValue == "" then
            ResearchOpenBoxPanel.inputField.text = 1
            return
        end
        local num = tonumber(inputValue)
        if num <= 0 then
            ResearchOpenBoxPanel.inputField.text = 1
            return
        end
    end)
end

function ResearchOpenBoxCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_OnReceiveOpenScienceBox",self.c_OnReceiveOpenScienceBox,self)
end

function ResearchOpenBoxCtrl:Refresh()
    self:_updateData()
end

function ResearchOpenBoxCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_OnReceiveOpenScienceBox",self.c_OnReceiveOpenScienceBox,self)
    if self.researchEvaBoxItems then
        for _, v in ipairs(self.researchEvaBoxItems) do
            UnityEngine.GameObject.Destroy(v.prefab)
        end
        self.researchEvaBoxItems = nil
    end
    self.nowItem = nil
end
-- 显示总数
function ResearchOpenBoxCtrl:_showTotalNum()
    ResearchOpenBoxPanel.totalNumText.text = "x" .. self.totalNum
end

-- 初始化基本数据
function ResearchOpenBoxCtrl:_updateData()
    -- 根据useType生成不用的效果
    self.totalNum = 0
    if not self.researchEvaBoxItems then
        self.researchEvaBoxItems = {}
        for i, v in ipairs(self.m_data.boxs) do
            self.totalNum = self.totalNum + v.n
            local go = ct.InstantiatePrefab(ResearchOpenBoxPanel.researchEvaBoxItem)
            local rect = go.transform:GetComponent("RectTransform")
            go.transform:SetParent(ResearchOpenBoxPanel.boxsScrollContent)
            rect.transform.localScale = Vector3.one
            rect.transform.localPosition = Vector3.zero
            go:SetActive(true)

            local function callback()
                ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.zero
                ResearchOpenBoxPanel.middleRoot.localScale = Vector3.one
                ResearchOpenBoxPanel.middleNumText.text = "x" .. v.n
                if self.nowItem then
                    self.nowItem:SetBg(false)
                    self.nowItem:SetBtn(true)
                end
                self.nowItem = self.researchEvaBoxItems[i]
                self.nowItem:SetBg(true)
                self.nowItem:SetBtn(false)
            end
            self.researchEvaBoxItems[i] = ResearchEvaBoxItem:new(go, v, callback)
            if i == 1 then
                callback()
            end
        end
    end

    self:_showTotalNum()
    ResearchOpenBoxPanel.inputField.text = 1
end
-------------------------------------按钮点击事件-------------------------------------
function ResearchOpenBoxCtrl:OnBack(go)
    PlayMusEff(1002)
    UIPanel.ClosePage()
end

function ResearchOpenBoxCtrl:OnOpen(go)
    PlayMusEff(1002)
    -- 调用ResearchInstituteModel，向服务器发送使用宝箱消息
    local inputValue = ResearchOpenBoxPanel.inputField.text
    DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_ReqOpenScienceBox', go.nowItem.data.key.id, tonumber(inputValue))
    --UIPanel.ClosePage()
end

function ResearchOpenBoxCtrl:c_OnReceiveOpenScienceBox(scienceBoxACK)
    ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.one
    ResearchOpenBoxPanel.middleRoot.localScale = Vector3.zero

    LoadSprite(ResearchConfig[scienceBoxACK.key.id].iconPath, ResearchOpenBoxPanel.iconImage, false)
    ResearchOpenBoxPanel.resultNumText.text = "x" .. scienceBoxACK.resultPoint
    ResearchOpenBoxPanel.resultNameText.text = ResearchConfig[scienceBoxACK.key.id].name

    self.totalNum = self.totalNum - scienceBoxACK.openNum
    self:_showTotalNum()

    if self.nowItem then
        self.nowItem:SetBg(false)
        self.nowItem:SetBtn(true)
    end
    self.nowItem = nil
    for i, v in ipairs(self.researchEvaBoxItems) do
        if v.data.key.id == scienceBoxACK.key.id then
            --v.data.n = v.data.n - scienceBoxACK.openNum
            if v.data.n <= 0 then
                UnityEngine.GameObject.Destroy(v.prefab)
                table.remove(self.researchEvaBoxItems, i)
                self.nowItem = nil
            else
                v:SetNumText()
            end
            break
        end
    end
end