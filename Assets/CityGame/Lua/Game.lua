if UnityEngine.Application.isEditor then
    require('Require_Editor')
else
    require('Require_RunTime')
end

local lu = luaunit
----单元测试
--require('test/test')
----性能测试
--require('test/performance/luaPerformance')

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
    local model = CtrlManager.GetModel(ModelNames.Login);
    if model ~= nil then
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

    --测试选服界面
    local serverListModel = CtrlManager.GetModel(ModelNames.ServerList);
    if serverListModel ~= nil then
        serverListModel:Awake();
    end

    --测试创角界面
    local createRoleModel = CtrlManager.GetModel(ModelNames.CreateRole);
    if createRoleModel ~= nil then
        createRoleModel:Awake();
    end

    --测试中心仓库
    local CenterWareHouseModel = CtrlManager.GetModel(ModelNames.CenterWareHouse);
    if CenterWareHouseModel ~= nil then
        CenterWareHouseModel:Awake();
    end

    --测试玩家临时数据
    local playerTempModel = CtrlManager.GetModel(ModelNames.PlayerTemp);
    if playerTempModel ~= nil then
        playerTempModel:Awake();
    end

    --
    local AdjustProductionLineModel = CtrlManager.GetModel(ModelNames.AdjustProductionLine);
    if AdjustProductionLineModel ~= nil then
        AdjustProductionLineModel:Awake();
    end

    --单元测试入口
    --if CityLuaUtil.isluaLogEnable() == true then
        lu.LuaUnit.run()
    --end
    UnitTest.Exec_now("Allen_w9", "c_CameraMove",self)
end
