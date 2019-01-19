require "bit"
require "Message"
local log = log
-----------------------------------------------------------------------------------------
--												bundle
-----------------------------------------------------------------------------------------*/
CityEngineLua.Bundle = {}

--[[
newAndSendMsg:
	1、 msgId：
		协议id， 比如 pb.asCode_pb.login
			proto25\asCode.proto 中定义了协议类型及ID， OpCode 这个枚举中的每一个标识符都对应一个协议类型，其枚举值代码协议的id

	2、 pb_buffer：
		protobuf 协议数据序列化之后的 stream 字节流
		proto25\as.proto 定义具体的协议数据结构， 每个协议数据对应 asCode.proto 中 OpCode 的一个标识符
]]--
function CityEngineLua.Bundle:newAndSendMsg(msgId, pb_buffer)
	local bundle = self:newNetMsg(msgId, pb_buffer);
	bundle:send();
	return bundle;
end

function CityEngineLua.Bundle:newAndSendMsgExt(msgId, pb_buffer, netInterface)
	local bundle = self:newNetMsg(msgId, pb_buffer);
	bundle:sendimp(netInterface);
	return bundle;
end

function CityEngineLua.Bundle:newNetMsg(msgId, pb_buffer)
	local bundle = CityEngineLua.Bundle:new();
	local msg = CityEngineLua.Message:newNetMsg(msgId);
	bundle:newMessage(msg);

	if pb_buffer then
		bundle:writeInt32(#pb_buffer);
		bundle:writeInt16(msgId);
		bundle:writeBytes(pb_buffer);
	else
		bundle:writeInt32(0);
		bundle:writeInt16(msgId);
	end

	return bundle;
end
function CityEngineLua.Bundle:new()
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me.streamList = {};
	me.stream = City.MemoryStream.New();
	me.numMessage = 0;
	me.messageLength = 0;	
	me.msgtype = nil;
	me._curMsgStreamIndex = 0;

    return me;
end

---------------------------------------------------------------------------------
function CityEngineLua.Bundle:newMessage(mt)
	self:fini(false);
	
	self.msgtype = mt;
	self.numMessage = self.numMessage + 1;

	--现在已经调整了包的顺序，第一个是包体长度，之后才是id； 这里不能写入id
	--self:writeUint16(self.msgtype.id);
	
	--if(self.msgtype.msglen == -1) then
	--	self:writeUint16(0);
	--	self.messageLength = 0;
	--end

	self._curMsgStreamIndex = 0;
end

---------------------------------------------------------------------------------
function CityEngineLua.Bundle:writeMsgLength()

	if(self.msgtype.msglen ~= -1) then
		return;
	end

	local stream = self.stream;
	if(self._curMsgStreamIndex > 0) then
		stream = self.streamList[#self.streamList - self._curMsgStreamIndex];
	end

	local data = stream:data();

	data[2] = bit.band(self.messageLength, 0xff);
	data[3] = bit.band(bit.rshift(self.messageLength,8) , 0xff);
end

---------------------------------------------------------------------------------
function CityEngineLua.Bundle:fini(issend)
	if(self.numMessage > 0) then
		self:writeMsgLength();
		table.insert(self.streamList, self.stream);
		self.stream = City.MemoryStream.New();
	end
	
	if issend then
		self.numMessage = 0;
		self.msgtype = nil;
	end

	self._curMsgStreamIndex = 0;
end

function CityEngineLua.Bundle:sendimp(networkInterface)
	self:fini(true);

	if(networkInterface:valid()) then
		for i = 1, #self.streamList, 1 do
			self.stream = self.streamList[i];
			networkInterface:send(self.stream);
		end
	else
		ct.log("Bundle::send: networkInterface invalid!");
	end

	self.streamList = {};
	self.stream:clear();
end
function CityEngineLua.Bundle:send()
	self:sendimp(CityEngineLua._networkInterface)
end

function CityEngineLua.Bundle:checkStream(v)
	if(v > self.stream:space()) then
		table.insert(self.streamList, self.stream);
		self.stream = City.MemoryStream.New();
		self._curMsgStreamIndex = self._curMsgStreamIndex + 1;
	end
	self.messageLength = self.messageLength + v;
end

---------------------------------------------------------------------------------
function CityEngineLua.Bundle:writeInt8(v)
	self:checkStream(1);
	self.stream:writeInt8(v);
end

function CityEngineLua.Bundle:writeInt16(v)
	self:checkStream(2);
	self.stream:writeInt16(v);
end
	
function CityEngineLua.Bundle:writeInt32(v)
	self:checkStream(4);
	self.stream:writeInt32(v);
end

function CityEngineLua.Bundle:writeInt64(v)
	self:checkStream(8);
	self.stream:writeInt64(v);
end

function CityEngineLua.Bundle:writeUint8(v)
	self:checkStream(1);
	self.stream:writeUint8(v);
end

function CityEngineLua.Bundle:writeUint16(v)
	self:checkStream(2);
	self.stream:writeUint16(v);
end
	
function CityEngineLua.Bundle:writeUint32(v)
	self:checkStream(4);
	self.stream:writeUint32(v);
end

function CityEngineLua.Bundle:writeUint64(v)
	self:checkStream(8);
	self.stream:writeUint64(v);
end

function CityEngineLua.Bundle:writeFloat(v)
	self:checkStream(4);
	self.stream:writeFloat(v);
end

function CityEngineLua.Bundle:writeDouble(v)
	self:checkStream(8);
	self.stream:writeDouble(v);
end

function CityEngineLua.Bundle:writeBlob(v)
	self:checkStream(v.Length + 4);
	self.stream:writeBlob(v);
end

function CityEngineLua.Bundle:writeBytes(v)
	self.stream:writeString(v);
end

function CityEngineLua.Bundle:readBytes(mslen)
	return CityLuaUtilExt.bufferToString(self.stream, mslen);
	--return	self.stream:bufferToString(mslen);
end
function CityEngineLua.Bundle:readInt16()
	return	self.stream:readInt16();
end

function CityEngineLua.Bundle:readInt16()
	return	self.stream:readInt16();
end
function CityEngineLua.Bundle:readInt32()
	return	self.stream:readInt32();
end
