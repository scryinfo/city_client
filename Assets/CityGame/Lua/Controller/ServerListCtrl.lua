-----
-----

ServerListCtrl = class('ServerListCtrl',UIPanel)
UIPanel:ResgisterOpen(ServerListCtrl)
ServerListCtrl.static.Server_PATH = "Assets/CityGame/Resources/View/GoodsItem/ServerItem.prefab";

local serverListBehaviour;
local tempTag = nil;
local Index = nil

function  ServerListCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ServerListPanel.prefab"
end

function ServerListCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--You can go back and hide other panels after the UI opens
    --UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--Can go back, after the UI is opened, other UI is not hidden
end

function ServerListCtrl:Awake()
    self.insId = OpenModelInsID.ServerListCtrl
    self.data = self.m_data

    serverListBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    serverListBehaviour:AddClick(ServerListPanel.back,self.c_OnBack,self);
    serverListBehaviour:AddClick(ServerListPanel.oKBtn,self.c_OnOK,self);

    --Common message registration
    Event.AddListener("c_GsCreateRole",self.c_GsCreateRole,self);
    Event.AddListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);
    Event.AddListener("c_OnServer",self.c_OnServer,self)

end

function ServerListCtrl:Active()
    UIPanel.Active(self)

    ServerListPanel.name.text = GetLanguage(10050001)
    ServerListPanel.oKBtnText.text = GetLanguage(10030019)
end

function ServerListCtrl:Refresh()
    self:_initInsData()
    self:_initData();
end

function ServerListCtrl:Hide()
    UIPanel.Hide(self)
    tempTag = nil
    Index = nil
end

function ServerListCtrl:c_OnBack(go)
    PlayMusEff(1002)
    local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.Select,
                content = GetLanguage(10050004),func = function()
            --Empty the item
            if go.server then
                for i, v in pairs(go.server) do
                    destroy(v.prefab.gameObject)
                end
            end
            UIPanel.ClosePage()
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end

function ServerListCtrl:_initInsData()
    DataManager.OpenDetailModel(ServerListModel,self.insId )
end

function ServerListCtrl:Close()
    UIPanel.Close(self)
    --Logout event
    Event.RemoveListener("c_GsCreateRole",self.c_GsCreateRole,self);
    Event.RemoveListener("c_GsLoginSuccess", self.c_GsLoginSuccess, self);
    Event.RemoveListener("c_OnServer",self.c_OnServer,self)
    tempTag = nil
    Index = nil
end

function ServerListCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
 end

function ServerListCtrl:_initData()
    for i, v in ipairs(self.m_data) do
        local function callback(prefab)
            self.serverLuaItem = ServerItem:new(serverListBehaviour,prefab,self,v,i)
            if not self.server then
                self.server = {}
            end
            self.server[i] = self.serverLuaItem
        end
        createPrefab(ServerListCtrl.static.Server_PATH,ServerListPanel.content, callback)
    end
end


--Select server--
function ServerListCtrl:c_OnServer(go)
    if  tempTag ~= nil then
        tempTag.localScale = Vector3.zero
    end
    go.tag.localScale = Vector3.one
    tempTag = go.tag
    Index = go.id;
end

--Click determine-- -
function ServerListCtrl:c_OnOK(go)
    PlayMusEff(1002)
    if Index == nil then
        return
    end
    local data = {}
    data.Index = Index
    data.serinofs = go.data
    DataManager.DetailModelRpcNoRet(go.insId , 'm_chooseGameServer',data)
end

function ServerListCtrl:c_GsCreateRole()
    ct.OpenCtrl("AvtarCtrl")
end

function ServerListCtrl:c_GsLoginSuccess(playerId)
    UIPanel:ClearAllPages()
    ct.OpenCtrl('GameMainInterfaceCtrl',playerId)
end
