--require "pb.person_pb"

local CityEngineLua = CityEngineLua
local this = CityEngineLua;

local pbl = pbl
local pbio   = pbl_io
local buffer = pbl_buffer
local slice  = pbl_slice
local conv   = pbl_conv

local serpent = require("Framework/pbl/serpent")
local protoc = require "Framework/pbl/protoc"
protoc:addpath("./Assets/CityGame/Lua/pb")
local log = log

-----------------可配置信息---------------
--CityEngineLua.ip = "127.0.0.1";
--CityEngineLua.port = "20013";

--李宁
--CityEngineLua.ip = "192.168.0.50";
--CityEngineLua.port = "10000";

--服务器
CityEngineLua.ip = AppConst.asServerIp
CityEngineLua.port = "9001";

-- Mobile(Phone, Pad)	= 1,
-- Windows Application program	= 2,
-- Linux Application program = 3,	
-- Mac Application program	= 4,	
-- Web，HTML5，Flash		= 5,
-- bots			= 6,
-- Mini-Client			= 7,
CityEngineLua.clientType = 1;
CityEngineLua.isOnInitCallPropertysSetMethods = true;
CityEngineLua.useAliasEntityID = true;
-----------------end-------------------------



CityEngineLua.CITY_FLT_MAX = 3.402823466e+38;

----- player的相关信息
-- 当前玩家的实体id与实体类别
CityEngineLua.entity_uuid = nil;
CityEngineLua.entity_id = 0;
CityEngineLua.entity_type = "";

CityEngineLua.controlledEntities = {};

CityEngineLua.entityServerPos = Vector3.New(0.0, 0.0, 0.0);

CityEngineLua.syncPlayer = true;

-- 空间的信息
CityEngineLua.spacedata = {};
CityEngineLua.spaceID = 0;
CityEngineLua.spaceResPath = "";
CityEngineLua.isLoadedGeometry = false;

--entityDef管理模块
CityEngineLua.entityDef =CityEngineLua.EntityDef:New()

-- 账号信息
CityEngineLua.username = "City";
CityEngineLua.password = "123456";

-- 网络信息
CityEngineLua.currserver = "";
CityEngineLua.currstate = "";

-- 服务端分配的baseapp地址
CityEngineLua.baseappIP = "";
CityEngineLua.baseappPort = nil;
CityEngineLua.token = ""

-- 交易服务器的地址
CityEngineLua.tradeappIP = "";
CityEngineLua.tradeappPort = nil;

CityEngineLua._serverdatas = {};
CityEngineLua._clientdatas = {};

-- 通信协议加密，blowfish协议--没用过~
CityEngineLua._encryptedKey = "";

-- 服务端与客户端的版本号以及协议MD5
CityEngineLua.clientVersion = "2.0.0";
CityEngineLua.clientScriptVersion = "0.1.0";
CityEngineLua.serverVersion = "";
CityEngineLua.serverScriptVersion = "";
CityEngineLua.serverProtocolMD5 = "";
CityEngineLua.serverEntitydefMD5 = "";

-- 各种存储结构
CityEngineLua.moduledefs = {};
CityEngineLua.serverErrs = {};

-- 所有实体都保存于这里， 请参看API手册关于entities部分
-- https://github.com/City/City/tree/master/docs/api
CityEngineLua.entities = {};

-- 在玩家View范围小于256个实体时我们可以通过一字节索引来找到entity
CityEngineLua.entityIDAliasIDList = {};
CityEngineLua.bufferedCreateEntityMessage = {};

-- 持久化
CityEngineLua._persistentInfos = nil;

-- 是否正在加载本地消息协议
CityEngineLua.loadingLocalMessages_ = false;
-- 各种协议是否已经导入了
CityEngineLua.loginappMessageImported_ = false;
CityEngineLua.baseappMessageImported_ = false;
CityEngineLua.entitydefImported_ = false;
CityEngineLua.isImportServerErrorsDescr_ = false;

-- 控制网络间隔
CityEngineLua._lastTickTime = os.clock();
CityEngineLua._lastTickCBTime = os.clock();
CityEngineLua._lastUpdateToServerTime = os.clock();

--网络接口
CityEngineLua._networkInterface = nil;
CityEngineLua._tradeNetworkInterface1 = nil;

CityEngineLua.deg2rad = Mathf.PI / 180;


CityEngineLua.GetArgs = function()
	return this.clientVersion, this.clientScriptVersion, this.ip, this.port;
end

CityEngineLua.int82angle = function(angle, half)
	local halfv = 128;
	if(half == true) then
		halfv = 254;
	end
	
	halfv = angle * (Mathf.PI / halfv);
	return halfv;
end

local function check_load(chunk, name)
	local pbdata = protoc.new():compile(chunk, name)
	local ret, offset = pbl.load(pbdata)
	if not ret then
		error("load error at "..offset..
				"\nproto: "..chunk..
				"\ndata: "..buffer(pbdata):tohex())
	end
end

function pbl_errorTest()
	local pGameServerInfo = {
		serverId = 1,
		name = "",
		port = 1,
		briefInfo = {
			{
				name = "good",
				lastLoginTime = 123123
			},
			{
				name = "xxxx",
				lastLoginTime = 33333
			}
		}
	}
	pBriefInfo = {
		id = tostring(123),
		name = "good",
		lastLoginTime = 123123
	}

	local bdata = assert(pbl.encode("as.Brief", pBriefInfo))
	local bmsg0 = pbl.decode("as.Brief", bdata)

	pGameServerInfo._name = "haha"
	pGameServerInfo.serverId = 0
	local data = assert(pbl.encode("as.GameServerInfo", pGameServerInfo))
	local bundle = CityEngineLua.Bundle:new();
	local msg = CityEngineLua.Message:newNetMsg(1002);
	local psize = #data
	bundle:newMessage(msg);
	bundle:writeInt32(psize);
	bundle:writeInt16(1002);
	bundle:writeBytes(data);

	local mslen = bundle:readInt32();
	local msid = bundle:readInt16();
	local netbf =  bundle:readBytes(mslen);

	local xxx = 0
	if not psize == #netbf then
		xxx = 1
	end
	if netbf then
		local msg0 = pbl.decode("as.GameServerInfo", netbf)
		xxx = 2
	end
	xxx = 0
end

CityEngineLua.InitEngine = function()
	this._networkInterface = City.NetworkInterface.New();
	CityEngineLua.Message.bindFixedMessage();
	this._persistentInfos = CityEngineLua.PersistentInfos:New(UnityEngine.Application.persistentDataPath);
	FixedUpdateBeat:Add(this.process, this);
	--测试
	pbl_errorTest()
end

CityEngineLua.postInitEngine = function()
	this._networkInterface = City.NetworkInterface.New();
	CityEngineLua.Message.bindFixedMessage();
	this._persistentInfos = CityEngineLua.PersistentInfos:New(UnityEngine.Application.persistentDataPath);
	FixedUpdateBeat:Add(this.process, this);

end

CityEngineLua.Destroy = function()
	logDebug("City::destroy()");
	this.reset();
	this.resetMessages();
end

CityEngineLua.player = function()
	return CityEngineLua.entities[CityEngineLua.entity_id];
end

CityEngineLua.findEntity = function(entityID)
	return CityEngineLua.entities[entityID];
end

CityEngineLua.resetMessages = function()
    this.loadingLocalMessages_ = false;
	this.loginappMessageImported_ = false;
	this.baseappMessageImported_ = false;
	this.entitydefImported_ = false;
	this.isImportServerErrorsDescr_ = false;
	this.serverErrs = {};
	this.Message.clear();
	this.moduledefs = {};
	this.entities = {};
    CityEngineLua.EntityDef.clear()
	ct.log("City::resetMessages()");
end

CityEngineLua.importMessagesFromMemoryStream = function(loginapp_clientMessages, baseapp_clientMessages,  entitydefMessages, serverErrorsDescr)

	this.resetMessages();
	
	this.loadingLocalMessages_ = true;
	local stream = City.MemoryStream.New();
	stream:append(loginapp_clientMessages, 0, loginapp_clientMessages.Length);
	this.currserver = "loginapp";
	this.onImportClientMessages(stream);

	stream = City.MemoryStream.New();
	stream:append(baseapp_clientMessages, 0, baseapp_clientMessages.Length);
	this.currserver = "baseapp";
	this.onImportClientMessages(stream);
	this.currserver = "loginapp";

	stream = City.MemoryStream.New();
	stream:append(serverErrorsDescr, 0, serverErrorsDescr.Length);
	this.onImportServerErrorsDescr(stream);
		
	stream = City.MemoryStream.New();
	stream:append(entitydefMessages, 0, entitydefMessages.Length);
	this.onImportClientEntityDef(stream);

	this.loadingLocalMessages_ = false;
	this.loginappMessageImported_ = true;
	this.baseappMessageImported_ = true;
	this.entitydefImported_ = true;
	this.isImportServerErrorsDescr_ = true;

	this.currserver = "";
	ct.log("City::importMessagesFromMemoryStream(): is successfully!");
	return true;
