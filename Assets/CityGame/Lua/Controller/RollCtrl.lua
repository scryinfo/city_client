
local pool={}
local  function InsAndObjectPool(config,class,prefabPath,parent,LuaBehaviour,this)
    if not pool[class] then
        pool[class]={}
    end
    --对象池创建物体
    local tempList={}
    for i, value in ipairs(config) do
        local ins =pool[class][1]
        if ins then  --有实例
            ins:updateData(value)
            value.id=i
            ins.prefab:SetActive(true)
            table.insert(tempList,ins)
            table.remove(pool[class],1)
        else--无实例
            local prefab=creatGoods(prefabPath,parent)
            value.id=i
            local ins=class:new(prefab,LuaBehaviour,value,this)
            table.insert(tempList,ins)
        end
    end
    --多余实例隐藏
    if #pool[class]>0 then
        for key, ins in ipairs(pool[class]) do
            ins.prefab:SetActive(false)
            table.insert(tempList,ins)
            pool[class][key]=nil
        end
    end
    --所有实例归还对象池
    for i, ins in ipairs(tempList) do
        table.insert(pool[class],ins)
    end
end

local prefabPath ="View/Laboratory/rollItem"

RollCtrl = class('RollCtrl',UIPanel)
UIPanel:ResgisterOpen(RollCtrl) --注册打开的方法
---====================================================================================框架函数==============================================================================================
local panel

function RollCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal);
end

function RollCtrl:bundleName()
    return "Assets/CityGame/Resources/View/RollPanel.prefab";
end

function RollCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

function RollCtrl:Refresh()
    Event.AddListener("c_creatRollItem",self.c_creatRollItem,self)

    local data = self.m_data
    self:updateText(data)
    self.popCompent:Refesh(data)
    self:c_creatRollItem(data)
end

function RollCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_creatRollItem",self.c_creatRollItem,self)
end

function RollCtrl:Close()
    UIPanel.Close(self)
    Event.RemoveListener("c_creatRollItem",self.c_creatRollItem,self)
end

function RollCtrl:Awake(go)
    panel = RollPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.LuaBehaviour=LuaBehaviour
    self.popCompent = PopCommpent:new(go,LuaBehaviour,self)


end
---====================================================================================点击函数==============================================================================================





---====================================================================================业务逻辑==============================================================================================
function RollCtrl:c_creatRollItem( data )
    local datas={}
    for i = 1, data.availableRoll do
        table.insert( datas,{ lineId = data.id } )
    end
   InsAndObjectPool(datas,RollItem,prefabPath,panel.scrolParent, self.LuaBehaviour,self)
end

function RollCtrl:updateText(data)
    -- panel.titleText.text = GetLanguage(40010009)
end

