local pbl = pbl

MaterialModel = {};
local this = MaterialModel;

--构建函数
function MaterialModel.New()
    return this;
end

function MaterialModel.Awake()
    this:OnCreate();
end

function MaterialModel.OnCreate()
    --注册本地UI事件
    Event.AddListener("m_OnOpenShelf",this.m_OnOpenShelf)
end

function MaterialModel.Close()
    --清空本地UI事件
end

function MaterialModel.m_OnOpenShelf()

end

























