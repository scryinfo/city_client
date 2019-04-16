---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/11/27 17:10
---
LaboratoryModel = class('LaboratoryModel',ModelBase)
local pbl = pbl

function LaboratoryModel:initialize(insId)
    self.insId = insId
    self:_addListener()
    --UpdateBeat:Add(self.Update, self)

end

function LaboratoryModel:Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.L) then
        self:m_ReqLabDeleteLine(self.data.inProcess[1].id)
    end
end

--启动事件--
function LaboratoryModel:_addListener()
    --网络回调注册
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","detailLaboratory","gs.Laboratory",self.n_OnReceiveLaboratoryDetailInfo,self)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labExclusive","gs.LabExclusive",self.n_OnReceiveLabExclusive,self)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labAddLine","gs.LabAddLineACK",self.n_OnReceiveLabLineAdd,self)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labCancelLine","gs.LabCancelLine",self.n_OnReceiveDelLine,self);
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labRoll","gs.LabRollACK",self.n_OnReceiveLineChange,self)
    DataManager.ModelRegisterNetMsg(self.insId,"gscode.OpCode","labLineChangeInform","gs.LabLineInform",self.n_OnReceivelabLineChangeInform,self)

    ------本地的事件注册
    --Event.AddListener("m_ReqLaboratoryDetailInfo", self.m_ReqLaboratoryDetailInfo, self)
    --Event.AddListener("m_labSetting", self.m_labSetting, self)
    --Event.AddListener("m_ReqLabAddLine", self.m_ReqLabAddLine, self)
    --Event.AddListener("m_ReqLabDeleteLine", self.m_ReqLabDeleteLine, self)
    --Event.AddListener("m_ReqLabRoll", self.m_ReqLabRoll, self)

end

---===================================================================================客户端请求===============================================================================
--获取建筑详情
function LaboratoryModel:m_ReqLaboratoryDetailInfo()
    DataManager.ModelSendNetMes("gscode.OpCode", "detailLaboratory","gs.Id",{ id = self.insId})
end
--关闭研究所详情推送
function LaboratoryModel:mReqCloseRetailStores()
    DataManager.ModelSendNetMes("gscode.OpCode","stopListenBuildingDetailInform","gs.Id",{id =  self.insId})
end
--设置研究是否他人可用
function LaboratoryModel:m_labSettings(exclusive)
    DataManager.ModelSendNetMes("gscode.OpCode", "labExclusive","gs.LabExclusive",
            { buildingId = self.insId ,exclusive = exclusive})
end
--设置研究价格
function LaboratoryModel:m_labSetting( pricePreTime , sellTimes )
    DataManager.ModelSendNetMes("gscode.OpCode", "labSetting","gs.LabSetting",
            { buildingId = self.insId ,pricePreTime = pricePreTime, sellTimes = sellTimes})
end
--添加线
function LaboratoryModel:m_ReqLabAddLine( itemId, count )
    DataManager.ModelSendNetMes("gscode.OpCode", "labAddLine","gs.LabAddLine",
            { buildingId = self.insId,goodCategory = itemId,times = count })
end
--删除线
function LaboratoryModel:m_ReqLabDeleteLine(lineId)
    local lMsg = { buildingId = self.insId, lineId = lineId }
    DataManager.ModelSendNetMes("gscode.OpCode", "labCancelLine","gs.LabCancelLine",lMsg)
end
--开箱
function LaboratoryModel:m_ReqLabRoll(lineId)
    local lMsg = { buildingId = self.insId, lineId = lineId }
    DataManager.ModelSendNetMes("gscode.OpCode", "labRoll","gs.LabRoll",lMsg)
end
---===================================================================================回调===============================================================================
--研究所详情
function LaboratoryModel:n_OnReceiveLaboratoryDetailInfo(data)
    self.data=data
    if data.completed  then
        if not data.inProcess then
            data.inProcess={}
        end
        for i, v in ipairs(data.completed) do
             table.insert( data.inProcess ,v )
        end
    end
    DataManager.ControllerRpcNoRet(self.insId,"LaboratoryCtrl", '_receiveLaboratoryDetailInfo', data)
end
--研究所设置
function LaboratoryModel:n_OnReceiveLabExclusive(LabExclusive)
    prints("他人可用")
end
--添加研究发明线
function LaboratoryModel:n_OnReceiveLabLineAdd(msg)
    if not self.data.inProcess then
        self.data.inProcess = {}
    end
    table.insert(self.data.inProcess,msg.line)
    ct.OpenCtrl("QueneCtrl",{name = "View/Laboratory/InventGoodItem",data = self.data.inProcess}  )
end
--删除line
function LaboratoryModel:n_OnReceiveDelLine(lineData)
    for i,line in ipairs(self.data.inProcess) do
        if line.id == lineData.lineId and DataManager.GetMyOwnerID() == line.proposerId then
            table.remove(self.data.inProcess,i)
        end
    end

    Event.Brocast("c_updateQuque",{data = self.data.inProcess,name = "View/Laboratory/InventGoodItem"})
end
--开箱
function LaboratoryModel:n_OnReceiveLineChange(lineData)
    prints("开箱回调")
    if lineData .itemId or  lineData .evaPoint then
        prints("成功")
    end
end
--更新箱子
function LaboratoryModel:n_OnReceivelabLineChangeInform(lineData)
    prints("更新箱子")
    for i, v in ipairs(self.data.inProcess) do
        if v.id == lineData.line.id  then
            self.data.inProcess[i]=lineData.line
            Event.Brocast("c_updateQuque",{data = self.data.inProcess,name = "View/Laboratory/InventGoodItem"})
            Event.Brocast("c_creatRollItem",lineData.line)
            return
        end
    end
end