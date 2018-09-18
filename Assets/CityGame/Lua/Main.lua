require "test/test"
require("Dbg")
local protoc = require "Framework/pbl/protoc"
protoc:addpath("./Assets/CityGame/Lua/pb") --注意这种从 Assets 开始的相对路径是目前发现的唯一能支持 loadfile 的相对路径

function OnInitProto()
	--加载并编译所有的 .proto 文件
	assert(protoc:loadfile( "common.proto"))
	assert(protoc:loadfile ("as.proto"))
	assert(protoc:loadfile ("asCode.proto"))
	assert(protoc:loadfile ("ga.proto"))
	assert(protoc:loadfile ("gaCode.proto"))
	assert(protoc:loadfile ("gs.proto"))
	assert(protoc:loadfile ("gsCode.proto"))
	assert(protoc:loadfile ("metadata.proto"))

	test.runtest()
end

--主入口函数。从这里开始lua逻辑
function Main()
	OnInitProto()	--加载 .proto
end

--场景切换通知
function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end