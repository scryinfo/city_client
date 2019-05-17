---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2019/2/27/027 18:03
---

HeadSizeType={
        [0]={width=70,heigth=70},
        [1]={ type="body/body",width=70,heigth=70},
        [2]={ type="backHat/backHat",width=70,heigth=70},
        [3]={ type="head/head",width=70,heigth=70},
        [4]={ type="decal/decal",width=70,heigth=70},
        [5]={ type="brow/brow",width=70,heigth=70},
        [6]={ type="hair/hair",width=70,heigth=70},
        [7]={ type="eyes/eyes",width=70,heigth=70},
        [8]={ type="nose/nose",width=70,heigth=70},
        [9]={ type="frontHat/frontHat",width=70,heigth=70},
        [10]={ type="mouth/mouth",width=70,heigth=70},
        [11]={ type="goatee/goatee",width=70,heigth=70},
}

AvatarManger ={}


local  appearance,unitPool,headPool,record,recordPath={},{},{},{},{}

local num,sex,currHead,headTypeId
local NilImage = nil
function  AvatarManger.Awake()
    headPool={}
    headPool[1],headPool[2]={},{}
    unitPool[1],unitPool[2]={},{}
    for i = 1, 6 do
        headPool[1][i]= LuaGameObjectPool:new("Avatar"..i,creatGoods(HeadConfig.man[i].path),0,Vector3.New(0,0,0) )
    end
    for i = 1, 8 do
        headPool[2][i]= LuaGameObjectPool:new("Avatar"..(i+10),creatGoods(HeadConfig.woMan[i].path),0,Vector3.New(0,0,0) )
    end

    --初始化空白图片
    local SpriteType = ct.getType(UnityEngine.Sprite)
    panelMgr:LoadPrefab_A("Assets/CityGame/Resources/Atlas/Avtar/10x10-white.png", SpriteType, nil, function(Icon, obj ,ab)
        if Icon == nil then
            return
        end
        if obj ~= nil  then
            NilImage = ct.InstantiatePrefab(obj)
        end
    end)
end

local UnityEngine_Vertical
local UnityEngine_Horizontal
 function AvatarManger.setSize(go,size)
     if UnityEngine_Vertical == nil then
         UnityEngine_Vertical = UnityEngine.RectTransform.Axis.Vertical
     end
     if UnityEngine_Horizontal == nil then
         UnityEngine_Horizontal = UnityEngine.RectTransform.Axis.Horizontal
     end
     local rect,imaRect,pImaRect= go.transform:GetComponent("RectTransform")

     rect:SetSizeWithCurrentAnchors(UnityEngine_Vertical,(rect.sizeDelta.x) * size)
     rect:SetSizeWithCurrentAnchors(UnityEngine_Horizontal,(rect.sizeDelta.y) * size)

     ----归位
     for i, sizeData in ipairs(HeadSizeType) do
         local trans=go.transform:Find(sizeData.type)
         if trans then
             imaRect=trans:GetComponent("Image").rectTransform
             imaRect:SetSizeWithCurrentAnchors(UnityEngine_Horizontal,(imaRect.sizeDelta.x)*size)
             imaRect:SetSizeWithCurrentAnchors(UnityEngine_Vertical,(imaRect.sizeDelta.y)*size)

             imaRect.anchoredPosition=Vector2.New(((imaRect.anchoredPosition.x)*size),((imaRect.anchoredPosition.y)*size))

             pImaRect=imaRect.parent:GetComponent("RectTransform")
             pImaRect:SetSizeWithCurrentAnchors(UnityEngine_Horizontal,(pImaRect.sizeDelta.x)*size)
             pImaRect:SetSizeWithCurrentAnchors(UnityEngine_Vertical,(pImaRect.sizeDelta.y)*size)

             pImaRect.anchoredPosition=Vector2.New(((pImaRect.anchoredPosition.x)*size),((pImaRect.anchoredPosition.y)*size))
         end

     end
     --归位
     go.transform.localScale = Vector3.one
     go.transform.localPosition=Vector3.zero
     return go
 end


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

