---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/18/018 12:01
---


AvtarCtrl = class('AvtarCtrl',UIPanel)
UIPanel:ResgisterOpen(AvtarCtrl) --注册打开的方法

local panel             --AvtarPanel
local LuaBehaviour      --LuaBehaviour
local this              --self


local fiveItemPath="View/AvtarItems/fiveItem"
local kindItemPath="View/AvtarItems/kindItem"

local pastApperanceID = {}        --之前选择的组件
local pool = {}

local mySex                       --我选择的性别
local myCurrentHeadNum            --我选择的headNum

local headPrefab = {}             --Avatar的HeadList
local AvatarOrganImageList = {}   --Avatar部件的Image存储
local my_appearance ={}           --我选择的外观

local currentHead = nil
FiveType = {
  head=1,
  body=2,
  brow=3,
  eyes=4,
  haircut=5,
  frontHat=6,
  mouth=7,
  nose=8,
  goatee=9,
  decal=10,
}
---==========================================================================================框架函数============================================================================================
--【over】
function  AvtarCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AvtarPanel.prefab"
end

function AvtarCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
end

--【over】
function AvtarCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function AvtarCtrl:Refresh()
    panel.InitLanguage()
    DataManager.OpenDetailModel(AvtarModel,OpenModelInsID.AvtarCtrl)
    self:begin()
end

--【over】
function  AvtarCtrl:Hide()
    UIPanel.Hide(self)
    self:ClearCasch()
end

--【over】
function AvtarCtrl:Close()
    UIPanel.Close(self)
    self:ClearCasch()
    pool = {}
end

--【over】
function AvtarCtrl:Awake(go)
    self.gameObject = go
    this = self
    panel = AvtarPanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    LuaBehaviour:AddClick(panel.backBtn.gameObject,self.c_OnClick_backBtn,self)
    LuaBehaviour:AddClick(panel.cofirmBtn.gameObject,self.c_OnClick_confirm,self)
    LuaBehaviour:AddClick(panel.randomBtn.gameObject,self.c_OnClick_randomChange,self)
    LuaBehaviour:AddClick(panel.maleBtn.gameObject,self.c_OnClick_male,self)
    LuaBehaviour:AddClick(panel.feMaleBtn.gameObject,self.c_OnClick_faMale,self)
end

---==========================================================================================业务代码===================================================================================================

--清空缓存数据
function AvtarCtrl:ClearCasch()
    ct.log("system","清空Avatar缓存数据")
    if headPrefab~= nil then
        for tempSex, table in pairs(headPrefab) do
            for i, v in pairs(table) do
                destroy(v)
            end
        end
    end
    if pastApperanceID ~= nil then
        for key, pastApperance in pairs(pastApperanceID) do
            UnLoadSprite(pastApperance.path)
        end
    end
    mySex = nil
    currentHead = nil
    myCurrentHeadNum = nil
    AvatarOrganImageList = nil
    headPrefab = nil
    --pool = {}
end


--临时对象池                 --【over】
local function InsAndObjectPool(config,class,prefabPath,parent,this)
    if nil == pool[class] then
        pool[class] = {}
    end
    local tempList = pool[class]
    local prefab
    --开始遍历
    for i, value in ipairs(config) do
        --对象池中当前个数还有
        if tempList[i] ~= nil then
            value.id = i
            tempList[i]:updateData(value)
            tempList[i].prefab:SetActive(true)
        else
            --需要新生成pool
            prefab = creatGoods(prefabPath,parent)
            value.id = i
            tempList[i] = class:new(prefab,LuaBehaviour,value,this)
        end
    end
    --多于的隐藏
    if #config < #tempList then
        for i = #config + 1 , #tempList do
            tempList[i].prefab:SetActive(false)
        end
    end
end


--遍历目标avatar的Image      --【over】
local function FindOrgan(transform)
    local AvatarImages = {}
    AvatarImages["body"] = transform:Find("body/body"):GetComponent("Image")
    AvatarImages["backHat"] = transform:Find("backHat/backHat"):GetComponent("Image")
    AvatarImages["head"] = transform:Find("head/head"):GetComponent("Image")
    AvatarImages["haircut"] = transform:Find("hair/hair"):GetComponent("Image")
    AvatarImages["nose"] = transform:Find("nose/nose"):GetComponent("Image")
    AvatarImages["brow"] = transform:Find("brow/brow"):GetComponent("Image")
    AvatarImages["frontHat"] = transform:Find("frontHat/frontHat"):GetComponent("Image")
    AvatarImages["eyes"] = transform:Find("eyes/eyes"):GetComponent("Image")
    AvatarImages["mouth"] = transform:Find("mouth/mouth"):GetComponent("Image")

    if transform:Find("decal/decal") ~= nil  then
        AvatarImages["decal"] = transform:Find("decal/decal"):GetComponent("Image")
        AvatarImages["goatee"] = transform:Find("goatee/goatee"):GetComponent("Image")
    end
    return AvatarImages
