---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/3/11 11:51
---开业按钮
OpenBusinessBtnItem = class('OpenBusinessBtnItem')

--初始化方法
function OpenBusinessBtnItem:initialize(viewRect)
    self.viewRect = viewRect
    self.openBtn = viewRect:GetComponent("Button")
    self.openText = viewRect.transform:Find("Text"):GetComponent("Text")

    self.openBtn.onClick:AddListener(function ()
        self:_clickOpenBtn()
    end)
end
--
function OpenBusinessBtnItem:initData(info, type)
    if info ~= nil and type ~= nil then
        self.data = {info = info, type = type}
    end
end
--
function OpenBusinessBtnItem:_clickOpenBtn()
    if self.data == nil then
        return
    end
    PlayMusEff(1002)

    if self.data.type == BuildingType.House then
        ct.OpenCtrl("OpenHouseCtrl", {info = self.data.info, callBackFunc = function (salary, rent)
            if salary ~= nil and rent ~= nil then
                self:_reqOpenBusiness(self.data.info.id)
                self:_reqSetSalary(self.data.info.id, salary, TimeSynchronized.GetTheCurrentTime())
                self:_reqHouseChangeRent(self.data.info.id, rent)
            end
        end})
    else
        ct.OpenCtrl("BuildingSetSalaryCtrl", {info = self.data.info, callBackFunc = function (salary)
            if salary ~= nil then
                self:_reqOpenBusiness(self.data.info.id)
                self:_reqSetSalary(self.data.info.id, salary, TimeSynchronized.GetTheCurrentTime())
            end
        end})
    end
end
--
function OpenBusinessBtnItem:toggleState(canShow)
    if canShow == true then
        self.viewRect.transform.localScale = Vector3.one
        self.openText.text = GetLanguage(12345678)
    else
        self.viewRect.transform.localScale = Vector3.zero
    end
end
-------------------------------------------------------------------------
--改变房租
function OpenBusinessBtnItem:_reqHouseChangeRent(id, price)
    DataManager.ModelSendNetMes("gscode.OpCode", "setRent","gs.SetRent",{ buildingId = id, rent = price})
end
--改变员工工资
function OpenBusinessBtnItem:_reqSetSalary(id, price, ts)
    DataManager.ModelSendNetMes("gscode.OpCode", "setSalary","gs.SetSalary",{ buildingId = id, Salary = price, ts = ts})
end
--请求开业
function OpenBusinessBtnItem:_reqOpenBusiness(id)
    DataManager.ModelSendNetMes("gscode.OpCode", "startBusiness","gs.Id",{ id = id})
end