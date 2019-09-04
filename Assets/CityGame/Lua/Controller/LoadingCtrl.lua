LoadingCtrl = class('LoadingCtrl',UIPanel)
UIPanel:ResgisterOpen(LoadingCtrl)
function LoadingCtrl:initialize()
    UIPanel.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
    if TerrainConfig.LoadingConfig.MinDurationTime ~= nil then
        self.MinDurationTime = TerrainConfig.LoadingConfig.MinDurationTime
    else
        self.MinDurationTime = 1
    end
    if TerrainConfig.LoadingConfig.RotateSpeed ~= nil then
        self.RotateSpeed = TerrainConfig.LoadingConfig.RotateSpeed
    else
        self.RotateSpeed = 200
    end
    if TerrainConfig.LoadingConfig.RotateDirection ~= nil then
        self.RotateDirection = TerrainConfig.LoadingConfig.RotateDirection
    else
        self.RotateDirection = Vector3.back
    end
    self.IsLoadOver = false
    MapObjectsManager.Init()
end

function LoadingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/LoadingPanel.prefab"
end

function LoadingCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
    UpdateBeat:Add(self._Update, self)
end

function LoadingCtrl:Awake(...)
    destroy(UnityEngine.GameObject.Find("LoadCanvas"))
    --PlayerInfoManager.Init()
    PlayerInfoManger.Awake()
    DataManager.Init()
    TerrainManager.Init()
    --Avatar管理器
    AvatarManger.Awake()

    PathFindManager.Init()
    --营收详情
    RevenueDetailsMsg.Awake()
    --初始图片加载
    SpriteManager.Init()
end

function LoadingCtrl:Active()
    LoadingPanel.content.text = GetLanguage(10010001)
end

function LoadingCtrl:_Update()
    LoadingPanel.rotateIconTrans:Rotate( self.RotateDirection * self.RotateSpeed * UnityEngine.Time.deltaTime )
    if self.MinDurationTime <= 0  then
        if MapObjectsManager.GetLoadingAssetsCount() <= 0 then
            self:EnterTheLogin()
        end
    else
        self.MinDurationTime =  self.MinDurationTime - UnityEngine.Time.deltaTime
    end
end

function LoadingCtrl:EnterTheMain()
    local playerId = self.m_data
    UpdateBeat:Remove(self._Update, self)
    UIPanel:ClearAllPages()
    ct.OpenCtrl('GameMainInterfaceCtrl',playerId)
end


function LoadingCtrl:EnterTheLogin()
    UpdateBeat:Remove(self._Update, self)
    ct.OpenCtrl('LoginCtrl',Vector2.New(0, 0))
end