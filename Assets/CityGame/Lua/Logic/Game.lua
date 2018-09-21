Event = require 'events'
require "Dbg"
require "City"

require "Framework/Account"
require "Framework/Avatar"
require "Framework/Gate"
require "Framework/Monster"
require "Framework/NPC"
require "Framework/DroppedItem"


require "Common/functions"
require "Controller/LoginCtrl"
require "Logic/CtrlManager"
require "Logic/World"



--管理器--
Game = {};
local this = Game;

local game; 
local transform;
local gameObject;
local WWW = UnityEngine.WWW;

function Game.InitViewPanels()
	for i = 1, #PanelNames do
		require ("View/"..tostring(PanelNames[i]))
	end
end

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
    --注册LuaView--
    this.InitViewPanels();

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
    ---测试住宅
    local HouseModel = CtrlManager.GetModel(ModelNames.House);
    if HouseModel ~= nil then
        HouseModel:Awake();
    end
end
