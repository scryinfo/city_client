functions = {}
--Find objects--
local _typeof = tolua.typeof

function find(str)
    return GameObject.Find(str);
end

function destroy(obj)
    GameObject.Destroy(obj);
end

function destroyImmediate(obj)
    GameObject.DestroyImmediate(obj);
end

function newObject(prefab)
    return GameObject.Instantiate(prefab);
end

--Create Panel--
function LoadPrefab_A(name, type, instance, callback)
    PanelManager:LoadPrefab_A(name, type, instance, callback);
end
--Create window--
function createWindows(name, pos)
    PanelManager:CreateWindow(name, pos);
end
function ResourcesImage(path)
    PanelManager:ResourcesImage(path)
end
function child(str)
    return transform:Find(str);
end

function subGet(childNode, typeName)
    return child(childNode):GetComponent(typeName);
end

function findPanel(str)
    local obj = find(str);
    if obj == nil then
        error(str .. " is null");
        return nil;
    end
    return obj:GetComponent("BaseLua");
end

--Get the price display text - the integer and decimal parts are different in size
function getPriceString(str, intSize, floatSize)
    local index = string.find(str, '%.')
    if not index then
        return str
    end

    local intString = string.sub(str, 1, index)
    local floatString = string.sub(str, index + 1)
    local finalStr = string.format("<size=%d>%s</size><size=%d>%s</size>", intSize, intString, floatSize, floatString)

    return finalStr
end

--Get numeric display text, different colors
function getColorString(numTab)
    local leng = 0
    for i, v in pairs(numTab) do
        leng = leng + 1
    end
    local str = nil
    if leng == 4 then
        local str1 = table.concat({ "<color=", numTab["col1"], ">", numTab["num1"], "</color>" })
        local str2 = table.concat({ "<color=", numTab["col2"], ">", numTab["num2"], "</color>" })
        str = table.concat({ str1, "/", str2 })
    else
        local str1 = table.concat({ "<color=", numTab["col1"], ">", numTab["num1"], "</color>" })
        local str2 = table.concat({ "<color=", numTab["col2"], ">", numTab["num2"], "</color>" })
        local str3 = table.concat({ "<color=", numTab["col3"], ">", numTab["num3"], "</color>" })
        str = table.concat({ str1, "/", str2, "/", str3 })
    end
    return str
end

--Convert seconds to time format string
function getTimeTable(time)
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time % 3600) / 60)
    local seconds = math.floor(time % 60)
    if hours < 10 then
        hours = "0" .. hours
    end
    if minutes < 10 then
        minutes = "0" .. minutes
    end
    if seconds < 10 then
        seconds = "0" .. seconds
    end
    local data = { hour = hours, minute = minutes, second = seconds }
    return data
end
--Get the corresponding color through the integer 255
function getColorByInt(r, b, g, a)
    local r1 = r / 255
    local b1 = b / 255
    local g1 = g / 255
    local a1 = 1
    if a ~= nil then
        a1 = a / 255
    end

    return Color.New(r1, b1, g1, a1)
end

function getColorByVector3(vector3, alpha)
    local r1 = vector3.x / 255
    local b1 = vector3.y / 255
    local g1 = vector3.z / 255
    local a1 = 1
    if alpha ~= nil then
        a1 = alpha / 255
    end

    return Color.New(r1, b1, g1, a1)
end

--Convert time seconds to xx hours xx minutes xx seconds format
function getFormatUnixTime(time)
    local tb = {}
    time = math.floor(time)
    tb.year = tonumber(os.date("%Y", time)) or 0
    tb.month = tonumber(os.date("%m", time)) or 0
    tb.day = tonumber(os.date("%d", time)) or 0
    tb.hour = tonumber(os.date("%H", time)) or 0
    tb.minute = tonumber(os.date("%M", time)) or 0
    tb.second = tonumber(os.date("%S", time)) or 0

    if tb.year < 10 then
        tb.year = "0" .. tb.year
    end
    if tb.month < 10 then
        tb.month = "0" .. tb.month
    end
    if tb.day < 10 then
        tb.day = "0" .. tb.day
    end
    if tb.hour < 10 then
        tb.hour = "0" .. tb.hour
    end
    if tb.minute < 10 then
        tb.minute = "0" .. tb.minute
    end
    if tb.second < 10 then
        tb.second = "0" .. tb.second
    end

    return tb
end
--Convert time seconds to xx hours xx minutes xx seconds format
function getFormatUnixTimeNumber(time)
    local tb = {}
    time = math.floor(time)
    tb.year = tonumber(os.date("%Y", time)) or 0
    tb.month = tonumber(os.date("%m", time)) or 0
    tb.day = tonumber(os.date("%d", time)) or 0
    tb.hour = tonumber(os.date("%H", time)) or 0
    tb.min = tonumber(os.date("%M", time)) or 0
    tb.sec = tonumber(os.date("%S", time)) or 0
    return tb
