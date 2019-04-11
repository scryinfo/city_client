---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/2 17:12
---建筑主界面今日营收
TurnoverPart = class('TurnoverPart', BasePart)
--
function TurnoverPart:PrefabName()
    return "TurnoverPart"
end
--
function TurnoverPart:GetDetailClass()
    return TurnoverDetailPart
end
--
function TurnoverPart:_InitTransform()
    self:_getComponent(self.transform)
end
--
function  TurnoverPart:_ResetTransform()
    self.turnover.text = "0.0000"
end
--
function TurnoverPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data
    self:_initFunc()
end
--
function TurnoverPart:_getComponent(transform)
    self.turnover = transform:Find("Top/turnover"):GetComponent("Text")
end
--
function TurnoverPart:_initFunc()
    self.turnover.text = GetClientPriceString(self.m_data.turnover)
end
