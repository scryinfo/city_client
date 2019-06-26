---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/6/19 11:41
---
WalletModel = class("WalletModel",ModelBase)

local pbl = pbl
function WalletModel:initialize(insId)
    self.insId = insId
    self:OnCreate()
end

function WalletModel:OnCreate()
    --本地事件
    Event.AddListener("ReqCreateWallet",self.ReqCreateWallet,self)
    Event.AddListener("ReqCreateOrder",self.ReqCreateOrder,self)
    Event.AddListener("ReqDisChargeOrder",self.ReqDisChargeOrder,self)
    Event.AddListener("ReqDisCharge",self.ReqDisCharge,self)
    Event.AddListener("ReqValidationPhoneCode",self.ReqValidationPhoneCode,self)
    Event.AddListener("ReqDetails",self.ReqDetails,self)

    --网络事件
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","ct_createUser","ccapi.ct_createUser",self.ReceiveCreateWallet,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","ct_RechargeRequestReq","ccapi.ct_RechargeRequestRes",self.ReqTopUpSucceed,self)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","ct_DisPaySmVefifyReq","ccapi.ct_DisPaySmVefifyReq",self.ReqValidationPhoneCodeSuccees,self)
end

function WalletModel:Close()
    --本地事件
    Event.RemoveListener("ReqCreateWallet",self.ReqCreateWallet,self)
    Event.RemoveListener("ReqCreateOrder",self.ReqCreateOrder,self)
    Event.RemoveListener("ReqDisChargeOrder",self.ReqDisChargeOrder,self)
    Event.RemoveListener("ReqDisCharge",self.ReqDisCharge,self)
    Event.RemoveListener("ReqValidationPhoneCode",self.ReqValidationPhoneCode,self)
    Event.RemoveListener("ReqDetails",self.ReqDetails,self)

    --网络事件
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","ct_createUser","ccapi.ct_createUser",self.ReceiveCreateWallet,self)
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","ct_RechargeRequestReq","ccapi.ct_RechargeRequestRes",self.ReqTopUpSucceed,self)
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","ct_DisPaySmVefifyReq","ccapi.ct_DisPaySmVefifyReq",self.ReqValidationPhoneCodeSuccees,self)
end

---客户端请求----
--创建钱包
function WalletModel:ReqCreateWallet(userId,userName,pubKey)
    local msgId = pbl.enum("gscode.OpCode","ct_createUser")
    local lMsg ={PlayerId = userId,CreateUserReq={ReqHeader={Version = 1,ReqId = tostring(msgId),},CityUserId = userId,CityUserName = userName,PubKey=City.signer_ct.ToHexString(pubKey),PayPassword=''}}
    local pMsg = assert(pbl.encode("ccapi.ct_createUser", lMsg))
    local msgRet = assert(pbl.decode("ccapi.ct_createUser",pMsg), "pbl.decode decode failed")
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--生成充值订单
function WalletModel:ReqCreateOrder(userId,Amount)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","ct_GenerateOrderReq","ccapi.ct_GenerateOrderReq",self.ReceiveCreateOrder,self)
    self.Amount = tostring(Amount)
    local msgId = pbl.enum("gscode.OpCode","ct_GenerateOrderReq")
    local lMsg ={PlayerId = userId,ReqHeader = {Version = 1,ReqId = tostring(msgId),}}
    local pMsg = assert(pbl.encode("ccapi.ct_GenerateOrderReq", lMsg))
    --local msgRet = assert(pbl.decode("ccapi.ct_GenerateOrderReq",pMsg), "pbl.decode decode failed")
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--生成提币订单
function WalletModel:ReqDisChargeOrder(userId)
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","ct_GenerateOrderReq","ccapi.ct_GenerateOrderReq",self.ReceiveDisChargeOrder,self)
    local msgId = pbl.enum("gscode.OpCode","ct_GenerateOrderReq")
    local lMsg ={PlayerId = userId,ReqHeader = {Version = 1,ReqId = tostring(msgId),}}
    local pMsg = assert(pbl.encode("ccapi.ct_GenerateOrderReq", lMsg))
    local msgRet = assert(pbl.decode("ccapi.ct_GenerateOrderReq",pMsg), "pbl.decode decode failed")
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--充值
function WalletModel:ReqTopUp(userId,PurchaseId,PubKey,Amount,Ts,Signature)
    local msgId = pbl.enum("gscode.OpCode","ct_RechargeRequestReq")
    local lMsg ={PlayerId = userId,RechargeRequestReq={ReqHeader={Version = 1,ReqId = tostring(msgId),},PurchaseId = PurchaseId,PubKey=PubKey,Amount=Amount,ExpireTime=9,Ts=Ts,Signature = Signature}}
    local pMsg = assert(pbl.encode("ccapi.ct_RechargeRequestReq", lMsg))
    --local msgRet = assert(pbl.decode("ccapi.ct_RechargeRequestReq",pMsg), "pbl.decode decode failed")
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--提币
function WalletModel:ReqDisCharge(userId,PurchaseId,PubKey,EthAddr,Amount,Ts,Signature)
    local msgId = pbl.enum("gscode.OpCode","ct_DisChargeReq")
    local lMsg ={PlayerId = userId,DisChargeReq = {ReqHeader = {Version = 1,ReqId = tostring(msgId),},PurchaseId = PurchaseId,PubKey = PubKey,EthAddr = EthAddr,Amount = Amount,ExpireTime = 9,Ts = Ts,Signature = Signature}}
    local pMsg = assert(pbl.encode("ccapi.ct_DisChargeReq", lMsg))
    local msgRet = assert(pbl.decode("ccapi.ct_DisChargeReq",pMsg), "pbl.decode decode failed")
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end
--验证手机验证码
function WalletModel:ReqValidationPhoneCode(userId,authCode)
    local msgId = pbl.enum("gscode.OpCode","ct_DisPaySmVefifyReq")
    local lMsg ={PlayerId = userId,authCode = authCode}
    local pMsg = assert(pbl.encode("ccapi.ct_DisPaySmVefifyReq", lMsg))
    local msgRet = assert(pbl.decode("ccapi.ct_DisPaySmVefifyReq",pMsg), "pbl.decode decode failed")
    CityEngineLua.Bundle:newAndSendMsg(msgId, pMsg)