end
--Convert time format string to timestamp - must be yyyy-mm-dd hh:mm:ss format
function getTimeUnixByFormat(timeString)
    if type(timeString) ~= 'string' then
        error('string2time: timeString is not a string')
        return 0
    end
    local fun = string.gmatch(timeString, "%d+")
    local y = fun() or 0
    if y == 0 then
        error('timeString is a invalid time string')
        return 0
    end
    local m = fun() or 0
    if m == 0 then
        error('timeString is a invalid time string')
        return 0
    end
    local d = fun() or 0
    if d == 0 then
        error('timeString is a invalid time string')
        return 0
    end
    local H = fun() or 0
    if H == 0 then
        error('timeString is a invalid time string')
        return 0
    end
    local M = fun() or 0
    if M == 0 then
        error('timeString is a invalid time string')
        return 0
    end
    local S = fun() or 0
    if S == 0 then
        error('timeString is a invalid time string')
        return 0
    end
    return os.time({ year = y, month = m, day = d, hour = H, min = M, sec = S })
end
--Get the corresponding weekly display through index
function getWeekStrByIndex(value)
    local str
    if value == 1 then
        str = GetLanguage(12345678)
    elseif value == 2 then
        str = GetLanguage(12345678)
    elseif value == 3 then
        str = GetLanguage(12345678)
    elseif value == 4 then
        str = GetLanguage(12345678)
    elseif value == 5 then
        str = GetLanguage(12345678)
    elseif value == 6 then
        str = GetLanguage(12345678)
    elseif value == 7 then
        str = GetLanguage(12345678)
    end
    return str
end
--
function convertTimeForm(second)
    local data = {}
    data.day = math.floor(second / 86400)
    data.hour = math.fmod(math.floor(second / 3600), 24)
    data.min = math.fmod(math.floor(second / 60), 60)
    data.sec = math.fmod(second, 60)
    return data
end

--Convert seconds to hours, minutes and seconds format, non-timestamp
function getTimeBySec(secTime)
    local tb = {}
    secTime = math.floor(secTime)
    tb.hour = math.floor(secTime / 3600) or 0
    tb.minute = math.floor((secTime - tb.hour * 3600) / 60) or 0
    tb.second = math.floor(secTime - tb.hour * 3600 - tb.minute * 60) or 0

    if tb.hour < 10 then
        tb.hour = "0" .. tb.hour
    end
    if tb.minute < 10 then
        tb.minute = "0" .. tb.minute
    end
    if tb.second < 10 then
        tb.second = "0" .. tb.second
    end

    return tb
end
--Obtain a dictionary with itemId as the key according to the building store
function getItemStore(store)
    local itemTable = {}
    local storeTemp = ct.deepCopy(store)
    if storeTemp.locked then
        for i, itemData in pairs(storeTemp.locked) do
            itemTable[itemData.key.id] = itemData.n
        end
    end
    if storeTemp.inHand then
        for i, itemData in pairs(storeTemp.inHand) do
            local tempCount = itemTable[itemData.key.id]
            if tempCount then
                itemTable[itemData.key.id] = itemData.n - tempCount
            else
                itemTable[itemData.key.id] = itemData.n
            end
        end
    end
    return itemTable
end

function ct.file_exists(path)
    local file = io.open(path, "rb")
    if file then
        file:close()
    end
    return file ~= nil
end

function ct.file_saveTable(filename, data)
    local file
    if filename == nil then
        file = io.stdout
    else
        local err
        file, err = io.open(filename, "wb")
        if file == nil then
            error(("Unable to write '%s': %s"):format(filename, err))
        end
    end
    for i = 1, #data do
        file:write(data[i] .. '\n')
    end
    if filename ~= nil then
        file:close()
    end
end

function ct.file_saveString(filename, str)
    local file
    if filename == nil then
        file = io.stdout
    else
        local err
        file, err = io.open(filename, "wb")
        if file == nil then
            error(("Unable to write '%s': %s"):format(filename, err))
        end
    end
    file:write(str)
    if filename ~= nil then
        file:close()
    end
end

function ct.file_readString(filename)
    local file = assert(io.open(filename, "rb"))
    local str = file:read("*all")
    file:close()
    return str
end

function ct.OpenCtrl(inClassName, data)
    -- Unify the method of opening the controller in a unified way. Note that the parameter is the name of the class. Use message mechanism to avoid coupling of caller and specific Controller
    Event.Brocast('c_OnOpen' .. inClassName, data)
end

function ct.MsgBox(titleInfo, contentInfo, tipInfo, okCallBack, closeCallBack)
    local info = {}
    info.titleInfo = titleInfo
    --Replace with multiple languages
    info.contentInfo = contentInfo
    info.tipInfo = tipInfo
    info.btnCallBack = okCallBack
    info.closeCallBack = closeCallBack
    if info.titleInfo == nil then
        info.titleInfo = "提示"
        ct.OpenCtrl("BtnDialogPageCtrl", info)
    else
        ct.OpenCtrl("ErrorBtnDialogPageCtrl", info)
    end
end

ct.MemoryProfilePath = ""

function ct.getMemoryProfile()
    return ct.MemoryProfilePath
end

