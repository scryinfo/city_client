

--研究所掷点界面ctrl
local pool={}
local LuaBehaviour
local odds
local proodds
local sums = 0
local isUpdata
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
    return "Assets/CityGame/Resources/View/RollPanel.prefab"
end

function RollCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end
function RollCtrl:Hide()
    UIPanel.Hide(self)
    --InsAndObjectPool(datas,RollItem,prefabPath,panel.scrolParent, self.LuaBehaviour,self)
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
    data.titleName = GetLanguage(28040018)
    if data.goodCategory ~= 0 then  --食物
        Event.AddListener("c_InventResult",self.handleGoodsResult,self)
        panel.EvaRoot.localScale = Vector3.zero
        panel.GoodRoot.localScale = Vector3.one
    else
        panel.EvaRoot.localScale = Vector3.one
        panel.GoodRoot.localScale = Vector3.zero
        Event.AddListener("c_InventResult",self.handleEvaResult,self)
    end
    self:updateText(data)
    self.popCompent:Refesh(data)
    self:c_creatRollItem(data,data.titleName)
    self:updateText(data)
end

--function RollCtrl:UpData()
--    self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
--    if self.currentTime >= data.beginProcessTs and self.currentTime <= data.beginProcessTs + data.times*3600000  then
--            if not isUpdata then
--                return
--            end
--            if panel.closeEvaBTn:Equals(nil) then
--                return
--            end
--            --倒计时
--            self.waiting = self.waiting -1
--            if self.waiting <= 0 then
--                self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
--                local ts =getTimeBySec( (self.currentTime - self.data.beginProcessTs)/1000)
--                panel.Remainingtime.text = "00".. ":" .. ts.minute .. ":" .. ts.second .. "/" .. math.floor(self.data.times).. "h"
--                self.waiting = 1
--            end
--    else
--        panel.Remainingtime.text = nil
--    end
--end
function RollCtrl:Awake(go)
    panel = RollPanel
    isUpdata = true
    self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.LuaBehaviour=LuaBehaviour
    self.popCompent = PopCommpent:new(go,LuaBehaviour,self)
    LuaBehaviour:AddClick(panel.FailRootBtn.gameObject, self._closeFail, self)
    LuaBehaviour:AddClick(panel.EvaRootBTn.gameObject, self._closeFail, self)
    LuaBehaviour:AddClick(panel.GoodRootBtn.gameObject, self._closeFail, self)
    LuaBehaviour:AddClick(panel.EvaresultBtn.gameObject, self._closeAll, self)
    LuaBehaviour:AddClick(panel.resultBtn.gameObject, self._closenotenough, self)
    LuaBehaviour:AddClick(panel.closeEvaBTn.gameObject, self._closeEvaBTn, self)
    --LuaBehaviour:AddClick(panel.leftButton.gameObject, self._leftButton, self)
    --LuaBehaviour:AddClick(panel.rightButton.gameObject, self._rightButton, self)
    --LuaBehaviour:AddClick(panel.closeBTn.gameObject, self._closeEva, self)
    self:closeAllRoot()
    self:language()

end
---====================================================================================点击函数==============================================================================================
--关闭失败
function RollCtrl:_closeFail(ins)
    ins:closeAllRoot()
end

function RollCtrl:_closeEva(ins)
    panel.Evaresult.localScale = Vector3.zero
    panel.EvaRoots.localScale = Vector3.one
end


function RollCtrl:_closeAll(ins)
    --及时销毁产生的item
    for i = 0, 4 do
        destroy(panel.Evaresult:GetChild(i).gameObject)
        panel.resultRoot.localScale =  Vector3.one
        panel.result.localScale =  Vector3.one
    end
    --eva开箱结果界面文本更新（0为失败+1 1为成功+10）
    for i = 1, #ins.data do
        if ins.data[i] == 0 then
            sums = sums + 1
            panel.sum.text = sums
        else
            sums = sums + 10
            panel.sum.text = sums
        end
    end
    panel.count.text = DataManager.GetEvaPoint()
    sums = 0
end

function RollCtrl:_closenotenough(ins)
    panel.result.localScale = Vector3.zero
    panel.resultRoot.localScale = Vector3.zero
end

function RollCtrl:_closeEvaBTn(ins)
    panel.evanotenough.localScale = Vector3.zero
    panel.result.localScale = Vector3.zero
    panel.resultRoot.localScale = Vector3.zero

end

--function RollCtrl:_leftButton(ins)
--
--end
--
--function RollCtrl:_rightButton(ins)
--
--end


---====================================================================================业务逻辑==============================================================================================
--多语言
function RollCtrl:language()
    panel.count1.text = GetLanguage(28040024)
    panel.count2.text = GetLanguage(28040024)
    panel.nametexts.text = GetLanguage(28040049)
    --panel.evanametexts.text = GetLanguage(28040024)
    panel.congratulation1.text = GetLanguage(28040020)
    panel.congratulation2.text = GetLanguage(28040020)
    panel.failtitleText.text = GetLanguage(28040023)
    panel.failtitle.text = GetLanguage(28040021)
    --panel.titleTexts.text = GetLanguage(28040018)
    --panel.achievement.text = GetLanguage(28040044)
    --panel.Remainingtime.text = GetLanguage(28040044)

end

