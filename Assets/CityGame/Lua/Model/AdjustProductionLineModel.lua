local pbl = pbl

AdjustProductionLineModel = {}
local this = AdjustProductionLineModel;

--构建函数
function AdjustProductionLineModel.New()
    return this;
end

function AdjustProductionLineModel.Awake()
    this:OnCreate();
end

--启动事件
function AdjustProductionLineModel.OnCreate()
    --注册本地事件
    Event.AddListener("m_OnDetermineBtn",this.m_OnDetermineBtn);

    ----注册 AccountServer 消息
    AdjustProductionLineModel.registerAsNetMsg()
end

function AdjustProductionLineModel.registerAsNetMsg()
    --网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addLine"),AdjustProductionLineModel.n_GsDetermineBtn);

end
--客户端请求--

--确定生产
function AdjustProductionLineModel.m_OnDetermineBtn(number,steffNumber,itemId)
    local msgId = pbl.enum("gscode.OpCode", "addLine")
    local lMsg = {id = PlayerTempModel.roleData.id, itemId = itemId, targetNum = number, workerNum = steffNumber}
    local pMsg = assert(pbl.encode("gs.AddLine", lMsg))
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end

--服务器回调--

--确定生产
function AdjustProductionLineModel.n_GsDetermineBtn(stream)
    local msgAllGameServerInfo = assert(pbl.decode("gs.AddLine", stream), "LoginModel.n_AllGameServerInfo: stream == nil")

end