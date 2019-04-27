-----
-----

ServerListCtrl = class('ServerListCtrl',UIPanel)
UIPanel:ResgisterOpen(ServerListCtrl)
ServerListCtrl.static.Server_PATH = "Assets/CityGame/Resources/View/GoodsItem/ServerItem.prefab";

local serverListBehaviour;
local tempBg = nil;
local tempTag = nil;
local Index = nil

function  ServerListCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ServerListPanel.prefab"
end

function ServerListCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function ServerListCtrl:Awake()
    self.insId = OpenModelInsID.ServerListCtrl
    self.data = self.m_data

    serverListBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    serverListBehaviour:AddClick(ServerListPanel.oKBtn,self.c_OnOK,self);

    self:_initData();
end

function ServerListCtrl:Active()
    UIPanel.Active(self)
    --普通消息注册
    Event.AddListener("c_GsCreateRole",self.c_GsCreateRole,self);
    Event.AddListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);
    Event.AddListener("c_OnServer",self.c_OnServer,self)

    ServerListPanel.serverText.text = GetLanguage(10030001)

end

function ServerListCtrl:Refresh()
    self:_initInsData()
end
--[[
function ServerListCtrl:Hide()
UIPanel.Hide(self)
--注销事件
EveeListener("c_GsCreateRole",self.c_GsCreateRole,self);
Event.RemoveListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);
Event.RemoveListener("c_OnServer",self.c_OnServer,self)
end
--]]
function ServerListCtrl:_initInsData()
    DataManager.OpenDetailModel(ServerListModel,self.insId )
end

function ServerListCtrl:Close()
    --destroy(self.gameObject)
    UIPanel.Close(self)
    --注销事件
    Event.RemoveListener("c_GsCreateRole",self.c_GsCreateRole,self);
    Event.RemoveListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);
    Event.RemoveListener("c_OnServer",self.c_OnServer,self)
end

function ServerListCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
    tempBg = nil

 end

function ServerListCtrl:_initData()
    for i, v in ipairs(self.m_data) do
        local function callback(prefab)
            self.serverLuaItem = ServerItem:new(serverListBehaviour,prefab,self,v,i)
        end
        createPrefab(ServerListCtrl.static.Server_PATH,ServerListPanel.content, callback)
        if not self.server then
            self.server = {}
        end
        self.server[i] = self.serverLuaItem
    end
end


--选择服务器--
function ServerListCtrl:c_OnServer(go)
    if tempBg ~= nil and tempTag ~= nil then
        tempBg:SetActive(false);
        tempTag:SetActive(false);
    end
    go.bg:SetActive(true);
    go.tag:SetActive(true);
    tempBg = go.bg;
    tempTag = go.tag
    Index = go.id;
end

--点击确定--
function ServerListCtrl:c_OnOK(go)
    PlayMusEff(1002)
    --Event.Brocast("m_chooseGameServer", Index,go.data);
    if Index == nil then
        return
    end
    local data = {}
    data.Index = Index
    data.serinofs = go.data
    DataManager.DetailModelRpcNoRet(go.insId , 'm_chooseGameServer',data)
    ServerListPanel.oKBtn:GetComponent("Button").enabled = false
end

function ServerListCtrl:c_GsCreateRole()
    ct.OpenCtrl("AvtarCtrl")
end

function ServerListCtrl:c_GsLoginSuccess(playerId)
    --ct.OpenCtrl('LoadingCtrl',playerId)
    UIPanel:ClearAllPages()
    ct.OpenCtrl('GameMainInterfaceCtrl',playerId)
end
--生成预制
function ServerListCtrl:_createServerPab(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return go
end