end

CityEngineLua.createDataTypeFromStreams = function(stream, canprint)
	local aliassize = stream:readUint16();
	ct.log("CityEngineApp::createDataTypeFromStreams: importAlias(size=" .. aliassize .. ")!");
	
	while(aliassize > 0)
    do  
		aliassize = aliassize -1;
		CityEngineLua.createDataTypeFromStream(stream, canprint);
	end
	
	for k, datatype in pairs(CityEngineLua.datatypes) do
		if(CityEngineLua.datatypes[k] ~= nil) then
			CityEngineLua.datatypes[k]:bind();
		end
	end
end
CityEngineLua.createDataTypeFromStream = function(stream, canprint)
	local utype = stream:readUint16();
	local name = stream:readString();
	local valname = stream:readString();
	
	-- 有一些匿名类型，我们需要提供一个唯一名称放到datatypes中
	-- 如：
	-- <onRemoveAvatar>
	-- 	<Arg>	ARRAY <of> INT8 </of>		</Arg>
	-- </onRemoveAvatar>				
	
	if(string.len(valname) == 0) then
		valname = "nil_" .. utype;
	end
		
	if(canprint) then
		ct.log("CityEngineApp::Client_onImportClientEntityDef: importAlias(" .. name .. ":" .. valname .. ":" .. utype .. ")!");
	end
	
	if(name == "FIXED_DICT") then
		local datatype = CityEngineLua.DATATYPE_FIXED_DICT:New();
		local keysize = stream:readUint8();
		datatype.implementedBy = stream:readString();
			
		while(keysize > 0)
        do
			keysize = keysize -1;
			local keyname = stream:readString();
			local keyutype = stream:readUint16();
			table.insert(datatype.dictKeys, keyname);
			datatype.dicttype[keyname] = keyutype;
		end
		
		CityEngineLua.datatypes[valname] = datatype;
	elseif(name == "ARRAY") then
		local uitemtype = stream:readUint16();
		local datatype = CityEngineLua.DATATYPE_ARRAY:New();
		datatype._type = uitemtype;
		CityEngineLua.datatypes[valname] = datatype;
	else
		CityEngineLua.datatypes[valname] = CityEngineLua.datatypes[name];
	end

	CityEngineLua.datatypes[utype] = CityEngineLua.datatypes[valname];
	
	-- 将用户自定义的类型补充到映射表中
	CityEngineLua.datatype2id[valname] = utype;
end

CityEngineLua.Client_onImportClientEntityDef = function(stream)
	local datas = stream:getbuffer();
	this.onImportClientEntityDef(stream);
	if(this._persistentInfos ~= nil) then
		this._persistentInfos:onImportClientEntityDef(datas);
	end
end

CityEngineLua.onImportClientEntityDef = function(stream)
	this.createDataTypeFromStreams(stream, false);

	while(stream:length() > 0)
	do
		local scriptmodule_name = stream:readString();
		local scriptUtype = stream:readUint16();
		local propertysize = stream:readUint16();
		local methodsize = stream:readUint16();
		local base_methodsize = stream:readUint16();
		local cell_methodsize = stream:readUint16();
		
		CityEngineLua.moduledefs[scriptmodule_name] = {};
		local currModuleDefs = CityEngineLua.moduledefs[scriptmodule_name];
		currModuleDefs["name"] = scriptmodule_name;
		currModuleDefs["propertys"] = {};
		currModuleDefs["methods"] = {};
		currModuleDefs["base_methods"] = {};
		currModuleDefs["cell_methods"] = {};
		CityEngineLua.moduledefs[scriptUtype] = currModuleDefs;
		
		local self_propertys = currModuleDefs["propertys"];
		local self_methods = currModuleDefs["methods"];
		local self_base_methods = currModuleDefs["base_methods"];
		local self_cell_methods= currModuleDefs["cell_methods"];
		
		local Class = CityEngineLua[scriptmodule_name];

		while(propertysize > 0)
		do
			propertysize = propertysize - 1;
			
			local properUtype = stream:readUint16();
			local properFlags = stream:readUint32();
			local aliasID = stream:readInt16();
			local name = stream:readString();
			local defaultValStr = stream:readString();
			local utype = CityEngineLua.datatypes[stream:readUint16()];
			local setmethod = nil;--函数
			if(Class ~= nil) then
				setmethod = Class["set_" .. name];
			end
			
			local savedata = {properUtype, aliasID, name, defaultValStr, utype, setmethod, properFlags};
			self_propertys[name] = savedata;
			
			if(aliasID ~= -1) then
				self_propertys[aliasID] = savedata;
				currModuleDefs["usePropertyDescrAlias"] = true;
			else
				self_propertys[properUtype] = savedata;
				currModuleDefs["usePropertyDescrAlias"] = false;
			end
			
			ct.log("CityEngineApp::Client_onImportClientEntityDef: add(" .. scriptmodule_name .. "), property(" .. name .. "/" .. properUtype .. ").");
		end
		while(methodsize > 0)
		do
			methodsize = methodsize - 1;
			
			local methodUtype = stream:readUint16();
			local aliasID = stream:readInt16();
			local name = stream:readString();
			local argssize = stream:readUint8();
			local args = {};
			
			while(argssize > 0)
			do
				argssize = argssize - 1;
				table.insert(args,CityEngineLua.datatypes[stream:readUint16()]);
			end
			
			local savedata = {methodUtype, aliasID, name, args};
			self_methods[name] = savedata;
			
			if(aliasID ~= -1) then
				self_methods[aliasID] = savedata;
				currModuleDefs["useMethodDescrAlias"] = true;
			else
				self_methods[methodUtype] = savedata;
				currModuleDefs["useMethodDescrAlias"] = false;
			end
			
			ct.log("CityEngineApp::Client_onImportClientEntityDef: add(" .. scriptmodule_name .. "), method(" .. name .. ").");
		end

		while(base_methodsize > 0)
		do
			base_methodsize = base_methodsize - 1;
			
			local methodUtype = stream:readUint16();
			local aliasID = stream:readInt16();
			local name = stream:readString();
			local argssize = stream:readUint8();
			local args = {};
			
			while(argssize > 0)
            do
				argssize = argssize - 1;
				table.insert(args,CityEngineLua.datatypes[stream:readUint16()]);
			end
			
			self_base_methods[name] = {methodUtype, aliasID, name, args};
			ct.log("CityEngineApp::Client_onImportClientEntityDef: add(" .. scriptmodule_name .. "), base_method(" .. name .. ").");
		end
		
		while(cell_methodsize > 0)
		do
			cell_methodsize = cell_methodsize - 1;
			
			local methodUtype = stream:readUint16();
			local aliasID = stream:readInt16();
			local name = stream:readString();
			local argssize = stream:readUint8();
			local args = {};
			
			while(argssize > 0)
			do
				argssize = argssize -1;
				table.insert(args,CityEngineLua.datatypes[stream:readUint16()]);
			end
			
			self_cell_methods[name] = {methodUtype, aliasID, name, args};
			ct.log("CityEngineApp::Client_onImportClientEntityDef: add(" .. scriptmodule_name .. "), cell_method(" .. name .. ").");
		end
		
		defmethod = CityEngineLua[scriptmodule_name];
		if defmethod == nil then
			ct.log("CityEngineApp::Client_onImportClientEntityDef: module(" .. scriptmodule_name .. ") not found~");
		end
		
		for k, value in pairs(currModuleDefs.propertys) do
			local infos = value;
			local properUtype = infos[1];
			local aliasID = infos[2];
			local name = infos[3];
			local defaultValStr = infos[4];
			local utype = infos[5];

			if(defmethod ~= nil) then
				defmethod[name] = utype:parseDefaultValStr(defaultValStr);
            end
		end

		for k, value in pairs(currModuleDefs.methods) do
			local infos = value;
			local properUtype = infos[1];
			local aliasID = infos[2];
			local name = infos[3];
			local args = infos[4];
			
			if(defmethod ~= nil and defmethod[name] == nil) then
				ct.log(scriptmodule_name .. ":: method(" .. name .. ") no implement~");
			end
		end
	end
	this.onImportEntityDefCompleted();
end

CityEngineLua.Client_onImportClientMessages = function( stream )
	local datas = stream:getbuffer();
	this.onImportClientMessages (stream);
	
	if(this._persistentInfos ~= nil) then
		this._persistentInfos:onImportClientMessages(this.currserver, datas);
	end
end