end

--初始化
function AvtarCtrl:begin()
    local faceId = DataManager.GetFaceId()
    --初始化
    AvatarOrganImageList = {}
    AvatarOrganImageList[1] = {}
    AvatarOrganImageList[2] = {}
    headPrefab = {}
    headPrefab[1] = {}
    headPrefab[2] = {}
    --加载中间实例
    if faceId then --有ID为二次修改，隐藏性别选项
        local arr = split(faceId,"-")
        if arr[1] == "1" then
            self:switchKinds(AvtarConfig.man[1].kinds)
            --加载左侧五官选择按钮
            InsAndObjectPool(AvtarConfig.man,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
        else
            self:switchKinds(AvtarConfig.woMan[1].kinds)
            --加载左侧五官选择按钮
            InsAndObjectPool(AvtarConfig.woMan,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
        end
        --左侧选到第一个
        this.select.localScale = Vector3.zero
        this.select = pool[FiveFaceItem][1].select
        this.select.localScale = Vector3.one
        --
        GetAvtar(faceId)
        --隐藏性别选项
        panel.maleBtn.gameObject:SetActive(false)
        panel.feMaleBtn.gameObject:SetActive(false)
        --打开幸运值展示
        panel.luckyRoot.localScale = Vector3.one
        panel.luckyValue.text = DataManager.GetMyFlightScore()
        --判断是否需要有按钮 this.cofirmBtn
        if DataManager.GetMyFlightScore() < 10 then
            panel.cofirmBtn.localScale = Vector3.zero
        else
            panel.cofirmBtn.localScale = Vector3.one
        end
    else--无ID，为初始建号
        --性别默认为男
        mySex = 1
        myCurrentHeadNum = 1
        --加载左侧五官选择按钮
        InsAndObjectPool(AvtarConfig.man,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
        --随机一个装扮
        self:randomChange()
        --默认选择男性的第一个部件
        self:switchKinds(AvtarConfig.man[1].kinds)
        --显示性别选项
        panel.maleBtn.gameObject:SetActive(true)
        panel.feMaleBtn.gameObject:SetActive(true)
        --隐藏幸运值展示
        panel.luckyRoot.localScale = Vector3.zero
    end
end

--加载右侧实例
function AvtarCtrl:switchKinds(config)
    InsAndObjectPool(config,KindsItem,kindItemPath,panel.kindsContent,self)
end

--随机选择
function AvtarCtrl:randomChange()
    local config
    if mySex == 1 then
        config=AvtarConfig.man
    else
        config=AvtarConfig.woMan
    end
    for i, qiGuan in ipairs(config) do
        local num = math.random(1,#qiGuan.kinds)
        self:changAparance(config[i].kinds[num],num)
    end
end

--改变人物某个部件选择
function AvtarCtrl:changAparance(data,rank)
    local path,type
    local arr = split(data.path,",")
    path = arr[1]           --更换路径
    type = arr[2]           --更换的类型
    --换头需要单独处理
    if type == "head" then
        --1.切换prefab
        --2.拷贝旧sprite
        local config
        if mySex == 1 then
            config = HeadConfig.man
        else
            config = HeadConfig.woMan
        end
        --已有的隐藏
        if currentHead ~= nil then
            currentHead:SetActive(false)
        end
        --标记切换为新的，并记录之前的Num
        local oldNum = myCurrentHeadNum
        myCurrentHeadNum  = data.id or rank
        --新的显示
        if headPrefab[mySex][myCurrentHeadNum] == nil then
            headPrefab[mySex][myCurrentHeadNum] = creatGoods( config[myCurrentHeadNum].path , panel.showContent )
            AvatarOrganImageList[mySex][myCurrentHeadNum] =  FindOrgan(headPrefab[mySex][myCurrentHeadNum].transform)
            LoadSprite(path,AvatarOrganImageList[mySex][myCurrentHeadNum][type])
        end
        currentHead = headPrefab[mySex][myCurrentHeadNum]
        currentHead:SetActive(true)
        --
        pastApperanceID[type]= {}
        pastApperanceID[type].path = path
        pastApperanceID[type].rank = myCurrentHeadNum
        pastApperanceID[type].type = type
        --加载原来服饰
        local tempList = AvatarOrganImageList[mySex][myCurrentHeadNum]
        local tempOldList = AvatarOrganImageList[mySex][oldNum]
        for key, value in pairs(tempList) do
            if key ~= "head" then
                --如果之前有sprite，直接拷贝，否则的话load/
                if tempOldList ~= nil and tempOldList[key] ~= nil and tempOldList[key].sprite ~= nil and pastApperanceID[key] ~= nil and pastApperanceID[key] ~= {} and pastApperanceID[key].path ~= nil then
                    value.sprite = tempOldList[key].sprite
                    value.transform.localScale = Vector3.one
                    value.gameObject:SetActive(true)
                else
                    ct.log("system","切换人种的时候移植sprite失败")
                    value.gameObject:SetActive(false)
                end
                if key == "frontHat" then
                    if tempOldList ~= nil and tempOldList["backHat"] ~= nil and tempOldList["backHat"].sprite ~= nil and pastApperanceID["backHat"] ~= nil and pastApperanceID["backHat"] ~= {} and pastApperanceID["backHat"].path ~= nil then
                        tempList["backHat"].gameObject:SetActive(true)
                        tempList["backHat"].sprite = tempOldList["backHat"].sprite
                        tempList["backHat"].transform.localScale = Vector3.one
                    else--部件不要的处理
                        tempList["backHat"].gameObject:SetActive(false)
                    end
                end
            end
        end
    --换头发需要额外处理
    --TODO://y验证
    elseif type == "frontHat" then
        local tempList = AvatarOrganImageList[mySex][myCurrentHeadNum]
        pastApperanceID[type] = {}
        if path =="" then
            tempList[type].gameObject:SetActive(false)
        else
            tempList[type].gameObject:SetActive(true)
            LoadSprite(path,tempList[type])
            pastApperanceID[type].path = path
            pastApperanceID[type].rank = rank
            pastApperanceID[type].type = type
        end
        pastApperanceID["backHat"] = {}
        if arr[3]=="" then
            tempList[arr[4]].gameObject:SetActive(false)
        else
            tempList[arr[4]].gameObject:SetActive(true)
            LoadSprite(arr[3],tempList[arr[4]])
            pastApperanceID["backHat"].path = arr[3]
            pastApperanceID["backHat"].rank = arr[4]
            pastApperanceID["backHat"].type = "backHat"
        end
    else  --其余普通的
        local tempList = AvatarOrganImageList[mySex][myCurrentHeadNum]
        pastApperanceID[type] = {}
        if path =="" then
            tempList[type].gameObject:SetActive(false)
        else
            tempList[type].gameObject:SetActive(true)
            LoadSprite(path,tempList[type])
            pastApperanceID[type].path = path
            pastApperanceID[type].rank = rank
            pastApperanceID[type].type = type
        end
    end
end

--获取中间的Avatar
function GetAvtar(faceId)
    local arr = split(faceId,"-")
    if arr[1] == "1" then--男人
        mySex = 1
        myCurrentHeadNum = 1
        local temp = split(arr[2],",")
        for i = 1, #temp ,2 do
            if temp[i] == "1" then
                myCurrentHeadNum = tonumber(temp[i+1])
            end
        end
        --todo：加载小人头像
        headPrefab[mySex][myCurrentHeadNum] = creatGoods(HeadConfig.man[myCurrentHeadNum].path,panel.showContent)
        AvatarOrganImageList[mySex][myCurrentHeadNum] =  FindOrgan(headPrefab[mySex][myCurrentHeadNum].transform)
        local arr = split(AvtarConfig.man[1].kinds[myCurrentHeadNum].path,",")
        LoadSprite(arr[1],AvatarOrganImageList[mySex][myCurrentHeadNum]["head"])

        for i = 1, #temp ,2 do
            if temp[i] ~= "" and temp[i] == "1" then
                local kind = AvtarConfig.man[tonumber(temp[i])].kinds[tonumber(temp[i+1])]
                this:changAparance(kind, temp[i+1])
            end
        end
        for i = 1, #temp ,2 do
            if temp[i] ~= "" and temp[i] ~= "1" then
                local kind = AvtarConfig.man[tonumber(temp[i])].kinds[tonumber(temp[i+1])]
                this:changAparance(kind, temp[i+1])
            end
        end

    else--女人
        mySex = 2
        myCurrentHeadNum = 1
        local temp = split(arr[2],",")
        for i = 1, #temp ,2 do
            if temp[i] == "1" then
                myCurrentHeadNum = tonumber(temp[i+1])
            end
        end
        --todo：加载小人头像
        headPrefab[mySex][myCurrentHeadNum] = creatGoods(HeadConfig.woMan[myCurrentHeadNum].path,panel.showContent)
        AvatarOrganImageList[mySex][myCurrentHeadNum] =  FindOrgan(headPrefab[mySex][myCurrentHeadNum].transform)
        local arr = split(AvtarConfig.woMan[1].kinds[myCurrentHeadNum].path,",")
        LoadSprite(arr[1],AvatarOrganImageList[mySex][myCurrentHeadNum]["head"])

        for i = 1, #temp ,2 do
            if temp[i] ~= "" and temp[i] == "1" then
                local kind = AvtarConfig.woMan[tonumber(temp[i])].kinds[tonumber(temp[i+1])]
                this:changAparance(kind,temp[i+1])
            end
        end
        for i = 1, #temp ,2 do
            if temp[i] ~= "" and temp[i] ~= "1" then
                local kind = AvtarConfig.woMan[tonumber(temp[i])].kinds[tonumber(temp[i+1])]
                this:changAparance(kind,temp[i+1])
            end
        end
    end
    return headPrefab[mySex][myCurrentHeadNum]
end

---==========================================================================================点击函数===================================================================================================
--返回
function AvtarCtrl:c_OnClick_backBtn(ins)
    PlayMusEff(1002)
    if DataManager.GetFaceId() then
        UIPanel.ClosePage()
    else
        --ins:Hide()
        CityEngineLua.LoginOut()
    end
end

--确定 TODO://
function AvtarCtrl:c_OnClick_confirm()

    PlayMusEff(1002)
    local faceId,type,rankID=""

    for key, value in pairs(pastApperanceID) do
        if value.type ~= nil and value.type ~= "backHat"  then
            type = tostring(FiveType[value.type])
            rankID = tostring(value.rank)
            if rankID == nil then
                rankID = ""
            end
            faceId = faceId..type..","..rankID..","
        end
    end
    --[[
    for key, value in pairs(appearance) do
        if value.typeId then
            type = tostring(FiveType[key])
            typeId = tostring(value.typeId)
            faceId = faceId..type..","..typeId..","
        end
    end--]]
    faceId = tostring(mySex).."-"..faceId
    local temp={}
    temp.faceId = faceId

    for key, pastApperance in pairs(pastApperanceID) do
        UnLoadSprite(pastApperance.path)
    end

    if DataManager.GetFaceId() then
        if faceId ~= DataManager.GetFaceId() then
            --打开提示弹窗
            local data={ReminderType = ReminderType.Common,ReminderSelectType = ReminderSelectType.Select,
                        content = GetLanguage(17030004,10),func = function()
                    Event.Brocast("m_setRoleFaceId",faceId)
                    DataManager.SetFaceId(faceId)
                    UIPanel.ClosePage()
                end  }
            ct.OpenCtrl('NewReminderCtrl',data)
        else
            UIPanel.ClosePage()
        end
    else
        if mySex == 1 then
            temp.gender = true
        else
            temp.gender = false
        end
        ct.OpenCtrl("CreateRoleCtrl",temp)
    end
end

--随机
function AvtarCtrl:c_OnClick_randomChange(ins)
    PlayMusEff(1002)
    ins:randomChange()
end

--切换为男性
function AvtarCtrl:c_OnClick_male(ins)
    PlayMusEff(1002)
    pastApperanceID = {}
    if mySex == 2 then
        mySex = 1
        panel.feMaleSelect.localScale=Vector3.zero
        panel.maleSelect.localScale=Vector3.one
        InsAndObjectPool(AvtarConfig.man,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
        ins:randomChange()
        ins:switchKinds(AvtarConfig.man[1].kinds)
        this.select.localScale = Vector3.zero
        this.select = pool[FiveFaceItem][1].select
        this.select.localScale = Vector3.one
    end
end

--切换为女性
function AvtarCtrl:c_OnClick_faMale(ins)
    PlayMusEff(1002)
    pastApperanceID = {}
    if mySex == 1 then
        mySex = 2
        panel.feMaleSelect.localScale=Vector3.one
        panel.maleSelect.localScale=Vector3.zero
        InsAndObjectPool(AvtarConfig.woMan,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
        ins:randomChange()
        ins:switchKinds(AvtarConfig.woMan[1].kinds)
        this.select.localScale = Vector3.zero
        this.select = pool[FiveFaceItem][1].select
        this.select.localScale = Vector3.one
    end
end
