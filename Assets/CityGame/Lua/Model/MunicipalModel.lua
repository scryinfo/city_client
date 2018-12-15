---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/23/023 11:28
---
local pbl = pbl

require "Common/define"
require "City"

MunicipalModel = {};
local this = MunicipalModel;

--构建函数
function MunicipalModel.New()
    return this;
end

function MunicipalModel.Awake()
    this:OnCreate();
    this.SlotList={}
    UpdateBeat:Add(this.Update, this)
    this.manger=ItemCreatDeleteMgr:new()
end




function MunicipalModel:OnCreate()

    --注册本地事件
    Event.AddListener("m_detailPublicFacility", this.m_detailPublicFacility,self);--广告细节
    Event.AddListener("m_addSlot", this.m_addSlot,self);--添加槽位
    Event.AddListener("m_deleteSlot",this.m_deleteSlot,self)--删除槽位
    Event.AddListener("m_adPutAdToSlot",this.m_adPutAdToSlot,self)--打广告
    Event.AddListener("m_Setticket",this.m_Setticket,self)--设置门票
    Event.AddListener("m_SetSlot",this.m_SetSlot,self)--设置槽位
    Event.AddListener("m_DelAdFromSlot",this.m_DelAdFromSlot,self)--删广告
    Event.AddListener("m_buySlot",this.m_buySlot,self)--买槽位


    ----注册 AccountServer 消息
    MunicipalModel.registerAsNetMsg()
end

function MunicipalModel.registerAsNetMsg()
    --as网络回调注册
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","detailPublicFacility"),MunicipalModel.n_getdetailPublicFacility);--广告细节
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adAddSlot"),MunicipalModel.n_getaddSlot);--添加槽位
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adDelSlot"),MunicipalModel.n_deleteSlot);--删除槽位
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adPutAdToSlot"),MunicipalModel.n_adPutAdToSlot);--打广告
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adSetSlot"),MunicipalModel.n_getSetSlot);--设置槽位
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adSlotTimeoutInform"),MunicipalModel.n_getadSlotTimeoutInform);--槽位过期
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adDelAdFromSlot"),MunicipalModel.n_getdeleteSlot);--删广告
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","adBuySlot"),MunicipalModel.n_getBuySlot);--删广告
end

--关闭事件--
function MunicipalModel.Close()
    --清空本地UI事件
    Event.RemoveListener("m_detailPublicFacility", this.m_detailPublicFacility);
end
---广告细节发包

function MunicipalModel:m_detailPublicFacility(buildingID)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","detailPublicFacility")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { id=buildingID}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.Id", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end
---广告细节收包
function MunicipalModel.n_getdetailPublicFacility(stream)
    local lMsg = assert(pbl.decode("gs.PublicFacility",stream),"广告细节收包失败")

    this.SlotList={}
    if  lMsg.ad.availableSlot then
        for i, v in pairs(lMsg.ad.availableSlot) do
            this.SlotList[i]=v
        end
    end
    if lMsg.ad.soldSlot then
        for i, v in pairs(lMsg.ad.soldSlot) do
            for k, s in pairs(this.SlotList) do
                if s.id==v.s.id then
                    table.remove(this.SlotList,k)
                end
            end
        end
    end
    MunicipalModel.ticket=lMsg.ticketPrice;
    MunicipalModel.lMsg=lMsg
    MunicipalModel.owenerId=PlayerTempModel.roleData.id
    MunicipalModel.buildingOwnerId=lMsg.info.ownerId

    if MunicipalModel.manger.isFirst then
        Event.Brocast("c_FirstCreate")
    end
    MunicipalModel.manger.isFirst=false
end

