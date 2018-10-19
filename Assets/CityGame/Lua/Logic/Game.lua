Event = require 'events'
--调试信息
require("Dbg")
require('TestGroup')
local lu = require "Framework/pbl/luaunit"
--单元测试
require('test.test')
--性能测试
require('test.performance.luaPerformance')

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

    --单元测试入口
    lu.LuaUnit.run()

    --延迟触发的测试分组
    UnitTest.Exec_now("abel_w5", "c_AddClick_self",self)
    UnitTest.Exec_now("abel_w7_RemoveClick", "c_RemoveClick_self",self)
    UnitTest.Exec_now("fisher_week9_ShelfGoodsItem", "c_MaterialModel_ShowPage",self)
end
