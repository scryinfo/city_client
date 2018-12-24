--Model基类

local class = require 'Framework/class'
BaseBuildModel = class('BaseBuildModel')

--初始化
--将protobuf内数据拷贝出来
function BaseBuildModel:initialize(data)
    self.Data = {}
    self:Refresh(data)
end

--刷新数据
function BaseBuildModel:Refresh(data)
    --ct.log("Allen_w9","请使用BaseModel派生类自己的Refresh方法，尽量不要调用基类的 Refresh 方法")
    for key, value in pairs(data) do
        self.Data[key] = value
    end
    DataManager.RefreshBlockDataWhenNodeChange(data.posID,PlayerBuildingBaseData[data.buildingID].x)
end

--打开界面
function BaseBuildModel:OpenPanel()
    --ct.log("Allen_w9","请使用BaseModel派生类自己的OpenPanel方法，尽量不要调用基类的OpenPanel方法")
    --TODO:在具体子类中做打开操作
    local typeID = self.Data.buildingID
    local instanceID = self.Data.id
    if typeID == 1100001 or typeID == 1100002 or typeID == 1100003 then         --原料厂
        --Event.Brocast('m_ReqOpenMaterial',instanceID)
        ct.OpenCtrl("MaterialCtrl", {insId = instanceID})
    elseif typeID == 1200001 or typeID == 1200002 or typeID == 1200003 then    --加工厂
        --Event.Brocast('m_ReqOpenProcessing',instanceID)
        ct.OpenCtrl('ProcessingCtrl',{insId = instanceID})
    elseif typeID == 1300001 or typeID == 1300002 or typeID == 1300003 then    --零售店
        ct.OpenCtrl("RetailStoresCtrl",{insId = instanceID})
    elseif typeID == 1400001 or typeID == 1400002 or typeID == 1400003 then    --住宅
        ct.OpenCtrl("HouseCtrl", {insId = instanceID})
    elseif typeID == 1500001 or typeID == 1500002 or typeID == 1500003 then    --研究所
        ct.OpenCtrl("LaboratoryCtrl", {insId = instanceID})
    elseif typeID == 1600001 or typeID == 1600002 or typeID == 1600003 then    --公园
        --Event.Brocast("m_detailPublicFacility",instanceID)
        ct.OpenCtrl("MunicipalCtrl",{insId=instanceID})
    end
end


function BaseBuildModel:Close()
    for  key, value in pairs(self.Data) do
        value = nil
    end
    --清除建筑GameObject
    if self.go ~= nil then
        Destory(self.go)
    end
    self = nil
end