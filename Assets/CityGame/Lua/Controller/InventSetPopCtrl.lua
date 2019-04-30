
InventSetPopCtrl = class('InventSetPopCtrl',UIPanel)
UIPanel:ResgisterOpen(InventSetPopCtrl) --注册打开的方法
---====================================================================================框架函数==============================================================================================
local panel

function InventSetPopCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function InventSetPopCtrl:bundleName()
    return "Assets/CityGame/Resources/View/InventSetPopPanel.prefab";
end

function InventSetPopCtrl:Refresh()
    local data = self.m_data.ins.m_data
    self:updateText(data)
    self:UpDateUI(data)
end

function InventSetPopCtrl:Awake(go)
    panel = InventSetPopPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')

    LuaBehaviour:AddClick(panel.xBtn,self.OnxBtn,self);
    LuaBehaviour:AddClick(panel.confirm,self.OnConfirm,self);
    panel.open.onValueChanged:AddListener(function(isOn)
        self:OnOpen(isOn)
    end)

end
---====================================================================================点击函数==============================================================================================

--设置
function InventSetPopCtrl:OnConfirm(ins)

    local isopen =  panel.open.isOn
    if isopen then
        if panel.price.text == "" or panel.time.text == "" or panel.price.text == "0" or panel.time.text == "0" then
            Event.Brocast("SmallPop","时间或价格不能为空",300)
            return
        end

        local price = tonumber(panel.price.text)
        local count = tonumber(panel.time.text)

        Event.Brocast("c_UpdateInventSet",count,price)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSettings',isopen)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSetting',price,count)
    else
        Event.Brocast("c_UpdateInventSet",0,0)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSettings',isopen)
    end
    UIPanel.ClosePage()
end

function InventSetPopCtrl:OnxBtn()
    UIPanel.ClosePage()
end



---====================================================================================业务逻辑==============================================================================================


function InventSetPopCtrl:updateText(data)
    -- panel.mainText.text = GetLanguage(40010009)
    panel.referencePrice.text = data.recommendPrice

end

function InventSetPopCtrl:UpDateUI(data)
    panel.price.text = ""
    panel.time.text = ""
    self.openUp =  not data.exclusive
    if self.openUp then
        panel.open.isOn = true
        panel.openBtn.anchoredPosition = Vector3.New(88, 0, 0)
        panel.close.localScale = Vector3.zero
    else
        panel.open.isOn = false
        panel.openBtn.anchoredPosition = Vector3.New(2, 0, 0)
        panel.close.localScale = Vector3.one
    end
end

--开启对外开放
function InventSetPopCtrl:OnOpen(isOn)
    if isOn then
        panel.openBtn.anchoredPosition = Vector3.New(88,0,0)
        panel.close.localScale = Vector3.zero
    else
        panel.openBtn.anchoredPosition = Vector3.New(2,0,0)
        panel.close.localScale = Vector3.one
    end
end