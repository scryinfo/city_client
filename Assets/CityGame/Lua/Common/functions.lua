--查找对象--
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

--创建面板--
function LoadPrefab_A(name, type, instance, callback)
	PanelManager:LoadPrefab_A(name,type, instance, callback);
end
--创建窗口--
function createWindows(name,pos)
	PanelManager:CreateWindow(name,pos);
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
		error(str.." is null");
		return nil;
	end
	return obj:GetComponent("BaseLua");
end

--获取价格显示文本 --整数和小数部分大小不同
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

--获取数值显示文本，颜色不同
function getColorString(numTab)
	local leng = 0
	for i,v in pairs(numTab) do
		leng = leng + 1
	end
	local str = nil
	if leng == 4 then
		local str1 = table.concat({"<color=",numTab["col1"],">",numTab["num1"],"</color>"})
		local str2 = table.concat({"<color=",numTab["col2"],">",numTab["num2"],"</color>"})
		str = table.concat({str1,"/",str2})
	else
		local str1 = table.concat({"<color=",numTab["col1"],">",numTab["num1"],"</color>"})
		local str2 = table.concat({"<color=",numTab["col2"],">",numTab["num2"],"</color>"})
		local str3 = table.concat({"<color=",numTab["col3"],">",numTab["num3"],"</color>"})
		str = table.concat({str1,"/",str2,"/",str3})
	end
	return str
end

--秒数转换时间格式字符串
function getTimeTable(time)
    local hours = math.floor(time / 3600)
    local minutes = math.floor((time % 3600) / 60)
    local seconds = math.floor(time % 60)
    if hours < 10 then hours = "0"..hours end
    if minutes < 10 then  minutes = "0"..minutes end
    if seconds < 10 then seconds = "0"..seconds end
    local data = {hour = hours, minute = minutes, second = seconds}
    return data
end
--通过整数255之类的得到对应的颜色
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

--把时间 秒转换成xx时xx分xx秒格式
function getFormatUnixTime(time)
	local tb = {}
	time = math.floor(time)
	tb.year = tonumber(os.date("%Y", time)) or 0
	tb.month = tonumber(os.date("%m", time)) or 0
	tb.day = tonumber(os.date("%d", time)) or 0
	tb.hour = tonumber(os.date("%H", time)) or 0
	tb.minute = tonumber(os.date("%M", time)) or 0
	tb.second = tonumber(os.date("%S", time)) or 0

	if tb.year < 10 then tb.year = "0"..tb.year end
	if tb.month < 10 then tb.month = "0"..tb.month end
	if tb.day < 10 then tb.day = "0"..tb.day end
	if tb.hour < 10 then tb.hour = "0"..tb.hour end
	if tb.minute < 10 then tb.minute = "0"..tb.minute end
	if tb.second < 10 then tb.second = "0"..tb.second end

	return tb
end
--把时间 秒转换成xx时xx分xx秒格式
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
--把时间格式字符串转化成时间戳 --必须为yyyy-mm-dd hh:mm:ss格式
function getTimeUnixByFormat(timeString)
	if type(timeString) ~= 'string' then error('string2time: timeString is not a string') return 0 end
	local fun = string.gmatch( timeString, "%d+")
	local y = fun() or 0
	if y == 0 then error('timeString is a invalid time string') return 0 end
	local m = fun() or 0
	if m == 0 then error('timeString is a invalid time string') return 0 end
	local d = fun() or 0
	if d == 0 then error('timeString is a invalid time string') return 0 end
	local H = fun() or 0
	if H == 0 then error('timeString is a invalid time string') return 0 end
	local M = fun() or 0
	if M == 0 then error('timeString is a invalid time string') return 0 end
	local S = fun() or 0
	if S == 0 then error('timeString is a invalid time string') return 0 end
	return os.time({year=y, month=m, day=d, hour=H,min=M,sec=S})
end
--通过index获取对应的周显示
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
	local data={}
	data.day  = math.floor(second/86400)
	data.hour  = math.fmod(math.floor(second/3600), 24)
	data.min = math.fmod(math.floor(second/60), 60)
	data.sec  = math.fmod(second, 60)
	return data
end

