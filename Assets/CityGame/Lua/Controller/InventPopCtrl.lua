
InventPopCtrl = class('InventPopCtrl',UIPanel)
UIPanel:ResgisterOpen(InventPopCtrl) --How to open the registration
---====================================================================================Frame function==============================================================================================
local panel
local buildInfo
local deatailBuildInfo
function InventPopCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function InventPopCtrl:bundleName()
    return "Assets/CityGame/Resources/View/InventPopPanel.prefab";
end

function InventPopCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function InventPopCtrl:Hide()
    self.m_data.info = nil
    panel.countInput1.text = ""
    panel.priceText.text = 0

    UIPanel.Hide(self)
    self:RemoveLis()
end

function InventPopCtrl:Close()
    self.m_data.info = nil
    panel.countInput1.text = ""
    panel.priceText.text = 0

    UIPanel.Close(self)
    self:RemoveLis()
end

-- Register to listen to events
function InventPopCtrl:Active()
    UIPanel.Active(self)
    --self:_addListener()

    -- Multilingual adaptation
    self:ChangeLan()
end

function InventPopCtrl:Refresh()
    local modelData = DataManager.GetDetailModelByID(LaboratoryCtrl.static.insId).data
    buildInfo = modelData.info
    deatailBuildInfo = modelData
    local data = self.m_data
    self.count = 1  --The default is 1
    self.popCompent:RefeshData(data)

    if self.m_data.ins.type ~= "eva" then
        panel.num.text = tostring(modelData.probGood  + modelData.probGoodAdd).."%"
        InventPopPanel.iconNameText.text = GetLanguage(self.m_data.ins.name)
        InventPopPanel.evaTips.text = string.format("You will get new %s when succeed", GetLanguage(self.m_data.ins.name))
        InventPopPanel.evaTips.text =GetLanguage(28040040)
        LoadSprite(self.m_data.ins.path, InventPopPanel.icon, true)
    else
        panel.num.text = tostring(modelData.probEva + modelData.probEvaAdd).."%"
        InventPopPanel.iconNameText.text = GetLanguage(28040031)
        InventPopPanel.evaTips.text = GetLanguage(28040014)
        LoadSprite("Assets/CityGame/Resources/Atlas/Laboratory/chooseInventPop/EVA-100%.png", InventPopPanel.icon, true)
    end

    if DataManager.GetMyOwnerID() ~= buildInfo.ownerId then -- Not the building owner
        self:other()
        panel.buyRoot.localScale = Vector3.one
        panel.sellRoot.localScale = Vector3.zero
        panel.price.localScale = Vector3.one
        self.popCompent:SetConfirmPos(Vector3.New(352, -285, 0))
    else -- Is the building owner
        panel.countInput1.onValueChanged:AddListener( function( string )
            if string == ""  then
                self.count=0
                panel.countInp.text = 0
                return
            end

            self.count =tonumber(string)
        end)
        panel.buyRoot.localScale = Vector3.zero
        panel.sellRoot.localScale = Vector3.one
        panel.price.localScale = Vector3.zero
        self.popCompent:SetConfirmPos(Vector3.New(0,-285,0))
    end
end

function InventPopCtrl:Awake(go)
    self.isOpen=false
    panel = InventPopPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.popCompent = PopCommpent:new(go,LuaBehaviour,self)
end



---====================================================================================Click function ==============================================================================================

---====================================================================================Business logic==============================================================================================
function InventPopCtrl:ChangeLan()
    if self.m_data.ins.type and self.m_data.ins.type == "eva" then  --Determine the type of study
        InventPopPanel.titleText.text = GetLanguage(28040029)
    else
        InventPopPanel.titleText.text = GetLanguage(28040030)
    end
    panel.iconNameText.text = GetLanguage(28040031)
    panel.oddsText.text = GetLanguage(28040003)
    panel.evaTips.text  = GetLanguage(28040014)
    panel.timeText.text = GetLanguage(28040006)
    panel.tips.text  = GetLanguage(28040008)
    panel.confimBtnText.text = GetLanguage(28040033)
    panel.timeText1.text = GetLanguage(28040048)
    panel.tips1.text =  GetLanguage(28040008)
end

function InventPopCtrl:other()
    if deatailBuildInfo.sellTimes == nil or deatailBuildInfo.sellTimes == 0 or deatailBuildInfo.pricePreTime == nil then
        return
    end

    panel.Slider.maxValue = deatailBuildInfo.sellTimes
    panel.Slider.minValue = 1
    panel.Slider.value = 1
    panel.countInp.text = 1
    panel.priceText.text = GetClientPriceString(deatailBuildInfo.pricePreTime)

    panel.countInp.onValueChanged:AddListener( function (string)
        local count
        if string == "" then
            count = 1
        else
            count = tonumber(string)
        end

        if count > deatailBuildInfo.sellTimes then
            count = deatailBuildInfo.sellTimes
        end
        panel.countInp.text = count
        panel.Slider.value = count

        self.count = count
        panel.priceText.text = GetClientPriceString(deatailBuildInfo.pricePreTime*count)
    end)

    panel.Slider.onValueChanged:AddListener(function (arg)
        --if arg <= 0 or deatailBuildInfo.sellTimes ==0 or not deatailBuildInfo.sellTimes then
        --    panel.countInp.text = 0
        --    panel.Slider.value = 0
        --    return
        --end

        panel.countInp.text = arg
    end)
end

function InventPopCtrl:RemoveLis()
    panel.countInp.onValueChanged:RemoveAllListeners()
    panel.Slider.onValueChanged:RemoveAllListeners()
    panel.countInput1.onValueChanged:RemoveAllListeners()
end