CityEngineLua.onImportClientMessages = function( stream )
	local msgcount = stream:readUint16();
	
	ct.log("CityEngineApp::onImportClientMessages: start(" .. msgcount .. ") ...!");
	
	while(msgcount > 0)
	do
		msgcount = msgcount - 1;
		
		local msgid = stream:readUint16();
		local msglen = stream:readInt16();

		local msgname = stream:readString();
		local argtype = stream:readInt8();
		local argsize = stream:readUint8();
		local argstypes = {};
		
		for i = 1, argsize, 1 do
			table.insert(argstypes, stream:readUint8());
		end
		
		local handler = nil;
		local isClientMethod = string.find(msgname, "Client_") ~= nil;
		if isClientMethod then
			handler = CityEngineLua[msgname];
			if handler == nil then
				ct.log("CityEngineApp::onImportClientMessages[" .. CityEngineLua.currserver .. "]: interface(" .. msgname .. "/" .. msgid .. ") no implement!");
			else
                local txtFunc = string.format("CityEngineApp::onImportClientMessages[%s]: import(%s/%d) successfully!", CityEngineLua.currserver, msgname, msgid)
                local txtParams = string.format("params: %s", tostring(argstypes))
                local txtFuncInfo = string.format("%s\n%s", txtFunc, txtParams)
				ct.log(txtFuncInfo);
			end
        else
            local txtFunc = string.format("CityEngineApp::onImportClientMessages[%s]: import(%s/%d) successfully!", CityEngineLua.currserver, msgname, msgid)
            local txtParams = string.format("params: %s", tostring(argstypes))
            local txtFuncInfo = string.format("%s\n%s", txtFunc, txtParams)
            ct.log(txtFuncInfo);
		end
	
		if string.len(msgname) > 0 then
			CityEngineLua.messages[msgname] = CityEngineLua.Message:new(msgid, msgname, msglen, argtype, argstypes, handler);
			
			if isClientMethod then
				CityEngineLua.clientMessages[msgid] = CityEngineLua.messages[msgname];
			else
				CityEngineLua.messages[CityEngineLua.currserver][msgid] = CityEngineLua.messages[msgname];
			end
		else
			CityEngineLua.messages[CityEngineLua.currserver][msgid] = CityEngineLua.Message:new(msgid, msgname, msglen, argtype, argstypes, handler);
		end
	end

	CityEngineLua.onImportClientMessagesCompleted();
end

CityEngineLua.Client_onImportServerErrorsDescr = function(stream)
	local datas = stream:getbuffer();
	this.onImportServerErrorsDescr(stream);
	
	if(this._persistentInfos ~= nil) then
		this._persistentInfos:onImportServerErrorsDescr(datas);
	end
end

CityEngineLua.onImportServerErrorsDescr = function(stream)
	local size = stream:readUint16();
	while size > 0
	do
		size = size - 1;
		
		local e = {};
		e.id = stream:readUint16();
		e.name = CityLuaUtil.ByteToUtf8(stream:readBlob());
		e.descr = CityLuaUtil.ByteToUtf8(stream:readBlob());
		
		this.serverErrs[e.id] = e;
		--ct.log("Client_onImportServerErrorsDescr: id=" + e.id + ", name=" + e.name + ", descr=" + e.descr);
	end
end
	-- 从二进制流导入消息协议完毕了
CityEngineLua.onImportClientMessagesCompleted = function()
	if(this.currserver == "loginapp") then
		if(not this.isImportServerErrorsDescr_ and not this.loadingLocalMessages_) then
			ct.log("City::onImportClientMessagesCompleted(): send importServerErrorsDescr!");
			this.isImportServerErrorsDescr_ = true;
			local bundle = CityEngineLua.Bundle:new();
			bundle:newMessage(CityEngineLua.messages["Loginapp_importServerErrorsDescr"]);
			bundle:send();
		end
		
		if(this.currstate == "login") then
			this.login_loginapp(false);
		elseif(this.currstate == "autoimport") then
		elseif(this.currstate == "resetpassword") then
			this.resetpassword_loginapp(false);
		elseif(this.currstate == "createAccount") then
			this.createAccount_loginapp(false);
		end

		this.loginappMessageImported_ = true;
	else
		this.baseappMessageImported_ = true;
		
		if(not this.entitydefImported_ and not this.loadingLocalMessages_) then
			ct.log("City::onImportClientMessagesCompleted: send importEntityDef(" .. (this.entitydefImported_ and "true" or "false")  .. ") ...");
			local bundle = CityEngineLua.Bundle:new();
			bundle:newMessage(CityEngineLua.messages["Baseapp_importClientEntityDef"]);
			bundle:send();
			--Event.fireOut("Baseapp_importClientEntityDef", new object[]{});
		else
			this.onImportEntityDefCompleted();
		end
	end
end
CityEngineLua.onImportEntityDefCompleted = function()
	ct.log("City::onImportEntityDefCompleted: successfully!");
	this.entitydefImported_ = true;
	
	if(not this.loadingLocalMessages_) then
		this.login_baseapp(false);
	end
end
CityEngineLua.Client_onCreatedProxies = function(rndUUID, eid, entityType)

	--ct.log("CityEngineApp::Client_onCreatedProxies: eid(" .. eid .. "), entityType(" .. entityType .. ")!");
	
	this.entity_uuid = rndUUID;
	this.entity_id = eid;
	this.entity_type = entityType;

	local entity = CityEngineLua.entities[eid];
	
	if(entity == nil) then		
		local runclass = CityEngineLua[entityType];
		if(runclass == nil) then
			ct.log("City::Client_onCreatedProxies: not found module(" .. entityType .. ")!");
			return;
		end
		
		local entity = runclass:New();
		entity.id = eid;
		entity.className = entityType;
		
		entity.baseEntityCall = CityEngineLua.EntityCall:New();
		entity.baseEntityCall.id = eid;
		entity.baseEntityCall.className = entityType;
		entity.baseEntityCall.type = CityEngineLua.ENTITYCALL_TYPE_BASE;
		
		CityEngineLua.entities[eid] = entity;
		
		local entityMessage = CityEngineLua.bufferedCreateEntityMessage[eid];
		if(entityMessage ~= nil) then
			CityEngineLua.Client_onUpdatePropertys(entityMessage);
			CityEngineLua.bufferedCreateEntityMessage[eid] = nil;
		end
			
		entity:__init__();
		entity.inited = true;
		
		if(CityEngineLua.isOnInitCallPropertysSetMethods) then
			entity:callPropertysSetMethods();
		end
	else
		local entityMessage = CityEngineLua.bufferedCreateEntityMessage[eid];
		if(entityMessage ~= nil) then
			CityEngineLua.Client_onUpdatePropertys(entityMessage);
			CityEngineLua.bufferedCreateEntityMessage[eid] = nil;
		end
	end
end