--将秒转换成小时分秒的格式，非时间戳
function getTimeBySec(secTime)
	local tb = {}
	secTime = math.floor(secTime)
	tb.hour = math.floor(secTime / 3600) or 0
	tb.minute = math.floor((secTime - tb.hour * 3600) / 60) or 0
	tb.second = math.floor(secTime - tb.hour * 3600 - tb.minute * 60) or 0

	if tb.hour < 10 then
		tb.hour = "0"..tb.hour
	end
	if tb.minute < 10 then
		tb.minute = "0"..tb.minute
	end
	if tb.second < 10 then
		tb.second = "0"..tb.second
	end

	return tb
end
--根据建筑store获取一个以itemId为key的字典
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
	if file then file:close() end
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
		file:write(data[i]..'\n')
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

function ct.OpenCtrl(inClassName,data) -- 统一的打开 Controller 的方法, 注意参数是类的名字。 使用消息机制，避免调用者和具体的Controller的耦合
	Event.Brocast('c_OnOpen'..inClassName,data)
end

function ct.MsgBox(titleInfo , contentInfo,tipInfo, okCallBack, closeCallBack)
	local info = {}
	info.titleInfo = titleInfo
	--替換為多語言
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

ct.MemoryProfilePath=""

function ct.getMemoryProfile()
	return ct.MemoryProfilePath
end

function ct.mkMemoryProfile()
	local file_exists = ct.file_exists
	if UnityEngine.Application.isEditor == false then
		ct.MemoryProfilePath =  UnityEngine.Application.persistentDataPath.."/CityGame/MemoryProfile"
		ct.log("system", "ProFi:writeReport path = ",ct.MemoryProfilePath)
		if file_exists(ct.MemoryProfilePath) == false then
			ct.log("system","[ProFi:writeReport] path not exist ")
			os.execute("mkdir -p \"" .. ct.MemoryProfilePath .. "\"")
		end
	else
		ct.MemoryProfilePath = "MemoryProfile"
		os.execute("mkdir "..ct.MemoryProfilePath)
	end
end

