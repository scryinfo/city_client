
InventPopCtrl = class('InventPopCtrl',UIPanel)
UIPanel:ResgisterOpen(InventPopCtrl) --注册打开的方法
---====================================================================================框架函数==============================================================================================
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

-- 注册监听事件
function InventPopCtrl:Active()
    UIPanel.Active(self)
    --self:_addListener()

    -- 多语言适配
    self:ChangeLan()
end

function InventPopCtrl:Refresh()
    local modelData = DataManager.GetDetailModelByID(LaboratoryCtrl.static.insId).data
    buildInfo = modelData.info
    deatailBuildInfo = modelData
    local data = self.m_data
    self.popCompent:RefeshData(data)

    if self.m_data.ins.type ~= "eva" then
        panel.num.text = tostring(modelData.probGood ).."%".."("..tostring(modelData.probGoodAdd * 100).."%"..")"


        InventPopPanel.iconNameText.text = GetLanguage(self.m_data.ins.name)
        InventPopPanel.evaTips.text = string.format("You will get new %s when succeed", GetLanguage(self.m_data.ins.name))
        InventPopPanel.evaTips.text =GetLanguage(28040040)
        LoadSprite(self.m_data.ins.path, InventPopPanel.icon, true)
    else
        panel.num.text = tostring(modelData.probEva).."%".."("..tostring(modelData.probEvaAdd * 100).."%"..")"
        InventPopPanel.iconNameText.text = GetLanguage(28040031)
        InventPopPanel.evaTips.text = GetLanguage(28040014)
        LoadSprite("Assets/CityGame/Resources/Atlas/Laboratory/chooseInventPop/EVA-100%.png", InventPopPanel.icon, true)
    end

    if DataManager.GetMyOwnerID() ~= buildInfo.ownerId then -- 不是建筑主人
        self:other()
        panel.buyRoot.localScale = Vector3.one
        panel.sellRoot.localScale = Vector3.zero
        panel.price.localScale = Vector3.one
        self.popCompent:SetConfirmPos(Vector3.New(352, -285, 0))
    else -- 是建筑主人
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



---====================================================================================点击函数==============================================================================================

---====================================================================================业务逻辑==============================================================================================
function InventPopCtrl:ChangeLan()
    if self.m_data.ins.type and self.m_data.ins.type == "eva" then  --判断研究类型
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
    panel.countInp.onValueChanged:AddListener( function (string)
        if string == "" or deatailBuildInfo.sellTimes == 0 or not deatailBuildInfo.pricePreTime  then
            self.count=0
            Event.Brocast("SmallPop","研究次数不够",300)
            panel.countInp.text = 0
            panel.priceText.text = 0
            return
        end

        local count = tonumber(string)

        if count >= deatailBuildInfo.sellTimes then
            count =deatailBuildInfo.sellTimes
        end
        panel.countInp.text = count
        if deatailBuildInfo.sellTimes then
            panel.Slider.value = count/ (deatailBuildInfo.sellTimes)
        end
        self.count = count

        panel.priceText.text = (GetClientPriceString(deatailBuildInfo.pricePreTime))*count

    end)

    panel.Slider.onValueChanged:AddListener(function (arg)
        if arg <= 0 or deatailBuildInfo.sellTimes ==0 or not deatailBuildInfo.sellTimes then
            panel.countInp.text = 0
            panel.Slider.value = 0
            return
        end

        local count = math.floor(arg*deatailBuildInfo.sellTimes )
        panel.countInp.text = count
    end)
    panel.Slider.value = 0
end

function InventPopCtrl:RemoveLis()
    panel.countInp.onValueChanged:RemoveAllListeners();
    panel.Slider.onValueChanged:RemoveAllListeners();
    panel.countInput1.onValueChanged:RemoveAllListeners()
end