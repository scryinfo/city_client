local log = log

--消息
CityEngineLua.messages = {};
CityEngineLua.messages[SERVER_TYPE.SERVER_TYPE_AS] = {};
CityEngineLua.messages[SERVER_TYPE.SERVER_TYPE_GS] = {};
CityEngineLua.clientMessages = {};


CityEngineLua.Message = {}
--[[
registerNetMsg:
	1、 msgId：
		协议id， pbl.enum("ascode.OpCode","login")
			1、 proto25\asCode.proto 中定义了协议类型及ID， OpCode 这个枚举中的每一个标识符都对应一个协议类型，其枚举值代码协议的id
			2、 proto25\as.proto 定义具体的协议数据结构， 每个协议数据对应 asCode.proto 中 OpCode 的一个标识符
	2、 handler：
		要注册的回调函数，网络消息回来之后，会调用到这个注册的函数，并传入一个 存放Protobuf数据的 steam 字节流， 客户端需要在回调函数中调用 protobuf 对应协议的反序列化方法
]]--
function CityEngineLua.Message:registerNetMsg(msgId, handler)
	CityEngineLua.clientMessages[msgId] = CityEngineLua.Message:new(msgId, tostring(msgId), 0, 0, {}, handler);
end

function CityEngineLua.Message:newNetMsg( id)
	return CityEngineLua.Message:new(id, " ", 0, 0, {}, nil);
end

function CityEngineLua.Message:new( id, name, length, argstype, argtypes, handler )
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me.id = id;
	me.name = name;
	me.msglen = length;
	me.argsType = argstype;

	-- 绑定执行Message
	me.args = {};
	for i = 1, #argtypes, 1 do
		table.insert( me.args, CityEngineLua.datatypes[argtypes[i]] );
	end

	me.handler = handler;

    return me;
end

	
function CityEngineLua.Message:createFromStream(msgstream)
	if #self.args <= 0 then
		return msgstream;
	end
	
	local result = {};
	for i = 1, #self.args, 1 do
		table.insert( result, self.args[i]:createFromStream(msgstream) );
	end
	
	return result;
end
	
function CityEngineLua.Message:handleMessage(msgstream)
	if self.handler == nil then
		ct.log("City.Message::handleMessage: interface(" .. self.name .. "/" .. self.id .. ") no implement!");
		return;
	end

	if msgstream  then
		self.handler(msgstream);
	else
		self.handler();
	end
	--if #self.args <= 0 then
	--	if self.argsType < 0 then
	--		self.handler(msgstream);
	--	else
	--		self.handler();
	--	end
	--else
	--	self.handler(unpack(self:createFromStream(msgstream)));
	--end
end

function CityEngineLua.Message.clear()
	CityEngineLua.messages = {};
	CityEngineLua.messages["loginapp"] = {};
	CityEngineLua.messages["baseapp"] = {};
	CityEngineLua.clientMessages = {};
end

function CityEngineLua.Message.n_errorProcess(stream)
	--local msg_err = pb.common.Fail();
	--if(stream == nil) then
	--	return
	--end
	--msg_err:ParseFromString(stream);
	--local err = msg_err.Fail();
	--print("cz login parser:", err.reason);
end

function CityEngineLua.Message.bindFixedMessage()
				-- 提前约定一些固定的协议
			-- 这样可以在没有从服务端导入协议之前就能与服务端进行握手等交互。
    --CityEngineLua.messages["Loginapp_hello"] = CityEngineLua.Message:new(pb.asCode_pb.login, "hello", -1, -1, {}, nil);
	--CityEngineLua.messages["Loginapp_importClientMessages"] = CityEngineLua.Message:new(5, "importClientMessages", 0, 0, {}, nil);
	--CityEngineLua.messages["Loginapp_hello"] = CityEngineLua.Message:new(4, "hello", -1, -1, {}, nil);
	--CityEngineLua.messages["Baseapp_importClientMessages"] = CityEngineLua.Message:new(207, "importClientMessages", 0, 0, {}, nil);
	--CityEngineLua.messages["Baseapp_importClientEntityDef"] = CityEngineLua.Message:new(208, "importClientMessages", 0, 0, {}, nil);
	--CityEngineLua.messages["Baseapp_hello"] = CityEngineLua.Message:new(200, "hello", -1, -1, {}, nil);
    --
	--------client--------------
	--服务器返回错误的处理
	CityEngineLua.Message:registerNetMsg(pbl.enum("common.OpCode","error"),CityEngineLua.Message.n_errorProcess);
	--CityEngineLua.clientMessages[pb.common.error] = CityEngineLua.Message:new(pb.common.error, "error", 0, 0, {}, CityEngineLua.Message.n_errorProcess);
	--CityEngineLua.messages["Client_onHelloCB"] = CityEngineLua.Message:new(521, "Client_onHelloCB", -1, -1, {},
	--	CityEngineLua["Client_onHelloCB"]);
	--CityEngineLua.clientMessages[CityEngineLua.messages["Client_onHelloCB"].id] = CityEngineLua.messages["Client_onHelloCB"];
    --
	--CityEngineLua.messages["Client_onScriptVersionNotMatch"] = CityEngineLua.Message:new(522, "Client_onScriptVersionNotMatch", -1, -1, {},
	--	CityEngineLua["Client_onScriptVersionNotMatch"]);
	--CityEngineLua.clientMessages[CityEngineLua.messages["Client_onScriptVersionNotMatch"].id] = CityEngineLua.messages["Client_onScriptVersionNotMatch"];
    --
	--CityEngineLua.messages["Client_onVersionNotMatch"] = CityEngineLua.Message:new(523, "Client_onVersionNotMatch", -1, -1, {},
	--	CityEngineLua["Client_onVersionNotMatch"]);
	--CityEngineLua.clientMessages[CityEngineLua.messages["Client_onVersionNotMatch"].id] = CityEngineLua.messages["Client_onVersionNotMatch"];
    --
	--CityEngineLua.messages["Client_onImportClientMessages"] = CityEngineLua.Message:new(518, "Client_onImportClientMessages", -1, -1, {},
	--	CityEngineLua["Client_onImportClientMessages"]);
	--CityEngineLua.clientMessages[CityEngineLua.messages["Client_onImportClientMessages"].id] = CityEngineLua.messages["Client_onImportClientMessages"];
	
