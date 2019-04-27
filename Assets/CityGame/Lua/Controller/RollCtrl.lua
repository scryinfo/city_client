
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
function RollCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_creatRollItem",self.c_creatRollItem,self)
    Event.RemoveListener("c_InventResult",self.handleGoodsResult,self)
    Event.RemoveListener("c_InventResult",self.handleEvaResult,self)

end

function RollCtrl:Close()
    UIPanel.Close(self)
    Event.RemoveListener("c_creatRollItem",self.c_creatRollItem,self)
end

function RollCtrl:Refresh()
    Event.AddListener("c_creatRollItem",self.c_creatRollItem,self)
    local data = self.m_data
    if data.goodCategory then
        Event.AddListener("c_InventResult",self.handleGoodsResult,self)
    else
        Event.AddListener("c_InventResult",self.handleEvaResult,self)
    end

    self:updateText(data)
    self.popCompent:Refesh(data)
    self:c_creatRollItem(data)

end
function RollCtrl:Awake(go)
    panel = RollPanel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.LuaBehaviour=LuaBehaviour
    self.popCompent = PopCommpent:new(go,LuaBehaviour,self)
    LuaBehaviour:AddClick(panel.FailRootBtn.gameObject, self._closeFail, self)
    LuaBehaviour:AddClick(panel.EvaRootBTn.gameObject, self._closeFail, self)
    LuaBehaviour:AddClick(panel.GoodRootBtn.gameObject, self._closeFail, self)
    self:closeAllRoot()

end
---====================================================================================点击函数==============================================================================================
--关闭失败
function RollCtrl:_closeFail(ins)
    ins:closeAllRoot()
end


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

function RollCtrl:handleEvaResult(data)
    if data then
        panel.resultRoot.localScale = Vector3.one
        panel.EvaRoots.localScale =  Vector3.one
        --panel.nowEva.text =
    else
        self:fail()
    end
end

function  RollCtrl:handleGoodsResult(data)
    if data then
        panel.resultRoot.localScale = Vector3.one
        panel.GoodRoot.localScale =  Vector3.one

        LoadSprite(Good[data[1]].ima,panel.ima)
        panel.nameText.text =  Good[data[1]].name

        if #data == 2  then
            LoadSprite(Good[data[2]].ima,panel.ima)
            panel.nameText.text = Good[data[2]].name
        elseif   #data == 3 then
            LoadSprite(Good[data[2]].ima,panel.child1Ima)
            panel.child1ImanNameText.text = Good[data[2]].name
            LoadSprite(Good[data[3]].ima,panel.child2Ima)
            panel.child2ImanNameText.text = Good[data[3]].name

        else
            LoadSprite(Good[data[2]].ima,panel.child1Ima)
            panel.child1ImanNameText.text = Good[data[2]].name
            LoadSprite(Good[data[3]].ima,panel.child2Ima)
            panel.child2ImanNameText.text = Good[data[3]].name
            LoadSprite(Good[data[4]].ima,panel.child3Ima)
            panel.child3ImanNameText.text = Good[data[3]].name
        end

    else
        self:fail()
    end
end

function RollCtrl:fail()
    panel.resultRoot.localScale = Vector3.one
    panel.FailRoot.localScale = Vector3.one
end

function RollCtrl:closeAllRoot()
    panel.EvaRoots.localScale = Vector3.zero
    panel.FailRoot.localScale = Vector3.zero
    panel.GoodRoot.localScale = Vector3.zero
    panel.resultRoot.localScale = Vector3.zero
end

function RollCtrl:changeLan()

end