function ct.mkMemoryProfile()
    local file_exists = ct.file_exists
    if UnityEngine.Application.isEditor == false then
        ct.MemoryProfilePath = UnityEngine.Application.persistentDataPath .. "/CityGame/MemoryProfile"
        ct.log("system", "ProFi:writeReport path = ", ct.MemoryProfilePath)
        if file_exists(ct.MemoryProfilePath) == false then
            ct.log("system", "[ProFi:writeReport] path not exist ")
            os.execute("mkdir -p \"" .. ct.MemoryProfilePath .. "\"")
        end
    else
        ct.MemoryProfilePath = "MemoryProfile"
        os.execute("mkdir " .. ct.MemoryProfilePath)
    end
end

local function deepCopy(orig)
    local copy
    local orig_type = type(orig)
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            if orig[orig_key] == orig then
                copy[orig_key] = copy
            elseif orig_key == 'super' then
                orig.super.subclasses[orig] = nil
                copy[deepCopy(orig_key)] = deepCopy(orig_value)
                copy.subclassed = function(self, other)
                end
                copy.super.subclass(copy, orig.name)
                orig.super.subclass(orig, orig.name)
            else
                copy[deepCopy(orig_key)] = deepCopy(orig_value)
            end
        end
        setmetatable(copy, deepCopy(getmetatable(orig)))
    else
        -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

ct.deepCopy = deepCopy

--Rounding function
function ct.getIntPart(x)
    local resault = math.ceil(x)
    if x <= 0 then
        return resault
    end

    if resault == x then
        x = resault
    else
        x = resault - 1;
    end
    return x;
end

function ct.getType(obj)
    return _typeof(obj)
end
--Instantiate the UI prefab
function ct.InstantiatePrefab(prefab)
    local go = UnityEngine.GameObject.Instantiate(prefab);
    go.name = prefab.name;
    if _typeof(prefab) == _typeof(UnityEngine.GameObject) then
        local rect = go.transform:GetComponent("RectTransform");
        rect.sizeDelta = prefab:GetComponent("RectTransform").sizeDelta;
    end
    return go
end

function ct.DestroyTable(tb)
    for i, v in pairs(tb) do
        GameObject.DestroyImmediate(v, true)
    end
    tb = {}
end

--Get the price display text - the integer and decimal parts are different in size
function getPriceString(str, intSize, floatSize)
    local index = string.find(str, '%.')
    if not index then
        return str
    end

    local intString = string.sub(str, 1, index)
    local floatString = string.sub(str, index + 1)
    local finalStr = string.format("<size=%d>%s</size><size=%d>%s</size>", intSize, intString, floatSize, floatString)

    return finalStr
end
function getMoneyString(str)
    local b
    local index = string.find(str, '%.')
    if not index then
        index = #tostring(str)
    else
        index = index - 1
    end
    local intString = string.sub(str, 1, index)
    local floatString = string.sub(str, index + 1)
    local n = math.floor(index / 3)
    local a = index % 3
    local temp
    b = string.sub(intString,1,a)
    for i = 1, n do
        temp = string.sub(intString,(a + 1) + 3*(i-1),(a + 3) + 3*(i-1))
        b = b .. "," .. temp
    end
    if a == 0 then
        b = string.sub(b,2)
    end
    return b..floatString
end

--Retain the number of digits after the decimal point
function radixPointNum(str,long)
    if (string.find(str, '%.') == nil) then
        return
    end
    local num = 0
    local index = string.find(str, '%.')
    local intString = string.sub(str, 1, index)
    local floatString = string.sub(str, index + 1)
    if floatString ~= "" then
        num = #floatString
    end
    local newfloatSrt
    if num <= long then
        newfloatSrt = string.sub(str, index + 1)
    else
        newfloatSrt = string.sub(str, index + 1,index + long)
    end
    return intString .. newfloatSrt
end

--Scientific notation removes the last decimal point
function ct.scientificNotation2Normal(number)
    local num = CityLuaUtil.scientificNotation2Normal(number)
    local index = string.find(num, '%.')
    if index == #num then
       num =  string.gsub(num,"%.","")
    end
    return num
end

currentLanguage={}
currentSprite={}
chinese={}
english={}
korean ={}
japanese ={}

sprite_chi={}
sprite_eng={}
sprite_kor={}
sprite_jap={}


function ReadConfigLanguage()
    chinese = Language_Chinese
    english = Language_English
    korean =Language_Korean
    japanese = Language_Japanese

    sprite_chi = Sprite_Chinese
    sprite_eng = Sprite_English
    sprite_kor = Sprite_Korean
    sprite_jap = Sprite_Japanese

    local num = UnityEngine.PlayerPrefs.GetInt("Language")
    SaveLanguageSettings(num)
end

function SaveLanguageSettings(languageType)
    if languageType == LanguageType.Chinese then
        UnityEngine.PlayerPrefs.SetInt("Language",0)
        currentLanguage=chinese
        currentSprite=sprite_chi
    elseif languageType==LanguageType.English then
        UnityEngine.PlayerPrefs.SetInt("Language",1)
        currentLanguage=english
        currentSprite=sprite_eng
    elseif languageType == LanguageType.Korean then
        UnityEngine.PlayerPrefs.SetInt("Language",2)
        currentLanguage = korean
        currentSprite = sprite_kor
    elseif languageType==LanguageType.Japanese then
        UnityEngine.PlayerPrefs.SetInt("Language",3)
        currentLanguage = japanese
        currentSprite = sprite_jap
    end
