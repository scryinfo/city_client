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
    --初始化多语言--
    ReadConfigLanguage()
    --初始化音乐--
    MusicManger:Awake()
    --初始化气泡--
    UIBubbleManager.Awake()
    --初始化屏幕适配比例--
    InitScreenRatio()

    ct.OpenCtrl('LoadingCtrl')
    --ct.OpenCtrl('LoginCtrl',Vector2.New(0, 0)) --注意传入的是类名
end

function Game.OnPostInitOK()
    BuilldingBubbleInsManger.Init()
    --开业停业
    StopAndBuildModel:Awake()
    --PlayerInfoManager.Init()
    PlayerInfoManger.Awake()
    --单元测试入口
    lu.LuaUnit.run()
    DataManager.Init()
    TerrainManager.Init()
    --Avatar管理器
    AvatarManger.Awake()

    PathFindManager.Init()
end
