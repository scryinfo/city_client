if UnityEngine.Application.isEditor then
    require('Require_Editor')
else
    require('Require_RunTime')
end

local lu = luaunit
----unit test
--require('test/test')
----Performance Testing
--require('test/performance/luaPerformance')

--Manager--
Game = {};
local this = Game;

local game;
local transform;
local gameObject;
local WWW = UnityEngine.WWW;

--Screen coordinate scaling
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

--Initialization is complete, send link server information--
function Game.OnInitOK()
    --Initialize multiple languages--
    ReadConfigLanguage()
    --Initial music--
    MusicManger:Awake()
    --Initial Bubble--
    UIBubbleManager.Awake()
    --Initial screen adaptation ratio--
    InitScreenRatio()

   --Unit test entrance
    lu.LuaUnit.run()

    ct.OpenCtrl('LoadingCtrl')--StopAndBuildCtrl--LoadingCtrl
    --ct.OpenCtrl('LoginCtrl',Vector2.New(0, 0)) - Note that the class name is passed in

end

function Game.OnPostInitOK()
    BuilldingBubbleInsManger.Init()
    --Opening and closing
    --[[
    StopAndBuildModel:Awake()
    --PlayerInfoManager.Init()
    PlayerInfoManger.Awake()
    --Unit test entrance
    lu.LuaUnit.run()
    DataManager.Init()
    TerrainManager.Init()
    --Avatar manager
    AvatarManger.Awake()

    PathFindManager.Init()
    --Revenue details
    RevenueDetailsMsg.Awake()--]]
end
