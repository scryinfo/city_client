local log = log

--news
CityEngineLua.messages = {};
CityEngineLua.messages[SERVER_TYPE.SERVER_TYPE_AS] = {};
CityEngineLua.messages[SERVER_TYPE.SERVER_TYPE_GS] = {};
CityEngineLua.clientMessages = {};
CityEngineLua.clientMessagesErrorHandlers = {};



CityEngineLua.Message = {}
--[[
registerNetMsg:
1. msgId:
Protocol id, pbl.enum("ascode.OpCode","login")
1. The protocol type and ID are defined in proto25\asCode.proto. Each identifier in the OpCode enumeration corresponds to a protocol type, and its enumeration value codes the protocol id.
2. proto25\as.proto defines the specific protocol data structure, each protocol data corresponds to an identifier of OpCode in asCode.proto
2. handler:
To register the callback function, after the network message comes back, it will call this registered function and pass in a steam byte stream that stores Protobuf data. The client needs to call the protobuf protocol deserialization method in the callback function
]]--
function CityEngineLua.Message:registerNetMsg(msgId, handler, errorHandler)
	CityEngineLua.clientMessages[msgId] = CityEngineLua.Message:new(msgId, tostring(msgId), 0, 0, {}, handler);
	CityEngineLua.clientMessagesErrorHandlers[msgId] = handler
end

function CityEngineLua.Message:processNetMsgError(stream,protoData)
    CityEngineLua.clientMessagesErrorHandlers[protoData.opcode](nil,stream,0)
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

	-- Binding to execute Message
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

function CityEngineLua.Message:handleMessage(msgstream, msgid)
	if self.handler == nil then
		ct.log("City.Message::handleMessage: interface(" .. self.name .. "/" .. self.id .. ") no implement!");
		return;
	end

	if msgstream  then
		self.handler(msgstream,msgid);
	else
		self.handler(msgid);
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
	-- A few fixed agreements agreed in advance
	-- This allows handshake and other interactions with the server before importing the protocol from the server.
	--CityEngineLua.messages["Loginapp_hello"] = CityEngineLua.Message:new(pb.asCode_pb.login, "hello", -1, -1, {}, nil);
	--CityEngineLua.messages["Loginapp_importClientMessages"] = CityEngineLua.Message:new(5, "importClientMessages", 0, 0, {}, nil);
	--CityEngineLua.messages["Loginapp_hello"] = CityEngineLua.Message:new(4, "hello", -1, -1, {}, nil);
	--CityEngineLua.messages["Baseapp_importClientMessages"] = CityEngineLua.Message:new(207, "importClientMessages", 0, 0, {}, nil);
	--CityEngineLua.messages["Baseapp_importClientEntityDef"] = CityEngineLua.Message:new(208, "importClientMessages", 0, 0, {}, nil);
	--CityEngineLua.messages["Baseapp_hello"] = CityEngineLua.Message:new(200, "hello", -1, -1, {}, nil);
	--
	--------client--------------
	--The server returns error handling
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

-- Message length 4 bytes
CityEngineLua.READ_STATE_MSGLEN = 0;
-- Message id
CityEngineLua.READ_STATE_MSGID = 1;
-- Use extended length when none of the above message lengths can reach the requirement
-- uint32
CityEngineLua.READ_STATE_MSGLEN_EX = 2;
-- Content of the message
CityEngineLua.READ_STATE_BODY = 3;
--Successful reply
CityEngineLua.READ_STATE_ACK = 4;

CityEngineLua.MessageReader = {
	msgid = 0,
	msglen = 0,
	expectMsgIdSize = 2,
	expectMsgLenSize = 4,
	expectSize = 4,
	expectBodySize = 0,
	state = CityEngineLua.READ_STATE_MSGLEN,
	bufferToRead = 0,
	stream = City.MemoryStream.New(),
};
local reader = CityEngineLua.MessageReader;
function CityEngineLua.MessageReader.onConnectError(errorCode)
	if(errorCode == SYSEVENT.SYSEVENT_DISCONNECT ) then
		-- At present, the connection processing error is uniformly handled as m_onDisconnect, because it is not yet clear what other connection errors are
		Event.Brocast("m_onDisconnect", errorCode);
	end
