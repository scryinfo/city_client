
InventPopCtrl = class('InventPopCtrl',UIPanel)
UIPanel:ResgisterOpen(InventPopCtrl) --注册打开的方法
---====================================================================================框架函数==============================================================================================
local panel
local buildInfo
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

function InventPopCtrl:Refresh()
    local modelData = DataManager.GetDetailModelByID(LaboratoryCtrl.static.insId).data
    buildInfo = modelData.info
    local data = self.m_data
    self.ChangeLan()
    self.popCompent:Refesh(data)



    if self.m_data.ins.type  then
        panel.num.text = tostring(modelData.probGood).."%"
    else
        panel.num.text = tostring(modelData.probEva).."%"
    end

    if DataManager.GetMyOwnerID() ~= buildInfo.ownerId then
        self:other()
        panel.buyRoot.localScale = Vector3.one
        panel.sellRoot.localScale = Vector3.zero

    else
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


function InventPopCtrl.ChangeLan()
    --panel.titleText
    --panel.iconNameText
    --panel.oddsText
    --panel.evaTips
    --panel.timeText
    --panel.tips
    --panel.confimBtnText
   --panel.timeText1
    --panel.tips1
end

function InventPopCtrl:other()
    panel.countInp.onValueChanged:AddListener( function (string)
        if string == "" or buildInfo.sellTimes == 0 or not buildInfo.pricePreTime then
            self.count=0
            Event.Brocast("SmallPop","研究次数不够",300)
            panel.countInp.text = 0
            panel.priceText.text = 0
            return
        end

        local count = tonumber(string)

        if buildInfo.sellTimes then
            panel.Slider.value = count/ (buildInfo.sellTimes)
        end
        self.count = count

        panel.priceText.text = (buildInfo.pricePreTime)*count

    end)

    panel.Slider.onValueChanged:AddListener(function (arg)
        if arg <= 0 or buildInfo.sellTimes ==0 or not buildInfo.sellTimes then
            panel.countInp.text = 0
            panel.Slider.value = 0
            return
        end

        local count = math.floor(arg*buildInfo.sellTimes )
        panel.countInp.text = count
    end)
end

function InventPopCtrl:RemoveLis()
    panel.countInp.onValueChanged:RemoveAllListeners();
    panel.Slider.onValueChanged:RemoveAllListeners();
    panel.countInput1.onValueChanged:RemoveAllListeners()
end