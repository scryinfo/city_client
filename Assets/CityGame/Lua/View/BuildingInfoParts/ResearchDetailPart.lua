---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/4/10/010 15:47
---
local pool={}
--临时对象池是做法
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
ResearchDetailPart = class('ResearchDetailPart', BasePartDetail)
local LuaBehaviour
local inventPrefab="View/Laboratory/InventGood"
---===================================================================================重写函数==============================================================================================

function ResearchDetailPart.PrefabName()
    return "ResearchDetailPart"
end
--
function ResearchDetailPart:_InitClick(mainPanelLuaBehaviour)
    LuaBehaviour=mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.xBtn.gameObject, self.OnXBtn, self)
    mainPanelLuaBehaviour:AddClick(self.goodsBtn.gameObject, self.onClick_good, self)
    mainPanelLuaBehaviour:AddClick(self.evaBtn.gameObject,self.onClick_eva, self)
    mainPanelLuaBehaviour:AddClick(self.setBtn.gameObject,self.onClick_set, self)
    mainPanelLuaBehaviour:AddClick(self.inventEva.gameObject,self.onClick_inventEva, self)
    mainPanelLuaBehaviour:AddClick(self.bgtitleQUNNE.gameObject,self.onClick_bgtitleQUNNE, self)

end
--
function ResearchDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:creatInvent()

    self:onClick_good(self)
    self:updateUI(data)
    self:updateLanguage()

end
--
function ResearchDetailPart:_InitTransform()
    Event.AddListener("c_UpdateInventSet",self.c_UpdateInventSet,self)

    local transform = self.transform
    self.xBtn = findByName(transform,"xBtn")

    self.goodsBtn =  findByName(transform,"goods")
    self.goodsBtnText =  findByName(transform,"foodBtnText"):GetComponent("Text")
    self.goods =  findByName(transform,"food")
    self.goodsText =  findByName(transform,"foodText"):GetComponent("Text")

    self.evaBtn=  findByName(transform,"eva")
    self.evaBtnText =  findByName(transform,"evaBtnText"):GetComponent("Text")
    self.evaIma =  findByName(transform,"evaIma")
    self.evaText =  findByName(transform,"evaText"):GetComponent("Text")

    self.bgtitleText =  findByName(transform,"bg-titleText"):GetComponent("Text")
    self.timesText =  findByName(transform,"timeText"):GetComponent("Text")
    self.timeCountText =  findByName(transform,"timeCountText"):GetComponent("Text")
    self.priceText =  findByName(transform,"priceText"):GetComponent("Text")
    self.priceCountText =  findByName(transform,"priceCountText"):GetComponent("Text")
    self.oodsText =  findByName(transform,"oodsText"):GetComponent("Text")
    self.oodsCountText =  findByName(transform,"oodsCountText"):GetComponent("Text")

    self.setBtn = findByName(transform,"set")
    self.inventGoodsRoot = findByName(transform,"Content")
    self.goodsRoot = findByName(transform,"goodsRoot")
    self.evaRoot = findByName(transform,"evaRoot")

    self.inventEva = findByName(transform,"inventEva")
    self.inventEvaText = findByName(transform,"inventEvaText"):GetComponent("Text")
    self.evaTips = findByName(transform,"evaTips"):GetComponent("Text")

    transform = findByName(transform,"bottomRoot")

    self.nameText = findByName(transform,"nameText"):GetComponent("Text")
    self.queneCountText = findByName(transform,"Text"):GetComponent("Text")

    self.timeText = findByName(transform,"timeText"):GetComponent("Text")
    self.dateText = findByName(transform,"dateText"):GetComponent("Text")

    self.bgtitleQUNNE = findByName(transform,"bg-titleQUNNE")
end

