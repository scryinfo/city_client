if CityLuaUtil.isAndroidPlatform() == false then
    require('Require_PC')
else
    require('Require_Android')
end

local lu = luaunit
----单元测试
--require('test/test')
----性能测试
--require('test/performance/luaPerformance')

require "City"
require "Framework/Account"
require "Framework/Avatar"
require "Framework/Gate"
require "Framework/Monster"
require "Framework/NPC"
require "Framework/DroppedItem"

require "Common/functions"
--require "Controller/LoginCtrl"
require "Logic/CtrlManager"
require "Logic/World"


--管理器--
Game = {};
local this = Game;

local game; 
local transform;
local gameObject;
local WWW = UnityEngine.WWW;

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    --注册LuaView--
    CtrlManager.Init();
    local ctrl = CtrlManager.GetCtrl(CtrlNames.Login);
    if ctrl ~= nil then
        ctrl:Awake();
    end

    World.init();
end

function Game.OnPostInitOK()
    log("system","[Game.OnPostInitOK]: ");
    local model = CtrlManager.GetModel(ModelNames.Login);
    if model ~= nil then
        log("system","[Game.OnPostInitOK]: model:Awake");
        model:Awake();
    end

    ---测试拍卖
    local groundAucModel = CtrlManager.GetModel(ModelNames.GroundAuction);
    if groundAucModel ~= nil then
        groundAucModel:Awake();
    end
    ---测试建筑信息
    local BuildingInfoModel = CtrlManager.GetModel(ModelNames.BuildingInfo);
    if BuildingInfoModel ~= nil then
        BuildingInfoModel:Awake();
    end
    local materialModel = CtrlManager.GetModel(ModelNames.Material);
    if materialModel ~= nil then
        materialModel:Awake();
    end

    local serverListModel = CtrlManager.GetModel(ModelNames.ServerList);
    if serverListModel ~= nil then
        serverListModel:Awake();
    end

    local createRoleModel = CtrlManager.GetModel(ModelNames.CreateRole);
    if createRoleModel ~= nil then
        createRoleModel:Awake();
    end

    --单元测试入口
    lu.LuaUnit.run()
end