end

function CityEngineLua.MessageReader.process(datas, offset, size)
 	local toReadDatalength = reader.stream.wpos
	--Receive network buffered data
	if size > 0 then
		--Calculate the length of data to be read in reader
		local testNewLength = reader.stream.wpos + size
		--If the free space on the right side of the reader.stream buffer is not full, copy the new data directly to the right space. If it is full, copy from the left 0 bits
		if reader.stream.wpos + size <= City.MemoryStream.BUFFER_MAX then
			--Note that there will not be a real reader.stream.wpos + size> City.MemoryStream.BUFFER_MAX,
			--Because the data in this case has been divided into two sections in C#, the first section of data passed to lua must be able to be fully filled and will not exceed
			--Reference public void process() else if (t_wpos <_rpos)
			CityLuaUtil.ArrayCopy(datas, offset, reader.stream:data(), reader.stream.wpos, size)
			reader.stream.wpos = reader.stream.wpos + size
			toReadDatalength = reader.stream.wpos - reader.stream.rpos
		else
			reader.stream.rpos = 0
			reader.stream.wpos = size
			toReadDatalength = size
			CityLuaUtil.ArrayCopy(datas, offset, reader.stream:data(), 0, size)
		end
	end
	while(toReadDatalength > 0 and reader.expectSize > 0) do
		if(reader.state == CityEngineLua.READ_STATE_MSGLEN) then
			if(toReadDatalength >= reader.expectSize) then
			--Update reader.stream write end point location
			--reader.stream.rpos = reader.stream.rpos + reader.expectSize
			--Update the length of remaining unread data
				toReadDatalength = toReadDatalength - reader.expectSize
				--Read pb data segment length
				reader.msglen = reader.stream:readUint32();
				--Switch the reading status
				reader.state = CityEngineLua.READ_STATE_MSGID;
				reader.expectSize = reader.expectMsgIdSize;
			else
				--If the length of incoming data on the network is less than 4 bytes, terminate the loop and wait for the arrival of subsequent data
				break;
			end
		elseif(reader.state == CityEngineLua.READ_STATE_MSGID) then
			if(toReadDatalength >= reader.expectSize) then
				--reader.stream.rpos = reader.stream.rpos + reader.expectSize;
				toReadDatalength = toReadDatalength - reader.expectSize;
				reader.msgid = reader.stream:readUint16();
				reader.expectSize = reader.msglen
				reader.state = CityEngineLua.READ_STATE_BODY
				--If there is no pb data segment, it will be processed here
				if(reader.msglen == 0) then
					-- If it is a message with 0 parameters, then there is no subsequent content to read, process this message and jump directly to the next message
					local msg = CityEngineLua.clientMessages[reader.msgid]
					if msg ~= nil then
						msg:handleMessage(CityLuaUtilExt.bufferToString(reader.stream, 0),reader.msgid)
					end
					reader.state = CityEngineLua.READ_STATE_MSGLEN;
					reader.expectSize = 4;
				end
			else
				break;--Waiting for the arrival of subsequent data
			end
		elseif(reader.state == CityEngineLua.READ_STATE_BODY) then
			if(toReadDatalength >= reader.expectSize) then
				--reader.stream.rpos = reader.stream.rpos + reader.expectSize;
				toReadDatalength = toReadDatalength - reader.expectSize;
				local msg = CityEngineLua.clientMessages[reader.msgid];
				if msg ~= nil then
					msg:handleMessage(CityLuaUtilExt.bufferToString(reader.stream, reader.expectSize),reader.msgid);
				else
					local pb = CityLuaUtilExt.bufferToString(reader.stream, reader.expectSize)
				end
				reader.state = CityEngineLua.READ_STATE_MSGLEN;
				reader.expectSize = 4;
			else
				break--Waiting for the arrival of subsequent data
			end
		elseif(reader.state == CityEngineLua.READ_STATE_MSGLEN_EX) then
			--This is not the case for now
			break
		end
	end
end