---添加槽位发包
function MunicipalModel:m_addSlot(buildingID,minDayToRent,maxDayToRent,rentPreDay)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adAddSlot")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId=buildingID,minDayToRent=minDayToRent,maxDayToRent=maxDayToRent,rentPreDay=rentPreDay}--/*,deposit=deposit/*}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AddSlot", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end
---添加槽位收包
function MunicipalModel.n_getaddSlot(stream)

   -- local lMsg = assert(pbl.decode("gs.Advertisement.Slot", stream),"添加槽位收包失败")
    Event.Brocast("m_detailPublicFacility",MunicipalModel.lMsg.info.id)
end

---删除槽位发包
function MunicipalModel:m_deleteSlot(buildingId,slotId)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adDelSlot")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId=buildingId,slotId=slotId}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AdDelSlot", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

---删除槽位收包
function MunicipalModel.n_deleteSlot(stream)

    --local lMsg = assert(pbl.decode("gs.success", stream),"LoginModel.n_GsLoginSuccessfully stream == nil")
    Event.Brocast("m_detailPublicFacility",MunicipalModel.lMsg.info.id)
end

---打广告发包
function MunicipalModel:m_adPutAdToSlot(Slotid,metaId,type,buildingId)
    --local tp = pbl.enum("gs.PublicFacility.Ad.Type", "BUILDING")
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adPutAdToSlot")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = {id=Slotid ,metaId=metaId,type=type,buildingId=buildingId}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AddAd", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

---打广告收包
function MunicipalModel.n_adPutAdToSlot(stream)
    local lMsg = assert(pbl.decode("gs.Advertisement.Ad", stream),"打广告收包失败")

        if not this.manger.adList[lMsg.metaId] then
            this.manger.adList[lMsg.metaId]={}
            --this.manger:_creatserverMapAdvertisementItem(lMsg)
            --this.manger.serverMapAdvertisementINSList[lMsg.metaId].numtext.text=this.manger.MapAdvertisementINSList[lMsg.metaId].numtext.text
        end
        table.insert(this.manger.adList[lMsg.metaId],lMsg)
end

---设置门票发包
function MunicipalModel:m_Setticket(buildingId,price)
    --local tp = pbl.enum("gs.PublicFacility.Ad.Type", "BUILDING")

    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adSetTicket")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId=buildingId,price=price}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AdSetTicket", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

---设置槽位发包
function MunicipalModel:m_SetSlot(buildingId,slotId,rent,minDayToRent,maxDayToRent)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adSetSlot")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId=buildingId,slotId=slotId,rentPreDay=rent,minDayToRent=minDayToRent,maxDayToRent=maxDayToRent}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AdSetSlot", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end

---设置槽位收包
function MunicipalModel.n_getSetSlot(stream)
    local lMsg = assert(pbl.decode("gs.AdSetSlot", stream),"设置槽位收包失败")
    local t =self
end

---槽位过期收包
function MunicipalModel.n_getadSlotTimeoutInform(stream)
    local lMsg = assert(pbl.decode("gs.PublicFacility.Slot.id", stream),"槽位过期收包失败")
end

---删广告发包
function MunicipalModel:m_DelAdFromSlot(buildingID,adid)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adDelAdFromSlot")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId=buildingID,adId=adid}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AdDelAdFromSlot", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
    local t=self
end
---删广告收包
function MunicipalModel.n_getdeleteSlot(stream)
    local lMsg = assert(pbl.decode("gs.AdDelAdFromSlot", stream),"删广告收包收包失败")

end

---购买槽位发包
function MunicipalModel:m_buySlot(buildingId,slotId,day)
    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","adBuySlot")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { buildingId=buildingId,slotId=slotId,day=day}
    ----3、 序列化成二进制数据
    local  pMsg = assert(pbl.encode("gs.AdBuySlot", lMsg))
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
end
---购买槽位收包
function MunicipalModel.n_getBuySlot(stream)
    ---购买槽位成功
    Event.Brocast("SmallPop","Successful adjustment",57)
end




function MunicipalModel.Update()
        --if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.E) then
        --    Event.Brocast("m_buySlot",MunicipalModel.lMsg.info.id,this.SlotList[23].id,3)
        --    ct.log("system","#############################################")
        --end
end