local function changAparance(kind)
    local arr,path,type,nums
    arr = split(kind.path,",")
    path = arr[1]
    type = arr[2]

    nums=num
    --特殊处理头和帽子
    if type == "head" then
        local config
        if sex==1 then
            config = HeadConfig.man
        else
            config = HeadConfig.woMan
        end
        if currHead then
            headPool[sex][headTypeId]:RecyclingGameObjectToPool(currHead)
        end
        headTypeId = nums
        currHead = headPool[sex][headTypeId]:GetAvailableGameObject()

        FindOrgan(currHead.transform)

        --加载原来服饰
        for key, value in pairs(appearance) do
            if key ~= "head"  then

                if appearance[key].path == "" then--部件不要的处理
                    if appearance[key].ima and appearance[key].ima.transform then
                        appearance[key].ima.transform.gameObject:SetActive(false)
                    end
                else--部件要的处理
                    if appearance[key].ima and appearance[key].ima.transform and appearance[key].path then
                        appearance[key].ima.transform.gameObject:SetActive(true)
                        LoadSprite(appearance[key].path,appearance[key].ima)
                    end
                end
                if key=="frontHat" then
                    if appearance["backHat"].path=="" then--部件不要的处理
                        appearance["backHat"].ima.transform.gameObject:SetActive(false)
                    else--部件不要的处理
                        appearance["backHat"].ima.transform.gameObject:SetActive(true)
                        LoadSprite(appearance["backHat"].path,appearance["backHat"].ima)
                    end
                end
            end
        end

    elseif type=="frontHat" then
        if arr[3]=="" then
            appearance[arr[4]].ima.transform.gameObject:SetActive(false)
        else
            appearance[arr[4]].ima.transform.gameObject:SetActive(true)
            LoadSprite(arr[3],appearance[arr[4]].ima)
        end
        appearance["backHat"]={}
        appearance["backHat"].path=arr[3]
    end

    appearance[type].typeId = nums
    appearance[type].type = type
    appearance[type].path = path

    table.insert(recordPath,path)

    if path=="" then
        appearance[type].ima.transform.gameObject:SetActive(false)
    else
        appearance[type].ima.transform.gameObject:SetActive(true)
        LoadSprite(path,appearance[type].ima)
    end

end

--获取Avatar的gameObject
local function GetAvatar(faceId,isSmall)
    local arr,config = split(faceId,"-")

    sex = tonumber(arr[1])
    --加载小人头像*
    currHead = headPool[sex][1]:GetAvailableGameObject()
    headTypeId = 1
    FindOrgan(currHead.transform)
    --配置表
    if isSmall then
        if sex == 1 then
            config = SmallAvtarConfig.man
        else
            config = SmallAvtarConfig.woMan
        end
    else
        if sex == 1 then
            config = AvtarConfig.man
        else
            config = AvtarConfig.woMan
        end
    end

    --换装
    local temp = split(arr[2],",")
    for i = 1, #temp ,2 do
        if temp[i]~="" then
            local type = tonumber(temp[i])
            local typeId = tonumber(temp[i+1])
            if config[type] then
                local kind = config[type].kinds[typeId]
                num = type
                changAparance(kind)
            end
        end
    end

    --便于回收对象池
    local temp = {}
    temp.sex = sex
    temp.headTypeId = headTypeId
    temp.go = currHead
    --便于回收内存
    table.insert(record,temp)

    return temp
end

--获取小资源的avatar
function AvatarManger.GetSmallAvatar(faceId , parent , size)
    local AvatarData = GetAvatar(faceId,true)
    AvatarData.size = 1 / size
    AvatarData.go.transform:SetParent(parent);
    AvatarManger.setSize(AvatarData.go,size)
    return AvatarData
end

--获取大资源的avatar
function AvatarManger.GetBigAvatar(faceId,parent,size)
    local AvatarData = GetAvatar(faceId,false)
    AvatarData.size = 1 / size
    AvatarData.go.transform:SetParent(parent);
    AvatarManger.setSize(AvatarData.go,size)
    return AvatarData
end

--回收指定avatar
local trans_CollectAvatar
function AvatarManger.CollectAvatar(AvatarData)
    if  AvatarData then
            for i, config in ipairs(HeadSizeType) do
                trans_CollectAvatar = AvatarData.go.transform:Find(config.type)
                if trans_CollectAvatar then
                    if NilImage ~= nil  then
                        trans_CollectAvatar:GetComponent("Image").sprite = NilImage
                    end
                end
            end
            AvatarManger.setSize(AvatarData.go,AvatarData.size)
            AvatarData.go.transform.localScale = Vector3.zero

            headPool[AvatarData.sex][AvatarData.headTypeId]:RecyclingGameObjectToPool(AvatarData.go)
    end

end


local trans_CollectAllAvatar
function AvatarManger.CollectAllAvatar()
    if #record>0 then
        for i, AvatarData in ipairs(record) do
            for i, config in ipairs(HeadSizeType) do
                trans_CollectAllAvatar = AvatarData.go.transform:Find(config.type)
                if trans_CollectAllAvatar then
                    if NilImage ~= nil  then
                        trans_CollectAllAvatar:GetComponent("Image").sprite = NilImage
                    end
                end
            end
            headPool[AvatarData.sex][AvatarData.headTypeId]:RecyclingGameObjectToPool(AvatarData.go)
        end
    end
    if #recordPath>0 then
        for i, path in pairs(recordPath) do
            UnLoadSprite(path)
        end
        recordPath = {}
    end
end
