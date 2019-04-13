
InventPopCtrl = class('InventPopCtrl',UIPanel)
UIPanel:ResgisterOpen(InventPopCtrl) --注册打开的方法
---====================================================================================框架函数==============================================================================================
local panel

function InventPopCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function InventPopCtrl:bundleName()
    return "Assets/CityGame/Resources/View/InventPopPanel.prefab";
end

function InventPopCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end


function InventPopCtrl:Refresh()
    local data = self.m_data
    self:updateText(data)
    self.popCompent:Refesh(data)
end

function InventPopCtrl:Awake(go)
    self.isOpen=false
    panel = InventPopPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.popCompent = PopCommpent:new(go,LuaBehaviour,self)


    panel.countInp.onValueChanged:AddListener(function (string)
        self.count=tonumber(string)
    end)
end
---====================================================================================点击函数==============================================================================================

---====================================================================================业务逻辑==============================================================================================


function InventPopCtrl:updateText(data)
    -- panel.mainText.text = GetLanguage(40010009)
end

