---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/28 11:08
---推广签约详情
AdBuildingSignDetailPart = class('AdBuildingSignDetailPart', BasePartDetail)
local datainfo = {}
local luaBehavior
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
    Event.AddListener("m_GetAllMyFlowSign",self.m_GetAllMyFlowSign,self)
end
--
function AdBuildingSignDetailPart:_InitClick(mainPanelLuaBehaviour)
    luaBehavior = mainPanelLuaBehaviour
end
--
function AdBuildingSignDetailPart:_ResetTransform()
    self.sign = nil
end
--
function AdBuildingSignDetailPart:_RemoveEvent()
    Event.RemoveListener("m_GetAllMyFlowSign",self.m_GetAllMyFlowSign,self)
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
    self.scroll = transform:Find("root/down/Scroll"):GetComponent('ActiveLoopScrollRect')

end

function AdBuildingSignDetailPart:_initData()
    self.sign = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.sign.mProvideData = AdBuildingSignDetailPart.static.SignProvideData
    self.sign.mClearData = AdBuildingSignDetailPart.static.SignClearData

end
--
function AdBuildingSignDetailPart:_initFunc()

end
--

function AdBuildingSignDetailPart:m_GetAllMyFlowSign(data)
    if self.m_data == nil then
        return
    end
    datainfo = data
    if datainfo == nil then
        self.scroll:ActiveLoopScroll(self.sign, 0)
    else
        for i, v in pairs(data) do
            data[i].insId  = self.m_data.insId
        end
        self.scroll:ActiveLoopScroll(self.sign, #datainfo)
    end
end

function AdBuildingSignDetailPart:Show(data)
    BasePartDetail.Show(self)
    self.m_data = data
    DataManager.DetailModelRpcNoRet(self.m_data.insId, 'm_GetAllMyFlowSign',self.m_data.insId)
end

function AdBuildingSignDetailPart:Hide()
    BasePartDetail.Hide(self)
end


--滑动复用
--滑动互用
AdBuildingSignDetailPart.static.SignProvideData = function(transform, idx)

    idx = idx + 1
    local item = PromoteSignItem:new( datainfo[idx],transform,luaBehavior)
end

AdBuildingSignDetailPart.static.SignClearData = function(transform)

end