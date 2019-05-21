---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/18/018 12:01
---


AvtarCtrl = class('AvtarCtrl',UIPanel)
UIPanel:ResgisterOpen(AvtarCtrl) --注册打开的方法

local panel
local LuaBehaviour;
local this
local headPrefab={}
headPrefab[1]={}
headPrefab[2]={}

local currHead

local fiveItemPath="View/AvtarItems/fiveItem"
local kindItemPath="View/AvtarItems/kindItem"

FiveType={
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

function  AvtarCtrl:bundleName()
    return "Assets/CityGame/Resources/View/AvtarPanel.prefab"
end

function AvtarCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
end

function AvtarCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function AvtarCtrl:Refresh()
    DataManager.OpenDetailModel(AvtarModel,OpenModelInsID.AvtarCtrl)
    self:begin()
end

function  AvtarCtrl:Hide()
    UIPanel.Hide(self)
    self:ClearCasch()
end

function AvtarCtrl:Close()
    UIPanel.Close(self)
    self:ClearCasch()
end

function  AvtarCtrl:Awake(go)
    self.gameObject = go
    this=self
    panel=AvtarPanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(panel.backBtn.gameObject,self.c_OnClick_backBtn,self);
    LuaBehaviour:AddClick(panel.cofirmBtn.gameObject,self.c_OnClick_confirm,self);
    LuaBehaviour:AddClick(panel.randomBtn.gameObject,self.c_OnClick_randomChange,self);
    LuaBehaviour:AddClick(panel.maleBtn.gameObject,self.c_OnClick_male,self);
    LuaBehaviour:AddClick(panel.feMaleBtn.gameObject,self.c_OnClick_faMale,self);

end

---==========================================================================================业务代码===================================================================================================
local appearance={}
local pastApperanceID={}
local pool={}
local sex
--清空缓存
function AvtarCtrl:ClearCasch()
    for sex, table in pairs(headPrefab) do
        for i, v in pairs(table) do
            destroy(v)
        end
    end
    for key, pastApperance in pairs(pastApperanceID) do
        UnLoadSprite(pastApperance.path)
    end
    currHead=nil
end


--临时对象池
--class  kindsItem
local  function InsAndObjectPool(config,class,prefabPath,parent,this)
    if not pool[class] then
        pool[class] = {}
    end
    local tempList = pool[class]
    local prefab
    --开始遍历
    for i, value in ipairs(config) do
        --对象池中当前个数还有
        if tempList[i] ~= nil then
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


--遍历目标avatar的Icon
local function FindOrgan(transform)
    if not appearance["body"] then
        appearance["body"]={}
        appearance["backHat"]={}
        appearance["head"]={}
        appearance["haircut"]={}
        appearance["nose"]={}
        appearance["brow"]={}
        appearance["frontHat"]={}
        appearance["eyes"]={}
        appearance["mouth"]={}
        appearance["decal"]={}
        appearance["goatee"]={}
    end

    appearance["body"].ima=transform:Find("body/body"):GetComponent("Image")
    appearance["backHat"].ima=transform:Find("backHat/backHat"):GetComponent("Image")
    appearance["head"].ima=transform:Find("head/head"):GetComponent("Image")
    appearance["haircut"].ima=transform:Find("hair/hair"):GetComponent("Image")
    appearance["nose"].ima=transform:Find("nose/nose"):GetComponent("Image")
    appearance["brow"].ima=transform:Find("brow/brow"):GetComponent("Image")
    appearance["frontHat"].ima=transform:Find("frontHat/frontHat"):GetComponent("Image")
    appearance["eyes"].ima=transform:Find("eyes/eyes"):GetComponent("Image")
    appearance["mouth"].ima=transform:Find("mouth/mouth"):GetComponent("Image")

    appearance["decal"].ima=transform:Find("decal/decal")
    appearance["goatee"].ima=transform:Find("goatee/goatee")

    if appearance["decal"].ima then
        appearance["decal"].ima=transform:Find("decal/decal"):GetComponent("Image")
        appearance["goatee"].ima=transform:Find("goatee/goatee"):GetComponent("Image")
    end
end

--初始化
function AvtarCtrl:begin()
    local faceId = DataManager.GetFaceId()

    if faceId then--有ID隐藏男女
        local arr = split(faceId,"-")
        if arr[1] == "1" then
            self:switchKinds(AvtarConfig.man[1].kinds)
        else
            self:switchKinds(AvtarConfig.woMan[1].kinds)
        end
        GetAvtar(faceId)
        panel.maleBtn.gameObject:SetActive(false)
        panel.feMaleBtn.gameObject:SetActive(false)

    else--无ID
        sex=1
        self:randomChange()
        self:switchKinds(AvtarConfig.man[1].kinds)
    end
    --加载五官
    InsAndObjectPool(AvtarConfig.man,FiveFaceItem,fiveItemPath,panel.fiveContent,self)

end

function AvtarCtrl:switchKinds(config)
    InsAndObjectPool(config,KindsItem,kindItemPath,panel.kindsContent,self)
end

local num
function AvtarCtrl:randomChange()
    local config
    if sex==1 then
        config=AvtarConfig.man
    else
        config=AvtarConfig.woMan
    end


    for i, qiGuan in ipairs(config) do
        num =math.random(1,#qiGuan.kinds)
        self:changAparance(config[i].kinds[num])
    end

end

--改变人物某个部件选择
function AvtarCtrl:changAparance(data)
    local arr,path,type,nums
    arr=split(data.path,",")
    path=arr[1]
    type=arr[2]

    nums=data.id or num
    --特殊处理头和帽子
    if type=="head" then
        local config
        if sex==1 then
            config=HeadConfig.man
        else
            config=HeadConfig.woMan
        end

        --已有的隐藏
        if currHead then
            --[[
            for i, config in ipairs(HeadSizeType) do
                local trans=currHead.transform:Find(config.type)
                if trans then
                    local ima= trans:GetComponent("Image")
                    LoadSprite("Assets/CityGame/Resources/Atlas/Avtar/10x10-white.png",ima)
                end
            end
            --]]
            currHead:SetActive(false)
        end
        --避免重复生成
        if headPrefab[sex][nums] then
            headPrefab[sex][nums]:SetActive(true)
        else--
            headPrefab[sex][nums] = creatGoods( config[nums].path,panel.showContent )
        end

        currHead = headPrefab[sex][nums]
        FindOrgan(headPrefab[sex][nums].transform)

        --加载原来服饰
        for key, value in pairs(appearance) do
            if key ~= "head" and pastApperanceID[key] then
                if pastApperanceID[key].path=="" then--部件不要的处理
                    if appearance[key].ima and appearance[key].ima.transform then
                        appearance[key].ima.transform.gameObject:SetActive(false)
                    end
                else--部件要的处理
                    if appearance[key].ima and appearance[key].ima.transform then
                        appearance[key].ima.transform.gameObject:SetActive(true)
                        LoadSprite(pastApperanceID[key].path,appearance[key].ima)
                    end
                end

                 if key=="frontHat" then
                    if pastApperanceID["backHat"].path=="" then--部件不要的处理
                        appearance["backHat"].ima.transform.gameObject:SetActive(false)
                    else--部件不要的处理
                        appearance["backHat"].ima.transform.gameObject:SetActive(true)
                        LoadSprite(pastApperanceID["backHat"].path,appearance["backHat"].ima)
                    end
                end
            end
        end
        currHead = headPrefab[sex][nums]


    elseif type=="frontHat" then
        if arr[3]=="" then
            appearance[arr[4]].ima.transform.gameObject:SetActive(false)
        else
            appearance[arr[4]].ima.transform.gameObject:SetActive(true)
            LoadSprite(arr[3],appearance[arr[4]].ima)
        end
        pastApperanceID["backHat"]={}
        pastApperanceID["backHat"].path=arr[3]
    end

    appearance[type].typeId=nums
    appearance[type].type=type

    if not pastApperanceID[type] then
        pastApperanceID[type]={}
    end

    pastApperanceID[type].path=path

    if path=="" then
        appearance[type].ima.transform.gameObject:SetActive(false)
    else
        appearance[type].ima.transform.gameObject:SetActive(true)
        LoadSprite(path,appearance[type].ima)
    end
end


function GetAvtar(faceId)
    local arr=split(faceId,"-")
    if arr[1]=="1" then--男人
        sex=1
        --todo：加载小人头像
        headPrefab[sex][1]=creatGoods(HeadConfig.man[1].path,panel.showContent)
        currHead=headPrefab[sex][1]
        FindOrgan(headPrefab[sex][1].transform)
        local temp=split(arr[2],",")
        for i = 1, #temp ,2 do
            if temp[i]~="" then
                local type=tonumber(temp[i])
                local typeId=tonumber(temp[i+1])
                local kind=AvtarConfig.man[type].kinds[typeId]
                num=type
                this:changAparance(kind)
            end
        end

    else--女人
        sex=2
        --todo：加载小人头像
        local temp=split(arr[2],",")
        for i = 1, #temp ,2 do
            local kind=AvtarConfig.woMan[temp[i]].kinds[temp[i+1]].path
            this:changAparance(kind)
        end

    end

    return currHead
end

---==========================================================================================点击函数===================================================================================================
--返回
function AvtarCtrl:c_OnClick_backBtn(ins)
    ins:Hide()
    --for key, pastApperance in pairs(pastApperanceID) do
    --    UnLoadSprite(pastApperance.path)
    --end

end

--确定
function AvtarCtrl:c_OnClick_confirm()
    local faceId,type,typeId=""
    for key, value in pairs(appearance) do
        if value.typeId then
            type=tostring(FiveType[key])
            typeId=tostring(value.typeId)
            faceId=faceId..type..","..typeId..","
        end
    end
    faceId=tostring(sex).."-"..faceId
    local temp={}
    temp.faceId=faceId

    for key, pastApperance in pairs(pastApperanceID) do
        UnLoadSprite(pastApperance.path)
    end

    if DataManager.GetFaceId() then
        Event.Brocast("m_setRoleFaceId",faceId)
    else
        if sex==1 then
            temp.gender=true
            ct.OpenCtrl("CreateRoleCtrl",temp)
        else
            temp.gender=false
            ct.OpenCtrl("CreateRoleCtrl",temp)
        end
    end

end

--随机
function AvtarCtrl:c_OnClick_randomChange(ins)
    ins:randomChange()
    --   AvatarManger.setSize(currHead,0.2)
end

--男性
function AvtarCtrl:c_OnClick_male(ins)
    panel.feMaleSelect.localScale=Vector3.zero
    panel.maleSelect.localScale=Vector3.one
    InsAndObjectPool(AvtarConfig.man,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
    sex=1
    ins:randomChange()
    ins:switchKinds(AvtarConfig.man[1].kinds)
end

--女性
function AvtarCtrl:c_OnClick_faMale(ins)
    panel.feMaleSelect.localScale=Vector3.one
    panel.maleSelect.localScale=Vector3.zero
    InsAndObjectPool(AvtarConfig.woMan,FiveFaceItem,fiveItemPath,panel.fiveContent,self)
    sex=2
    ins:randomChange()
    ins:switchKinds(AvtarConfig.woMan[1].kinds)
end
