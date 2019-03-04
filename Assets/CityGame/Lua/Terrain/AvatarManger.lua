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

AvatarManger={}

local  appearance,unitPool={},{}
local headPool,record={},{}

local num,sex,currHead,headTypeId

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

end

 function AvatarManger.setSize(go,size)
     local V,H=UnityEngine.RectTransform.Axis.Vertical,UnityEngine.RectTransform.Axis.Horizontal

     local rect,imaRect= go.transform:GetComponent("RectTransform")

     rect:SetSizeWithCurrentAnchors(V,(rect.sizeDelta.x)*size)
     rect:SetSizeWithCurrentAnchors(H,(rect.sizeDelta.y)*size)

     --归位
     go.transform.localScale = Vector3.one
     go.transform.localPosition=Vector3.zero

     for i, sizeData in ipairs(HeadSizeType) do

        local trans=go.transform:Find(sizeData.type)
        if trans then
            imaRect=trans:GetComponent("Image").rectTransform
            imaRect:SetSizeWithCurrentAnchors(H,(imaRect.sizeDelta.x)*size)
            imaRect:SetSizeWithCurrentAnchors(V,(imaRect.sizeDelta.y)*size)

            imaRect.anchoredPosition=Vector2.New(((imaRect.anchoredPosition.x)*size),((imaRect.anchoredPosition.y)*size))
        end

    end
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
    arr=split(kind.path,",")
    path=arr[1]
    type=arr[2]

    nums=num
    --特殊处理头和帽子
    if type=="head" then
        local config
        if sex==1 then
            config=HeadConfig.man
        else
            config=HeadConfig.woMan
        end
        headTypeId=nums

        currHead=headPool[sex][headTypeId]:GetAvailableGameObject()

        FindOrgan(currHead.transform)

        --加载原来服饰
        for key, value in pairs(appearance) do
            if key ~= "head"  then

                if appearance[key].path=="" then--部件不要的处理
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

    appearance[type].typeId=nums
    appearance[type].type=type
    appearance[type].path=path


    if path=="" then
        appearance[type].ima.transform.gameObject:SetActive(false)
    else
        appearance[type].ima.transform.gameObject:SetActive(true)
        LoadSprite(path,appearance[type].ima)
    end

end

local function GetAvatar(faceId,isSmall)
    local arr,config=split(faceId,"-")

    sex=tonumber(arr[1])
    --加载小人头像
    currHead =headPool[sex][1]:GetAvailableGameObject()
    FindOrgan(currHead.transform)
    --配置表
    if isSmall then
        if sex==1 then
            config=SmallAvtarConfig.man
        else
            config=SmallAvtarConfig.woMan
        end
    else
        if sex==1 then
            config=AvtarConfig.man
        else
            config=AvtarConfig.woMan
        end
    end

    --换装
    local temp=split(arr[2],",")
    for i = 1, #temp ,2 do
        if temp[i]~="" then
            local type=tonumber(temp[i])
            local typeId=tonumber(temp[i+1])
            if config[type] then
                local kind=config[type].kinds[typeId]
                num=type
                changAparance(kind)
            end
        end
    end

    --便于回收
    local temp ={}
    temp.sex=sex
    temp.headTypeId=headTypeId
    temp.go=currHead

    table.insert(record,temp)

    return temp
end


function AvatarManger.GetSmallAvatar(faceId,parent,size)

   local AvatarData=GetAvatar(faceId,true)

    AvatarData.go.transform:SetParent(parent);
    AvatarManger.setSize(AvatarData.go,size)
end

function AvatarManger.GetBigAvatar(faceId,parent,size)

    local AvatarData=GetAvatar(faceId,false)

    AvatarData.go.transform:SetParent(parent);
    AvatarManger.setSize(AvatarData.go,size)
end


function AvatarManger.CollectAvatar()
    if #record>0 then
        for i, AvatarData in ipairs(record) do
            for i, config in ipairs(HeadSizeType) do
                 local trans=AvatarData.go.transform:Find(config.type)
                if trans then
                   local ima= trans:GetComponent("Image")
                    LoadSprite("Assets/CityGame/Resources/Atlas/Avtar/10x10-white.png",ima)
                end
            end
            headPool[AvatarData.sex][AvatarData.headTypeId]:RecyclingGameObjectToPool(AvatarData.go)
        end
    end
end