--通过服务器回调数据生成item
function RollCtrl:c_creatRollItem( data )
    local moedelData = DataManager.GetDetailModelByID(LaboratoryCtrl.static.insId).data
    if data.goodCategory == 0 then
        odds = moedelData.probEva
        proodds = moedelData.probEvaAdd
    else
        odds = moedelData.probGood
        proodds = moedelData.probGoodAdd
    end
    self.datas = {}
    for i = 1, data.availableRoll do
        table.insert( self.datas,{ lineId = data.id ,odds = odds ,availableRoll = data.availableRoll, oddAdd = proodds} )
    end

    --panel.notenough.localScale = Vector3.one
    --InsAndObjectPool(self.datas,RollItem,prefabPath,panel.scrolParent, self.LuaBehaviour,self)

    InsAndObjectPool(self.datas,RollItem,prefabPath,panel.scrolParent, self.LuaBehaviour,self)
    panel.totalText.text = data.availableRoll
end

--设置item名称（区分商品 服饰 以及 eva）
function RollCtrl:updateText(data)
    if data.goodCategory == 52 then
        panel.evanametexts.text = GetLanguage(28040053)
        panel.BigEVAtext.transform.localScale = Vector3.zero
        panel.food.localScale = Vector3.zero
        panel.icon.localScale = Vector3.zero
        panel.cloth.localScale = Vector3.one
    elseif data.goodCategory == 51 then
        panel.evanametexts.text = GetLanguage(28040052)
        panel.BigEVAtext.transform.localScale = Vector3.zero
        panel.cloth.localScale = Vector3.zero
        panel.icon.localScale = Vector3.zero
        panel.food.localScale = Vector3.one
    elseif  data.goodCategory == 0 then
        panel.evanametexts.text = GetLanguage(28040024)
        panel.BigEVAtext.transform.localScale = Vector3.one
        panel.icon.localScale = Vector3.one
        panel.cloth.localScale = Vector3.zero
        panel.food.localScale = Vector3.zero
        panel.BigEVAtext.text = DataManager.GetEvaPoint()
    else
        return
    end
    --panel.evacounts.text = DataManager.GetEvaPoint()
end

--点击一次item开启五个宝箱
function RollCtrl:handleEvaResult(data)
    self.Rollpoint = {}
    self.data = data
    panel.Evaresultbg.localScale = Vector3.one
    panel.Evaresult.localScale = Vector3.one
    panel.resultRoot.localScale = Vector3.one
    for i, v in ipairs(data) do
        if v == 0 then
            local function callback(prefab)
                self.Rollpoint[i] = Failitem:new(prefab,LuaBehaviour)
            end
            createPrefab("Assets/CityGame/Resources/View/Laboratory/failitem.prefab",panel.Evaresult,callback)
            panel.nowEva.text = DataManager.GetEvaPoint()
            DataManager.SetEvaPoint(DataManager.GetEvaPoint()+1)
            panel.BigEVAtext.text = DataManager.GetEvaPoint()
        elseif v == 1 then
            local function callback(prefab)
                self.Rollpoint[i] = Successitem:new(prefab,LuaBehaviour)
            end
            createPrefab("Assets/CityGame/Resources/View/Laboratory/successitem.prefab",panel.Evaresult,callback)
            panel.nowEva.text = DataManager.GetEvaPoint()
            DataManager.SetEvaPoint(DataManager.GetEvaPoint()+10)
            panel.BigEVAtext.text = DataManager.GetEvaPoint()
        end
    end
    panel.evacount.text = DataManager.GetEvaPoint()
end

--设置食物以及服饰研究成功时界面
function  RollCtrl:handleGoodsResult(data)
    if data then
        panel.resultRoot.localScale = Vector3.one
        panel.GoodRoot.localScale =  Vector3.one
        panel.Evaresultbg.localScale = Vector3.zero
        LoadSprite(Good[data[1]].img,panel.ima)
        panel.nameText.text =  Good[data[1]].name
        --panel.count.text =

        if #data == 2  then
            panel.child1.localScale = Vector3.one

            LoadSprite(Good[data[2]].img,panel.ima)
            panel.child1ImanNameText.text = Good[data[2]].name
        elseif   #data == 3 then
            panel.child1.localScale = Vector3.one
            panel.child2.localScale = Vector3.one


            LoadSprite(Good[data[2]].img,panel.child1Ima)
            panel.child1ImanNameText.text = Good[data[2]].name
            LoadSprite(Good[data[3]].img,panel.child2Ima)
            panel.child2ImanNameText.text = Good[data[3]].name

        elseif  #data == 4 then
            panel.child1.localScale = Vector3.one
            panel.child2.localScale = Vector3.one
            panel.child3.localScale = Vector3.one

            LoadSprite(Good[data[2]].img,panel.child1Ima)
            panel.child1ImanNameText.text = Good[data[2]].name
            LoadSprite(Good[data[3]].img,panel.child2Ima)
            panel.child2ImanNameText.text = Good[data[3]].name
            LoadSprite(Good[data[4]].img,panel.child3Ima)
            panel.child3ImanNameText.text = Good[data[3]].name
        end

    else
        self:fail()
    end
end

--研究失败
function RollCtrl:fail()
    panel.resultRoot.localScale = Vector3.one
    panel.FailRoot.localScale = Vector3.one
end

--关闭所有节点
function RollCtrl:closeAllRoot()
    panel.EvaRoots.localScale = Vector3.zero
    panel.FailRoot.localScale = Vector3.zero
    panel.GoodRoot.localScale = Vector3.zero
    panel.resultRoot.localScale = Vector3.zero

    panel.child1.localScale = Vector3.zero
    panel.child2.localScale = Vector3.zero
    panel.child3.localScale = Vector3.zero
end

function RollCtrl:changeLan()

end

--关闭界面后关闭更新
function RollCtrl:CloseUpdata()
    isUpdata = false
end