end

function SaveBuildingBubbleSettings(bubbleType)
    BuilldingBubbleInsManger.ChangeBuilldingBubbleType(bubbleType)
    UnityEngine.PlayerPrefs.SetInt("BuildingBubble", bubbleType)
end

function GetLanguage(key, ...)
    local temp = { ... }
    for Id, String in pairs(currentLanguage) do
        if Id == key then
            local tempString = String
            for i = 1, #temp do
                tempString = string.gsub(tempString, "{" .. tostring(i - 1) .. "}", temp[i])
            end
            return tempString
        end
    end
    if key ~= nil then
        return key .. "没有设置"  --Development model
    end
    --return GetLanguage(41010014)  --Official display
end

function GetSprite(key)

    local path = currentSprite[key]
    if path then
        return path
    else
        return key .. "没有设置"  --Development model
        --return GetLanguage(41010014)  --Official display
    end
end
--Generate prefab
function creatGoods(path, parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    if parent then
        go.transform:SetParent(parent);--.transform
    end
    rect.transform.localScale = Vector3.one
    rect.transform.localPosition = Vector3.zero
    return go
end

--Generate prefabs (prefabs are placed under child objects)
function createPrefabs(prefab,itemRoot)
    local obj = UnityEngine.GameObject.Instantiate(prefab)
    local objRect = obj.transform:GetComponent("RectTransform")
    obj.transform:SetParent(itemRoot.transform)
    objRect.transform.localScale = Vector3.one
    objRect.transform.localPosition = Vector3.zero
    obj:SetActive(true)
    return obj
end

--Generate prefab (new version)
function createPrefab(path, parent, callback)
    panelMgr:LoadPrefab_A(path, nil, nil, function(ins, obj)
        if obj ~= nil then
            local go = ct.InstantiatePrefab(obj)
            local rect = go.transform:GetComponent("RectTransform")
            if parent then
                go.transform:SetParent(parent.transform);--.transform
            end
            rect.transform.localScale = Vector3.one
            rect.transform.localPosition = Vector3.zero
            callback(go)
        end
    end)
end

function ct.file_saveString(filename, str)
    local file
    if filename == nil then
        file = io.stdout
    else
        local err
        file, err = io.open(filename, "wb")
        if file == nil then
            error(("Unable to write '%s': %s"):format(filename, err))
        end
    end
    file:write(str)
    if filename ~= nil then
        file:close()
    end
end

function ct.file_readString(filename)
    --local file = assert(io.open(filename, "rb"))
    local file, err
    file, err = io.open(filename, "rb")
    if file == nil then
        error(("Unable to write '%s': %s"):format(filename, err))
        return
    end
    local str = file:read("*all")
    file:close()
    return str
end

--String splitting
function split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter == '') then
        return false
    end
    local pos, arr = 0, {}
    -- for each divider found
    for st, sp in function()
        return string.find(input, delimiter, pos, true)
    end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

local AssetObjs = {}
local SpriteType = nil
--The third parameter is whether to set img to the original image size
function LoadSprite(path, iIcon, bSetNativeSize)
    if SpriteType == nil then
        SpriteType = ct.getType(UnityEngine.Sprite)
    end
    panelMgr:LoadPrefab_A(path, SpriteType, iIcon, function(Icon, obj, ab)
        if Icon == nil then
            return
        end
        if obj ~= nil then
            local texture = ct.InstantiatePrefab(obj)
            if Icon then
                Icon.sprite = texture
                if bSetNativeSize == true then
                    Icon:SetNativeSize()
                end
                --This is to show the effect
                Icon.transform.localScale = Vector3.one
            end
            if AssetObjs == nil then
                AssetObjs = {}
            end
            if ab ~= nil then
                AssetObjs[path] = ab
            end
        end
    end)
end

function UnLoadSprite(path)
    local temp = {}
    if AssetObjs ~= nil and AssetObjs[path] ~= nil then
        local v = AssetObjs[path]
        AssetObjs[path] = nil

        --UnityEngine.AssetBundle.Unload(v,true) --This is a forced uninstall without considering the reference, which may cause some images to not display pictures
        --UnityEngine.AssetBundle.Unload(v,false)
        for paths, ab in pairs(temp) do
            if ab ~= v then
                temp[path] = v
            end
        end
    end

    for i, v in pairs(temp) do
        resMgr:UnloadAssetBundle(v, false)
    end

end

function findByName(transform, name)
    local trim = transform:Find(name)
    if trim then
        return trim
    end
    for i = 1, transform.childCount do
        trim = findByName(transform:GetChild(i - 1), name)
        if trim then
            return trim
        end
    end
    return nil
end

--Convert screen coordinates to real coordinates
function ScreenPosTurnActualPos(targetScreenPos)
    local ActualPos = Vector2.New(targetScreenPos.x * Game.ScreenRatio, targetScreenPos.y * Game.ScreenRatio)
    return ActualPos
