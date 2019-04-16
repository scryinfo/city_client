---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/12 15:07
---建筑主界面生产线详情界面
BuildingProductionDetailPart = class('BuildingProductionDetailPart',BuildingBaseDetailPart)
local Math_Ceil = math.ceil
function BuildingProductionDetailPart:PrefabName()
    return "BuildingProductionDetailPart"
end

function BuildingProductionDetailPart:_InitTransform()
    self:_getComponent(self.transform)
    --待生产
    self.waitingQueueIns = {}
end

function BuildingProductionDetailPart:RefreshData(data)
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
    self.closeBtn = transform:Find("topRoot/closeBtn"):GetComponent("Button")

    self.addBtn = transform:Find("contentRoot/addBtnBg")
    self.addBtnBg = transform:Find("contentRoot/addBtnBg/addBtn"):GetComponent("Button")
    self.content = transform:Find("contentRoot/content")
    self.addTip = transform:Find("contentRoot/addBtnBg/addTip"):GetComponent("Text")
    --leftRoot
    self.nameBg = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/nameBg")
    self.goods = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods")

    self.iconImg = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/iconImg"):GetComponent("Image")
    self.nameText = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/nameBg/nameText"):GetComponent("Text")
    self.levelImg = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/levelImg"):GetComponent("Image")
    self.brandNameText = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = transform:Find("contentRoot/content/leftRoot/lineInfo/goodsInfo/goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")
    self.numberText = transform:Find("contentRoot/content/leftRoot/lineInfo/numberText"):GetComponent("Text")
    self.timeText = transform:Find("contentRoot/content/leftRoot/lineInfo/timeBg/timeText"):GetComponent("Text")
    self.deleBtn = transform:Find("contentRoot/content/leftRoot/lineInfo/deleBtn")
    self.timeSlider = transform:Find("contentRoot/content/leftRoot/lineInfo/timeSlider"):GetComponent("Slider")
    self.oneTimeText = transform:Find("contentRoot/content/leftRoot/lineInfo/timeText"):GetComponent("Text")
    --rightRoot
    self.numberTipText = transform:Find("contentRoot/content/rightRoot/topBg/numberTipText"):GetComponent("Text")
    self.lineNumberText = transform:Find("contentRoot/content/rightRoot/topBg/numberTipText/lineNumberText"):GetComponent("Text")
    self.Content = transform:Find("contentRoot/content/rightRoot/content/ScrollView/Viewport/Content")
    self.noLineTip = transform:Find("contentRoot/content/rightRoot/content/noLineTip"):GetComponent("Text")
    self.rightAddBg = transform:Find("contentRoot/content/rightRoot/content/addBg/addBtn"):GetComponent("Button")

    self.lineItemPrefab = transform:Find("contentRoot/content/rightRoot/content/ScrollView/Viewport/Content/LineItem").gameObject
end

function BuildingProductionDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.mainPanelLuaBehaviour = mainPanelLuaBehaviour
    mainPanelLuaBehaviour:AddClick(self.closeBtn.gameObject,function()
        self:clickCloseBtn()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.addBtnBg.gameObject,function()
        self:clickAddBtnBg()
    end,self)
    mainPanelLuaBehaviour:AddClick(self.rightAddBg.gameObject,function()
        self:clickAddBtnBg()
    end,self)
end

function BuildingProductionDetailPart:_RemoveClick()
    self.closeBtn.onClick:RemoveAllListeners()
    self.addBtnBg.onClick:RemoveAllListeners()
    self.rightAddBg.onClick:RemoveAllListeners()
end

function BuildingProductionDetailPart:_initFunc()
    self:_language()
    self:initializeUiInfoData(self.m_data.line)
end
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
--设置多语言
function BuildingProductionDetailPart:_language()
    self.addTip.text = "增加一条生产线"
    self.numberTipText.text = "数量"