local  function deepCopy(orig)
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
				copy.subclassed = function(self, other) end
				copy.super.subclass(copy,orig.name)
				orig.super.subclass(orig,orig.name)
			else
				copy[deepCopy(orig_key)] = deepCopy(orig_value)
			end
		end
		setmetatable(copy, deepCopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

ct.deepCopy = deepCopy

--取整函数
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
--实例化UI的prefab
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

--获取价格显示文本 --整数和小数部分大小不同
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
	UnityEngine.PlayerPrefs.SetInt("BuildingBubble",bubbleType)
end

function GetLanguage(key,...)
	local temp={...}
	for Id, String in pairs(currentLanguage) do
		if Id == key then
            local tempString = String
			for i = 1, #temp do
				tempString = string.gsub(tempString,"{"..tostring(i-1).."}",temp[i])
			end
			return tempString
		end
	end
	return key.."没有设置"
end

function GetSprite(key)

    local path=currentSprite[key]
	if path then
		return path
	else
		return key.."没有设置"
	end
end
---生成预制
function creatGoods(path,parent)
	local prefab = UnityEngine.Resources.Load(path);
	local go = UnityEngine.GameObject.Instantiate(prefab);
	local rect = go.transform:GetComponent("RectTransform");
	if parent then
		go.transform:SetParent(parent);--.transform
	end
	rect.transform.localScale = Vector3.one
	rect.transform.localPosition=Vector3.zero
	return go
end

--生成预制(新版)
function createPrefab(path, parent, callback)
	panelMgr:LoadPrefab_A(path, nil, nil, function(ins, obj )
		if obj ~= nil then
			local go = ct.InstantiatePrefab(obj)
			local rect = go.transform:GetComponent("RectTransform")
			if parent then
				go.transform:SetParent(parent.transform);--.transform
			end
			rect.transform.localScale = Vector3.one
			rect.transform.localPosition=Vector3.zero
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

--字符串分割
function split(input, delimiter)
	input = tostring(input)
	delimiter = tostring(delimiter)
	if (delimiter=='') then return false end
	local pos,arr = 0, {}
	-- for each divider found
	for st,sp in function() return string.find(input, delimiter, pos, true) end do
		table.insert(arr, string.sub(input, pos, st - 1))
		pos = sp + 1
	end
	table.insert(arr, string.sub(input, pos))
	return arr
end

local AssetObjs  = {}
local SpriteType = nil
--第三个参数为是否设置img为原图大小
function LoadSprite(path, iIcon, bSetNativeSize)
	if SpriteType == nil then
		SpriteType = ct.getType(UnityEngine.Sprite)
	end
	panelMgr:LoadPrefab_A(path, SpriteType, iIcon, function(Icon, obj ,ab)
		if Icon == nil then
			return
		end
		if obj ~= nil  then
			local texture = ct.InstantiatePrefab(obj)
			if Icon then
				Icon.sprite = texture
				if bSetNativeSize == true then
					Icon:SetNativeSize()
				end
				--此处是为了显示效果
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
	local temp={}
	if AssetObjs ~= nil and AssetObjs[path] ~= nil then
		local v = AssetObjs[path]
		AssetObjs[path] = nil

		--UnityEngine.AssetBundle.Unload(v,true) --这个是不考虑引用的强制卸载，可能会导致某些image显示不出图片
		--UnityEngine.AssetBundle.Unload(v,false)
		for paths, ab in pairs(temp) do
			if ab ~=v then
				temp[path]=v
			end
		end
	end

	for i, v in pairs(temp) do
		resMgr:UnloadAssetBundle(v, false)
	end

end

function findByName(transform ,name)
    local trim = transform:Find(name)
	if trim  then
		return trim
	end
	for i = 1, transform.childCount do
		trim = findByName(transform:GetChild(i-1),name)
		if trim then
			return  trim
		end
	end
   return nil
end

--屏幕坐标转化为真实坐标
function ScreenPosTurnActualPos(targetScreenPos)
	local ActualPos = Vector2.New(  targetScreenPos.x * Game.ScreenRatio ,targetScreenPos.y * Game.ScreenRatio)
	return ActualPos
end
--将服务器的数据转化成客户端数据格式
function GetClientPriceString(serverPrice)
	if serverPrice == nil or serverPrice == "" or tonumber(serverPrice) < 0 then
		return "0.0000"
	end
	return string.format("%0.4f", tonumber(serverPrice) / 10000)
end

--客户端的数据转化成服务端数据格式
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
	ct.log("system",str.."==================================================")
end

--给曲线图Y轴动态赋值(根据传入数据的最大值)
function SetYScale(max,count,transform,percentage)
	local scale
	if percentage then
		scale = 1/count
		if transform ~= nil then
			for i = 1, count do
				transform:GetChild(i - 1):GetComponent("Text").text =math.ceil((scale * i)*100) .. "%"
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
		local typeId = tonumber(string.sub(buildingTypeId,1, 2))
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

-- 动态加载预制
function DynamicLoadPrefab(path, parent, scale, fuc)
	panelMgr:LoadPrefab_A(path, nil, nil, function(ins, obj )
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
	local arg = {...}
	arg[#arg](ins[modelMethord](ins,...))
end

-- 得到eva显示数据
-- index 小中大型
function GetEvaData(index, configData, lv)
	if not index or not configData or not lv then
		return
	end
	local brandSizeNum
	if index == 1 then -- 小
		brandSizeNum = 16
	elseif index == 2 then -- 中
		brandSizeNum = 64
	elseif index == 3 then -- 大
		brandSizeNum = 144
	end
	if configData.Btype == "Quality" then -- 品质
		if configData.Atype < 2100000 then -- 建筑品质加成
			return string.format( (1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum)
		else -- 商品品质值
			return string.format( (1 + EvaUp[lv].add / 100000) * configData.basevalue)
		end
	elseif configData.Btype == "ProduceSpeed" then -- 生产速度
		local resultNum = tostring( 1 / ((1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum))
		if string.find(resultNum, ".") ~= nil then
			resultNum = string.format( "%.2f", resultNum)
		end
		return resultNum .. GetLanguage(31010042)
	elseif configData.Btype == "PromotionAbility" then -- 推广能力
		return math.floor((1 + EvaUp[lv].add / 100000) * configData.basevalue * brandSizeNum) .. "/h"
	elseif configData.Btype == "InventionUpgrade" then -- 发明提升
		return string.format("%.2f", ((1 + EvaUp[lv].add / 100000) * (configData.basevalue / 100000)) * 100 * brandSizeNum) .. "%"
	elseif configData.Btype == "EvaUpgrade" then -- Eva提示
		return string.format("%.2f", ((1 + EvaUp[lv].add / 100000) * (configData.basevalue / 100000)) * 100 * brandSizeNum) .. "%"
	end
end

-- 得到eva百分比加成
function GetEvaPercent(lv)
	if not lv or lv <= 0 then
		return ""
	end

	if lv == 1 then
		return "0"
	else
		return tostring(EvaUp[lv].add / 1000) .. "%"
	end
end

--限制字符输入长度
function ct.LimitInputLength(tempInputField , maxLength)
	if tempInputField == nil or typeof(UnityEngine.UI.InputField) ~= type(tempInputField) or maxLength == nil or type(maxLength) ~= 'number' or maxLength < 1 then
		return false
	end
	tempInputField.characterLimit = maxLength
	return true
end

--获取正确的有效价格：12345678.1234
local maxInt = 8  --最大整数位
local maxFloat = 4  --最大小数位
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
		return intString.."."..floatString
	else
		if #valueStr > maxInt then
			return string.sub(valueStr, 1, maxInt)
		end
	end

	return valueStr
end

--获取带...的string，航班预测
local cnDefaultLength = 27  --默认显示的中文字符长度，一个中字占3length
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

local PRIDMagnification = 10000000   --推荐定价表ID倍率
local CPMagnification = 50		  --竞争力倍率
local AfterPointBit = 1 		--小数点后取1位
--计算小数点后取N位
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

---计算原料厂竞争力
--推荐定价:recommendedPricing
--定价:price
--原料ID：materialID（7位ID）
function ct.CalculationMaterialCompetitivePower(recommendedPricing,price,materialID)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = Competitive[11 * PRIDMagnification + materialID]
	end
	--竞争力 = 推荐定价 / 定价 * 1000 (整数)
	return  CalculationNBitAfterDecimalPoint((recommendedPricing/ price * CPMagnification ))
end

---计算原料厂推荐定价
--推荐定价:recommendedPricing
--原料ID：materialID（7位ID）
function ct.CalculationMaterialSuggestPrice(recommendedPricing,materialID)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = Competitive[11 * PRIDMagnification + materialID]
		return recommendedPricing
	end
	return recommendedPricing
end


---计算推广公司竞争力
--推荐定价:recommendedPricing
--定价:price
--推广能力:competitivePower  -- 所有不同类型推广能力和 / 4
--推广类型:Advertisementtype  --2251食品推广  2252服饰推广   13零售店推广   14住宅推广
function ct.CalculationAdvertisementCompetitivePower(recommendedPricing,price,competitivePower,Advertisementtype)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表(新增-建筑ID前两位*10000000+能力id)
		recommendedPricing =  Competitive[16 * PRIDMagnification  + Advertisementtype]
		--竞争力 = 推荐定价 / 定价  * 1000 (整数)
		return  CalculationNBitAfterDecimalPoint((recommendedPricing / price * CPMagnification ))
	else
		--竞争力 = 推荐定价 / (定价/推广能力) * 1000 (整数)
		return  CalculationNBitAfterDecimalPoint((recommendedPricing / ( price / competitivePower) * CPMagnification ))
	end
end

---计算研发公司竞争力【over】
--推荐定价:recommendedPricing
--定价:price
--玩家研发能力: RDAbility
function ct.CalculationLaboratoryCompetitivePower(recommendedPricing,price,RDAbility)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表(新增-建筑ID前两位*10000000+能力id)
		recommendedPricing =  Competitive[15 * PRIDMagnification + 5]
		--竞争力 = 推荐定价 / 定价  * 50(整数)
		return CalculationNBitAfterDecimalPoint((recommendedPricing / price * CPMagnification ))
	else
		--竞争力 = 推荐定价 / (定价/(玩家研发能力))  * 50(整数)
		return CalculationNBitAfterDecimalPoint((recommendedPricing / ( price /( RDAbility)) * CPMagnification ))
	end
end

---计算研发公司推荐默认值
--推荐定价:recommendedPricing
--研究还是发明：RBtype    -- 5是发明，6是研究
--玩家研发能力: RDAbility
function ct.CalculationLaboratorySuggestPrice(recommendedPricing,RDAbility)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = Competitive[15 * PRIDMagnification + 5]
		return recommendedPricing * RDAbility
	end
	return recommendedPricing * RDAbility
end

---计算加工厂竞争力
--推荐定价:recommendedPricing
--定价:price
--商品ID：commodityID（7位ID）
--玩家商品评分:commodityScore
--销售均评分:averageSalesScore(找服务器要)
function ct.CalculationFactoryCompetitivePower(recommendedPricing,price,commodityID,commodityScore,averageSalesScore)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = Competitive[12 * PRIDMagnification + commodityID]
		--竞争力 = 推荐定价 / 定价  * 1000 (整数)
		return  CalculationNBitAfterDecimalPoint((recommendedPricing / price * CPMagnification))
	end
	--竞争力 = (全城成交均价 * 玩家商品评分)/ (定价 * 销售均评分) * 1000 (整数)
	return  CalculationNBitAfterDecimalPoint(((recommendedPricing * commodityScore)/ ( price * averageSalesScore) * CPMagnification))
end

---计算加工厂推荐定价
function ct.CalculationProcessingSuggestPrice(recommendedPricing,goodsID)
	if recommendedPricing <= 0 then
		recommendedPricing = Competitive[12 * PRIDMagnification + goodsID]
		return recommendedPricing
	end
	return recommendedPricing
end

---计算零售店竞争力
--推荐定价:recommendedPricing
--定价:price
--商品ID：commodityID（7位ID）
--玩家商品评分:commodityScore
--玩家店铺评分:shopScore(找服务器要)
--全城销售均商品评分:averageSalesScore(找服务器要)
--全城销售均店铺评分:averageShopScore(找服务器要)
function ct.CalculationSupermarketCompetitivePower(recommendedPricing,price,commodityID,commodityScore,shopScore,averageSalesScore,averageShopScore)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = 13 * PRIDMagnification + commodityID
		--竞争力 = 推荐定价 / 定价  * 1000 (整数)
		return CalculationNBitAfterDecimalPoint((recommendedPricing / price * CPMagnification))
	end
	--竞争力 = (推荐定价 * (玩家商品评分+玩家店铺评分))/ (定价 * (全城销售均商品评分+全城销售均店铺评分)) * 1000
	return CalculationNBitAfterDecimalPoint(((recommendedPricing * (commodityScore + shopScore))/ ( price * (averageSalesScore + averageShopScore)) * CPMagnification))
end

---计算零售店推荐定价
function ct.CalculationRetailSuggestPrice(recommendedPricing,goodsID)
	if recommendedPricing <= 0 then
		recommendedPricing = Competitive[12 * PRIDMagnification + goodsID]
		return recommendedPricing
	end
	return recommendedPricing
end

---计算住宅竞争力
--推荐定价:recommendedPricing
--定价:price
--玩家店铺评分:shopScore(找服务器要)
--全城销售均店铺评分:averageShopScore(找服务器要)
function ct.CalculationHouseCompetitivePower(recommendedPricing,price,shopScore,averageShopScore)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = Competitive[14 * PRIDMagnification]
		--竞争力 = 推荐定价 / 定价  * 1000 (整数)
		return  CalculationNBitAfterDecimalPoint((recommendedPricing / price * CPMagnification))
	end
	--竞争力 = (推荐定价 * 玩家店铺评分)/ (定价 * 全城销售均店铺评分) * 1000 (整数)
	return  CalculationNBitAfterDecimalPoint(((recommendedPricing * shopScore)/ ( price * averageShopScore) * CPMagnification))
end
---计算住宅推荐定价
--推荐定价:recommendedPricing
function ct.CalculationHouseSuggestPrice(recommendedPricing)
	if recommendedPricing <= 0 then
		--推荐定价 = 推荐定价表
		recommendedPricing = Competitive[14 * PRIDMagnification]
		return recommendedPricing
	end
	return recommendedPricing
end

--航班预测根据机场二字码得到对应多语言
function ct.GetFlightCompanyName(flightNo)
	if flightNo == nil then return end
	local code = string.sub(flightNo, 1,2)
	local languageId = FlightCompanyConfig[code]
	if languageId == nil then
		languageId = 32030035
	end
	return GetLanguage(languageId)
end
