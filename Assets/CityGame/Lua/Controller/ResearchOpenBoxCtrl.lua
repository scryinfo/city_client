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
    luaBehaviour:AddClick(ResearchOpenBoxPanel.subtractBtn, self.OnSubtract, self)
    luaBehaviour:AddClick(ResearchOpenBoxPanel.addBtn, self.OnAdd, self)
    luaBehaviour:AddClick(ResearchOpenBoxPanel.closeBtn.gameObject, self.OnClose, self)

    ResearchOpenBoxPanel.inputField.onEndEdit:AddListener(function (inputValue) --onEndEdit
        if inputValue == nil or inputValue == "" then
            ResearchOpenBoxPanel.inputField.text = 1
            return
        end
        local num = tonumber(inputValue)
        if num <= 0 then
            ResearchOpenBoxPanel.inputField.text = 1
            return
        end
        if num >= self.nowItem.data.n then
            ResearchOpenBoxPanel.inputField.text = tostring(self.nowItem.data.n)
            return
        end
        ResearchOpenBoxPanel.tipsText.text = string.format("Earn %d~%d tech points", 10 * num, 100 * num)
    end)
end

function ResearchOpenBoxCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_OnReceiveOpenScienceBox",self.c_OnReceiveOpenScienceBox,self)
    -- 监听生产线变化推送
    Event.AddListener("c_OnReceiveGetFtyLineChangeInform",self.c_OnReceiveGetFtyLineChangeInform,self)

    ResearchOpenBoxPanel.leftTitleText.text = GetLanguage(28050026)
    ResearchOpenBoxPanel.titleText.text = GetLanguage(28050024)
end

function ResearchOpenBoxCtrl:Refresh()
    self:_updateData()
end

function ResearchOpenBoxCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_OnReceiveOpenScienceBox",self.c_OnReceiveOpenScienceBox,self)
    -- 移除监听生产线变化推送
    Event.RemoveListener("c_OnReceiveGetFtyLineChangeInform", self.c_OnReceiveGetFtyLineChangeInform, self)
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
    ResearchOpenBoxPanel.closeBtn.localScale = Vector3.zero
    ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.zero
    ResearchOpenBoxPanel.middleRoot.localScale = Vector3.one
    
    -- 根据useType生成不用的效果
    self.totalNum = 0
    self.openBoxsData = ct.deepCopy(self.m_data.boxs)
    if not self.researchEvaBoxItems then
        self.researchEvaBoxItems = {}
        for i, v in ipairs(self.openBoxsData) do
            self.totalNum = self.totalNum + v.n
            local go = ct.InstantiatePrefab(ResearchOpenBoxPanel.researchEvaBoxItem)
            local rect = go.transform:GetComponent("RectTransform")
            go.transform:SetParent(ResearchOpenBoxPanel.boxsScrollContent)
            rect.transform.localScale = Vector3.one
            rect.transform.localPosition = Vector3.zero
            go:SetActive(true)

            local function callback(clickItem)
                ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.zero
                ResearchOpenBoxPanel.middleRoot.localScale = Vector3.one
                ResearchOpenBoxPanel.middleNumText.text = "x" .. clickItem.data.n
                if self.nowItem then
                    self.nowItem:SetBg(false)
                    self.nowItem:SetBtn(true)
                end
                self.nowItem = clickItem
                self.nowItem:SetBg(true)
                self.nowItem:SetBtn(false)
                ResearchOpenBoxPanel.inputField.text = 1
                ResearchOpenBoxPanel.tipsText.text = "Earn 10~100 tech points"
            end
            self.researchEvaBoxItems[i] = ResearchEvaBoxItem:new(go, self.openBoxsData[i], callback)
            if i == 1 then
                callback(self.researchEvaBoxItems[1])
            end
        end
    end

    self:_showTotalNum()
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

function ResearchOpenBoxCtrl:OnSubtract(go)
    PlayMusEff(1002)
    -- 调用ResearchInstituteModel，向服务器发送使用宝箱消息
    local inputValue = tonumber(ResearchOpenBoxPanel.inputField.text)
    if inputValue <= 1 then
        return
    end
    ResearchOpenBoxPanel.inputField.text = tostring(inputValue - 1)
    ResearchOpenBoxPanel.tipsText.text = string.format("Earn %d~%d tech points", 10 * (inputValue - 1), 100 * (inputValue - 1))
