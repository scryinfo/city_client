
-----

GameMainInterfaceModel = {};
local this = GameMainInterfaceModel;

--构建函数--
function GameMainInterfaceModel.New()
    return this;
end

function GameMainInterfaceModel.Awake()
    --UpdateBeat:Add(this.Update, this);
    this:OnCreate();
end
--启动事件--
function GameMainInterfaceModel.OnCreate()
    --注册本地事件
end



