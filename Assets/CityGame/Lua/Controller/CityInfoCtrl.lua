---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/8/10 10:55
---城市信息Ctrl
CityInfoCtrl = class('CityInfoCtrl',UIPanel)
UIPanel:ResgisterOpen(CityInfoCtrl)

local cityInfoBehaviour
local createTs

function CityInfoCtrl:bundleName()
    return "Assets/CityGame/Resources/View/CityInfoPanel.prefab"
end

function CityInfoCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)
end

function CityInfoCtrl:Awake(go)
    cityInfoBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    cityInfoBehaviour:AddClick(CityInfoPanel.back,self.OnBack,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.notBasic,self.OnNotBasic,self)  --基础信息
    cityInfoBehaviour:AddClick(CityInfoPanel.notIndustry,self.OnNotIndustry,self)  --行业信息
    cityInfoBehaviour:AddClick(CityInfoPanel.homeHouse,self.OnHomeHouse,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.supermarket,self.OnSupermarket,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.materialPlant,self.OnMaterialPlant,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.factory,self.OnFactory,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.advertising,self.OnAdvertising,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.technology,self.OnTechnology,self)
    cityInfoBehaviour:AddClick(CityInfoPanel.land,self.OnLand,self)

    self.width = CityInfoPanel.titleBg.sizeDelta.x
    self.ownerId = DataManager.GetMyOwnerID()
    self.first = true  --第一次点击行业信息
    self.rankItem = {}   --排行榜实例

    self.industryInfoItem = {}
    for i, v in ipairs(CityInfoConfig) do
       local prefab = createPrefabs(CityInfoPanel.industryInfoItem,CityInfoPanel.content)
        self.industryInfoItem[i] = IndustryInfoItem:new(cityInfoBehaviour,prefab,v,self)
    end
    self.m_data = {}
    self.m_data.insId = OpenModelInsID.CityInfoCtrl

    self.homeHouseBtn = {}
    self.supermarketBtn = {}
    self.materialPlantBtn = {}
    self.factoryBtn = {}
    self.advertisingBtn = {}
    self.technologyBtn = {}
    self.landBtn = {}

    self.isHomeHouse = true
    self.isSupermarket = true
    self.isMaterialPlant = true
    self.isFactory = true
    self.isAdvertising = true
    self.isTechnology = true
    self.isLand = true

    self.buildingTs = DataManager.GetServerCreateTs() -- 开服时间
    createTs = self.buildingTs
    createTs = math.floor(createTs)
    if tonumber(getFormatUnixTime(createTs).second) ~= 0 then
        createTs = createTs - tonumber(getFormatUnixTime(createTs).second)
    end
    if tonumber(getFormatUnixTime(createTs).minute) ~= 0 then
        createTs = createTs - tonumber(getFormatUnixTime(createTs).minute) * 60
    end
    if tonumber(getFormatUnixTime(createTs).hour) ~= 0 then
        createTs = createTs - tonumber(getFormatUnixTime(createTs).hour) * 3600
    end
end

function CityInfoCtrl:Active()
    UIPanel.Active(self)
end

function CityInfoCtrl:Refresh()
    DataManager.OpenDetailModel(CityInfoModel,self.m_data.insId)
    DataManager.DetailModelRpcNoRet(self.m_data.insId , 'm_GetNpcNum')
    DataManager.DetailModelRpcNoRet(self.m_data.insId , 'm_GetPlayerNum')
    self:initData()
end

function CityInfoCtrl:Hide()
    UIPanel.Hide(self)

    self.first = true

    self.isHomeHouse = true
    self.isSupermarket = true
    self.isMaterialPlant = true
    self.isFactory = true
    self.isAdvertising = true
    self.isTechnology = true
    self.isLand = true

    CityInfoPanel.homeHouseTag.localScale = Vector3.one
    CityInfoPanel.supermarketTag.localScale = Vector3.one
    CityInfoPanel.materialPlantTag.localScale = Vector3.one
    CityInfoPanel.factoryTag.localScale = Vector3.one
    CityInfoPanel.advertisingTag.localScale = Vector3.one
    CityInfoPanel.technologyTag.localScale = Vector3.one
    CityInfoPanel.landTag.localScale = Vector3.one

    self.industryInfoItem[1]:_initPanel()

    CityInfoPanel.four.gameObject:SetActive(false)
    CityInfoPanel.five.gameObject:SetActive(false)
    CityInfoPanel.six.gameObject:SetActive(false)

