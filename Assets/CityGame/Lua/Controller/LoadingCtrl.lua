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
end

function LoadingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/LoadingPanel.prefab"
end

function LoadingCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
    UpdateBeat:Add(self._Update, self)
end

function LoadingCtrl:_Update()
    LoadingPanel.rotateIconTrans:Rotate( self.RotateDirection * self.RotateSpeed * UnityEngine.Time.deltaTime )
    if TerrainManager.BuildObjQueue ~= nil and TerrainManager.BuildObjQueue <= 0 then
        self.IsLoadOver = true
    end
    if self.MinDurationTime <= 0 and  self.IsLoadOver == true then
        UIPanel.ClosePage()
    else
        self.MinDurationTime =  self.MinDurationTime - UnityEngine.Time.deltaTime
    end
end

function LoadingCtrl:Hide()
    UIPanel.Close(self)
    UpdateBeat:Remove(self._Update, self)
end