end

--订单详情
function WalletModel:ReqDetails(userId)
    --local currentTime = TimeSynchronized.GetTheCurrentTime()
    --local ts = getFormatUnixTime(currentTime)
    --if tonumber(ts.second) ~= 0 then
    --    currentTime = currentTime - tonumber(ts.second)
    --end
    --if tonumber(ts.minute) ~= 0 then
    --    currentTime = currentTime - tonumber(ts.second)
    --end

end

---服务器回调---
--创建钱包
function WalletModel:ReceiveCreateWallet(data)
    if data ~= nil then
        Event.Brocast("createWalletSucceed",data)
    end
end
--生成充值订单
function WalletModel:ReceiveCreateOrder(data)
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","ct_GenerateOrderReq","ccapi.ct_GenerateOrderReq",self.ReceiveCreateOrder,self)
    if data ~= nil then
        local serverNowTime = TimeSynchronized.GetTheCurrentServerTime()
        local privateKeyStr = self:parsing()
        local sm = City.signer_ct.New()
        local pubkey = sm.GetPublicKeyFromPrivateKey(privateKeyStr)
        local pubkeyStr = sm.ToHexString(pubkey)
        sm:pushSting(data.PurchaseId)
        sm:pushSting(self.Amount)
        --暂时发秒
        local second = math.ceil(serverNowTime)
        sm:pushLong(second)
        --生成签名(用于验证关键数据是否被篡改)
        local sig = sm:sign(privateKeyStr);
        self:ReqTopUp(data.PlayerId,data.PurchaseId,pubkeyStr,self.Amount,second,sm.ToHexString(sig))
    end
end
--生成提币订单
function WalletModel:ReceiveDisChargeOrder(data)
    DataManager.ModelRemoveNetMsg(nil,"gscode.OpCode","ct_GenerateOrderReq","ccapi.ct_GenerateOrderReq",self.ReceiveDisChargeOrder,self)
    if data ~= nil then
        Event.Brocast("reqDisChargeOrderSucceed",data)
    end
end
--充值成功
function WalletModel:ReqTopUpSucceed(data)
    if data ~= nil then
        Event.Brocast("reqTopUpSucceed",data)
    end
end
--验证手机验证码并通过
function WalletModel:ReqValidationPhoneCodeSuccees(data)
    if data ~= nil then
        Event.Brocast("ValidationPhoneCode",data)
    end
end
------------------------------------------------------------------------解析-----------------------------------------------------------------------------
--解析支付密码和私钥
function WalletModel:parsing()
    local passWordPath = CityLuaUtil.getAssetsPath().."/Lua/pb/passWard.data"
    local passWordStr = ct.file_readString(passWordPath)
    local privateKeyNewEncrypted = ct.GetPrivateKeyLocal(passWordStr)
    return privateKeyNewEncrypted
end