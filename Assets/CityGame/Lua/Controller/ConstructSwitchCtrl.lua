---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by allen.
--- DateTime: 2018/11/2 17:01
---Construction panel
-----

ConstructSwitchCtrl = class('ConstructSwitchCtrl',UIPanel)
UIPanel:ResgisterOpen(ConstructSwitchCtrl)

function ConstructSwitchCtrl:initialize()
    UIPanel.initialize(self, UIType.Bubble, UIMode.DoNothing, UICollider.None)
end

function ConstructSwitchCtrl:bundleName()
    return "Assets/CityGame/Resources/View/ConstructSwitchPanel.prefab"
end

function ConstructSwitchCtrl:OnCreate(obj)
    UIPanel.OnCreate(self, obj)
    --Close panel
    local LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(ConstructSwitchPanel.btn_confirm.gameObject, function()
        --Confirm construction
        --ct.log("Allen_wk13","Confirm construction")
        Event.Brocast("m_constructBuildConfirm")
        Event.Brocast("m_abolishConstructBuild")
        PlayMusEff(1002)
    end );
    LuaBehaviour:AddClick(ConstructSwitchPanel.btn_abolish.gameObject, function()
        --Cancel construction
        --ct.log("Allen_wk13","Cancel construction")
        Event.Brocast("m_abolishConstructBuild")
        PlayMusEff(1002)
    end );
end

function ConstructSwitchCtrl:Awake(go)
    self.gameObject = go
end

function ConstructSwitchCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("m_abolishConstructBuild", self.Hide, self)
    Event.AddListener("m_constructBuildGameObjectMove", self.MoveBtnNodePosition, self)
    Event.AddListener("m_constructBuildConfirm", self.ConstructBuildConfirm, self)
end

function ConstructSwitchCtrl:Refresh()
    TerrainManager.MoveTempConstructObj()
end


--Mobile node location
--Trigger: 1. Triggered once when created 2. Triggered once when moving buildings 3. Triggered once when moving screen
function ConstructSwitchCtrl:MoveBtnNodePosition()
    --Calculate the latest Node location
    if DataManager.TempDatas.constructObj == nil then
        return
    end
    --Calculate the top offset
    local tempPos = DataManager.TempDatas.constructObj.transform.position
    tempPos.x =  tempPos.x + PlayerBuildingBaseData[DataManager.TempDatas.constructID]["deviationPos"][1]
    tempPos.y =  tempPos.y + PlayerBuildingBaseData[DataManager.TempDatas.constructID]["deviationPos"][2]
    tempPos.z =  tempPos.z + PlayerBuildingBaseData[DataManager.TempDatas.constructID]["deviationPos"][3]
    --3D coordinates to 2D coordinates
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
    UIPanel.Hide(self)
    TerrainManager.AbolishConstructBuild()
    Event.RemoveListener("m_abolishConstructBuild", self.Hide, self)
    Event.RemoveListener("m_constructBuildGameObjectMove", self.MoveBtnNodePosition, self)
    Event.RemoveListener("m_constructBuildConfirm", self.ConstructBuildConfirm, self)
end

--Confirm construction
function ConstructSwitchCtrl:ConstructBuildConfirm()
    --Send construction data to the server
    if DataManager.TempDatas.constructID ~= nil then
        local tempPos = DataManager.TempDatas.constructObj.transform.position
        PlayerTempModel.m_ReqAddBuilding(DataManager.TempDatas.constructID, math.floor(tempPos.x) ,  math.floor(tempPos.z))
    end
end