CityEngineLua.getViewEntityIDFromStream = function(stream)
	if not this.useAliasEntityID then
		return stream:readInt32();
	end

	local id = 0;
	if(#CityEngineLua.entityIDAliasIDList > 255)then
		id = stream:readInt32();
	else
		local aliasID = stream:readUint8();

		-- -- 如果为0且客户端上一步是重登陆或者重连操作并且服务端entity在断线期间一直处于在线状态
		-- -- 则可以忽略这个错误, 因为cellapp可能一直在向baseapp发送同步消息， 当客户端重连上时未等
		-- -- 服务端初始化步骤开始则收到同步信息, 此时这里就会出错。
		if(#CityEngineLua.entityIDAliasIDList <= aliasID) then
			return 0;
		end

		id = CityEngineLua.entityIDAliasIDList[aliasID+1];
	end

	return id;
end
	
CityEngineLua.onUpdatePropertys_ = function(eid, stream)

	local entity = CityEngineLua.entities[eid];
	
	if(entity == nil) then
		local entityMessage = CityEngineLua.bufferedCreateEntityMessage[eid];
		if(entityMessage ~= nil) then
			ct.log("CityEngineApp::Client_onUpdatePropertys: entity(" .. eid .. ") not found!");
			return;
		end
		
		local stream1 = City.MemoryStream.New();
		stream1:copy(stream);
		stream1.rpos = stream1.rpos - 4;--让出一个id

		CityEngineLua.bufferedCreateEntityMessage[eid] = stream1;
		return;
	end
	
	local currModule = CityEngineLua.moduledefs[entity.className];
	local pdatas = currModule.propertys;
	while(stream:length() > 0) do
		local _t_utype = 0;
		local _t_child_utype = 0;
		if(currModule.usePropertyDescrAlias) then
			_t_utype = stream:readUint8();
			_t_child_utype = stream:readUint8();
		else
			_t_utype = stream:readUint16();
			_t_child_utype = stream.readUint16();
        end

		local propertydata = nil;
        if(_t_utype == 0) then
			propertydata = pdatas[_t_child_utype];
		else
			return;
		end

		local setmethod = propertydata[6];
		local flags = propertydata[7];
		local val = propertydata[5]:createFromStream(stream);
		local oldval = entity[propertydata[3]];
		
		entity[propertydata[3]] = val;
		if(setmethod ~= nil) then

			-- base类属性或者进入世界后cell类属性会触发set_*方法
			if(flags == 0x00000020 or flags == 0x00000040) then
				if(entity.inited) then
					setmethod(entity, oldval);
				end
			else
				if(entity.inWorld) then
					setmethod(entity, oldval);
				end
			end
		end
	end
end

CityEngineLua.Client_onUpdatePropertysOptimized = function(stream)
	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	CityEngineLua.onUpdatePropertys_(eid, stream);
end

CityEngineLua.Client_onUpdatePropertys = function(stream)
	local eid = stream:readInt32();
	CityEngineLua.onUpdatePropertys_(eid, stream);
end

CityEngineLua.onRemoteMethodCall_ = function(eid, stream)
	local entity = CityEngineLua.entities[eid];
	
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onRemoteMethodCall: entity(" .. eid .. ") not found!");
		return;
	end

	local sm = CityEngineLua.moduledefs[entity.className];
	
	local methodUtype = 0;
	local componentPropertyUType = 0;

	if(sm.useMethodDescrAlias) then
		componentPropertyUType = stream:readUint8();
		methodUtype = stream:readUint8();
	else
		componentPropertyUType = stream:readUint16();
		methodUtype = stream:readUint16();
	end

	local methoddata = nil;
	if(componentPropertyUType == 0) then
		methoddata = sm.methods[methodUtype];
	else
		return;
	end
	
	local args = {};
	local argsdata = methoddata[4];
	for i=1, #argsdata do
		table.insert(args, argsdata[i]:createFromStream(stream));
	end
	
	if(entity[methoddata[3]] ~= nil) then
		entity[methoddata[3]](entity, unpack(args));
	else
		ct.log("CityEngineApp::Client_onRemoteMethodCall: entity(" .. eid .. ") not found method(" .. methoddata[2] .. ")!");
	end
end

CityEngineLua.Client_onRemoteMethodCallOptimized = function(stream)
	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	CityEngineLua.onRemoteMethodCall_(eid, stream);
end

CityEngineLua.Client_onRemoteMethodCall = function(stream)
	local eid = stream:readInt32();
	CityEngineLua.onRemoteMethodCall_(eid, stream);
end


--服务端通知一个实体进入了世界(如果实体是当前玩家则玩家第一次在一个space中创建了， 如果是其他实体则是其他实体进入了玩家的View)
CityEngineLua.Client_onEntityEnterWorld = function(stream)
	local eid = stream:readInt32();
	if(CityEngineLua.entity_id > 0 and eid ~= CityEngineLua.entity_id) then
		table.insert(CityEngineLua.entityIDAliasIDList, eid);
	end
	
	local entityType;
	if(#CityEngineLua.moduledefs > 255) then
		entityType = stream:readUint16();
	else
		entityType = stream:readUint8();
	end
	
	local isOnGround = 1;
	
	if(stream:length() > 0) then
		isOnGround = stream:readInt8();
	end
	
	entityType = CityEngineLua.moduledefs[entityType].name;
	ct.log("CityEngineApp::Client_onEntityEnterWorld: " .. entityType .. "(" .. eid .. "), spaceID(" .. CityEngineLua.spaceID .. "), isOnGround(" .. isOnGround .. ")!");
	
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		
		entityMessage = CityEngineLua.bufferedCreateEntityMessage[eid];
		if(entityMessage == nil) then
			ct.log("CityEngineApp::Client_onEntityEnterWorld: entity(" .. eid .. ") not found!");
			return;
		end
		
		local runclass = CityEngineLua[entityType];
		if(runclass == nil)  then
			return;
		end
		
		local entity = runclass:New();
		entity.id = eid;
		entity.className = entityType;

		entity.cellEntityCall = CityEngineLua.EntityCall:New();
		entity.cellEntityCall.id = eid;
		entity.cellEntityCall.className = entityType;
		entity.cellEntityCall.type = CityEngineLua.ENTITYCALL_TYPE_CELL;
		
		CityEngineLua.entities[eid] = entity;
		
		CityEngineLua.Client_onUpdatePropertys(entityMessage);
		CityEngineLua.bufferedCreateEntityMessage[eid] = nil;
		
		entity.isOnGround = isOnGround > 0;
		entity:__init__();
		entity.inited = true;
		entity.inWorld = true;
		entity:enterWorld();
		
		if(CityEngineLua.isOnInitCallPropertysSetMethods) then
			entity:callPropertysSetMethods();
		end
		
		entity:set_direction(entity.direction);
		entity:set_position(entity.position);
	else
		if(not entity.inWorld) then
			entity.cellEntityCall = CityEngineLua.EntityCall:New();
			entity.cellEntityCall.id = eid;
			entity.cellEntityCall.className = entityType;
			entity.cellEntityCall.type = CityEngineLua.ENTITYCALL_TYPE_CELL;

			-- 安全起见， 这里清空一下
			-- 如果服务端上使用giveClientTo切换控制权
			-- 之前的实体已经进入世界， 切换后的实体也进入世界， 这里可能会残留之前那个实体进入世界的信息
			CityEngineLua.entityIDAliasIDList = {};
			CityEngineLua.entities = {}
			CityEngineLua.entities[entity.id] = entity;

			entity:set_direction(entity.direction);
			entity:set_position(entity.position);

			CityEngineLua.entityServerPos.x = entity.position.x;
			CityEngineLua.entityServerPos.y = entity.position.y;
			CityEngineLua.entityServerPos.z = entity.position.z;
			
			entity.isOnGround = isOnGround > 0;
			entity.inWorld = true;
			entity:enterWorld();
			
			if(CityEngineLua.isOnInitCallPropertysSetMethods) then
				entity:callPropertysSetMethods();
			end
		end
	end
end


--服务端使用优化的方式通知一个实体离开了世界(如果实体是当前玩家则玩家离开了space， 如果是其他实体则是其他实体离开了玩家的View)
CityEngineLua.Client_onEntityLeaveWorldOptimized = function(stream)
	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	CityEngineLua.Client_onEntityLeaveWorld(eid);
end


--服务端通知一个实体离开了世界(如果实体是当前玩家则玩家离开了space， 如果是其他实体则是其他实体离开了玩家的View)
CityEngineLua.Client_onEntityLeaveWorld = function(eid)
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onEntityLeaveWorld: entity(" .. eid .. ") not found!");
		return;
	end
	
	if(entity.inWorld) then
		entity:leaveWorld();
	end

	if(this.entity_id == eid) then
		this.clearSpace(false);
		entity.cellEntityCall = nil;
	else
		table.removeItem(this.controlledEntities, entity, false);
		--if(_controlledEntities.Remove(entity))
		--	Event.fireOut("onLoseControlledEntity", new object[]{entity});
		this.entities[eid] = nil;
		entity:onDestroy();
		table.removeItem(this.entityIDAliasIDList, eid, false);
	end
end

CityEngineLua.Client_onEntityDestroyed = function(eid)
	ct.log("CityEngineApp::Client_onEntityDestroyed: entity(" .. eid .. ")!");
	
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onEntityDestroyed: entity(" .. eid .. ") not found!");
		return;
	end

	if(entity.inWorld) then
		if(CityEngineLua.entity_id == eid) then
			CityEngineLua.clearSpace(false);
		end
		entity:leaveWorld();
	end

	table.removeItem(this.controlledEntities, entity, false);
	--if(_controlledEntities.Remove(entity))
	--	Event.fireOut("onLoseControlledEntity", new object[]{entity});
		
	CityEngineLua.entities[eid] = nil;
	entity.onDestroy();

end

--服务端通知当前玩家进入了一个新的space
CityEngineLua.Client_onEntityEnterSpace = function(stream)

	local eid = stream:readInt32();
	CityEngineLua.spaceID = stream:readUint32();
	local isOnGround = true;
	
	if(stream:length() > 0) then
		isOnGround = stream:readInt8();
	end
	
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onEntityEnterSpace: entity(" .. eid .. ") not found!");
		return;
	end
	
	CityEngineLua.entityServerPos.x = entity.position.x;
	CityEngineLua.entityServerPos.y = entity.position.y;
	CityEngineLua.entityServerPos.z = entity.position.z;
	entity:enterSpace();
end

--服务端通知当前玩家离开了space
CityEngineLua.Client_onEntityLeaveSpace = function(eid)
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onEntityLeaveSpace: entity(" .. eid .. ") not found!");
		return;
	end
	
	CityEngineLua.clearSpace(false);
	entity:leaveSpace();
end

--账号创建返回结果
CityEngineLua.Client_v_onCreateAccountResult = function(stream)

	local retcode = stream:readUint16();
	local datas = stream:readBlob();
	
	Event.Brocast("c_onCreateAccountResult", retcode, datas);

	if(retcode ~= 0) then
		ct.log("CityEngineApp::Client_v_onCreateAccountResult: " .. CityEngineLua.username .. " create is failed! code=" .. CityEngineLua.serverErrs[retcode].name .. "!");
		return;
	end

	
	ct.log("CityEngineApp::Client_v_onCreateAccountResult: " .. CityEngineLua.username .. " create is successfully!");
end


--	告诉客户端：你当前负责（或取消）控制谁的位移同步
CityEngineLua.Client_onControlEntity = function(eid, isControlled)

	local entity = this.entities[eid];

	if (entity == nil) then
		ct.log("City::Client_onControlEntity: entity(" .. eid .. ") not found!");
		return;
	end

	local isCont = isControlled ~= 0;
	if (isCont) then
		-- 如果被控制者是玩家自己，那表示玩家自己被其它人控制了
		-- 所以玩家自己不应该进入这个被控制列表
		if (this.player().id ~= entity.id) then
			table.insert(this.controlledEntities, entity);
		end
	else
		table.removeItem(this.controlledEntities, entity, false);
	end
	
	entity.isControlled = isCont;
	
	entity.onControlled(isCont);
	--Event.fireOut("onControlled", new object[]{entity, isCont});
end

CityEngineLua.updatePlayerToServer = function()

	if not this.syncPlayer or this.spaceID == 0 then 
		return;
	end

	local now = os.clock();

	local span = now - this._lastUpdateToServerTime; 
	if(span < 0.05) then
		return;
	end

	local player = CityEngineLua.player();
	
	if(player == nil or player.inWorld == false or CityEngineLua.spaceID == 0 or player.isControlled) then
		return;
    end

    this._lastUpdateToServerTime = now - (span - 0.05);

    --ct.log(player.position.x .. " " .. player.position.y);
	if(Vector3.Distance(player._entityLastLocalPos, player.position) > 0.001 or Vector3.Distance(player._entityLastLocalDir, player.direction) > 0.001) then
	
		-- 记录玩家最后一次上报位置时自身当前的位置
		player._entityLastLocalPos.x = player.position.x;
		player._entityLastLocalPos.y = player.position.y;
		player._entityLastLocalPos.z = player.position.z;
		player._entityLastLocalDir.x = player.direction.x;
		player._entityLastLocalDir.y = player.direction.y;
		player._entityLastLocalDir.z = player.direction.z;	
						
		local bundle = CityEngineLua.Bundle:new();
		bundle:newMessage(CityEngineLua.messages["Baseapp_onUpdateDataFromClient"]);
		bundle:writeFloat(player.position.x);
		bundle:writeFloat(player.position.y);
		bundle:writeFloat(player.position.z);

		local x = player.direction.x * CityEngineLua.deg2rad;
		local y = player.direction.y * CityEngineLua.deg2rad;
		local z = player.direction.z * CityEngineLua.deg2rad;
		-- 根据弧度转角度公式会出现负数
		-- unity会自动转化到0~360度之间，这里需要做一个还原
		if(x - Mathf.PI > 0.0) then
			x = x - Mathf.PI * 2;
		end

		if(y - Mathf.PI > 0.0) then
			y = y - Mathf.PI * 2;
		end
		
		if(z - Mathf.PI > 0.0) then
			z = z - Mathf.PI * 2;
		end

		bundle:writeFloat(x);
		bundle:writeFloat(y);
		bundle:writeFloat(z);
		bundle:writeUint8((player.isOnGround and 1) or 0);
		bundle:writeUint32(this.spaceID);
		bundle:send();
	end

	-- 开始同步所有被控制了的entity的位置
	for i, e in ipairs(this.controlledEntities) do
		local entity = this.controlledEntities[i];
		position = entity.position;
		direction = entity.direction;

		posHasChanged = Vector3.Distance(entity._entityLastLocalPos, position) > 0.001;
		dirHasChanged = Vector3.Distance(entity._entityLastLocalDir, direction) > 0.001;

		if (posHasChanged or dirHasChanged) then
			entity._entityLastLocalPos = position;
			entity._entityLastLocalDir = direction;

			local bundle = CityEngineLua.Bundle:new();
			bundle:newMessage(Message.messages["Baseapp_onUpdateDataFromClientForControlledEntity"]);
			bundle:writeInt32(entity.id);
			bundle:writeFloat(position.x);
			bundle:writeFloat(position.y);
			bundle:writeFloat(position.z);

			--double x = ((double)direction.x / 360 * (System.Math.PI * 2));
			--double y = ((double)direction.y / 360 * (System.Math.PI * 2));
			--double z = ((double)direction.z / 360 * (System.Math.PI * 2));
		
			-- 根据弧度转角度公式会出现负数
			-- unity会自动转化到0~360度之间，这里需要做一个还原
			--if(x - System.Math.PI > 0.0)
			--	x -= System.Math.PI * 2;

			--if(y - System.Math.PI > 0.0)
			--	y -= System.Math.PI * 2;
			
			--if(z - System.Math.PI > 0.0)
			--	z -= System.Math.PI * 2;
			
			bundle:writeFloat(direction.x);
			bundle:writeFloat(direction.y);
			bundle:writeFloat(direction.z);
			bundle:writeUint8((entity.isOnGround and 1) or 0);
			bundle:writeUint32(this.spaceID);
			bundle:send();
		end
	end
end

CityEngineLua.addSpaceGeometryMapping = function(spaceID, respath)

	ct.log("CityEngineApp::addSpaceGeometryMapping: spaceID(" .. spaceID .. "), respath(" .. respath .. ")!");
	
	CityEngineLua.spaceID = spaceID;
	CityEngineLua.spaceResPath = respath;
	Event.Brocast("addSpaceGeometryMapping", respath);
end

CityEngineLua.clearSpace = function(isAll)
	CityEngineLua.entityIDAliasIDList = {};
	CityEngineLua.spacedata = {};
	CityEngineLua.clearEntities(isAll);
	CityEngineLua.isLoadedGeometry = false;
	CityEngineLua.spaceID = 0;
end

CityEngineLua.clearEntities = function(isAll)

	this.controlledEntities = {};

	if(not isAll) then
		local entity = CityEngineLua.player();
		for eid, e in pairs(CityEngineLua.entities) do
		 
			if(eid ~= entity.id) then
				if(CityEngineLua.entities[eid].inWorld) then
			    	CityEngineLua.entities[eid]:leaveWorld();
			    end
			    
			    CityEngineLua.entities[eid]:onDestroy();
			end
		end  
			
		CityEngineLua.entities = {}
		CityEngineLua.entities[entity.id] = entity;
	else
		for eid, e in pairs(CityEngineLua.entities) do
			if(CityEngineLua.entities[eid].inWorld) then
		    	CityEngineLua.entities[eid]:leaveWorld();
		    end
		    
		    CityEngineLua.entities[eid]:onDestroy();
		end  
			
		CityEngineLua.entities = {};
	end
end

CityEngineLua.Client_initSpaceData = function(stream)

	CityEngineLua.clearSpace(false);
	
	CityEngineLua.spaceID = stream:readInt32();
	while(stream:length() > 0) do
		local key = stream:readString();
		local value = stream:readString();
		CityEngineLua.Client_setSpaceData(CityEngineLua.spaceID, key, value);
	end
	
	--ct.log("CityEngineApp::Client_initSpaceData: spaceID(" .. CityEngineLua.spaceID .. "), datas(" .. CityEngineLua.spacedata["_mapping"] .. ")!");
end

CityEngineLua.Client_setSpaceData = function(spaceID, key, value)

	ct.log("CityEngineApp::Client_setSpaceData: spaceID(" .. spaceID .. "), key(" .. key .. "), value(" .. value .. ")!");
	
	CityEngineLua.spacedata[key] = value;
	
	if(key == "_mapping") then
		CityEngineLua.addSpaceGeometryMapping(spaceID, value);
    end
	
	--City.Event.fire("onSetSpaceData", spaceID, key, value);
end

CityEngineLua.Client_delSpaceData = function(spaceID, key)

	ct.log("CityEngineApp::Client_delSpaceData: spaceID(" .. spaceID .. "), key(" .. key .. ")!");
	
	CityEngineLua.spacedata[key] = nil;
	City.Event.fire("onDelSpaceData", spaceID, key);
end

CityEngineLua.Client_getSpaceData = function(spaceID, key)
	return CityEngineLua.spacedata[key];
end

CityEngineLua.Client_onUpdateBasePos = function(x, y, z)

	this.entityServerPos.x = x;
	this.entityServerPos.y = y;
	this.entityServerPos.z = z;

	local entity = this.player();
	if (entity ~= nil and entity.isControlled) then
		entity.position.x = _entityServerPos.x;
		entity.position.y = _entityServerPos.y;
		entity.position.z = _entityServerPos.z;
		Event.Brocast("updatePosition", entity);
		entity.onUpdateVolatileData();
	end
end

CityEngineLua.Client_onUpdateBasePosXZ = function(x, z)

	CityEngineLua.entityServerPos.x = x;
	CityEngineLua.entityServerPos.z = z;

	local entity = this.player();
	if (entity ~= nil and entity.isControlled) then
		entity.position.x = _entityServerPos.x;
		entity.position.z = _entityServerPos.z;
		Event.Brocast("updatePosition", entity);
		entity.onUpdateVolatileData();
	end
end

CityEngineLua.Client_onUpdateBaseDir = function(stream)
	local x = stream:readFloat();
	local y = stream:readFloat();
	local z = stream:readFloat();

	local entity = this.player();
	if (entity ~= nil and entity.isControlled) then
		entity.direction.x = x;
		entity.direction.y = y;
		entity.direction.z = z;
		Event.Brocast("set_direction", entity);
		entity.onUpdateVolatileData();
	end
end

CityEngineLua.Client_onUpdateData = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onUpdateData: entity(" .. eid .. ") not found!");
		return;
	end
end

CityEngineLua.Client_onSetEntityPosAndDir = function(stream)

	local eid = stream:readInt32();
	local entity = CityEngineLua.entities[eid];
	if(entity == nil) then
		ct.log("CityEngineApp::Client_onSetEntityPosAndDir: entity(" .. eid .. ") not found!");
		return;
	end
	
	entity.position.x = stream:readFloat();
	entity.position.y = stream:readFloat();
	entity.position.z = stream:readFloat();
	entity.direction.x = stream:readFloat();
	entity.direction.y = stream:readFloat();
	entity.direction.z = stream:readFloat();
	
	-- 记录玩家最后一次上报位置时自身当前的位置
	entity._entityLastLocalPos.x = entity.position.x;
	entity._entityLastLocalPos.y = entity.position.y;
	entity._entityLastLocalPos.z = entity.position.z;
	entity._entityLastLocalDir.x = entity.direction.x;
	entity._entityLastLocalDir.y = entity.direction.y;
	entity._entityLastLocalDir.z = entity.direction.z;	
			
	entity:set_direction(entity.direction);
	entity:set_position(entity.position);
end

CityEngineLua.Client_onUpdateData_ypr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local y = stream:readInt8();
	local p = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, y, p, r, -1);
end

CityEngineLua.Client_onUpdateData_yp = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local y = stream:readInt8();
	local p = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, y, p, CityEngineLua.CITY_FLT_MAX, -1);
end

CityEngineLua.Client_onUpdateData_yr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local y = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, y, CityEngineLua.CITY_FLT_MAX, r, -1);
end

