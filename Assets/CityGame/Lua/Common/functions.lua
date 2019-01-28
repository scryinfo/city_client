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
		str = table.concat({str1,"/",str3,"/",str2})
	end
	return str
end

--秒数转换时间格式字符串
function getTimeString(time)
	local hours = math.floor(time / 3600)
	local minutes = math.floor((time % 3600) / 60)
	local seconds = math.floor(time % 60)
	if hours < 10 then hours = "0"..hours end
	if minutes < 10 then  minutes = "0"..minutes end
	if seconds < 10 then seconds = "0"..seconds end
	local time = hours..":"..minutes..":"..seconds
	return time
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

	if tb.year < 10 then
		tb.year = "0"..tb.year
	end
	if tb.month < 10 then
		tb.month = "0"..tb.month
	end
	if tb.day < 10 then
		tb.day = "0"..tb.day
	end
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

function convertTimeForm(second)
	local data={}
	data.day  = math.floor(second/86400)
	data.hour  = math.fmod(math.floor(second/3600), 24)
	data.min = math.fmod(math.floor(second/60), 60)
	data.sec  = math.fmod(second, 60)
	return data
end


--表格排序
function tableSort(table,gameObject)
	TableSort.tableSort(table,gameObject)
end
--修改表数据
function UpdataTable(table,gameObject,prefabs)
	TableSort:UpdataTable(table,gameObject,prefabs)
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

currentLanguage={}
currentSprite={}
chinese={}
english={}
sprite_chi={}
sprite_eng={}
function ReadConfigLanguage()
	for ID, ch in pairs(Language_Chinese) do
		chinese[ID]=ch
	end
	for ID, en in pairs(Language_English) do
		english[ID]=en
	end

	for key, content in pairs(Sprite_Chinese) do
		sprite_chi[key]=content
	end
	for key, content in pairs(Sprite_English) do
		sprite_eng[key]=content
	end


   local num=UnityEngine.PlayerPrefs.GetInt("Language")
	if num==0 then
		currentLanguage=english
		currentSprite=sprite_eng
	elseif num==1 then
		currentLanguage=chinese
		currentSprite=sprite_chi
	end
end

function SaveLanguageSettings(languageType)
	if languageType==LanguageType.Chinese then
		UnityEngine.PlayerPrefs.SetInt("Language",1)
		currentLanguage=chinese
		currentSprite=sprite_chi
	elseif languageType==LanguageType.English then
		UnityEngine.PlayerPrefs.SetInt("Language",0)
		currentLanguage=english
		currentSprite=sprite_eng
	end
end

function GetLanguage(key,...)
	local temp={...}
	for Id, String in pairs(currentLanguage) do
		if Id==key then
          local tempString=String
			for i = 1, #temp do
				tempString=string.gsub(tempString,"{"..tostring(i-1).."}",temp[i])
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
	go.transform:SetParent(parent);--.transform
	rect.transform.localScale = Vector3.one
	rect.transform.localPosition=Vector3.zero
	return go
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

--第三个参数为是否设置img为原图大小
function LoadSprite(path, Icon, bSetNativeSize)
	local type = ct.getType(UnityEngine.Sprite)
	panelMgr:LoadPrefab_A(path, type, nil, function(staticData, obj )
		if obj ~= nil then
			local texture = ct.InstantiatePrefab(obj)
			Icon.sprite = texture
			if bSetNativeSize == true then
				Icon:SetNativeSize()
			end
		end
	end)
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
