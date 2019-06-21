---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/21 10:35
---
-----

FlightLoadingCtrl = class('FlightLoadingCtrl',UIPanel)
UIPanel:ResgisterOpen(FlightLoadingCtrl)

function FlightLoadingCtrl:initialize()
    UIPanel.initialize(self, UIType.Fixed, UIMode.DoNothing, UICollider.None)
end
--
function FlightLoadingCtrl:bundleName()
    return "Assets/CityGame/Resources/View/FlightLoadingPanel.prefab"
end

function FlightLoadingCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
end
--
function FlightLoadingCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    Event.AddListener("m_CloseFlightLoading", self.CloseFlightLoading)
    UpdateBeat:Add(self._Update, self)
end
--
function FlightLoadingCtrl:Refresh()
    self:_initData()
end
--
function FlightLoadingCtrl:Hide()
    UpdateBeat:Remove(self._Update, self)
    UIPanel.Hide(self)
end
--
function FlightLoadingCtrl:_getComponent(go)
    local trans = go.transform
    self.rotateIconTrans = trans:Find("BackGround/rotateIcon").transform
end
--
function FlightLoadingCtrl:_initData()
    self.rotateIconTrans.localEulerAngles = Vector3.zero
end
--
function FlightLoadingCtrl:CloseFlightLoading()
    if self ~= nil then
        UIPanel.Hide(self)
    end
end
--
function FlightLoadingCtrl:_Update()
    self.rotateIconTrans:Rotate(Vector3.back * 200 * UnityEngine.Time.deltaTime)
end