CityEngineLua.Client_onUpdateData_pr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local p = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, p, r, -1);
end

CityEngineLua.Client_onUpdateData_y = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local y = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, y, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, -1);
end

CityEngineLua.Client_onUpdateData_p = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local p = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, p, CityEngineLua.CITY_FLT_MAX, -1);
end

CityEngineLua.Client_onUpdateData_r = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, r, -1);
end

CityEngineLua.Client_onUpdateData_xz = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, 1);
end

CityEngineLua.Client_onUpdateData_xz_ypr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local y = stream:readInt8();
	local p = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, y, p, r, 1);
end

CityEngineLua.Client_onUpdateData_xz_yp = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local y = stream:readInt8();
	local p = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, y, p, CityEngineLua.CITY_FLT_MAX, 1);
end

CityEngineLua.Client_onUpdateData_xz_yr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local y = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, y, CityEngineLua.CITY_FLT_MAX, r, 1);
end

CityEngineLua.Client_onUpdateData_xz_pr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local p = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, CityEngineLua.CITY_FLT_MAX, p, r, 1);
end

CityEngineLua.Client_onUpdateData_xz_y = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local y = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, y, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, 1);
end

CityEngineLua.Client_onUpdateData_xz_p = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local p = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, CityEngineLua.CITY_FLT_MAX, p, CityEngineLua.CITY_FLT_MAX, 1);
end