end

-- 消息的长度 4字节
CityEngineLua.READ_STATE_MSGLEN = 0;
-- 消息id
CityEngineLua.READ_STATE_MSGID = 1;
-- 当上面的消息长度都无法到达要求时使用扩展长度
-- uint32
CityEngineLua.READ_STATE_MSGLEN_EX = 2;
-- 消息的内容
CityEngineLua.READ_STATE_BODY = 3;
--成功的答复
CityEngineLua.READ_STATE_ACK = 4;

CityEngineLua.MessageReader = {
	msgid = 0,
	msglen = 0,
	expectMsgIdSize = 2,
	expectMsgLenSize = 4,
	expectSize = 4,
	expectBodySize = 0,
	state = CityEngineLua.READ_STATE_MSGLEN,
	stream = City.MemoryStream.New(),
};
local reader = CityEngineLua.MessageReader;

function CityEngineLua.MessageReader.onConnectError(errorCode)
	if(errorCode == SYSEVENT.SYSEVENT_DISCONNECT ) then
		--目前连接处理错误统一处理为 m_onDisconnect ，因为暂时还不清楚有哪些别的连接错误
		Event.Brocast("m_onDisconnect", errorCode);
	end
end

function CityEngineLua.MessageReader.process(datas, offset, length)
	local totallen = offset;
	while(length > 0 and reader.expectSize > 0)
		do if(reader.state == CityEngineLua.READ_STATE_MSGLEN) then
			if(length >= reader.expectSize) then
				CityLuaUtil.ArrayCopy(datas, totallen, reader.stream:data(), reader.stream.wpos, reader.expectSize);
				totallen = totallen + reader.expectSize;
				reader.stream.wpos = reader.stream.wpos + reader.expectSize;
				length = length - reader.expectSize;

				reader.msglen = reader.stream:readUint32();
				reader.state = CityEngineLua.READ_STATE_MSGID;
				reader.expectSize = reader.expectMsgIdSize;
			else
				--c#传入的buffer至少包含长度和msid区段，否则就是网络异常，终止本次解析
				break;
			end
		elseif(reader.state == CityEngineLua.READ_STATE_MSGID) then
			if(length >= reader.expectSize) then
				CityLuaUtil.ArrayCopy(datas, totallen, reader.stream:data(), reader.stream.wpos, reader.expectSize);
				totallen = totallen + reader.expectSize;
				reader.stream.wpos = reader.stream.wpos + reader.expectSize;
				length = length - reader.expectSize;
				reader.msgid = reader.stream:readUint16();
				reader.expectSize = reader.msglen
				reader.state = CityEngineLua.READ_STATE_BODY
				--reader.stream:clear();

				local msg = CityEngineLua.clientMessages[reader.msgid];
				if not msg then
					--这种情况可能是协议没注册，需要跳过当前数据段
					CityLuaUtilExt.bufferToString(reader.stream, reader.msglen)
					reader.expectSize = 4;
					reader.state = CityEngineLua.READ_STATE_MSGLEN
				else
					if(reader.msglen == 0) then
						-- 如果是0个参数的消息，那么没有后续内容可读了，处理本条消息并且直接跳到下一条消息
						msg:handleMessage(CityLuaUtilExt.bufferToString(reader.stream, 0));
						reader.state = CityEngineLua.READ_STATE_MSGLEN;
						reader.expectSize = 4;
					end
				end
			else
				--msid解析必须是成功的，否则也是网络异常，终止本次解析
					--也就是说，服务器发送的包长度区段和msgid区段都是必须有的，这两个数据段6个字节，必定是小于最小传输单位的，所以如果这两个数据段不完整，必然是网络的问题
				break;
			end
		elseif(reader.state == CityEngineLua.READ_STATE_BODY) then
			if(length >= reader.expectSize) then
				reader.stream:append(datas, totallen, reader.expectSize);
				totallen = totallen + reader.expectSize;
				length = length - reader.expectSize;
				local msg = CityEngineLua.clientMessages[reader.msgid];
				msg:handleMessage(CityLuaUtilExt.bufferToString(reader.stream, reader.expectSize));
				reader.stream:clear();
				reader.state = CityEngineLua.READ_STATE_MSGLEN;
				reader.expectSize = 4;
			else
				--length 小于 reader.expectSize, 说明pb数据段不完整，需等待下一次socket收包组包
			end
		elseif(reader.state == CityEngineLua.READ_STATE_MSGLEN_EX) then
			--现在暂时没有这种情况
			break
		end
	end
end