end
--Transform server data into client data format
function GetClientPriceString(serverPrice)
    if serverPrice == nil or serverPrice == "" or tonumber(serverPrice) < 0 then
        return "0.0000"
    end
    return string.format("%0.4f", tonumber(serverPrice) / 10000)
end

--The data of the client is converted into the data format of the server
function GetServerPriceNumber(clientValue)
    if clientValue == nil or tostring(clientValue) == "" then
        return 0
    end
    local valuableNum = math.floor(tonumber(clientValue) * 10000)
    if valuableNum < 1 then
        valuableNum = 0
    end
    return valuableNum
end

function prints(str)
    ct.log("system", str .. "==================================================")
end

--Dynamically assign values to the Y axis of the graph (according to the maximum value of the incoming data)
function SetYScale(max, count, transform, percentage)
    local scale
    if percentage then
        scale = 1 / count
        if transform ~= nil then
            for i = 1, count do
                transform:GetChild(i - 1):GetComponent("Text").text = math.ceil((scale * i) * 100) .. "%"
            end
        end
    else
        scale = math.ceil(max / (count))
        if transform ~= nil then
            for i = 1, count do
                transform:GetChild(i - 1):GetComponent("Text").text = scale * i
            end
        end
    end
    return scale
end
--
function GetBuildingTypeById(buildingTypeId)
    if buildingTypeId ~= nil then
        local type
        local typeId = tonumber(string.sub(buildingTypeId, 1, 2))
        if typeId == 11 then
            type = BuildingType.MaterialFactory
        elseif typeId == 12 then
            type = BuildingType.ProcessingFactory
        elseif typeId == 13 then
            type = BuildingType.RetailShop
        elseif typeId == 14 then
            type = BuildingType.House
        elseif typeId == 15 then
            type = BuildingType.Laboratory
        elseif typeId == 16 then
            type = BuildingType.Municipal
        elseif typeId == 17 then
            type = BuildingType.TalentCenter
        end
        return type
    end
    return nil
end

-- Dynamic loading prefabrication
function DynamicLoadPrefab(path, parent, scale, fuc)
    panelMgr:LoadPrefab_A(path, nil, nil, function(ins, obj)
        if obj ~= nil then
            local go = ct.InstantiatePrefab(obj)
            local rect = go.transform:GetComponent("RectTransform")
            go.transform:SetParent(parent)

            if scale then
                rect.transform.localScale = scale
            else
                rect.transform.localScale = Vector3.one
            end

            if fuc then
                fuc(go)
            end
        end
    end)
end

