AddLineBoxCtrl = class('AddLineBoxCtrl',BuildingBaseCtrl)
UIPanel:ResgisterOpen(AddLineBoxCtrl)

local addLineBox
function AddLineBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.Normal)
end

function AddLineBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AddLineBoxPanel.prefab"
end
function AddLineBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end
function AddLineBoxCtrl:Awake(go)
    self.gameObject = go
end
function AddLineBoxCtrl:Active()
    UIPanel.Active(self)
    addLineBox = self.gameObject:GetComponent('LuaBehaviour')
    addLineBox:AddClick(AddLineBoxPanel.leftBtn.gameObject,self.OnClick_leftBtn,self)
    addLineBox:AddClick(AddLineBoxPanel.rightBtn.gameObject,self.OnClick_rightBtn,self)
    addLineBox:AddClick(AddLineBoxPanel.closeBtn.gameObject,self.OnClick_closeBtn,self)
    addLineBox:AddClick(AddLineBoxPanel.confirmBtn.gameObject,self.OnClick_confirmBtn,self)

    AddLineBoxPanel.numberScrollbar.onValueChanged:AddListener(function()
        self:SlidingUpdateInput()
    end)
    AddLineBoxPanel.inputNumber.onValueChanged:AddListener(function()
        self:InputUpdateSlider()
    end)
end
function AddLineBoxCtrl:Refresh()
    self:InitializeData()
end
function AddLineBoxCtrl:Hide()
    UIPanel.Hide(self)
end
----------------------------------------------------------------------初始化函数------------------------------------------------------------------------------------------
function AddLineBoxCtrl:InitializeData()
    AddLineBoxPanel.numberScrollbar.maxValue = PlayerBuildingBaseData[self.m_data.mId].storeCapacity
    AddLineBoxPanel.numberScrollbar.value = 0
    AddLineBoxPanel.inputNumber.characterLimit = string.len(AddLineBoxPanel.numberScrollbar.maxValue)
    AddLineBoxPanel.inputNumber.text = 0
    AddLineBoxPanel.timeText.text = "00:00:00"
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        local speed = 1 / Material[self.m_data.itemId].numOneSec / 60
        AddLineBoxPanel.nemaText.text = Material[self.m_data.itemId].name
        AddLineBoxPanel.speedText.text = "<color=#00ffba>"..self:GetOneSecNum(speed).." sec.".."</color>/one"
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        local speed = 1 / Good[self.m_data.itemId].numOneSec / 60
        AddLineBoxPanel.nemaText.text = Good[self.m_data.itemId].name
        AddLineBoxPanel.speedText.text = "<color=#00ffba>"..self:GetOneSecNum(speed).." sec.".."</color>/one"
    end
end
----------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------------
--左Button
function AddLineBoxCtrl:OnClick_leftBtn()

end
--右Button
function AddLineBoxCtrl:OnClick_rightBtn()

end
--关闭Button
function AddLineBoxCtrl:OnClick_closeBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--确定Button
function AddLineBoxCtrl:OnClick_confirmBtn(go)
    PlayMusEff(1002)
    local number = AddLineBoxPanel.numberScrollbar.value
    local ststaffaffNum = PlayerBuildingBaseData[go.m_data.mId].maxWorkerNum
    if go:NumberWhetherZero(number) == true then
        if go.m_data.buildingType == BuildingType.MaterialFactory then
            Event.Brocast("m_ReqMaterialAddLine",go.m_data.buildingId,number,ststaffaffNum,go.m_data.itemId)
        end
    end
end
------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------------
--添加成功后
function AddLineBoxCtrl:SucceedUpdatePanel(dataInfo)
    local aaa = dataInfo
    local bbb = ""
end
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--截取小数点后两位
function AddLineBoxCtrl:GetOneSecNum(str)
    local index = string.find(str, '%.')
    if not index then
        return str
    end
    local secStr = string.sub(str,1,index + 2)
    return secStr
end
--滑动条刷新输入框值
function AddLineBoxCtrl:SlidingUpdateInput()
    AddLineBoxPanel.inputNumber.text = AddLineBoxPanel.numberScrollbar.value
    --AddLineBoxPanel.timeText.text =
end
--输入刷新滑动条
function AddLineBoxCtrl:InputUpdateSlider()
    if AddLineBoxPanel.inputNumber.text ~= "" then
        AddLineBoxPanel.numberScrollbar.value = AddLineBoxPanel.inputNumber.text
    end
end
--检查要生产的数量是否为零
function AddLineBoxCtrl:NumberWhetherZero(number)
    if number == 0 then
        Event.Brocast("SmallPop",GetLanguage(26020003),300)
        return false
    end
    return true
end