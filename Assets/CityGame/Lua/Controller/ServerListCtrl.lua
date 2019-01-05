-----
-----

ServerListCtrl = class('ServerListCtrl',UIPage)
UIPage:ResgisterOpen(ServerListCtrl)
ServerListCtrl.static.Server_PATH = "View/GoodsItem/ServerItem";

local serverListBehaviour;
local gameObject;
local tempBg = nil;
local tempTag = nil;
local Index = nil

function  ServerListCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ServerListPanel.prefab"
end

function ServerListCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function ServerListCtrl:Refresh()
    self:_initInsData()
end

function ServerListCtrl:_initInsData()
    DataManager.OpenDetailModel(ServerListModel,2)

end

function ServerListCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    self.data = self.m_data
    serverListBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    serverListBehaviour:AddClick(ServerListPanel.oKBtn,self.c_OnOK,self);

    self:_initData();

    --普通消息注册
    Event.AddListener("c_GsCreateRole",self.c_GsCreateRole,self);
    Event.AddListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);
    Event.AddListener("c_OnServer",self.c_OnServer,self)

 end

function ServerListCtrl:_initData()
    for i, v in ipairs(self.m_data) do

        local server_prefab = self:_createServerPab(ServerListCtrl.static.Server_PATH,ServerListPanel.content)
        local serverLuaItem = ServerItem:new(serverListBehaviour,server_prefab,self,v,i)
        if not self.server then
            self.server = {}
        end
        self.server[i] = serverLuaItem
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
    --Event.Brocast("m_chooseGameServer", Index,go.data);
    local data = {}
    data.Index = Index
    data.serinofs = go.data
    DataManager.DetailModelRpcNoRet(2, 'm_chooseGameServer',data)
end

function ServerListCtrl:c_GsCreateRole()
    UIPage:ClearAllPages()
    ct.OpenCtrl("CreateRoleCtrl")
end
function ServerListCtrl:c_GsLoginSuccess(playerId)
    UIPage:ClearAllPages()---------------------
    --UIPage:ShowPage(GameMainInterfaceCtrl)
    ct.OpenCtrl('GameMainInterfaceCtrl',playerId)
    --UIPage:ShowPage(TopBarCtrl)
    --UIPage:ShowPage(MainPageCtrl,"UI数据传输测试")
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