CityEngineLua.Client_onUpdateData_xz_r = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();

	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, CityEngineLua.CITY_FLT_MAX, xz.y, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, r, 1);
end

CityEngineLua.Client_onUpdateData_xyz = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, 0);
end

CityEngineLua.Client_onUpdateData_xyz_ypr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local yaw = stream:readInt8();
	local p = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, yaw, p, r, 0);
end

CityEngineLua.Client_onUpdateData_xyz_yp = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local yaw = stream:readInt8();
	local p = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, yaw, p, CityEngineLua.CITY_FLT_MAX, 0);
end

CityEngineLua.Client_onUpdateData_xyz_yr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local yaw = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, yaw, CityEngineLua.CITY_FLT_MAX, r, 0);
end

CityEngineLua.Client_onUpdateData_xyz_pr = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local p = stream:readInt8();
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, CityEngineLua.CITY_FLT_MAX, p, r, 0);
end

CityEngineLua.Client_onUpdateData_xyz_y = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local yaw = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, yaw, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, 0);
end

CityEngineLua.Client_onUpdateData_xyz_p = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local p = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, CityEngineLua.CITY_FLT_MAX, p, CityEngineLua.CITY_FLT_MAX, 0);
end

CityEngineLua.Client_onUpdateData_xyz_r = function(stream)

	local eid = CityEngineLua.getViewEntityIDFromStream(stream);
	
	local xz = stream:readPackXZ();
	local y = stream:readPackY();
	
	local r = stream:readInt8();
	
	CityEngineLua._updateVolatileData(eid, xz.x, y, xz.y, CityEngineLua.CITY_FLT_MAX, CityEngineLua.CITY_FLT_MAX, r, 0);
end

CityEngineLua._updateVolatileData = function(entityID, x, y, z, yaw, pitch, roll, isOnGround)

	local entity = CityEngineLua.entities[entityID];
	if(entity == nil) then
		-- 如果为0且客户端上一步是重登陆或者重连操作并且服务端entity在断线期间一直处于在线状态
		-- 则可以忽略这个错误, 因为cellapp可能一直在向baseapp发送同步消息， 当客户端重连上时未等
		-- 服务端初始化步骤开始则收到同步信息, 此时这里就会出错。			
		ct.log("CityEngineApp::_updateVolatileData: entity(" .. entityID .. ") not found!");
		return;
	end
	
	-- 小于0不设置
	if(isOnGround >= 0) then
		entity.isOnGround = (isOnGround > 0);
	end
	
	local changeDirection = false;
	
	if(roll ~= CityEngineLua.CITY_FLT_MAX) then
		changeDirection = true;
		entity.direction.x = CityEngineLua.int82angle(roll, false);
	end

	if(pitch ~= CityEngineLua.CITY_FLT_MAX) then
		changeDirection = true;
		entity.direction.y = CityEngineLua.int82angle(pitch, false);
	end
	
	if(yaw ~= CityEngineLua.CITY_FLT_MAX) then
		changeDirection = true;
		entity.direction.z = CityEngineLua.int82angle(yaw, false);
	end
	
	local done = false;
	if(changeDirection == true) then
		Event.Brocast("set_direction", entity);		
		done = true;
	end
	
	local positionChanged = x ~= CityEngineLua.CITY_FLT_MAX or y ~= CityEngineLua.CITY_FLT_MAX or z ~= CityEngineLua.CITY_FLT_MAX;
	if (x == CityEngineLua.CITY_FLT_MAX) then x = 0.0; end
	if (y == CityEngineLua.CITY_FLT_MAX) then y = 0.0; end
	if (z == CityEngineLua.CITY_FLT_MAX) then z = 0.0; end
            
	if(positionChanged) then
		entity.position.x = x + CityEngineLua.entityServerPos.x;
		entity.position.y = y + CityEngineLua.entityServerPos.y;
		entity.position.z = z + CityEngineLua.entityServerPos.z;
		
		done = true;
		Event.Brocast("updatePosition", entity);
	end
	
	if(done) then
		entity.onUpdateVolatileData();		
    end
end

--CityEngineLua.login = function( username, password, data )
--	CityEngineLua.username = username;
--	CityEngineLua.password = password;
--    CityEngineLua._clientdatas = data;
--
--	CityEngineLua.login_loginapp(true);
--end

--注意，这里在运行时会调用不过来
CityEngineLua.onConnectionState = function( state )
	ct.log("system","[m_onConnectionState]",state.error)
	Event.Brocast("c_ConnectionStateChange", state );
	if state.error == '' then
		ct.log("system","[CityEngineLua.onConnectionState]"..state.error)
	elseif state.error == 'Connect server succeed' then --连接成功
		ct.log("system","[CityEngineLua.onConnectionState]"..state.error)
	elseif state.error == 'Manual close connection' then --手动断开成功
		ct.log("system","[CityEngineLua.onConnectionState]"..state.error)
	else
		ct.MsgBox("网络连接错误", "错误原因：" ..state.error)
		ct.log("system","[CityEngineLua.onConnectionState]"..state.error)
	end
end

--登录到服务端(loginapp), 登录成功后还必须登录到网关(baseapp)登录流程才算完毕
CityEngineLua.login_loginapp = function( noconnect )
	if noconnect then
		this.reset();
		local timer = FrameTimer.New(function()
			this._networkInterface:connectTo(this.ip, this.port, this.onConnectTo_loginapp_callback, nil);
		end, 10, 0)
		timer:Start()
	else
		--清除所有注册的网络消息
		----ct.log("City::login_loginapp(): send login! username=" .. this.username);
		------1、 获取协议id
		--local msgId = pb.asCode.login
		------2、 填充 protobuf 内部协议数据
		----local msglogion = pb.as.Login()
		----msglogion.account = this.username
		----local pb_login = msglogion:SerializeToString()  -- Parse Example
		------3、 创建包，填入数据并发包
		----CityEngineLua.Bundle:newAndSendMsg(msgId,pb_login);

		----1、 获取协议id
		local msgId = pbl.enum("ascode.OpCode","login")
		----2、 填充 protobuf 内部协议数据
		local msglogion = {
			account = this.username
		}
		-- 序列化成二进制数据
		local pb_login = assert(pbl.encode("as.Login", msglogion))
		--发包
		CityEngineLua.Bundle:newAndSendMsg(msgId,pb_login);
		--多连接测试
		--UnitTest.Exec_now("wk24_abel_mutiConnect", "c_wk24_abel_mutiConnect",self)
	end
