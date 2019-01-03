---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/30 17:06
---表格排序
TableSort = class('TableSort')
function tableSort(table,gameObject)
    local width = gameObject.transform:GetComponent("RectTransform").sizeDelta.x;
    local height = gameObject.transform:GetComponent("RectTransform").sizeDelta.y;
    local cellWidth = {}
    local instances = {}
    local low
    local spaceWidth
    local parfab = {}
    for i, v in ipairs(table) do
        low = #table
        spaceWidth = v.space
        cellWidth[i] = v.width
        local parfabs = TableSort:_createCityInfoPab(v.path,gameObject.transform)
        instances[i] = parfabs
       -- gameObject:_initData(cellWidth,v.space,instances)
        parfabs:GetComponent("Image").color =getColorByInt(v.color.r,v.color.b,v.color.g,v.color.a)
        if parfabs.childCount >0 then
            if   parfabs.transform:Find("Text") ~=nil then
                parfabs.transform:Find("Text"):GetComponent("Text").text = v.data
                parfabs.transform:Find("Text"):GetComponent("Text").fontSize = v.size
            end
            if parfabs.transform:Find("Text/Images") ~=nil then
                if v.itemPath == nil then
                    return
                end
                local sprite =gameObject:ResourcesImage(v.itemPath)
                parfabs.transform:Find("Text/Images"):GetComponent("Image").overrideSprite =sprite
                parfabs.transform:Find("Text/Images"):GetComponent("Image").color =getColorByInt(v.itemColor.r,v.itemColor.b,v.itemColor.g,v.itemColor.a)
            end
        end
        parfab[i] = parfabs
    end
    TableSort:Stro(instances,low,cellWidth,spaceWidth,width,height)
    return parfab
end

--修改表数据
function TableSort:UpdataTable(table,gameObject,prefabs)
    local width = gameObject.transform:GetComponent("RectTransform").sizeDelta.x;
    local height = gameObject.transform:GetComponent("RectTransform").sizeDelta.y;
    local cellWidth = {}
    local instances = {}
    instances = prefabs
    local low
    local spaceWidth
    for i, v in ipairs(table) do
        low = #table
        spaceWidth = v.space
        cellWidth[i] = v.width

        prefabs[i]:GetComponent("Image").color =getColorByInt(v.color.r,v.color.b,v.color.g,v.color.a)
        if prefabs[i].childCount >0 then
            if   prefabs[i].transform:Find("Text") ~=nil then
                prefabs[i].transform:Find("Text"):GetComponent("Text").text = v.data
                prefabs[i].transform:Find("Text"):GetComponent("Text").fontSize = v.size
            end
            if prefabs[i].transform:Find("Text/ImageImages") ~=nil then
                if v.itemPath == nil then
                    return
                end
                local sprite =gameObject:ResourcesImage(v.itemPath)
                prefabs[i].transform:Find("Text/ImageImages"):GetComponent("Image").overrideSprite =sprite
                prefabs[i].transform:Find("Text/ImageImages"):GetComponent("Image").color =getColorByInt(v.itemColor.r,v.itemColor.b,v.itemColor.g,v.itemColor.a)
            end
        end
    end
    TableSort:Stro(instances,low,cellWidth,spaceWidth,width,height)
end
--生成预制
function TableSort:_createCityInfoPab(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent.transform);
    rect.transform.localScale = Vector3.one;
    return rect
end
--排序
function TableSort:Stro(childObj,row,cellWidth,spaceWidth,width,height)
    local lenght = 0;
    local count = 0;
    if childObj == nil then
        return
    end
    for i = 1, row do
        if cellWidth[i] ~= 0 then
            lenght = lenght + cellWidth[i];
            count = count + 1;
        end
    end
    local x = 0;
    local y = 0;
    for i = 1, row do
        if cellWidth[i] == 0 then
            cellWidth[i] = (width - lenght - spaceWidth * row) / (row - count)
        end
        if i == 1 then
            x = 0
        else
            x = x + cellWidth[i - 1]
        end
        childObj[i].transform:GetComponent("RectTransform").sizeDelta = Vector2.New(cellWidth[i], height);
        childObj[i].transform.localPosition = Vector3.New(x + spaceWidth * i, y, 0);
    end
end