end
--初始化UI数据
function BuildingProductionDetailPart:initializeUiInfoData(lineData)
    if not lineData then
        self.addBtn.transform.localScale = Vector3.one
        self.content.transform.localScale = Vector3.zero
        self.lineNumberText.text = 0 .."/"..0

    else
        self.addBtn.transform.localScale = Vector3.zero
        self.content.transform.localScale = Vector3.one
        self.nameText.text = GetLanguage(lineData[1].itemId)
        self.timeText.text = self:GetTime(lineData[1])
        self.numberText.text = lineData[1].nowCount.."/"..lineData[1].targetCount

        --当前生产中线开始的时间
        self.startTime = lineData[1].ts
        --当前服务器时间
        self.serverNowTime = TimeSynchronized.GetTheCurrentServerTime()
        --当前生产中线已经生产的时间
        self.pastTime = self.serverNowTime - self.startTime

        if self.m_data.buildingType == BuildingType.MaterialFactory then
            self.nameBg.transform.localPosition = Vector3(-140,-100,0)
            self.goods.transform.localScale = Vector3.zero
            LoadSprite(Material[lineData[1].itemId].img,self.iconImg,false)
            self.oneTotalTime = self:GetOneNumTime(Material[lineData[1].itemId].numOneSec,lineData[1].workerNum)
        elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
            LoadSprite(Good[lineData[1].itemId].img,self.iconImg,false)
            self.oneTotalTime = self:GetOneNumTime(Good[lineData[1].itemId].numOneSec,lineData[1].workerNum)
        end
        self.timeSlider.maxValue = Math_Ceil(self.oneTotalTime / 1000)
        self.timeSlider.value = Math_Ceil((self.oneTotalTime - (self.pastTime % self.oneTotalTime)) / 1000)
        --实验直接使用已经生产的时间赋值
        --self.timeSlider.value = Math_Ceil(self.pastTime / 1000)
        self.oneTimeText.text = self:GetStringTime(self.timeSlider.maxValue - self.timeSlider.value)

        self.lineNumberText.text = #lineData.."/"..#lineData
        --判断当前有没有代生产队列
        if #lineData == 1 then
            self.noLineTip.text = "you can add some production lines."
            self.noLineTip.transform.localScale = Vector3.one
        elseif #lineData > 1 then
            self.noLineTip.transform.localScale = Vector3.zero
            --判断当前是否已经创建好了队列
            if #lineData - 1 == #self.waitingQueueIns then
                self.Content.transform.localPosition = Vector3(0,0,0)
                return
            else
                for i = 2, #lineData do
                    self:CreatedWaitingQueue(lineData[i],self.lineItemPrefab,self.Content,LineItem,self.mainPanelLuaBehaviour,self.waitingQueueIns,self.m_data.buildingType)
                end
            end
        end
    end
end
-----------------------------------------------------------------------------点击函数--------------------------------------------------------------------------------------
--关闭详情
function BuildingProductionDetailPart:clickCloseBtn()
    self.groupClass.TurnOffAllOptions(self.groupClass)
end
--打开添加生产线界面
function BuildingProductionDetailPart:clickAddBtnBg()
    PlayMusEff(1002)
    if self.m_data.info.state == "OPERATE" then
        ct.OpenCtrl("AddProductionLineCtrl",self.m_data)
        self:CloseDestroy(self.waitingQueueIns)
    else
        Event.Brocast("SmallPop",GetLanguage(35040013),300)
        return
    end
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--计算总时间
function BuildingProductionDetailPart:GetTime(lineData)
    local remainingNum = lineData.targetCount - lineData.nowCount
    if remainingNum == 0 then
        return "00:00:00"
    end
    if self.m_data.buildingType == BuildingType.MaterialFactory then
        self.time = remainingNum / (Material[lineData.itemId].numOneSec * lineData.workerNum)
    elseif self.m_data.buildingType == BuildingType.ProcessingFactory then
        self.time = remainingNum / (Good[lineData.itemId].numOneSec * lineData.workerNum)
    end
    local timeTable = getTimeBySec(self.time)
    local timeStr = timeTable.hour..":"..timeTable.minute..":"..timeTable.second
    return timeStr
end
--计算当前生产一个需要的时间(毫秒级)
function BuildingProductionDetailPart:GetOneNumTime(numOneSec,workerNum)
    local seconds = 1 / (numOneSec * workerNum)
    local ms = seconds * 1000
    return ms
end
--生产一个的时间转换 时分秒
function BuildingProductionDetailPart:GetStringTime(ms)
    local timeTable = getTimeBySec(ms / 1000)
    local timeStr = timeTable.minute..":"..timeTable.second
    return timeStr
end