end

function ResearchOpenBoxCtrl:OnAdd(go)
    PlayMusEff(1002)
    -- 调用ResearchInstituteModel，向服务器发送使用宝箱消息
    local inputValue = tonumber(ResearchOpenBoxPanel.inputField.text)
    if inputValue >= go.nowItem.data.n then
        return
    end
    ResearchOpenBoxPanel.inputField.text = tostring(inputValue + 1)
    ResearchOpenBoxPanel.tipsText.text = string.format("Earn %d~%d tech points", 10 * (inputValue + 1), 100 * (inputValue + 1))
end

function ResearchOpenBoxCtrl:OnClose(go)
    PlayMusEff(1002)
    ResearchOpenBoxPanel.closeBtn.localScale = Vector3.zero
    ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.zero
    ResearchOpenBoxPanel.middleRoot.localScale = Vector3.one
    if go.nowItem == nil then
        if go.researchEvaBoxItems[1] then
            go.nowItem = go.researchEvaBoxItems[1]
            go.nowItem:SetBg(true)
            go.nowItem:SetBtn(false)
            ResearchOpenBoxPanel.inputField.text = 1
            ResearchOpenBoxPanel.tipsText.text = "Earn 10~100 tech points"
        else
            ResearchOpenBoxPanel.middleRoot.localScale = Vector3.zero
        end
    end
end
-------------------------------------网络回调-------------------------------------
function ResearchOpenBoxCtrl:c_OnReceiveOpenScienceBox(scienceBoxACK)
    ResearchOpenBoxPanel.closeBtn.localScale = Vector3.one
    ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.one
    ResearchOpenBoxPanel.middleRoot.localScale = Vector3.zero

    LoadSprite(ResearchConfig[scienceBoxACK.key.id].iconPath, ResearchOpenBoxPanel.iconImage, true)
    ResearchOpenBoxPanel.resultNumText.text = "x" .. scienceBoxACK.resultPoint
    ResearchOpenBoxPanel.resultNameText.text = ResearchConfig[scienceBoxACK.key.id].name

    self.totalNum = self.totalNum - scienceBoxACK.openNum
    self:_showTotalNum()

    for i, v in ipairs(self.researchEvaBoxItems) do
        if v.data.key.id == scienceBoxACK.key.id then
            v:ChangeNumber(- scienceBoxACK.openNum)
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

-- 生产线变化推送
function ResearchOpenBoxCtrl:c_OnReceiveGetFtyLineChangeInform(data)
    self.totalNum = self.totalNum + data.produceNum
    self:_showTotalNum()
    if self.researchEvaBoxItems then
        local isExit = false
        for _, v in ipairs(self.researchEvaBoxItems) do
            if v.data.key.id == data.iKey.id then
                v:ChangeNumber(data.produceNum)
                v:SetNumText()
                isExit = true
                break
            end
        end
        if not isExit then
            local temp = { key= {id = data.iKey.id}, n = data.produceNum}
            table.insert(self.openBoxsData, temp)

            local go = ct.InstantiatePrefab(ResearchOpenBoxPanel.researchEvaBoxItem)
            local rect = go.transform:GetComponent("RectTransform")
            go.transform:SetParent(ResearchOpenBoxPanel.boxsScrollContent)
            rect.transform.localScale = Vector3.one
            rect.transform.localPosition = Vector3.zero
            go:SetActive(true)

            local function callback(clickItem)
                ResearchOpenBoxPanel.researchMaterialItem.localScale = Vector3.zero
                ResearchOpenBoxPanel.middleRoot.localScale = Vector3.one
                ResearchOpenBoxPanel.middleNumText.text = "x" .. clickItem.data.n
                if self.nowItem then
                    self.nowItem:SetBg(false)
                    self.nowItem:SetBtn(true)
                end
                self.nowItem = clickItem
                self.nowItem:SetBg(true)
                self.nowItem:SetBtn(false)
                ResearchOpenBoxPanel.inputField.text = 1
                ResearchOpenBoxPanel.tipsText.text = "Earn 10~100 tech points"
            end
            self.researchEvaBoxItems[#self.openBoxsData] = ResearchEvaBoxItem:new(go, temp, callback)
        end
    end
end