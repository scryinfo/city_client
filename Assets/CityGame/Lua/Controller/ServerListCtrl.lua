-----
-----

ServerListCtrl = class('ServerListCtrl',UIPage)
UIPage:ResgisterOpen(ServerListCtrl)
ServerListCtrl.static.Server_PATH = "View/GoodsItem/ServerItem";

local serverListBehaviour;
local gameObject;

function  ServerListCtrl:bundleName()
    return "ServerListPanel"
end

function ServerListCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function ServerListCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    serverListBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    serverListBehaviour:AddClick(ServerListPanel.serverOneBtn,self.c_OnServerOne,self);
    serverListBehaviour:AddClick(ServerListPanel.serverTwoBtn,self.c_OnServerTwo,self);
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
function ServerListCtrl:Refresh()
--[[    ct.log("rodger_w8_GameMainInterface","[ServerListCtrl:Refresh] UI数据刷新， 数据为: m_data =",self.m_data);
    ServerListPanel.serverOneText:GetComponent('Text').text =self.m_data[1];
    ServerListPanel.serverTwoText:GetComponent('Text').text = self.m_data[2];]]

end

--选择服务器--
function ServerListCtrl:c_OnServer(go)
    local showTest = go.serverName.text;
    ServerListPanel.serverText:GetComponent('Text').text = showTest;
    local Index = go.id;
    Event.Brocast("m_chooseGameServer", Index);
end

--点击确定--
function ServerListCtrl:c_OnOK()
    if ServerListModel.isClick then
        Event.Brocast("m_GsOK");
    end
    ServerListModel.isClick = false
end

function ServerListCtrl:c_GsCreateRole()
    UIPage:ClearAllPages()
    UIPage:ShowPage(CreateRoleCtrl)
end
function ServerListCtrl:c_GsLoginSuccess()
    UIPage:ClearAllPages()
    UIPage:ShowPage(GameMainInterfaceCtrl)
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