function ct.instance_rpc(ins, modelMethord, ...)
    local arg = { ... }
    arg[#arg](ins[modelMethord](ins, ...))
end

-- Get eva display data
-- index Small, medium and large
function GetEvaData(index, configData, lv)
    if not index or not configData or not lv then
        return
    end
    local brandSizeNum
    if index == 1 then
        -- small
        brandSizeNum = 1
    elseif index == 2 then
        -- medium
        brandSizeNum = 1
    elseif index == 3 then
        -- big
        brandSizeNum = 1
    end
    if configData.Btype == "Quality" then
        -- quality
        if configData.Atype < 2100000 then
            -- Building quality bonus
            return string.format((1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum)
        else
            -- Product quality value
            return string.format((1 + EvaUp[lv].add / 100000) * configData.basevalue)
        end
    elseif configData.Btype == "Brand" then  -- Popularity, casually written
        if configData.Atype < 2100000 then
            -- building
            return string.format((1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum)
        else
            -- commodity
            return string.format((1 + EvaUp[lv].add / 100000) * configData.basevalue)
        end
    elseif configData.Btype == "ProduceSpeed" then
        -- Production speed
        local resultNum = tostring(1 / ((1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum))
        if string.find(resultNum, ".") ~= nil then
            resultNum = string.format("%.2f", resultNum)
        end
        return resultNum .. GetLanguage(31010042)
    elseif configData.Btype == "PromotionAbility" then
        -- Promotion ability
        return math.floor((1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum) .. "/h"
    elseif configData.Btype == "InventionUpgrade" then
        -- Invention promotion
        return string.format("%.2f", ((1 + EvaUp[lv].add / 100000) * (configData.basevalue / 100000)) * 100 * brandSizeNum) .. "%"
    elseif configData.Btype == "EvaUpgrade" then
        -- Eva tips
        return string.format("%.2f", ((1 + EvaUp[lv].add / 100000) * (configData.basevalue / 100000)) * 100 * brandSizeNum) .. "%"
    end
end

-- Get eva percentage bonus
function GetEvaPercent(lv)
    if not lv or lv <= 0 then
        return ""
    end

    if lv == 1 then
        return "0%"
    else
        return tostring(EvaUp[lv].add / 1000) .. "%"
    end
end

--Limit character input length
function ct.LimitInputLength(tempInputField, maxLength)
    if tempInputField == nil or typeof(UnityEngine.UI.InputField) ~= type(tempInputField) or maxLength == nil or type(maxLength) ~= 'number' or maxLength < 1 then
        return false
    end
    tempInputField.characterLimit = maxLength
    return true
end

--Get the correct effective price: 12345678.1234
local maxInt = 8  --Maximum integer
local maxFloat = 4  --Maximum decimal places
function ct.getCorrectPrice(valueStr)
    local index = string.find(valueStr, '%.')
    if index ~= nil then
        local intString = string.sub(valueStr, 1, index - 1)
        local floatString = string.sub(valueStr, index + 1)
        if #intString > maxInt then
            intString = string.sub(intString, 1, maxInt)
        end
        if #floatString > maxFloat then
            floatString = string.sub(floatString, 1, maxFloat)
        end
        return intString .. "." .. floatString
    else
        if #valueStr > maxInt then
            return string.sub(valueStr, 1, maxInt)
        end
    end

    return valueStr
end

--Get string with... flight forecast
local cnDefaultLength = 27  --The length of Chinese characters displayed by default, a Chinese character takes up 3length
local enDefaultLength = 16

function ct.getFlightSubString(value, cnLen, enLen , koLen ,jpLen)
    local result = value
    local language = currentLanguage
    if language == Language_Chinese then
        if cnLen == nil then cnLen = cnDefaultLength end
        if #value > cnLen then
            result = string.sub(value, 1, cnLen).."..."
        end
    elseif language == Language_English then
        if enLen == nil then enLen = enDefaultLength end
        if #value > enLen then
            result = string.sub(value, 1, enLen).."..."
        end
    elseif language == Language_Korean then
        if koLen == nil then koLen = cnDefaultLength end
        if #value > koLen then
            result = string.sub(value, 1, koLen).."..."
        end
    elseif language == Language_Japanese then
        if jpLen == nil then jpLen = cnDefaultLength end
        if #value > jpLen then
            result = string.sub(value, 1, jpLen).."..."
        end
    end
    return result
end

local PRIDMagnification = 10000000   --Recommended pricing table ID multiple
local CPMagnification = 50		  --Competitiveness ratio
local BargainingPower = 49		  --Bargaining power
local Divisor = 2       		  --divisor
local AfterPointBit = 1 		  --1 digit after the decimal point
functions.maxCompetitive = 99     --Maximum competitiveness
functions.minCompetitive = 1      --Minimum competitiveness
--Take N places after calculating the decimal point
function CalculationNBitAfterDecimalPoint(nNum)
    if type(nNum) ~= "number" then
        return nNum
    elseif nNum >= 100 then
        nNum = 100
    end
    local nDecimal = 10 ^ AfterPointBit
    local nTemp = math.floor(nNum * nDecimal)
    local nRet = nTemp / nDecimal
    return nRet
end

---Calculate raw material plant competitiveness
--Recommended pricing: recommendedPricing (value sent from the server)
--Pricing: price
--Material ID: materialID (7-digit ID)
function ct.CalculationMaterialCompetitivePower(recommendedPricing,price,materialID)
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[11 * PRIDMagnification + materialID]
    end
    local temp
    if recommendedPricing > price then
        --Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 2 / 49) + 50
        temp = (recommendedPricing - price) / ((recommendedPricing / Divisor) / BargainingPower) + CPMagnification
    else
        --Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 49) + 50
        temp = (recommendedPricing - price) / (recommendedPricing / BargainingPower) + CPMagnification
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    return temp
end
---Calculate the recommended pricing of the raw material factory
--Recommended pricing: recommendedPricing (value sent from the server)
--Material ID: materialID (7-digit ID)
function ct.CalculationMaterialSuggestPrice(recommendedPricing,materialId)
    local price = recommendedPricing
    if price <= 0 then
        price = Competitive[11 * PRIDMagnification + materialId]
    end
    return price
end
---Calculate raw material factory pricing
--Recommended pricing: recommendedPricing (value sent from the server)
--Competitiveness: power
--Material ID: materialID (7-digit ID)
function ct.CalculationMateriaPrice(recommendedPricing,power,materialId)
    local tempPrice
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[11 * PRIDMagnification + materialId]
    end
    if power < 50 then
        --Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    else
        --Player pricing = recommended pricing-(competitive-50) * (recommended pricing / 2 / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * ((recommendedPricing / Divisor) / BargainingPower)
    end
    return tempPrice
end
-----No recommended pricing for land transactions
----Recommended pricing: recommendedPricing (value sent from the server)
---Calculation of land transaction competitiveness
--Recommended pricing: recommendedPricing (value sent from the server)
--Pricing: price
function ct.CalculationGroundCompetitivePower(recommendedPricing,price)
    local temp
    if recommendedPricing > price then
        --Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 2 / 49) + 50
        temp = (recommendedPricing - price) / ((recommendedPricing / Divisor) / BargainingPower) + CPMagnification
    else
        --Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 49) + 50
        temp = (recommendedPricing - price) / (recommendedPricing / BargainingPower) + CPMagnification
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    return temp
end
---Calculate land transaction pricing
--Recommended pricing: recommendedPricing (value sent from the server)
--Competitiveness: power
function ct.CalculationGroundPrice(recommendedPricing,power)
    local tempPrice
    if power < 50 then
        --Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    else
        --Player pricing = recommended pricing-(competitive-50) * (recommended pricing / 2 / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * ((recommendedPricing / Divisor) / BargainingPower)
    end
    return tempPrice
end
---Computing to promote company competitiveness
--Recommended pricing: recommendedPricing
--Pricing: price
--Promotion type: Advertisementtype --1600012 merchandise 1600013 retail store 1600013 residential
function ct.CalculationAdvertisementCompetitivePower(recommendedPricing,price,Advertisementtype)
    --Recommended pricing <= 0 Recommended pricing = Recommended pricing table
    if recommendedPricing <= 0 then
        recommendedPricing =  Competitive[16 * PRIDMagnification  + Advertisementtype]
    end
    --Recommended Pricing >= Pricing Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 2 / 49) + 50
  local temp
    if recommendedPricing >= price then
        temp = (recommendedPricing - price) / (recommendedPricing / Divisor / BargainingPower) + CPMagnification
    else
        temp = (recommendedPricing - price) / (recommendedPricing  / BargainingPower) + CPMagnification
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    return temp
end

---Calculate the recommended default value of the promotion company
--Recommended pricing: recommendedPricing
--Competitiveness: power
--Promotion type: Advertisementtype --1600012 merchandise 1600013 retail store 1600013 residential
function ct.CalculationPromoteSuggestPrice(recommendedPricing,power,Advertisementtype)
    if recommendedPricing <= 0 then
        recommendedPricing =  Competitive[16 * PRIDMagnification  + Advertisementtype]
    end
    local tempPrice
    --Competitiveness >= 50 Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 2 / 49)
    if power >=50 then
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / Divisor/ BargainingPower)
    else
        --Competitiveness <50 Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    end
    return tempPrice
