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
    self.buildingId = self.m_data.insId
    self.itemId = self.m_data.itemId
    self.workerNum = PlayerBuildingBaseData[self.m_data.mId].maxWorkerNum

    AddLineBoxPanel.numberScrollbar.maxValue = PlayerBuildingBaseData[self.m_data.mId].storeCapacity
    AddLineBoxPanel.numberScrollbar.value = 0
    AddLineBoxPanel.inputNumber.characterLimit = string.len(AddLineBoxPanel.numberScrollbar.maxValue)
    AddLineBoxPanel.inputNumber.text = 0
    AddLineBoxPanel.timeText.text = "00:00:00"
    AddLineBoxPanel.nemaText.text = GetLanguage(self.itemId)
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        local speed = 1 / (Material[self.itemId].numOneSec * self.workerNum)
        AddLineBoxPanel.speedText.text = "<color=#00ffba>"..self:GetOneSecNum(speed).." sec.".."</color>/one"
        AddLineBoxPanel.itemGoodsbg.localScale = Vector3.New(0,0,0)
        LoadSprite(Material[self.itemId].img,AddLineBoxPanel.icon,false)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        local speed = 1 / (Good[self.itemId].numOneSec * self.workerNum)
        AddLineBoxPanel.speedText.text = "<color=#00ffba>"..self:GetOneSecNum(speed).." sec.".."</color>/one"
        AddLineBoxPanel.itemMaterialbg.localScale = Vector3.New(0,0,0)
        LoadSprite(Good[self.itemId].img,AddLineBoxPanel.icon,false)
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
    if go:NumberWhetherZero(number) == true then
        if go.m_data.buildingType == BuildingType.MaterialFactory then
            Event.Brocast("m_ReqMaterialAddLine",go.buildingId,number,go.workerNum,go.itemId)
        end
    end
end
------------------------------------------------------------------------回调函数--------------------------------------------------------------------------------------------
--添加成功后
function AddLineBoxCtrl:SucceedUpdatePanel(dataInfo)
    if dataInfo ~= nil then
        UIPanel.BackToPageInstance(MaterialCtrl,self.m_data)
    end
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
    AddLineBoxPanel.timeText.text = self:GetTime(AddLineBoxPanel.numberScrollbar.value,self.workerNum)
end
--输入刷新滑动条
function AddLineBoxCtrl:InputUpdateSlider()
    if AddLineBoxPanel.inputNumber.text ~= "" then
        AddLineBoxPanel.numberScrollbar.value = AddLineBoxPanel.inputNumber.text
        AddLineBoxPanel.timeText.text = self:GetTime(AddLineBoxPanel.numberScrollbar.value,self.workerNum)
    else
        AddLineBoxPanel.timeText.text = "00:00:00"
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
--计算时间
function AddLineBoxCtrl:GetTime(targetCount,workerNum)
    if targetCount == 0 then
        return "00:00:00"
    end
    local materialKey,goodsKey = 21,22  --商品类型
    local time
    if math.floor(self.itemId / 100000) == materialKey then
        time = targetCount / (Material[self.itemId].numOneSec * workerNum)
    elseif math.floor(self.itemId / 100000) == goodsKey then
        time = targetCount / (Good[self.itemId].numOneSec * workerNum)
    end
    local timeTable = getTimeBySec(time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end