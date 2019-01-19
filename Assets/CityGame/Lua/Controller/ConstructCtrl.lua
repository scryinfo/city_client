---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by allen.
--- DateTime: 2018/11/2 17:01
---建造面板
-----

ConstructCtrl = class('ConstructCtrl',UIPage)
UIPage:ResgisterOpen(ConstructCtrl)

function ConstructCtrl:initialize()
    UIPage.initialize(self, UIType.Normal, UIMode.HideOther, UICollider.None)
end

function ConstructCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ConstructPanel.prefab"
end

function ConstructCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
    --关闭面板
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(ConstructPanel.btn_back.gameObject, function()
        UIPage.ClosePage();
    end );
end

function ConstructCtrl:Awake(go)
    self.gameObject = go
    self.contentTrans = self.gameObject.transform:Find("bottomScroll/Viewport/Content")
    self:_initPanelData()
end

function ConstructCtrl:Refresh()
    --self:ClearAllItem()
    --self:_initPanelData()

    Event.Brocast("c_HideGroundBubble")
    ct.log("Allen_wk14_MyGround","临时生成我的地块")
    UnitTest.Exec_now("Allen_wk14_MyGround", "c_CreateMyGrounds",self)
end

function ConstructCtrl:ClearAllItem()
    if self.contentTrans.childCount > 0 then
        for i = 0, self.contentTrans.childCount - 1 do
            destroy(self.contentTrans:GetChild(i).gameObject)
        end
        --ConstructCtrl:ClearItemData()
    end
end

function ConstructCtrl:_initPanelData()
    --根据配置表生成Items
    local path = 'View/Items/ConstructItem'
    local prefab = UnityEngine.Resources.Load(path);
    if not prefab then
        return
    end
    local contentWidth = 0
    self.Items  = {}
    for key, item in ipairs(ConstructConfig) do
        local itemObj = UnityEngine.GameObject.Instantiate(prefab,self.contentTrans)
        self.Items[key] = ConstructItem:new(item, itemObj.transform ,contentWidth)
        contentWidth =  self.Items[key].sizeDeltaX
    end
    contentWidth  =  contentWidth - 12
    self.contentTrans:GetComponent("RectTransform").sizeDelta = Vector2.New(contentWidth,self.contentTrans:GetComponent("RectTransform").sizeDelta.y)
end

function ConstructCtrl:ClearItemData()
    if self.Items ~= nil then
        for i, v in pairs(self.Items) do
            v:Close()
            v = nil
        end
        self.Items = nil
    end
end

function ConstructCtrl:Hide()
    UIPage.Hide(self)
    UnitTest.Exec_now("Allen_wk14_MyGround", "c_DestoryMyGrounds",self)
    CameraMove.ChangeCameraState(TouchStateType.NormalState)
    Event.Brocast("m_abolishConstructBuild")
    Event.Brocast("c_ShowGroundBubble")
end


UnitTest.TestBlockStart()
UnitTest.Exec("Allen_wk14_MyGround", "test_CreateMyGrounds_self",  function ()
    ct.log("Allen_wk14_MyGround","[c_CreateMyGrounds] ...............")
    Event.AddListener("c_CreateMyGrounds", function (obj)
        if not DataManager.TempDatas then
            DataManager.TempDatas ={}
        end
        DataManager.TempDatas.myGroundObj = {}
        local myPersonData = DataManager.GetMyPersonData()
        local myGroundObj = UnityEngine.Resources.Load(PlayerBuildingBaseData[4000001].prefabRoute)
        if myPersonData.m_groundInfos then
            for key, value in pairs(myPersonData.m_groundInfos) do
                if  DataManager.IsOwnerGround({x = value.x, z = value.y}) then
                    local tempObj = UnityEngine.GameObject.Instantiate(myGroundObj)
                    tempObj.transform.position =Vector3.New(value.x,0,value.y)
                    tempObj.transform.localScale = Vector3.one
                    tempObj.name = "My_OwnGround"
                    table.insert(DataManager.TempDatas.myGroundObj,tempObj)
                end
            end
        else
            myPersonData.m_groundInfos = {}
        end
        if  myPersonData.m_rentGroundInfos then
            for key, value in pairs(myPersonData.m_rentGroundInfos) do
                if  DataManager.IsOwnerGround({x = value.x, z = value.y}) then
                    local tempObj = UnityEngine.GameObject.Instantiate(myGroundObj)
                    tempObj.transform.position =Vector3.New(value.x,0,value.y)
                    tempObj.transform.localScale = Vector3.one
                    tempObj.name = "My_RentGround"
                    table.insert(DataManager.TempDatas.myGroundObj,tempObj)
                end
            end
        else
            myPersonData.m_rentGroundInfos = {}
        end
    end)
end)


UnitTest.Exec("Allen_wk14_MyGround", "test_c_DestoryMyGrounds_self",  function ()
    ct.log("Allen_wk14_MyGround","[c_DestoryMyGrounds] ...............")
    Event.AddListener("c_DestoryMyGrounds", function (obj)
        if not DataManager.TempDatas or not DataManager.TempDatas.myGroundObj then
            return
        end
        for key, value in pairs(DataManager.TempDatas.myGroundObj) do
                destroy(value)
        end
        DataManager.TempDatas.myGroundObj = nil
    end)
end)


UnitTest.TestBlockEnd()