require('Common.define')
require('LuaUtil')
local CityLuaUtil = CityLuaUtil
require("Dbg")
require('ImpTestGroup')
local protoc = require ("Framework/pbl/protoc")

function OnInitProto()
	ct.log("abel_w7_pkg","[OnInitProto] protoc:addpath")
	ct.log("abel_w7_pkg","[OnInitProto] persistentDataPath: ",UnityEngine.Application.persistentDataPath)
	--protoc:addpath("./Assets/CityGame/Lua/pb") --注意这种从 Assets 开始的相对路径是目前发现的PC上唯一能支持 loadfile 的相对路径
	--protoc:addpath(UnityEngine.Application.persistentDataPath.."/CityGame/lua/pb") --这个路径是Android上能访问的路径
	protoc:addpath(CityLuaUtil.getAssetsPath().."/Lua/pb") --注意这种从 Assets 开始的相对路径是目前发现的PC上唯一能支持 loadfile 的相对路径
	protoc:addpath(CityLuaUtil.getAssetsPath().."/lua/pb") --这个路径是Android上能访问的路径

	ct.log("abel_w7_pkg","[OnInitProto] protoc:loadfile")
	--加载并编译所有的 .proto 文件
	assert(protoc:loadfile( "common.proto"))
	assert(protoc:loadfile ("as.proto"))
	assert(protoc:loadfile ("asCode.proto"))
	--assert(protoc:loadfile ("ga.proto"))
	--assert(protoc:loadfile ("gaCode.proto"))
	assert(protoc:loadfile ("gs.proto"))
	assert(protoc:loadfile ("gsCode.proto"))
	assert(protoc:loadfile ("metadata.proto"))
	assert(protoc:loadfile ("client.proto"))
end

--主入口函数。从这里开始lua逻辑
function Main()
	OnInitProto()	--加载 .proto
	--testMain()		--测试入口
end

--场景切换通知
function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end