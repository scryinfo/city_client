---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/28 11:08
---推广签约详情
AdBuildingSignDetailPart = class('AdBuildingSignDetailPart', BasePartDetail)
--
function AdBuildingSignDetailPart:PrefabName()
    return "AdBuildingSignDetailPart"
end
--
function AdBuildingSignDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    self:_initData()
end
--
function  AdBuildingSignDetailPart:_InitEvent()

end
--
function AdBuildingSignDetailPart:_InitClick(mainPanelLuaBehaviour)
    mainPanelLuaBehaviour:AddClick(self.xBtn, self.OnXBtn, self)
end
--
function AdBuildingSignDetailPart:_ResetTransform()

end
--
function AdBuildingSignDetailPart:_RemoveEvent()

end
--
function AdBuildingSignDetailPart:_RemoveClick()

end
--
function AdBuildingSignDetailPart:RefreshData(data)

end
--
function AdBuildingSignDetailPart:_getComponent(transform)
    --top
    self.xBtn = transform:Find("root/closeBtn").gameObject --返回


end

function AdBuildingSignDetailPart:_initData()

end
--
function AdBuildingSignDetailPart:_initFunc()

end
--

function AdBuildingSignDetailPart:OnXBtn(go)
    go.groupClass.TurnOffAllOptions(go.groupClass)
end

function AdBuildingSignDetailPart:Show(data)
    BasePartDetail.Show(self)
    self.m_data = data
    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_GetAllMyFlowSign',self.m_data.insId)
end

function AdBuildingSignDetailPart:Hide()
    BasePartDetail.Hide(self)
end
