---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by allen.
--- DateTime: 2018/11/2 17:01
---建造面板
-----

ConstructSwitchCtrl = class('ConstructSwitchCtrl',UIPage)
UIPage:ResgisterOpen(ConstructSwitchCtrl)

function ConstructSwitchCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.None)
end

function ConstructSwitchCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ConstructSwitchPanel.prefab"
end

function ConstructSwitchCtrl:OnCreate(obj)
    UIPage.OnCreate(self, obj)
    --关闭面板
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(ConstructSwitchPanel.btn_confirm.gameObject, function()
        --TODO：确认建造
        ct.log("Allen_wk13","确认建造")
        Event.Brocast("m_constructBuildConfirm")
        Event.Brocast("m_abolishConstructBuild")
    end );
    LuaBehaviour:AddClick(ConstructSwitchPanel.btn_abolish.gameObject, function()
        --TODO：取消建造
        ct.log("Allen_wk13","取消建造")
        Event.Brocast("m_abolishConstructBuild")
    end );
end

function ConstructSwitchCtrl:Awake(go)
    self.gameObject = go
    Event.AddListener("m_abolishConstructBuild", self.Hide, self);
    Event.AddListener("m_constructBuildGameObjectMove", self.MoveBtnNodePosition, self);
    Event.AddListener("m_constructBuildConfirm", self.ConstructBuildConfirm, self);
end

function ConstructSwitchCtrl:Refresh()
    TerrainManager.MoveTempConstructObj()
end


--移动节点位置
--触发：1.创建时触发一次2.移动建筑物时触发一次3.移动屏幕时触发一次
function ConstructSwitchCtrl:MoveBtnNodePosition()
    --计算最新Node位置
    if DataManager.TempDatas.constructObj == nil then
        return
    end
    --计算顶部偏移量
    local tempPos = DataManager.TempDatas.constructObj.transform.position
    tempPos.x =  tempPos.x + PlayerBuildingBaseData[DataManager.TempDatas.constructID]["deviationPos"][1]
    tempPos.y =  tempPos.y + PlayerBuildingBaseData[DataManager.TempDatas.constructID]["deviationPos"][2]
    tempPos.z =  tempPos.z + PlayerBuildingBaseData[DataManager.TempDatas.constructID]["deviationPos"][3]
    --3D坐标转2D坐标
    local nodePosition = UnityEngine.Camera.main:WorldToScreenPoint(tempPos)
    ConstructSwitchPanel.BtnNode.anchoredPosition = ScreenPosTurnActualPos(nodePosition)
    local blockID = TerrainManager.PositionTurnBlockID(DataManager.TempDatas.constructObj.transform.position)
    local tempSize = PlayerBuildingBaseData[DataManager.TempDatas.constructID].x
    if DataManager.IsAllOwnerGround(blockID,tempSize) and DataManager.IsALlEnableChangeGround(blockID,tempSize) then
        ConstructSwitchPanel.confirmEnableIconTransform.localScale = Vector3.one
    else
        ConstructSwitchPanel.confirmEnableIconTransform.localScale = Vector3.zero
    end
end

function ConstructSwitchCtrl:Hide()
    UIPage.Hide(self)
    TerrainManager.AbolishConstructBuild()
end

--确认建造建筑
function ConstructSwitchCtrl:ConstructBuildConfirm()
    --TODO：向服务器发送建造数据
    if DataManager.TempDatas.constructID ~= nil then
        local tempPos = DataManager.TempDatas.constructObj.transform.position
        PlayerTempModel.m_ReqAddBuilding(DataManager.TempDatas.constructID, math.floor(tempPos.x) ,  math.floor(tempPos.z))
    end
end
