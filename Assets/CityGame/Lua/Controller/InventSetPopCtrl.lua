
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

function InventSetPopCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end


function InventSetPopCtrl:Refresh()
    local data = self.m_data
    self:updateText(data)
    self.popCompent:Refesh(data)
end

function InventSetPopCtrl:Awake(go)
    self.isOpen=false
    panel = InventSetPopPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.popCompent = PopCommpent:new(go,LuaBehaviour,self)
    LuaBehaviour:AddClick(panel.isOpenBtn.gameObject,self.OnClick_isOpen,self);
    panel.priceInp.onValueChanged:AddListener(function (string)
        self.price=tonumber(string)
    end)

    panel.countInp.onValueChanged:AddListener(function (string)
        self.count=tonumber(string)
    end)
end
---====================================================================================点击函数==============================================================================================
---
function InventSetPopCtrl:OnClick_isOpen(ins)
    if ins.isOpen then
        ins.isOpen = not ins.isOpen
    else
        ins.isOpen = not ins.isOpen
    end
    panel.isOpenBtnText.text=tostring(ins.isOpen)
end



---====================================================================================业务逻辑==============================================================================================


function InventSetPopCtrl:updateText(data)
   -- panel.mainText.text = GetLanguage(40010009)
end

