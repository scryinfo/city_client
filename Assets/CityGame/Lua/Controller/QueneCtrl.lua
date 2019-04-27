---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/25/025 17:50
---

---====================================================================================框架函数==============================================================================================

QueneCtrl = class('QueneCtrl',UIPanel)
UIPanel:ResgisterOpen(QueneCtrl) --注册打开的方法
--构建函数
function QueneCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function QueneCtrl:bundleName()
    return "Assets/CityGame/Resources/View/QuenePanel.prefab"
end

function QueneCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end

local panel,luabehaviour,this

--todo：刷新
function QueneCtrl:Refresh()

    Event.AddListener("c_updateQuque",self.c_updateQuque,self)
    self:ChangeLanguage()

    self:c_updateQuque(self.m_data)
end


function QueneCtrl:Awake(go)
    panel = QuenePanel
    this=self
    luabehaviour = self.gameObject:GetComponent('LuaBehaviour');
    luabehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);

    self.loopScrollDataSource = UnityEngine.UI.LoopScrollDataSource.New()
    self.loopScrollDataSource.mProvideData =self.ReleaseData
    self.loopScrollDataSource.mClearData = self.CollectClearData


end

---====================================================================================点击函数==============================================================================================


--返回
function QueneCtrl:OnClick_backBtn(ins)
    UIPanel.ClosePage()
    PlayMusEff(1002)
end


---====================================================================================业务代码==============================================================================================
--对数据处理
local function handleData( data )
   local reminderTime = TimeSynchronized.GetTheCurrentServerTime()

    local mselfData,others={},{}
   table.sort(data,function (a,b)  return a.createTs <  b.createTs end)

    --处理时间
    if data[1].availableRoll then
        for i, lineData in ipairs(data) do
            if lineData.beginProcessTs == 0  then
                lineData.queneTime = reminderTime
            else
                lineData.queneTime = lineData.beginProcessTs
            end
            reminderTime = reminderTime + (lineData.times* 3600000)
        end
    end

    --自已的置顶
    for i, lineData in ipairs(data) do
        if lineData.proposerId == DataManager.GetMyOwnerID()   then
            table.insert(mselfData,lineData)
        else
            table.insert(others,lineData)
        end
    end
    for i, lineData in ipairs(others) do
        table.insert(mselfData,lineData)
    end

    return mselfData
end

--多语言
function QueneCtrl.ChangeLanguage()
    --panel.topicText
    --panel.buildingInfoText
    --panel.buildingSelectedInfoText
    --panel.landInfomationText
    --panel.landInfomationSelectedText
    --panel.buildTimeNameText
    --panel.buyTimeNameText
    --panel.ownerRentNameText
    --panel.operatorText.text=GetLanguage(40010002)
    --panel.groundInfoText.text=GetLanguage(40010001)
    --panel.scaleText.text=GetLanguage(40010003)
    --panel.constructText.text=GetLanguage(40010004)
    --panel.tips.text=GetLanguage(40010007)
    --panel.dateText.text=GetLanguage(40010005)
    --panel.dailyRentText.text=GetLanguage(40010006)
    --panel.depositText.text=GetLanguage(40010017)
    --panel.stopText.text=GetLanguage(40010016)
end

--刷新队列
function QueneCtrl:c_updateQuque(data)
    if data.data  then
        if data.func then
            self.m_data.data = data.func(data.ins,data.data)
        else
            self.m_data.data = handleData(data.data)
        end

        panel.loopScrol:ActiveLoopScroll(self.loopScrollDataSource, #self.m_data.data,data.name)

    else
        panel.loopScrol:ActiveLoopScroll(self.loopScrollDataSource, 0,data.name)
    end
end



function QueneCtrl.ReleaseData(transform, idx)
    idx = idx + 1
    local data=  this.m_data.data[idx]
    this.m_data.insClass:new(data, transform,luabehaviour)
end

function QueneCtrl.CollectClearData(transform)

end