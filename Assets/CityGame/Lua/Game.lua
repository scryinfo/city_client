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

--屏幕坐标缩放尺寸
Game.ScreenRatio = 1

local function InitScreenRatio()
    local m_AspectRatio = UnityEngine.Screen.width / UnityEngine.Screen.height
    local ActualAspectRatio = 1920 / 1080
    if m_AspectRatio < ActualAspectRatio then
        Game.ScreenRatio = 1920 / UnityEngine.Screen.width
    else
        Game.ScreenRatio = 1080 / UnityEngine.Screen.height
    end
end

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    --注册LuaView--
    CtrlManager.Init();
    local ctrl = CtrlManager.GetCtrl(CtrlNames.Login);
    if ctrl ~= nil then
        ctrl:Awake();
    end
    InitScreenRatio()
    World.init();
end

function Game.OnPostInitOK()
    local model = CtrlManager.GetModel(ModelNames.Login);
    if model ~= nil then
        model:Awake();
    end
    --[[
    ---测试拍卖
    local groundAucModel = CtrlManager.GetModel(ModelNames.GroundAuction);
    if groundAucModel ~= nil then
        groundAucModel:Awake();
    end
    --]]
    ---测试建筑信息
    local BuildingInfoModel = CtrlManager.GetModel(ModelNames.BuildingInfo);
    if BuildingInfoModel ~= nil then
        BuildingInfoModel:Awake();
    end
    ----原料厂
    --local materialModel = CtrlManager.GetModel(ModelNames.Material);
    --if materialModel ~= nil then
    --    materialModel:Awake();
    --end
    ----加工厂
    --local processingModel = CtrlManager.GetModel(ModelNames.Processing)
    --if processingModel ~= nil then
    --    processingModel:Awake();
    --end

    --测试选服界面
--[[    local serverListModel = CtrlManager.GetModel(ModelNames.ServerList);
    if serverListModel ~= nil then
        serverListModel:Awake();
    end]]

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

    --测试中心仓库
    local MunicipalModel = CtrlManager.GetModel(ModelNames.Municipal);
    if MunicipalModel ~= nil then
        MunicipalModel:Awake();
    end

    --测试玩家临时数据
    local playerTempModel = CtrlManager.GetModel(ModelNames.PlayerTemp);
    if playerTempModel ~= nil then
        playerTempModel:Awake();
    end
    --测试仓库
    local WarehouseModel = CtrlManager.GetModel(ModelNames.Warehouse);
    if WarehouseModel ~= nil then
        WarehouseModel:Awake();
    end
    --调整生产线
    local AdjustProductionLineModel = CtrlManager.GetModel(ModelNames.AdjustProductionLine);
    if AdjustProductionLineModel ~= nil then
        AdjustProductionLineModel:Awake();
    end
    --科技交易所
    local ScienceSellHallModel = CtrlManager.GetModel(ModelNames.ScienceSellHall);
    if ScienceSellHallModel ~= nil then
        ScienceSellHallModel:Awake();
    end

    --测试货架
    local ShelfModel = CtrlManager.GetModel(ModelNames.Shelf);
    if ShelfModel ~= nil then
        ShelfModel:Awake();
    end

    --测试临时角色信息界面
    --local PlayerTempModel = CtrlManager.GetModel(ModelNames.PlayerTemp);
    --if PlayerTempModel ~= nil then
    --    PlayerTempModel:Awake();
    --end
    --临时运输测试
    local tempTransportModel = CtrlManager.GetModel(ModelNames.tempTransport);
    if tempTransportModel ~= nil then
        tempTransportModel:Awake();
    end

    --local friendsModel = CtrlManager.GetModel(ModelNames.friends);
    --if friendsModel ~= nil then
    --    friendsModel:Awake();
    --end

    --local chatModel = CtrlManager.GetModel(ModelNames.Chat);
    --if chatModel ~= nil then
    --    chatModel:Awake();
    --end
    --开业停业
    StopAndBuildModel:Awake()
    --单元测试入口
    --if CityLuaUtil.isluaLogEnable() == true then
        lu.LuaUnit.run()
    --end
    DataManager.Init()
    TerrainManager.Init()
end
