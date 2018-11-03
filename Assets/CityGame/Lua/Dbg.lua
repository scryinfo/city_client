
Dbg = {}

local this = Dbg;

--输出日志--
local loginner = print
DEBUGLEVEL = {
	DEBUG = 0,
	INFO = 1,
	WARNING = 2,
	ERROR = 3,
	NOLOG = 4,  -- 放在最后面，使用这个时表示不输出任何日志（!!!慎用!!!）
}

if ct.G_DEBUGLOG then
	this.debugLevel = DEBUGLEVEL.DEBUG;
else
	this.debugLevel = DEBUGLEVEL.NOLOG
end

this.getHead = function()
	return "";
end
this.getIdHead = function(id)
	return "["..id.."]";
end

log = nil

ct.log = function(logid,s,...)
	if s == nil then
		return
	end
	local plgid = TestGroup.get_TestGroupId(logid)
	local palgid = TestGroup.get_ActiveTestGroupId(logid)
	if plgid == nil or  palgid == nil then
		return
	end
	assert(s)
	loginner(this.getIdHead(plgid) .. s,...);
end

print = function(s,...)
	ct.log("system",s,...)
end

logWarn = print
logDebug = print

error = function(s,...)
	ct.log("system","[error]",s,...)
end

this.INFO_MSG = function( s )
	if (DEBUGLEVEL.INFO >= this.debugLevel) then
		ct.log(this.getHead() .. s);
	end
end

this.DEBUG_MSG = function( s ,...)
	if (DEBUGLEVEL.DEBUG >= this.debugLevel) then
		ct.log(this.getHead() .. s,...);
	end
end

this.WARNING_MSG = function(s)
	if (DEBUGLEVEL.WARNING >= this.debugLevel) then
		CityLuaUtil.LogWarning(this.getHead() .. s);
	end
end

this.ERROR_MSG = function(s)
	if (DEBUGLEVEL.ERROR >= this.debugLevel) then
		CityLuaUtil.LogError(this.getHead() .. s);
	end
end

--debug输出日志--
function logDebug(str,...)
	assert(str,"logdebug nil")
    Dbg.DEBUG_MSG(str,...);
end

--错误日志--
function logError(str)
	assert(str,"logError nil")
	Dbg.ERROR_MSG(str);
end

--警告日志--
function logWarn(str)
	assert(str,"logWarn nil")
	Dbg.WARNING_MSG(str);
end