end

--Calculate promotion company recommended pricing
--Recommended pricing recommendedPricing
--Promotion type: Advertisementtype --1600012 merchandise 1600013 retail store 1600013 residential
function ct.CalculationPromoteRecommendPrice(recommendedPricing,Advertisementtype)
    if recommendedPricing == nil or next(recommendedPricing) == nil then
        return
    end
    local temp
    for i, v in pairs(recommendedPricing) do
        if v.typeId == Advertisementtype then
            temp = v.guidePrice
        end
    end
    if temp <= 0 then
        temp =  Competitive[16 * PRIDMagnification  + Advertisementtype]
    end
    return temp
end

---Computational R&D Company Competitiveness【over】
--Pricing: price
function ct.CalculationLaboratoryCompetitivePower(recommendedPricing, price,typeId)
    --Recommended pricing >= pricing
    --Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 2 / 49) + 50
    --Recommended pricing <pricing
    --Competitiveness = (Recommended Pricing-Player Pricing) / (Recommended Pricing / 49) + 50
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[15 * PRIDMagnification + typeId]
    end
    local temp
    if recommendedPricing > price then
        temp = (recommendedPricing - price) / ((recommendedPricing / Divisor) / BargainingPower) + CPMagnification
    else
        temp = (recommendedPricing - price) / (recommendedPricing / BargainingPower) + CPMagnification
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    return temp
end

---Calculate recommended pricing for R&D companies
--Recommended pricing: recommendedPricing (value sent from the server)
--typeId (7-digit ID)
function ct.CalculationLaboratorySuggestPrice(recommendedPricing,typeId)
    local price = recommendedPricing
    if price <= 0 then
        price = Competitive[15 * PRIDMagnification + typeId]
    end
    return price
end

---Computing R&D company pricing
--Recommended pricing: recommendedPricing (value sent from the server)
--Competitiveness: power
--Product ID: typeId (7-digit ID)
function ct.CalculationLaboratoryPrice(recommendedPricing,power,typeId)
    --Competitiveness >= 50
    --Player pricing = recommended pricing-(competitive-50) * (recommended pricing / 2 / 49)
    --Competitiveness <50
    --Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 49)
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[15 * PRIDMagnification + typeId]
    end
    local temp
    if power < 50 then
        temp = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    else
        temp = recommendedPricing - (power - CPMagnification) * ((recommendedPricing / Divisor) / BargainingPower)
    end
    return temp
end

---Calculate the competitiveness of processing plants
--Recommended pricing: recommendedPricing (value sent from the server)
--Pricing: price
--Commodity ID: commodityID (7-digit ID)
function ct.CalculationFactoryCompetitivePower(recommendedPricing,price,commodityID)
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[12 * PRIDMagnification + commodityID]
    end
    local temp
    if recommendedPricing > price then
        --Competitiveness = (recommended pricing-player pricing) / (recommended pricing / 2 / 49) + 50
        temp = (recommendedPricing - price) / ((recommendedPricing / Divisor) / BargainingPower) + CPMagnification
    else
        --Competitiveness = (recommended pricing-player pricing) / (recommended pricing / 49) + 50
        temp = (recommendedPricing - price) / (recommendedPricing / BargainingPower) + CPMagnification
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    return temp
end
---Calculate recommended pricing for processing plants
--Recommended pricing: recommendedPricing (value sent from the server)
--Commodity ID: commodityID (7-digit ID)
function ct.CalculationProcessingSuggestPrice(recommendedPricing,commodityID)
    local price = recommendedPricing
    if price <= 0 then
        price = Competitive[12 * PRIDMagnification + commodityID]
    end
    return price