---===================================================================================研究所业务逻辑==============================================================================================
function ResearchDetailPart:updateUI(data)
    if data.info.ownerId == DataManager.GetMyOwnerID() then
        self.setBtn.localScale = Vector3.one
    else
        self.setBtn.localScale = Vector3.zero
    end

    --self.goods.localScale = Vector3.one
    --self.evaIma.localScale = Vector3.zero

    self:onClick_good(self)

    self.timeCountText.text = data.sellTimes
    self.priceCountText.text = GetClientPriceString(data.pricePreTime)

    if data.inProcess then
        self.queneCountText.text = #( data.inProcess )
        local reminderTime=0
        for i, lineData in ipairs(data.inProcess) do

            reminderTime = reminderTime + ((lineData.times-(lineData.availableRoll+lineData.usedRoll))*3600000)
        end

        local ts = getFormatUnixTime((TimeSynchronized.GetTheCurrentServerTime()+ reminderTime)/1000)
        self.dateText.text = ts.hour..":"..ts.minute.." ".. ts.month.."/"..ts.day.."/"..ts.year
    else
        self.queneCountText.text = 0
        local ts = getFormatUnixTime(TimeSynchronized.GetTheCurrentServerTime()/1000)
        self.dateText.text = ts.hour..":"..ts.minute.." ".. ts.month.."/"..ts.day.."/"..ts.year

    end

end

function ResearchDetailPart:creatInvent()
    InsAndObjectPool(InventConfig,InventItem,inventPrefab,self.inventGoodsRoot,LuaBehaviour,self)
end
--切换Root
function ResearchDetailPart:switchRoot(panelTrans)
    if self.panelTrans then
        self.panelTrans.localScale = Vector3.zero
    end
    panelTrans.localScale = Vector3.one
    self.panelTrans=panelTrans
end

function ResearchDetailPart:updateLanguage()
    --self.timesText
    --self.priceText
    --self.oodsText
    --self.nameText
    --self.timeText

    --self.goodsBtnText
    --self.goodsText
    --self.evaBtnText
    --self.evaText
    --self.bgtitleText
    --self.inventEvaText
end

---===================================================================================释放==============================================================================================
function ResearchDetailPart:_RemoveClick()
    --self.xBtn.onClick:RemoveAllListeners()
end
--
function ResearchDetailPart:_RemoveEvent()

end
---===================================================================================点击函数==============================================================================================
function ResearchDetailPart:OnXBtn(ins)
    ins.groupClass.TurnOffAllOptions(ins.groupClass)
end
--研究物品
function ResearchDetailPart:onClick_good(ins)
    ins:switchRoot(ins.goodsRoot)
    ins.type="good"
    ins.evaRoot.localScale = Vector3.zero
    ins.goods.localScale = Vector3.one
    ins.evaIma.localScale = Vector3.zero
    ins.oodsCountText.text = tostring(ins.m_data.probGood).."%"
end
--研究eva
function ResearchDetailPart:onClick_eva(ins)
    ins:switchRoot(ins.evaRoot)
    ins.type="eva"
    ins.goods.localScale = Vector3.zero
    ins.evaIma.localScale = Vector3.one
    ins.oodsCountText.text = tostring(ins.m_data.probEva).."%"
end
--设置
function ResearchDetailPart:onClick_set(ins)
    local data={ins = ins,func = function(Ins)
        local price = Ins.ctrl.price
        local count = Ins.ctrl.count
        local isopen = Ins.ctrl.isOpen
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSettings',isopen)
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_labSetting',GetServerPriceNumber(price),count)
    end  }

    ct.OpenCtrl("InventSetPopCtrl",data)
end

--研究eva
function ResearchDetailPart:onClick_inventEva(ins)
    ins.buildInfo = ins.m_data.info
    local data={ins = ins,func = function(Ins)
        local count = Ins.ctrl.count
        if count == nil then
            return
        end
        if not count or count <= 0 then
                return
         end
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_ReqLabAddLine',nil,count)
    end  }

    ct.OpenCtrl("InventPopCtrl",data)
end
--跟新设置
function ResearchDetailPart:c_UpdateInventSet(times,price)
    self.timeCountText.text = times
    self.priceCountText.text = GetClientPriceString(price)
end

function ResearchDetailPart:onClick_bgtitleQUNNE(ins)
    ct.OpenCtrl("QueneCtrl",{name = "View/Laboratory/InventGoodQueneItem",data = ins.m_data.inProcess ,insClass=InventGoodQueneItem}  )
end
