---心跳检测断开
-----

HeartbeatDisconnectionCtrl = class('HeartbeatDisconnectionCtrl',UIPanel)
UIPanel:ResgisterOpen(HeartbeatDisconnectionCtrl)

function HeartbeatDisconnectionCtrl:initialize()
    UIPanel.initialize(self, UIType.Fixed, UIMode.DoNothing, UICollider.None)
end

function HeartbeatDisconnectionCtrl:bundleName()
    return "Assets/CityGame/Resources/View/HeartbeatDisconnectionPanel.prefab"
end

function HeartbeatDisconnectionCtrl:Awake(go)
    Event.AddListener("HeartbeatIsConnect", self.HeartbeatIsConnect, self)
end

function HeartbeatDisconnectionCtrl:Refresh()
end

function HeartbeatDisconnectionCtrl:HeartbeatIsConnect()
    ct.log("system","消息弱界面关闭")
    UIPanel.Hide(self)
end
function HeartbeatDisconnectionCtrl:Close()
    Event.RemoveListener("HeartbeatIsConnect",self.HeartbeatIsConnect,self)
end
