---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 15:07
---建筑主界面生产线详情界面
BuildingProductionDetailPart = class('BuildingProductionDetailPart',BasePartDetail)

function BuildingProductionDetailPart:PrefabName()
    return "BuildingProductionDetailPart"
end

function BuildingProductionDetailPart:_InitTransform()
    self:_getComponent(self.transform)
end

function BuildingProductionDetailPart:RefreshData(data)
    self:_ResetTransform()
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end

function BuildingProductionDetailPart:_ResetTransform()

end

function BuildingProductionDetailPart:_getComponent(transform)
    if transform == nil then
        return
    end
end

function BuildingProductionDetailPart:_InitClick(mainPanelLuaBehaviour)

end

function BuildingProductionDetailPart:_RemoveClick()

end

function BuildingProductionDetailPart:_initFunc()

end


