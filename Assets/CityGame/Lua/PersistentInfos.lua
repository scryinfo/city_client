--	持久化引擎协议，在检测到协议版本发生改变时会清理协议

CityEngineLua.PersistentInfos = {}

function CityEngineLua.PersistentInfos:New( path )
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me._persistentDataPath = path;
	me._digest = "";

	me._isGood = me:loadAll();

    return me;
end
	
function CityEngineLua.PersistentInfos:isGood()
	return self._isGood;
end

function CityEngineLua.PersistentInfos:_getSuffixBase()
    local clientVersion, clientScriptVersion, ip, port = CityEngineLua.GetArgs();
	return clientVersion .. "." .. clientScriptVersion .. "." .. ip .. "." .. port;
end

function CityEngineLua.PersistentInfos:_getSuffix()
	return self._digest .. "." .. self:_getSuffixBase();
end

function CityEngineLua.PersistentInfos:loadAll()
	
	local cityEngine_Digest = CityLuaUtil.loadFile (self._persistentDataPath, "City.digest." .. self:_getSuffixBase(), false);
	if(cityEngine_Digest.Length <= 0) then
		self:clearMessageFiles();
		return false;
	end

	

	self._digest = CityLuaUtil.bytesToString(cityEngine_Digest);
	
	local loginapp_onImportClientMessages = CityLuaUtil.loadFile(self._persistentDataPath, "loginapp_clientMessages." .. self:_getSuffix(), false);

	local baseapp_onImportClientMessages = CityLuaUtil.loadFile(self._persistentDataPath, "baseapp_clientMessages." .. self:_getSuffix(), false);

	local onImportServerErrorsDescr = CityLuaUtil.loadFile(self._persistentDataPath, "serverErrorsDescr." .. self:_getSuffix(), false);

	local onImportClientEntityDef = CityLuaUtil.loadFile(self._persistentDataPath, "clientEntityDef." .. self:_getSuffix(), false);

	if(loginapp_onImportClientMessages.Length > 0 and baseapp_onImportClientMessages.Length > 0) then
        local re = CityEngineLua.importMessagesFromMemoryStream(loginapp_onImportClientMessages, baseapp_onImportClientMessages, onImportClientEntityDef, onImportServerErrorsDescr);

        if (not re) then
            self:clearMessageFiles();
            return false;
        end
		
	end
	
	return true;
end

function CityEngineLua.PersistentInfos:onImportClientMessages(currserver, stream)
	if(currserver == "loginapp") then
		CityLuaUtil.createFile (self._persistentDataPath, "loginapp_clientMessages." .. self:_getSuffix(), stream);
	else
		CityLuaUtil.createFile (self._persistentDataPath, "baseapp_clientMessages." .. self:_getSuffix(), stream);
	end
end

function CityEngineLua.PersistentInfos:onImportServerErrorsDescr(stream)
	CityLuaUtil.createFile (self._persistentDataPath, "serverErrorsDescr." .. self:_getSuffix(), stream);
end

function CityEngineLua.PersistentInfos:onImportClientEntityDef(stream)
	CityLuaUtil.createFile (self._persistentDataPath, "clientEntityDef." .. self:_getSuffix(), stream);
end

function CityEngineLua.PersistentInfos:onVersionNotMatch(verInfo, serVerInfo)
	self:clearMessageFiles();
end

function CityEngineLua.PersistentInfos:onScriptVersionNotMatch(verInfo, serVerInfo)
	self:clearMessageFiles();
end

function CityEngineLua.PersistentInfos:onServerDigest(currserver, serverProtocolMD5, serverEntitydefMD5)
	-- 我们不需要检查网关的协议， 因为登录loginapp时如果协议有问题已经删除了旧的协议
	if(currserver == "baseapp") then
		return;
	end
	
	if(self._digest ~= serverProtocolMD5 .. serverEntitydefMD5) then
		self._digest = serverProtocolMD5 .. serverEntitydefMD5;

		self:clearMessageFiles();
	else
		return;
	end
	
	if(CityLuaUtil.loadFile(self._persistentDataPath, "City.digest." .. self:_getSuffixBase(), false).Length) then
		CityLuaUtil.createFile(self._persistentDataPath, "City.digest." .. self:_getSuffixBase(), CityLuaUtil.stringToBytes(serverProtocolMD5 .. serverEntitydefMD5));
	end
end
	
function CityEngineLua.PersistentInfos:clearMessageFiles()
	CityLuaUtil.deleteFile(self._persistentDataPath, "City.digest." .. self:_getSuffixBase());
	CityLuaUtil.deleteFile(self._persistentDataPath, "loginapp_clientMessages." .. self:_getSuffix());
	CityLuaUtil.deleteFile(self._persistentDataPath, "baseapp_clientMessages." .. self:_getSuffix());
	CityLuaUtil.deleteFile(self._persistentDataPath, "serverErrorsDescr." .. self:_getSuffix());
	CityLuaUtil.deleteFile(self._persistentDataPath, "clientEntityDef." .. self:_getSuffix());

    CityEngineLua.resetMessages();
end