end

function CityInfoCtrl:Close()
    if self.industryInfoItem then
        for i, v in pairs(self.industryInfoItem) do
            destroy(v.prefab.gameObject)
        end
    end
    self.industryInfoItem = {}
end

function CityInfoCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

--初始化数据
function CityInfoCtrl:initData()
    CityInfoPanel.notBasic.transform.localScale = Vector3.zero
    CityInfoPanel.basic.localScale = Vector3.one
    CityInfoPanel.notIndustry.transform.localScale = Vector3.one
    CityInfoPanel.industry.localScale = Vector3.zero

    CityInfoPanel.basicInfo.localScale = Vector3.one
    CityInfoPanel.industryInfo.localScale = Vector3.zero

    CityInfoPanel.content.localScale = Vector3.zero

    self.industryInfoItem[1].notSelect.transform.localScale = Vector3.zero
    self.industryInfoItem[1].select.localScale = Vector3.one
    self.industryInfoItem[1]:SetLast(self.industryInfoItem[1])

    CityInfoPanel.industryBg.localScale = Vector3.one
    CityInfoPanel.oneContent.localScale = Vector3.zero
end

--返回
function CityInfoCtrl:OnBack()
    UIPanel.ClosePage()
end

function CityInfoCtrl:OnNotBasic(go)
    CityInfoPanel.notBasic.transform.localScale = Vector3.zero
    CityInfoPanel.basic.localScale = Vector3.one
    CityInfoPanel.notIndustry.transform.localScale = Vector3.one
    CityInfoPanel.industry.localScale = Vector3.zero

    CityInfoPanel.basicInfo.localScale = Vector3.one
    CityInfoPanel.industryInfo.localScale = Vector3.zero

    CityInfoPanel.content.localScale = Vector3.zero
    --CityInfoPanel.content:DOScale(Vector3.New(0,0,0),0.5):SetEase(DG.Tweening.Ease.OutCubic);
    local last = go.industryInfoItem[1]:GetLast():GetTitle()
    if last then
        local temp = last:GetLast()
        if temp.id == 2 then
            if temp.type == 20 then
                CityInfoPanel.four.gameObject:SetActive(false)
            elseif temp.type ==11 or temp.type ==15 or temp.type ==16 then
                CityInfoPanel.five.gameObject:SetActive(false)
            elseif temp.type ==12 or temp.type ==13 or temp.type ==14 then
                CityInfoPanel.six.gameObject:SetActive(false)
            end
        end
    end
end

function CityInfoCtrl:OnNotIndustry(go)
    CityInfoPanel.notBasic.transform.localScale = Vector3.one
    CityInfoPanel.basic.localScale = Vector3.zero
    CityInfoPanel.notIndustry.transform.localScale = Vector3.zero
    CityInfoPanel.industry.localScale = Vector3.one

    CityInfoPanel.basicInfo.localScale = Vector3.zero
    CityInfoPanel.industryInfo.localScale = Vector3.one

    CityInfoPanel.content.localScale = Vector3.one
    --CityInfoPanel.content:DOScale(Vector3.New(1,1,1),0.5):SetEase(DG.Tweening.Ease.OutCubic);
    if go.first then
        DataManager.DetailModelRpcNoRet(go.m_data.insId, 'm_queryIndustryIncome')  --查询行业收入
    end
    go.first = false
    local last = go.industryInfoItem[1]:GetLast():GetTitle()
    if last then
        local temp = last:GetLast()
        if temp.id == 2 then
            if temp.type == 20 then
                CityInfoPanel.four.gameObject:SetActive(true)
            elseif temp.type ==11 or temp.type ==15 or temp.type ==16 then
                CityInfoPanel.five.gameObject:SetActive(true)
            elseif temp.type ==12 or temp.type ==13 or temp.type ==14 then
                CityInfoPanel.six.gameObject:SetActive(true)
            end
        end
    end
end

--npc数量
function CityInfoCtrl:c_NpcNum(info)
    CityInfoPanel.citizenNum.text = info.workNpcNum,info.unEmployeeNpcNum
end

--玩家数量
function CityInfoCtrl:c_PlayerNum(info)
    CityInfoPanel.playerNum.text = info
end

