---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/25/025 17:54
---

--StopAndBuildModel=class('StopAndBuildModel',ModelBase)
local pbl = pbl
--function StopAndBuildModel:initialize()
--    self:OnCreate()
--    UpdateBeat:Add(self._updateTime, self);
--end

StopAndBuildModel={}
local this=StopAndBuildModel

function StopAndBuildModel.Awake()
   this:OnCreate()
   UpdateBeat:Add(this._updateTime, self);
end

function StopAndBuildModel:OnCreate()
    Event.AddListener("m_startBusiness", StopAndBuildModel.m_startBusiness,self);--开业
    Event.AddListener("m_shutdownBusiness", StopAndBuildModel.m_shutdownBusiness,self);--停业
    Event.AddListener("m_delBuilding", StopAndBuildModel.m_delBuilding,self);--拆建筑发包

    ----注册 AccountServer消息
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","startBusiness"),this.n_startBusiness);--开业
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","shutdownBusiness"),this.n_shutdownBusiness);--停业
    --CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","delBuilding"),this.n_delBuilding);--拆建筑
end
---开业发包
function StopAndBuildModel:m_startBusiness(buildingID)
DataManager.ModelSendNetMes("gscode.OpCode", "startBusiness","gs.Id",{ id = buildingID})
end
---开业收包
function StopAndBuildModel.n_startBusiness(lMsg)
 Event.Brocast("c_successBuilding")
end

---停业发包
function StopAndBuildModel:m_shutdownBusiness(buildingID)
    DataManager.ModelSendNetMes("gscode.OpCode", "shutdownBusiness","gs.Id",{ id = buildingID})
end

---停业收包
function StopAndBuildModel.n_shutdownBusiness(lMsg)
    Event.Brocast("SmallPop",GetLanguage(40010018),300)
end

---拆建筑发包
function StopAndBuildModel:m_delBuilding(buildingID)
    DataManager.ModelSendNetMes("gscode.OpCode", "delBuilding","gs.Id",{ id = buildingID})
end

-----拆建筑收包
--function StopAndBuildModel.n_delBuilding(lMsg)
--    Event.Brocast("SmallPop","Success",300)
--end

function StopAndBuildModel:_updateTime()
    --Event.AddListener("m_startBusiness", StopAndBuildModel.m_startBusiness,self);--开业
    --Event.AddListener("m_shutdownBusiness", StopAndBuildModel.m_shutdownBusiness,self);--停业
    --Event.AddListener("m_delBuilding", StopAndBuildModel.m_delBuilding,self);--拆建筑发包
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.X) then
        ct.log("system","aaaaaaaaaaaaaaaaa")
        Event.Brocast("m_delBuilding",MunicipalPanel.buildingId)
    end

end

