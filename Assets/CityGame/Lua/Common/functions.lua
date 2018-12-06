--查找对象--
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
function LoadPrefab_A(name)
	PanelManager:LoadPrefab_A(name);
end
--创建窗口--
function createWindows(name,pos)
	PanelManager:CreateWindow(name,pos);
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
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[deepCopy(orig_key)] = deepCopy(orig_value)
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