end

CityEngineLua.onConnectTo_loginapp_callback = function( ip, port, success, netState)
	this._lastTickCBTime = os.clock();

	this.onConnectionState(netState)
			
	this.currserver = "loginapp";
	this.currstate = "login";
			
	ct.log("City::login_loginapp(): connect ".. ip.. ":"..port.." success!");

	this.login_loginapp(false);

end

CityEngineLua.onLogin_loginapp = function()
	this._lastTickCBTime = os.clock();
	if not this.loginappMessageImported_ then
		local bundle = CityEngineLua.Bundle:new();
		bundle:newMessage(CityEngineLua.messages["Loginapp_importClientMessages"]);
		bundle:send();
		ct.log("City::onLogin_loginapp: send importClientMessages ...");
	else
		this.onImportClientMessagesCompleted();
	end
end

CityEngineLua.connectToGs = function()
	this._networkInterface = City.NetworkInterface.New();
	this._networkInterface:connectTo(this.baseappIP, this.baseappPort, this.onConnectTo_baseapp_callback, nil);
end

-----登录到服务端，登录到网关(baseapp)
CityEngineLua.login_baseapp = function(noconnect)
	if(noconnect) then
		--Event.fireOut("onLoginBaseapp", new object[]{});
 		this._networkInterface:reset();
		this.currserver = "baseapp";
		this._networkInterface = City.NetworkInterface.New();
		this._networkInterface:connectTo(this.baseappIP, this.baseappPort, this.onConnectTo_baseapp_callback, nil);
		--if this._networkInterface then
		--	return
		--else
		--	this._networkInterface = City.NetworkInterface.New();
		--	this._networkInterface:connectTo(this.baseappIP, this.baseappPort, this.onConnectTo_baseapp_callback, nil);
		--end
	else
		--gs 登录
		----1、 获取协议id
		local msgId = pbl.enum("gscode.OpCode","login")
		----2、 填充 protobuf 内部协议数据
		local lMsg = { account = CityEngineLua.username, token = CityEngineLua.token}
		local pMsg = assert(pbl.encode("gs.Login", lMsg))
		----3、 创建包，填入数据并发包
		CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);
	end
end

CityEngineLua.onConnectTo_baseapp_callback = function(ip, port, success, netState)
	this._lastTickCBTime = os.clock();
	this.onConnectionState(netState)
	
	this.currserver = "baseapp";
	this.currstate = "";
	
	logDebug("City::login_baseapp(): connect "..ip..":"..port.." is successfully!");
	Event.Brocast("c_GsConnected", true );
	this.login_baseapp(false);
end

--登录到服务端，登录到交易服务器
CityEngineLua.login_tradeapp = function(noconnect)
	if(noconnect) then
		this._tradeNetworkInterface1 = City.NetworkInterface.New();
		this._tradeNetworkInterface1:connectTo(this.tradeappIP, this.tradeappPort, this.onConnectTo_tradeapp_callback, nil);
	else
		--UnitTest.Exec_now("wk24_abel_mutiConnect_revMsg", "c_wk24_abel_mutiConnect_revMsg",self)
		----ss 登录
		----1、 获取协议id
		--local msgId = pbl.enum("sscode.OpCode","queryPlayerEconomy")
		----2、 填充 protobuf 内部协议数据
		--local lMsg = { id = "123"}
		--local pMsg = assert(pbl.encode("ss.Id", lMsg))
		----3、 创建包，填入数据并发包
		--CityEngineLua.Bundle:newAndSendMsgExt(msgId, pMsg, this._tradeNetworkInterface1);
		if this._tradeNetworkInterface1 then
			this._tradeNetworkInterface1:reset()
			this._tradeNetworkInterface1 = nil
		end
	end
end

CityEngineLua.onConnectTo_tradeapp_callback = function(ip, port, success, netState)
	this._lastTickCBTime = os.clock();
	this.onConnectionState(netState)

	--this.currserver = "baseapp";
	--this.currstate = "";

	logDebug("City::login_tradeapp(): connect "..ip..":"..port.." is successfully!");
	--Event.Brocast("c_GsConnected", true );
	--this.login_tradeapp(false)
end

CityEngineLua.hello = function()

	local bundle = CityEngineLua.Bundle:new();

	if CityEngineLua.currserver == "loginapp" then
		bundle:newMessage(CityEngineLua.messages["Loginapp_hello"]);
	else
		bundle:newMessage(CityEngineLua.messages["Baseapp_hello"]);
	end

	bundle:writeBytes(CityEngineLua.clientVersion);
	bundle:writeBytes(CityEngineLua.clientScriptVersion);
	bundle:writeBlob(CityLuaUtil.Utf8ToByte(CityEngineLua._encryptedKey));
	bundle:send();
end

CityEngineLua.Client_onHelloCB = function( stream )

end

CityEngineLua.onServerDigest = function()
	if this._persistentInfos ~= nil then
		this._persistentInfos:onServerDigest(this.currserver, this.serverProtocolMD5, this.serverEntitydefMD5);
	end
end



	--登录loginapp失败了
CityEngineLua.Client_v_onLoginFailed = function(stream)
	local failedcode = stream:readUint16();
	this._serverdatas = stream:readBlob();
	ct.log("City::Client_v_onLoginFailed: failedcode(" .. failedcode .. "), datas(" .. this._serverdatas.Length .. ")!");
	Event.Brocast("c_onLoginFailed", failedcode);
end

CityEngineLua.Client_onLoginSuccessfully = function(stream)

end




CityEngineLua.reset = function()
	--City.Event.clearFiredEvents();
	CityEngineLua.clearEntities(true);

	this.currserver = "";
	this.currstate = "";
	this._serverdatas = {};
	this.serverVersion = "";
	this.serverScriptVersion = "";
	
	this.entity_uuid = 0;
	this.entity_id = 0;
	this.entity_type = "";

    this.spaceID = 0;
    this.spaceResPath = "";
    this.isLoadedGeometry = false;
	
	this.bufferedCreateEntityMessage = {};

	if this._networkInterface then
		if this._networkInterface._ConnectState then
			this._networkInterface._ConnectState.error = 'Manual close connection'
		end
		this._networkInterface:reset();
	end
	if this._tradeNetworkInterface1 then
		if this._networkInterface._ConnectState then
			this._tradeNetworkInterface1._ConnectState.error = 'Manual close connection'
		end
		this._tradeNetworkInterface1:reset();
	end
	this._lastTickTime = os.clock();
	this._lastTickCBTime = os.clock();
	this._lastUpdateToServerTime = os.clock();

	this.spacedata = {};
	this.entityIDAliasIDList = {};
	
end


CityEngineLua.onOpenLoginapp_resetpassword = function()
	ct.log("City::onOpenLoginapp_resetpassword: successfully!");
	this.currserver = "loginapp";
	this.currstate = "resetpassword";
	this._lastTickCBTime = os.clock();
	
	if(not this.loginappMessageImported_) then
		local bundle = CityEngineLua.Bundle:new();
		bundle:newMessage(CityEngineLua.messages["Loginapp_importClientMessages"]);
		bundle:send();
		ct.log("City::onOpenLoginapp_resetpassword: send importClientMessages ...");
	else
		this.onImportClientMessagesCompleted();
	end
end

	--重置密码, 通过loginapp
CityEngineLua.resetPassword = function(username)
	this.username = username;
	this.resetpassword_loginapp(true);
end


	--重置密码, 通过loginapp
CityEngineLua.resetpassword_loginapp = function(noconnect)
	if(noconnect) then
		this.reset();
		this._networkInterface:connectTo(this.ip, this.port, this.onConnectTo_resetpassword_callback, nil);
	else
		local bundle = CityEngineLua.Bundle:new();
		bundle:newMessage(CityEngineLua.messages["Loginapp_reqAccountResetPassword"]);
		bundle:writeBytes(this.username);
		bundle:send();
	end
end

CityEngineLua.onConnectTo_resetpassword_callback = function(ip, port, success, userData)
	this._lastTickCBTime = os.clock();

	if(not success) then
		ct.log("City::resetpassword_loginapp(): connect "..ip..":"..port.." is error!");
		return;
	end
	
	ct.log("City::resetpassword_loginapp(): connect "..ip..":"..port.." is success!");
	this.onOpenLoginapp_resetpassword();
end

CityEngineLua.Client_onReqAccountResetPasswordCB = function(failcode)
	if(failcode ~= 0) then
		ct.log("City::Client_onReqAccountResetPasswordCB: " .. this.username .. " is failed! code=" .. failcode .. "!");
		return;
	end
	ct.log("City::Client_onReqAccountResetPasswordCB: " .. this.username .. " is successfully!");
