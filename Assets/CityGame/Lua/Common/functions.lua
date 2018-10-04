
--查找对象--
function find(str)
	return GameObject.Find(str);
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newObject(prefab)
	return GameObject.Instantiate(prefab);
end

--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name);
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