end
---Calculate processing plant pricing
--Recommended pricing: recommendedPricing (value sent from the server)
--Competitiveness: power
--Commodity ID: commodityID (7-digit ID)
function ct.CalculationProcessingPrice(recommendedPricing,power,commodityID)
    local tempPrice
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[12 * PRIDMagnification + commodityID]
    end
    if power < 50 then
       -- Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    else
        -- Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 2 / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * ((recommendedPricing / Divisor) / BargainingPower)
    end
    return tempPrice
end

---Calculate retail store competitiveness
--Recommended pricing: recommendedPricing (value sent from the server)
--Pricing: price
--Commodity ID: commodityID (7-digit ID)
function ct.CalculationSupermarketCompetitivePower(recommendedPricing,price,commodityID)
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[13 * PRIDMagnification + commodityID]
    end
    local temp
    if recommendedPricing > price then
        --Competitiveness = (recommended pricing-player pricing) / (recommended pricing / 2 / 49) + 50
        temp = (recommendedPricing - price) / ((recommendedPricing / Divisor) / BargainingPower) + CPMagnification
    else
        --Competitiveness = (recommended pricing-player pricing) / (recommended pricing / 49) + 50
        temp = (recommendedPricing - price) / (recommendedPricing / BargainingPower) + CPMagnification
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    return temp
end
---Calculate retail store recommended pricing
--Recommended pricing: recommendedPricing (value sent from the server)
--Commodity ID: commodityID (7-digit ID)
function ct.CalculationRetailSuggestPrice(recommendedPricing,commodityID)
    local price = recommendedPricing
    if price <= 0 then
        price = Competitive[13 * PRIDMagnification + commodityID]
    end
    return price
end
--Calculate retail store pricing
--Recommended pricing: recommendedPricing (value sent from the server)
--Pricing: price
--Commodity ID: commodityID (7-digit ID)
function ct.CalculationRetailPrice(recommendedPricing,power,commodityID)
    local tempPrice
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[13 * PRIDMagnification + commodityID]
    end
    if power < 50 then
        -- Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    else
        -- Player pricing = Recommended pricing-(Competitiveness-50) * (Recommended pricing / 2 / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * ((recommendedPricing / Divisor) / BargainingPower)
    end
    return tempPrice
end

---Calculate residential competitiveness
--Recommended pricing: recommendedPricing
--Pricing: price
-- NPC expected consumption: npc (to find the server)
function ct.CalculationHouseCompetitivePower(recommendedPricing,price,npc)
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[14 * PRIDMagnification]
    end
    local temp
    if price > recommendedPricing then
        --Competitiveness = (recommended pricing-player pricing) / (recommended pricing / 49) + 50
        temp = (recommendedPricing - price) / (recommendedPricing / BargainingPower) + CPMagnification
    else
        --Competitiveness = (recommended pricing-player pricing) / (recommended pricing / 2 / 49) + 50
        temp = (recommendedPricing - price) / ((recommendedPricing / Divisor )/ BargainingPower) + CPMagnification
    end
    if temp <= functions.minCompetitive then
        temp = functions.minCompetitive
    end
    if temp >= functions.maxCompetitive then
        temp = functions.maxCompetitive
    end
    return temp
end
---Calculate residential pricing
--Recommended pricing: recommendedPricing
--Competitiveness: power
-- NPC expected consumption: npc (to find the server)
function ct.CalculationHousePrice(recommendedPricing,power)
    local tempPrice
    if recommendedPricing <= 0 then
        recommendedPricing = Competitive[14 * PRIDMagnification]
    end
    if power < 50 then
        --Player pricing = Recommended pricing-(Competitiveness-50)* (Recommended pricing / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * (recommendedPricing / BargainingPower)
    else
        --Player pricing = Recommended pricing-(Competitiveness-50)* (Recommended pricing / 2 / 49)
        tempPrice = recommendedPricing - (power - CPMagnification) * ((recommendedPricing / Divisor) / BargainingPower)
    end
    return tempPrice
end
---Calculate residential recommended pricing
--Recommended pricing: recommendedPricing\
-- Player store rating: shopScore (to find the server)
-- Store ratings for all sales across the city: averageShopScore (to find a server)
function ct.CalculationHouseSuggestPrice(recommendedPricing)
    local price = recommendedPricing
    if recommendedPricing <= 0 then
        price = Competitive[14 * PRIDMagnification]
    end
    return price
end

--Flight forecasting is based on the airport two-letter code to get the corresponding multi-language
function ct.GetFlightCompanyName(flightNo)
    if flightNo == nil then
        return
    end
    local code = string.sub(flightNo, 1, 2)
    local languageId = FlightCompanyConfig[code]
    if languageId == nil then
        languageId = 32030035
    end
    return GetLanguage(languageId)
end