end

	--绑定Email，通过baseapp

CityEngineLua.bindAccountEmail = function(emailAddress)
	local bundle = CityEngineLua.Bundle:new();
	bundle:newMessage(CityEngineLua.messages["Baseapp_reqAccountBindEmail"]);
	bundle:writeInt32(this.entity_id);
	bundle:writeBytes(this.password);
	bundle:writeBytes(emailAddress);
	bundle:send();
end

CityEngineLua.Client_onReqAccountBindEmailCB = function(failcode)
	if(failcode ~= 0) then
		ct.log("City::Client_onReqAccountBindEmailCB: " .. this.username .. " is failed! code=" .. failcode .. "!");
		return;
	end

	ct.log("City::Client_onReqAccountBindEmailCB: " .. this.username .. " is successfully!");
end

----设置新密码，通过baseapp， 必须玩家登录在线操作所以是baseapp。

CityEngineLua.newPassword = function(old_password, new_password)
	local bundle = CityEngineLua.Bundle:new();
	bundle:newMessage(CityEngineLua.messages["Baseapp_reqAccountNewPassword"]);
	bundle:writeInt32(this.entity_id);
	bundle:writeBytes(old_password);
	bundle:writeBytes(new_password);
	bundle:send();
end

CityEngineLua.Client_onReqAccountNewPasswordCB = function(failcode)
	if(failcode ~= 0) then
		ct.log("City::Client_onReqAccountNewPasswordCB: " .. this.username .. " is failed! code=" .. failcode .. "!");
		return;
	end

	ct.log("City::Client_onReqAccountNewPasswordCB: " .. this.username .. " is successfully!");
end

CityEngineLua.createAccount = function(username, password, data)
	this.username = username;
	this.password = password;
    this._clientdatas = data;
	
	this.createAccount_loginapp(true);
end


	--创建账号，通过loginapp

CityEngineLua.createAccount_loginapp = function(noconnect)
	if(noconnect) then
		this.reset();
		this._networkInterface:connectTo(this.ip, this.port, this.onConnectTo_createAccount_callback, nil);
	else
		local bundle = CityEngineLua.Bundle:new();
		bundle:newMessage(CityEngineLua.messages["Loginapp_reqCreateAccount"]);
		bundle:writeBytes(this.username);
		bundle:writeBytes(this.password);
		bundle:writeBlob(CityLuaUtil.Utf8ToByte(this._clientdatas));
		bundle:send();
	end
end

CityEngineLua.onOpenLoginapp_createAccount = function()
	ct.log("City::onOpenLoginapp_createAccount: successfully!");
	this.currserver = "loginapp";
	this.currstate = "createAccount";
	this._lastTickCBTime = os.clock();
	
	if( not this.loginappMessageImported_) then
		local bundle = CityEngineLua.Bundle:new();
		bundle:newMessage(CityEngineLua.messages["Loginapp_importClientMessages"]);
		bundle:send();
		ct.log("City::onOpenLoginapp_createAccount: send importClientMessages ...");
	else
		this.onImportClientMessagesCompleted();
	end
end

CityEngineLua.onConnectTo_createAccount_callback = function(ip, port, success, userData)
	this._lastTickCBTime = os.clock();

	if( not success) then
		logError("City::createAccount_loginapp(): connect "..ip..":"..port.." is error!");
		return;
	end
	
	ct.log("City::createAccount_loginapp(): connect "..ip..":"..port.." is success!");
	this.onOpenLoginapp_createAccount();
end


--	引擎版本不匹配

CityEngineLua.Client_onVersionNotMatch = function(stream)
	this.serverVersion = stream:readString();
	
	logError("Client_onVersionNotMatch: verInfo=" .. this.clientVersion .. "(server: " .. this.serverVersion .. ")");
	--Event.fireAll("onVersionNotMatch", new object[]{clientVersion, serverVersion});
	
	if(this._persistentInfos ~= nil) then
		this._persistentInfos:onVersionNotMatch(this.clientVersion, this.serverVersion);
	end
end

--	脚本版本不匹配

CityEngineLua.Client_onScriptVersionNotMatch = function(stream)
	this.serverScriptVersion = stream:readString();
	
	ct.log("Client_onScriptVersionNotMatch: verInfo=" .. this.clientScriptVersion .. "(server: " .. this.serverScriptVersion .. ")");
	--Event.fireAll("onScriptVersionNotMatch", new object[]{clientScriptVersion, this.serverScriptVersion});
	
	if(_persistentInfos ~= nil) then
		_persistentInfos.onScriptVersionNotMatch(this.clientScriptVersion, this.serverScriptVersion);
	end
end

--	被服务端踢出

CityEngineLua.Client_onKicked = function(failedcode)
	ct.log("Client_onKicked: failedcode=" .. failedcode);
	--Event.fireAll("onKicked", new object[]{failedcodeend);
end

--	重登录到网关(baseapp)
--	一些移动类应用容易掉线，可以使用该功能快速的重新与服务端建立通信

CityEngineLua.reConnect = function()
	if CityEngineLua.currserver == "loginapp" then
		CityEngineLua.reLoginLoginApp()
	else if CityEngineLua.currserver == "baseapp" then
		CityEngineLua.reLoginBaseapp()
		else

		end
	end
end
CityEngineLua.reLoginLoginApp = function()
	--Event.fireAll("onReloginBaseapp", new object[]{end);
	this._networkInterface:connectTo(this.ip, this.port, this.onReConnectTo_LoginApp_callback, nil);
end

CityEngineLua.reLoginBaseapp = function()
	--Event.fireAll("onReloginBaseapp", new object[]{end);
	this._networkInterface:connectTo(this.baseappIP, this.baseappPort, this.onReConnectTo_baseapp_callback, nil);
end

CityEngineLua.onReConnectTo_LoginApp_callback = function(ip, port, success, userData)
	local xxx = 0
end

CityEngineLua.onReConnectTo_baseapp_callback = function(ip, port, success, userData)
	CityEngineLua.login_loginapp(false)
end

	--登录baseapp失败了
CityEngineLua.Client_onLoginBaseappFailed = function(failedcode)
	ct.log("City::Client_onLoginBaseappFailed: failedcode(" .. failedcode .. ")!");
	--Event.fireAll("onLoginBaseappFailed", new object[]{failedcode});
end

	--重登录baseapp失败了
CityEngineLua.Client_onReloginBaseappFailed = function(failedcode)
	ct.log("City::Client_onReloginBaseappFailed: failedcode(" .. failedcode .. ")!");
	--Event.fireAll("onReloginBaseappFailed", new object[]{failedcodeend);
end

	--登录baseapp成功了
CityEngineLua.Client_onReloginBaseappSuccessfully = function(stream)
	this.entity_uuid = stream:readUint64();
	ct.log("City::Client_onReloginBaseappSuccessfully: name(" .. this.username .. ")!");
	--Event.fireAll("onReloginBaseappSuccessfully", new object[]{end);
end


CityEngineLua.sendTick = function()
	if(not this._networkInterface:valid()) then
		return;
	end

	if(not this.loginappMessageImported_ and not this.baseappMessageImported_) then
		return;
	end
	
	local span = os.clock() - this._lastTickTime; 
	
	-- 更新玩家的位置与朝向到服务端
	this.updatePlayerToServer();
	
	if(span > 15) then
		span = this._lastTickCBTime - this._lastTickTime;

		-- 如果心跳回调接收时间小于心跳发送时间，说明没有收到回调
		-- 此时应该通知客户端掉线了
		if(span < 0) then
			ct.log("sendTick: Receive appTick timeout!");
			this._networkInterface:close();
			return;
		end

		local Loginapp_onClientActiveTickMsg = CityEngineLua.messages["Loginapp_onClientActiveTick"];
		local Baseapp_onClientActiveTickMsg = CityEngineLua.messages["Baseapp_onClientActiveTick"];
		
		if(this.currserver == "loginapp") then
			if(Loginapp_onClientActiveTickMsg ~= nil) then
				local bundle = CityEngineLua.Bundle:new();
				bundle:newMessage(Loginapp_onClientActiveTickMsg);
				bundle:send();
			end
		else
			if(Baseapp_onClientActiveTickMsg ~= nil) then
				local bundle = CityEngineLua.Bundle:new();
				bundle:newMessage(Baseapp_onClientActiveTickMsg);
				bundle:send();
			end
		end
		
		this._lastTickTime = os.clock();
	end
end


--
--	服务器心跳回调
--		
CityEngineLua.Client_onAppActiveTickCB = function()
	this._lastTickCBTime = os.clock();
end

	---插件的主循环处理函数

CityEngineLua.process = function()
	-- 处理网络
	this._networkInterface:process();

	if this._tradeNetworkInterface1 then
		this._tradeNetworkInterface1:process();
	end

	-- 向服务端发送心跳以及同步角色信息到服务端
    this.sendTick();
end