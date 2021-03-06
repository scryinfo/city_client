---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/5/28 17:06
---

EvaTitleItemTwo = class("EvaTitleItemTwo", BaseEvaTitleItem)

EvaTitleItemTwo.static.NomalNameColor = Vector3.New(99, 132, 202) -- 默认的名字颜色
EvaTitleItemTwo.static.SelectNameColor = Vector3.New(255, 255, 255) -- 被选中的名字颜色

-- 子类继承实现自己的方法用以显示具体的内容
function EvaTitleItemTwo:_showContent()
    local recordData = EvaCtrl.static.evaCtrl:GetEvaRecordData()
    self.nameText.text = GetLanguage(EvaCtrl.static.evaCtrl.allUIData[recordData[1]].option[self.index].name)
    if EvaCtrl.static.evaCtrl.isClickEva then
        EvaCtrl.static.evaCtrl.isClickEva = false
        self:_onClickBtn()
    end
    if recordData[1] == 2 then
        if EvaCtrl.static.evaCtrl.addData and EvaCtrl.static.evaCtrl.addData[recordData[1]] and EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index] then
            if EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index].value then
                self:_setAddNumber(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index].value)
            else
                self:_setAddNumber()
            end
            if EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index].marketValue then
                self:_setMarketAddNumber(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index].marketValue)
            else
                self:_setMarketAddNumber()
            end
        else
            self:_setAddNumber()
            self:_setMarketAddNumber()
        end
    else
        if EvaCtrl.static.evaCtrl.addData and EvaCtrl.static.evaCtrl.addData[recordData[1]] and EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index] then
            self:_setAddNumber(EvaCtrl.static.evaCtrl.addData[recordData[1]].optionValue[self.index].value)
        else
            self:_setAddNumber()
        end
        self:_setMarketAddNumber()
    end
end

-- 按钮点击事件、子类继承实现自己的方法
function EvaTitleItemTwo:_onClickBtn()
    BaseEvaTitleItem._onClickBtn(self)
    local optionOne = EvaCtrl.static.evaCtrl:GetEvaRecordData()[1]
    if EvaCtrl.static.evaCtrl.allUIData[optionOne].option[self.index].option then
        EvaPanel.propertyRootRt.offsetMax = Vector2.New(0, -282)
        EvaCtrl.static.evaCtrl.isClickEvaT = true
        EvaCtrl.static.evaCtrl:ShowOptionThere(#EvaCtrl.static.evaCtrl.allUIData[optionOne].option[self.index].option)
    else
        EvaPanel.propertyRootRt.offsetMax = Vector2.New(0, -192)
        EvaCtrl.static.evaCtrl.isClickEvaT = false
        EvaCtrl.static.evaCtrl:ShowOptionThere(0)
        EvaCtrl.static.evaCtrl:CreatePropertyItem(EvaCtrl.static.evaCtrl.allUIData[optionOne].option[self.index].property)
    end
end

-- 设置按钮文字的颜色、子类继承实现自己的方法
function EvaTitleItemTwo:_setNameTextColor(isSelect)
    self.nameText.color = getColorByVector3(isSelect and EvaTitleItemOne.static.NomalNameColor or EvaTitleItemOne.static.SelectNameColor)
end