--行业收入回调
function CityInfoCtrl:_receiveIndustryIncome(info)
    CityInfoPanel.graph:Close()
    --CityInfoPanel.slide:Close()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime -second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    if hour ~= 0 then
        currentTime = currentTime - hour * 3600
    end
    currentTime = math.floor(currentTime)        --当天0点的时间
    local sevenAgo = currentTime - 604800 + 86400     --7天前的0点
    local updataTime = sevenAgo
    local time = {}
    local homeHouseTab = {}
    local supermarketTab = {}
    local materialPlantTab = {}
    local factoryTab = {}
    local advertisingTab = {}
    local technologyTab = {}
    local landTab = {}
    if createTs >= sevenAgo then
        updataTime = createTs
        for i = 1, 7 do
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            if updataTime <= currentTime then
                homeHouseTab[i] = {}
                homeHouseTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 184) - 60
                homeHouseTab[i].money = 0
                supermarketTab[i] = {}
                supermarketTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 184) - 40
                supermarketTab[i].money = 0
                materialPlantTab[i] = {}
                materialPlantTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 184) - 20
                materialPlantTab[i].money = 0
                factoryTab[i] = {}
                factoryTab[i].coordinate = (updataTime - createTs + 86400) / 86400 * 184
                factoryTab[i].money = 0
                advertisingTab[i] = {}
                advertisingTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 184) + 20
                advertisingTab[i].money = 0
                technologyTab[i] = {}
                technologyTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 184) + 40
                technologyTab[i].money = 0
                landTab[i] = {}
                landTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 184) +60
                landTab[i].money = 0
                if info ~= nil then
                    for k, z in pairs(info) do
                        for s, v in pairs(z) do
                            if updataTime == v.time /1000 then
                                if v.msg then
                                    for a, b in pairs(v.msg) do
                                        if b.type == 11 then
                                            materialPlantTab[i].money = tonumber(GetClientPriceString(b.income))
                                        elseif b.type == 12 then
                                            factoryTab[i].money = tonumber(GetClientPriceString(b.income))
                                        elseif b.type == 13 then
                                            supermarketTab[i].money = tonumber(GetClientPriceString(b.income))
                                        elseif b.type == 14 then
                                            homeHouseTab[i].money = tonumber(GetClientPriceString(b.income))
                                        elseif b.type == 15 then
                                            technologyTab[i].money = tonumber(GetClientPriceString(b.income))
                                        elseif b.type == 16 then
                                            advertisingTab[i].money = tonumber(GetClientPriceString(b.income))
                                        elseif b.type == 20 then
                                            landTab[i].money = tonumber(GetClientPriceString(b.income))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            updataTime = updataTime + 86400
        end
    else
        for i = 1, 7 do
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            homeHouseTab[i] = {}
            homeHouseTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 184) - 60
            homeHouseTab[i].money = 0
            supermarketTab[i] = {}
            supermarketTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 184) - 40
            supermarketTab[i].money = 0
            materialPlantTab[i] = {}
            materialPlantTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 184) - 20
            materialPlantTab[i].money = 0
            factoryTab[i] = {}
            factoryTab[i].coordinate = (updataTime - sevenAgo + 86400) / 86400 * 184
            factoryTab[i].money = 0
            advertisingTab[i] = {}
            advertisingTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 184) + 20
            advertisingTab[i].money = 0
            technologyTab[i] = {}
            technologyTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 184) + 40
            technologyTab[i].money = 0
            landTab[i] = {}
            landTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 184) +60
            landTab[i].money = 0
            if info ~= nil then
                for k, z in pairs(info) do
                    for s, v in pairs(z) do
                        if updataTime == v.time /1000 then
                            if v.msg then
                                for a, b in pairs(v.msg) do
                                    if b.type == 11 then
                                        materialPlantTab[i].money = tonumber(GetClientPriceString(b.income))
                                    elseif b.type == 12 then
                                        factoryTab[i].money = tonumber(GetClientPriceString(b.income))
                                    elseif b.type == 13 then
                                        supermarketTab[i].money = tonumber(GetClientPriceString(b.income))
                                    elseif b.type == 14 then
                                        homeHouseTab[i].money = tonumber(GetClientPriceString(b.income))
                                    elseif b.type == 15 then
                                        technologyTab[i].money = tonumber(GetClientPriceString(b.income))
                                    elseif b.type == 16 then
                                        advertisingTab[i].money = tonumber(GetClientPriceString(b.income))
                                    elseif b.type == 20 then
                                        landTab[i].money = tonumber(GetClientPriceString(b.income))
                                    end
                                end
                            end
                        end
                    end
                end
            end
            updataTime = updataTime + 86400
        end
    end

    --转换为Vector2类型
    local homeHouse = {}
    local supermarket = {}
    local materialPlant = {}
    local factory = {}
    local advertising = {}
    local technology = {}
    local land = {}
    for i, v in pairs(homeHouseTab) do
        homeHouse[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(supermarketTab) do
        supermarket[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(materialPlantTab) do
        materialPlant[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(factoryTab) do
        factory[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(advertisingTab) do
        advertising[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(technologyTab) do
        technology[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(landTab) do
        land[i] = Vector2.New(v.coordinate,v.money)
    end
    table.insert(time,1,"0")
    table.insert(homeHouse,1,Vector2.New(0,0))
    table.insert(supermarket,1,Vector2.New(0,0))
    table.insert(materialPlant,1,Vector2.New(0,0))
    table.insert(factory,1,Vector2.New(0,0))
    table.insert(advertising,1,Vector2.New(0,0))
    table.insert(technology,1,Vector2.New(0,0))
    table.insert(land,1,Vector2.New(0,0))
    local max = 0
    for i, v in pairs(homeHouse) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(supermarket) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(materialPlant) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(factory) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(advertising) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(technology) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(land) do
        if v.y > max then
            max = v.y
        end
    end
    local scale = SetYScale(max,6,CityInfoPanel.yScale)
    local homeHouseVet = {}
    for i, v in pairs(homeHouse) do
        if scale == 0 then
            homeHouseVet[i] = v
        else
            homeHouseVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end
    local supermarketVet = {}
    for i, v in pairs(supermarket) do
        if scale == 0 then
            supermarketVet[i] = v
        else
            supermarketVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end
    local materialPlantVet = {}
    for i, v in pairs(materialPlant) do
        if scale == 0 then
            materialPlantVet[i] = v
        else
            materialPlantVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end
    local factoryVet = {}
    for i, v in pairs(factory) do
        if scale == 0 then
            factoryVet[i] = v
        else
            factoryVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end
    local advertisingVet = {}
    for i, v in pairs(advertising) do
        if scale == 0 then
            advertisingVet[i] = v
        else
            advertisingVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end
    local technologyVet = {}
    for i, v in pairs(technology) do
        if scale == 0 then
            technologyVet[i] = v
        else
            technologyVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end
    local landVet = {}
    for i, v in pairs(land) do
        if scale == 0 then
            landVet[i] = v
        else
            landVet[i] = Vector2.New(v.x,v.y / scale * 110)
        end
    end

    self.homeHouseBtn = homeHouseVet
    self.supermarketBtn = supermarketVet
    self.materialPlantBtn = materialPlantVet
    self.factoryBtn = factoryVet
    self.advertisingBtn = advertisingVet
    self.technologyBtn = technologyVet
    self.landBtn = landVet

    CityInfoPanel.slide:SetXScaleValue(time,184)
    if self.isHomeHouse then
        CityInfoPanel.graph:DrawHistogram(homeHouseVet,Color.New(68 / 255, 90 / 255, 162 / 255, 179 / 255),1)
    end
    --CityInfoPanel.slide:SetCoordinate(homeHouseVet,homeHouse,Color.New(68 / 255, 90 / 255, 162 / 255, 179 / 255),1)

    if self.isSupermarket then
        CityInfoPanel.graph:DrawHistogram(supermarketVet,Color.New(17 / 255, 24 / 255, 62 / 255, 179 / 255),2)
    end
    --CityInfoPanel.slide:SetCoordinate(supermarketVet,supermarket,Color.New(17 / 255, 24 / 255, 62 / 255, 179 / 255),2)

    if self.isMaterialPlant then
        CityInfoPanel.graph:DrawHistogram(materialPlantVet,Color.New(200 / 255, 29 / 255, 31 / 255, 179 / 255),3)
    end
    --CityInfoPanel.slide:SetCoordinate(materialPlantVet,materialPlant,Color.New(200 / 255, 29 / 255, 31 / 255, 179 / 255),3)

    if self.isFactory then
        CityInfoPanel.graph:DrawHistogram(factoryVet,Color.New(226 / 255, 114 / 255, 50 / 255, 179 / 255),4)
    end
    --CityInfoPanel.slide:SetCoordinate(factoryVet,factory,Color.New(226 / 255, 114 / 255, 50 / 255, 179 / 255),4)

    if self.isAdvertising then
        CityInfoPanel.graph:DrawHistogram(advertisingVet,Color.New(255 / 255, 174 / 255, 59 / 255, 179 / 255),5)
    end
    --CityInfoPanel.slide:SetCoordinate(advertisingVet,advertising,Color.New(255 / 255, 174 / 255, 59 / 255, 179 / 255),5)

    if self.isTechnology then
        CityInfoPanel.graph:DrawHistogram(technologyVet,Color.New(101 / 255, 54 / 255, 32 / 255, 179 / 255),6)
    end
    --CityInfoPanel.slide:SetCoordinate(technologyVet,technology,Color.New(101 / 255, 54 / 255, 32 / 255, 179 / 255),6)
    if self.isLand then
        CityInfoPanel.graph:DrawHistogram(landVet,Color.New(151 / 255, 174 / 255, 47 / 255, 179 / 255),7)
    end
    --CityInfoPanel.slide:SetCoordinate(landVet,land,Color.New(151 / 255, 174 / 255, 47 / 255, 179 / 255),7)

    CityInfoPanel.curve.localPosition = CityInfoPanel.curve.localPosition + Vector3.New(0.01, 0,0)
    CityInfoPanel.curve.sizeDelta = CityInfoPanel.curve.sizeDelta + Vector2.New(0.01, 0)
end

function CityInfoCtrl:OnHomeHouse(go)
    go.isHomeHouse = not go.isHomeHouse
    local data = {vet = go.homeHouseBtn, color = Color.New(68 / 255, 90 / 255, 162 / 255, 179 / 255),id = 1 }
    go:ShowHide(go.isHomeHouse,CityInfoPanel.homeHouseTag,data)
end

function CityInfoCtrl:OnSupermarket(go)
    go.isSupermarket = not go.isSupermarket
    local data = {vet = go.supermarketBtn, color = Color.New(17 / 255, 24 / 255, 62 / 255, 179 / 255),id = 2 }
    go:ShowHide(go.isSupermarket,CityInfoPanel.supermarketTag,data)
end

function CityInfoCtrl:OnMaterialPlant(go)
    go.isMaterialPlant = not go.isMaterialPlant
    local data = {vet = go.materialPlantBtn, color = Color.New(200 / 255, 29 / 255, 31 / 255, 179 / 255),id = 3 }
    go:ShowHide(go.isMaterialPlant,CityInfoPanel.materialPlantTag,data)
end

function CityInfoCtrl:OnFactory(go)
    go.isFactory = not go.isFactory
    local data = {vet = go.factoryBtn, color = Color.New(226 / 255, 114 / 255, 50 / 255, 179 / 255),id = 4 }
    go:ShowHide(go.isFactory,CityInfoPanel.factoryTag,data)
end

function CityInfoCtrl:OnAdvertising(go)
    go.isAdvertising = not go.isAdvertising
    local data = {vet = go.advertisingBtn, color = Color.New(255 / 255, 174 / 255, 59 / 255, 179 / 255),id = 5 }
    go:ShowHide(go.isAdvertising,CityInfoPanel.advertisingTag,data)
end

function CityInfoCtrl:OnTechnology(go)
    go.isTechnology = not go.isTechnology
    local data = {vet = go.technologyBtn, color = Color.New(101 / 255, 54 / 255, 32 / 255, 179 / 255),id = 6 }
    go:ShowHide(go.isTechnology,CityInfoPanel.technologyTag,data)
end

function CityInfoCtrl:OnLand(go)
    go.isLand = not go.isLand
    local data = {vet = go.landBtn, color = Color.New(151 / 255, 174 / 255, 47 / 255, 179 / 255),id = 7 }
    go:ShowHide(go.isLand,CityInfoPanel.landTag,data)
end

function CityInfoCtrl:ShowHide(show,tag,data)
    if show then
        tag.localScale = Vector3.one
        CityInfoPanel.graph:DrawHistogram(data.vet,data.color,data.id)
    else
        tag.localScale = Vector3.zero
        CityInfoPanel.graph:DrawHistogram(data.vet,data.color,data.id)
    end
    CityInfoPanel.curve.localPosition = CityInfoPanel.curve.localPosition + Vector3.New(0.01, 0,0)
    CityInfoPanel.curve.sizeDelta = CityInfoPanel.curve.sizeDelta + Vector2.New(0.01, 0)
end

--行业供需
function CityInfoCtrl:_receiveSupplyAndDemand(info)
    CityInfoPanel.supplyDemandGraph:Close()
    CityInfoPanel.supplyDemandSlide:Close()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime -second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    if hour ~= 0 then
        currentTime = currentTime - hour * 3600
    end
    currentTime = math.floor(currentTime)        --当天0点的时间
    local sevenAgo = currentTime - 604800 + 86400     --7天前的0点
    local updataTime = sevenAgo
    local time = {}
    local avgPriceTab = {}       --上架数量(供应)
    local purchasesTab = {}     --购买量(需求)
    if createTs >= sevenAgo then
        updataTime = createTs
        for i = 1, 7 do
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            if updataTime <= currentTime then
                avgPriceTab[i] = {}
                avgPriceTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 190) - 30
                avgPriceTab[i].money = 0
                purchasesTab[i] = {}
                purchasesTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 190) +30
                purchasesTab[i].money = 0
                if info.info ~= nil then
                    for k, v in pairs(info.info) do
                        if updataTime == v.time / 1000 then
                            avgPriceTab[i].money = v.supply
                            purchasesTab[i].money = v.demand
                        end
                    end
                end
                if updataTime == currentTime then
                    avgPriceTab[i].money = info.todayS
                    purchasesTab[i].money = info.todayD
                end
            end
            updataTime = updataTime + 86400
        end
    else
        for i = 1, 7 do
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            avgPriceTab[i] = {}
            avgPriceTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 190) - 30
            avgPriceTab[i].money = 0
            purchasesTab[i] = {}
            purchasesTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 190) +30
            purchasesTab[i].money = 0
            if info.info ~= nil then
                for k, v in pairs(info.info) do
                    if updataTime == v.time / 1000 then
                        avgPriceTab[i].money = v.supply
                        purchasesTab[i].money = v.demand
                    end
                end
            end
            updataTime = updataTime + 86400
        end
        avgPriceTab[#avgPriceTab].money = info.todayS
        purchasesTab[#purchasesTab].money = info.todayD
    end

    --转换为Vector2类型
    local avgPrice = {}
    local purchases = {}

    for i, v in pairs(avgPriceTab) do
        avgPrice[i] = Vector2.New(v.coordinate,v.money)
    end
    for i, v in pairs(purchasesTab) do
        purchases[i] = Vector2.New(v.coordinate,v.money)
    end

    table.insert(time,1,"0")
    table.insert(avgPrice,1,Vector2.New(0,0))
    table.insert(purchases,1,Vector2.New(0,0))
    local max = 0
    for i, v in pairs(avgPrice) do
        if v.y > max then
            max = v.y
        end
    end
    for i, v in pairs(purchases) do
        if v.y > max then
            max = v.y
        end
    end

    local scale = SetYScale(max,8,CityInfoPanel.supplyDemandYScale)
    local avgPriceVet = {}
    for i, v in pairs(avgPrice) do
        if scale == 0 then
            avgPriceVet[i] = v
        else
            avgPriceVet[i] = Vector2.New(v.x,v.y / scale * 78)
        end
    end
    local purchasesVet = {}
    for i, v in pairs(purchases) do
        if scale == 0 then
            purchasesVet[i] = v
        else
            purchasesVet[i] = Vector2.New(v.x,v.y / scale * 78)
        end
    end


    CityInfoPanel.supplyDemandSlide:SetXScaleValue(time,190)

    CityInfoPanel.supplyDemandGraph:DrawHistogram(avgPriceVet,Color.New(158 / 255, 190 / 255, 255 / 255, 179 / 255),1)
    CityInfoPanel.supplyDemandSlide:SetCoordinate(avgPriceVet,avgPrice,Color.New(158 / 255, 190 / 255, 255 / 255, 255 / 255),1)

    CityInfoPanel.supplyDemandGraph:DrawHistogram(purchasesVet,Color.New(255 / 255, 82 / 255, 48 / 255, 179 / 255),2)
    CityInfoPanel.supplyDemandSlide:SetCoordinate(purchasesVet,purchases,Color.New(255 / 255, 82 / 255, 48 / 255, 255 / 255),2)

    CityInfoPanel.supplyDemandCurve.localPosition = CityInfoPanel.supplyDemandCurve.localPosition + Vector3.New(0.01, 0,0)
    CityInfoPanel.supplyDemandCurve.sizeDelta = CityInfoPanel.supplyDemandCurve.sizeDelta + Vector2.New(0.01, 0)
end

--行业排行回调
function CityInfoCtrl:_receiveIndustryTopInfo(info)
    if self.rankItem and next(self.rankItem) then
        for i, v in pairs(self.rankItem) do
            --回收avatar
            if v.my_avatarData ~= nil then
                AvatarManger.CollectAvatar(v.my_avatarData)
                v.my_avatarData = nil
            end
            destroy(v.prefab.gameObject)
        end
    end
    self.rankItem = {}
    if info.type == 20 then
        CityInfoPanel.fourTotal.text = info.total
        if info.topInfo then
            local data = ct.deepCopy(info.topInfo)
            if #info.topInfo > 10 then
                CityInfoPanel.fourMyRankFourItem.localScale = Vector3.one
                if self.my_avatarData ~= nil then
                    AvatarManger.CollectAvatar(self.my_avatarData)
                    self.my_avatarData = nil
                end
                self.my_avatarData = AvatarManger.GetSmallAvatar(info.faceId,CityInfoPanel.fourMyIcon,0.15)
                CityInfoPanel.fourMyRank.text = ">10"
                CityInfoPanel.fourMyMame.text = info.topInfo[#info.topInfo].name
                CityInfoPanel.fourMyIncome.text = info.topInfo[#info.topInfo].income
                CityInfoPanel.fourMyVolume.text = info.topInfo[#info.topInfo].count
                table.remove(data)
            else
                CityInfoPanel.fourMyRankFourItem.localScale = Vector3.zero
            end
            self.rankFourItem = {}
            for i, v in ipairs(data) do
                local prefab = createPrefabs(CityInfoPanel.fourRankFourItem,CityInfoPanel.fourContent)
                self.rankItem[i] = RankFourItem:new(cityInfoBehaviour,prefab,v,i)
            end
        end
    elseif info.type ==11 or info.type ==15 or info.type ==16 then
        CityInfoPanel.fiveEmployees.text = info.staffNum
        CityInfoPanel.fiveTotalIncome.text = info.total
        if info.topInfo then
            local data = ct.deepCopy(info.topInfo)
            if #info.topInfo > 10 then
                CityInfoPanel.fiveMyRankFiveItem.localScale = Vector3.one
                if self.my_avatarData ~= nil then
                    AvatarManger.CollectAvatar(self.my_avatarData)
                    self.my_avatarData = nil
                end
                self.my_avatarData = AvatarManger.GetSmallAvatar(info.faceId,CityInfoPanel.fiveMyIcon,0.15)
                CityInfoPanel.fiveMyRank.text = ">10"
                CityInfoPanel.fiveMyMame.text = info.topInfo[#info.topInfo].name
                CityInfoPanel.fiveMyIncome.text = info.topInfo[#info.topInfo].income
                CityInfoPanel.fiveMyStaff.text = info.topInfo[#info.topInfo].woker
                CityInfoPanel.fiveMyTechnology.text = info.topInfo[#info.topInfo].science
                table.remove(data)
            else
                CityInfoPanel.fiveMyRankFiveItem.localScale = Vector3.zero
            end
            self.rankFiveItem = {}
            for i, v in ipairs(data) do
                local prefab = createPrefabs(CityInfoPanel.fiveRankFiveItem,CityInfoPanel.fiveContent)
                self.rankItem[i] = RankFiveItem:new(cityInfoBehaviour,prefab,v,i)
            end
        end
    elseif info.type ==12 or info.type ==13 or info.type ==14 then
        CityInfoPanel.sixEmployees.text = info.staffNum
        CityInfoPanel.sixTotalIncome.text = info.total
        if info.topInfo then
            local data = ct.deepCopy(info.topInfo)
            if #info.topInfo > 10 then
                CityInfoPanel.sixMyRankSixItem.localScale = Vector3.one
                if self.my_avatarData ~= nil then
                    AvatarManger.CollectAvatar(self.my_avatarData)
                    self.my_avatarData = nil
                end
                self.my_avatarData = AvatarManger.GetSmallAvatar(info.faceId,CityInfoPanel.sixMyIcon,0.15)
                CityInfoPanel.sixMyRank.text = ">10"
                CityInfoPanel.sixMyMame.text = info.topInfo[#info.topInfo].name
                CityInfoPanel.sixMyIncome.text = info.topInfo[#info.topInfo].income
                CityInfoPanel.sixMyStaff.text = info.topInfo[#info.topInfo].woker
                CityInfoPanel.sixMyTechnology.text = info.topInfo[#info.topInfo].science
                CityInfoPanel.sixMyMarket.text = info.topInfo[#info.topInfo].promotion
                table.remove(data)
            else
                CityInfoPanel.sixMyRankSixItem.localScale = Vector3.zero
            end
            for i, v in ipairs(data) do
                local prefab = createPrefabs(CityInfoPanel.sixRankSixItem,CityInfoPanel.sixContent)
                self.rankItem[i] = RankSixItem:new(cityInfoBehaviour,prefab,v,i)
            end
        end
    end
end

--成交均价
function CityInfoCtrl:_receiveAvgPrice(info)
    CityInfoPanel.supplyDemandGraph:Close()
    CityInfoPanel.supplyDemandSlide:Close()
    local currentTime = TimeSynchronized.GetTheCurrentTime()    --服务器当前时间(秒)
    local ts = getFormatUnixTime(currentTime)
    local second = tonumber(ts.second)
    local minute = tonumber(ts.minute)
    local hour = tonumber(ts.hour)
    if second ~= 0 then
        currentTime = currentTime -second
    end
    if minute ~= 0 then
        currentTime = currentTime - minute * 60
    end
    if hour ~= 0 then
        currentTime = currentTime - hour * 3600
    end
    currentTime = math.floor(currentTime)        --当天0点的时间
    local sevenAgo = currentTime - 604800 + 86400     --7天前的0点
    local updataTime = sevenAgo
    local time = {}
    local avgPriceTab = {}      --成交均价
    if createTs >= sevenAgo then
        updataTime = createTs
        for i = 1, 7 do
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            if updataTime <= currentTime then
                avgPriceTab[i] = {}
                avgPriceTab[i].coordinate = ((updataTime - createTs + 86400) / 86400 * 190)
                avgPriceTab[i].money = 0
                if info.avg ~= nil then
                    for k, v in pairs(info.avg) do
                        if updataTime == v.time / 1000 then
                            avgPriceTab[i].money = tonumber(GetClientPriceString(v.price))
                        end
                    end
                end
            end
            updataTime = updataTime + 86400
        end
    else
        for i = 1, 7 do
            time[i] = getFormatUnixTime(updataTime).month .. "." .. getFormatUnixTime(updataTime).day
            avgPriceTab[i] = {}
            avgPriceTab[i].coordinate = ((updataTime - sevenAgo + 86400) / 86400 * 190)
            avgPriceTab[i].money = 0
            if info.avg ~= nil then
                for k, v in pairs(info.avg) do
                    if updataTime == v.time / 1000 then
                        avgPriceTab[i].money = tonumber(GetClientPriceString(v.price))
                    end
                end
            end
            updataTime = updataTime + 86400
        end
    end

    --转换为Vector2类型
    local avgPrice = {}
    for i, v in pairs(avgPriceTab) do
        avgPrice[i] = Vector2.New(v.coordinate,v.money)
    end
    table.insert(time,1,"0")
    table.insert(avgPrice,1,Vector2.New(0,0))
    local max = 0
    for i, v in pairs(avgPrice) do
        if v.y > max then
            max = v.y
        end
    end

    local scale = SetYScale(max,8,CityInfoPanel.supplyDemandYScale)
    local avgPriceVet = {}
    for i, v in pairs(avgPrice) do
        if scale == 0 then
            avgPriceVet[i] = v
        else
            avgPriceVet[i] = Vector2.New(v.x,v.y / scale * 78)
        end
    end

    CityInfoPanel.supplyDemandSlide:SetXScaleValue(time,190)

    CityInfoPanel.supplyDemandGraph:DrawLine(avgPriceVet,Color.New(158 / 255, 190 / 255, 255 / 255, 255 / 255),1)
    CityInfoPanel.supplyDemandSlide:SetCoordinate(avgPriceVet,avgPrice,Color.New(158 / 255, 190 / 255, 255 / 255, 255 / 255),1)

    CityInfoPanel.supplyDemandCurve.localPosition = CityInfoPanel.supplyDemandCurve.localPosition + Vector3.New(0.01, 0,0)
    CityInfoPanel.supplyDemandCurve.sizeDelta = CityInfoPanel.supplyDemandCurve.sizeDelta + Vector2.New(0.01, 0)
end