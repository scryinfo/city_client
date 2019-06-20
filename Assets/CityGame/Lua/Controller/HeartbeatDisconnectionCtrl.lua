---心跳检测断开
-----

HeartbeatDisconnectionCtrl = class('HeartbeatDisconnectionCtrl',UIPanel)
UIPanel:ResgisterOpen(HeartbeatDisconnectionCtrl)

--常量
local iconMaxLv = 4
local LvScale = Vector3.one / iconMaxLv
local timeInterval = 0.5
local uTime = UnityEngine.Time

local m_time = 0
local iconLv = 0

function HeartbeatDisconnectionCtrl:initialize()
    UIPanel.initialize(self, UIType.Fixed, UIMode.DoNothing, UICollider.None)
end

function HeartbeatDisconnectionCtrl:bundleName()
    return "Assets/CityGame/Resources/View/HeartbeatDisconnectionPanel.prefab"
end

function HeartbeatDisconnectionCtrl:Awake(go)
    Event.AddListener("HeartbeatIsConnect", self.HeartbeatIsConnect, self)
    self.m_Timer = Timer.New(slot(self.RefreshIcon, self), timeInterval, -1, true)
    m_time = 0
    iconLv = 0
end

function HeartbeatDisconnectionCtrl:RefreshIcon()
    iconLv = iconLv + 1
    if iconLv > iconMaxLv then
        iconLv = 0
    end
    HeartbeatDisconnectionPanel.moveIcon.localScale = LvScale * iconLv
end

function HeartbeatDisconnectionCtrl:Refresh()
    HeartbeatDisconnectionPanel.Tipstext.text = GetLanguage(41010007)
    if self.m_Timer ~= nil then
        self.m_Timer:Start()
    end
    HeartbeatDisconnectionPanel.moveIcon.localScale = Vector3.zero
end

function HeartbeatDisconnectionCtrl:HeartbeatIsConnect()
    ct.log("system","消息弱界面关闭")
    if self.m_Timer ~= nil then
        self.m_Timer:Stop()
    end
    UIPanel.Hide(self)
end
function HeartbeatDisconnectionCtrl:Close()
    Event.RemoveListener("HeartbeatIsConnect",self.HeartbeatIsConnect,self)
end
