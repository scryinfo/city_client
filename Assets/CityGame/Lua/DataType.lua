

CityEngineLua.DATATYPE_UINT8 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readInt8();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeUint8(v);
	end,

	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		if(type(v) ~= "number") then
			return false;
        end
		
		if(v < 0 or v > 0xff) then
			return false;
		end
		
		return true;
	end
}

CityEngineLua.DATATYPE_UINT16 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readUint16();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeUint16(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		if(type(v) ~= "number") then
			return false;
		end
		
		if(v < 0 or v > 0xffff) then
			return false;
		end
		return true;
	end
}

CityEngineLua.DATATYPE_UINT32 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readUint32();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeUint32(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		if(type(v) ~= "number") then
			return false;
		end
		
		if(v < 0 or v > 0xffffffff) then
			return false;
		end
		
		return true;
	end,
}

CityEngineLua.DATATYPE_UINT64 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readUint64();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeUint64(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return true;
	end
}

CityEngineLua.DATATYPE_INT8 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readInt8();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeInt8(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		if(type(v) ~= "number")then
			return false;
		end
		
		if(v < -0x80 or v > 0x7f)then
			return false;
		end
		return true;
	end
}

CityEngineLua.DATATYPE_INT16 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readInt16();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeInt16(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		if(type(v) ~= "number")then
			return false;
		end
		
		if(v < -0x8000 or v > 0x7fff)then
			return false;
		end
		return true;
	end
}

CityEngineLua.DATATYPE_INT32 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readInt32();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeInt32(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
	
		if(type(v) ~= "number")then
			return false;
		end
		
		if(v < -0x80000000 or v > 0x7fffffff)then
			return false;
		end
		return true;
	end
}

CityEngineLua.DATATYPE_INT64 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readInt64();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeInt64(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return true;
	end
}

CityEngineLua.DATATYPE_FLOAT =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readFloat();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeFloat(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return type(v) == "number";
	end
}

CityEngineLua.DATATYPE_DOUBLE =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readDouble();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeDouble(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return type(v) == "number";
	end
}

CityEngineLua.DATATYPE_STRING =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readString();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeString(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return type(v) == "string";
	end
}

CityEngineLua.DATATYPE_VECTOR2 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return Vector2.New(stream:readFloat(), stream:readFloat());
	end,
	
	addToStream = function(self, stream, v)
		stream:writeFloat(v.x);
		stream:writeFloat(v.y);
	end,
	
	parseDefaultValStr = function(self, v)
		return Vector2.New(0,0);
	end,
	
	isSameType = function(self, v)		
		return true;
	end
}
CityEngineLua.DATATYPE_VECTOR3 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return Vector3.New(stream:readFloat(), stream:readFloat(), stream:readFloat());
	end,
	
	addToStream = function(self, stream, v)
		stream:writeFloat(v.x);
		stream:writeFloat(v.y);
		stream:writeFloat(v.z);
	end,
	
	parseDefaultValStr = function(self, v)
		return Vector3.New(0,0,0);
	end,
	
	isSameType = function(self, v)		
		return true;
	end
}

CityEngineLua.DATATYPE_VECTOR4 =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return Vector4.New(stream:readFloat(), stream:readFloat(), stream:readFloat(), stream:readFloat());
	end,
	
	addToStream = function(self, stream, v)
		stream:writeFloat(v.x);
		stream:writeFloat(v.y);
		stream:writeFloat(v.z);
		stream:writeFloat(v.w);
	end,
	
	parseDefaultValStr = function(self, v)
		return Vector4.New(0,0,0,0);
	end,
	
	isSameType = function(self, v)		
		return true;
	end
}


CityEngineLua.DATATYPE_PYTHON =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readBlob();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeBlob(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v)
	end,
	
	isSameType = function(self, v)
		return true;
	end
}

CityEngineLua.DATATYPE_UNICODE =
{
	bind = function(self)
	end,

	createFromStream = function(self, stream)
		return CityLuaUtil.ByteToUtf8(stream:readBlob());
	end,
	
	addToStream = function(self, stream, v)
		stream:writeBlob(CityLuaUtil.Utf8ToByte(v));
	end,
	
	parseDefaultValStr = function(self, v)
		if(type(v) == "string")then
			return v;
        end
		return "";
	end,
	
	isSameType = function(self, v)
		return type(v) == "string";
	end
}

CityEngineLua.DATATYPE_ENTITYCALL =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
	end,
	
	addToStream = function(self, stream, v)
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return false;
	end
}

CityEngineLua.DATATYPE_BLOB =
{
	bind = function(self)
	end,
	
	createFromStream = function(self, stream)
		return stream:readBlob();
	end,
	
	addToStream = function(self, stream, v)
		stream:writeBlob(v);
	end,
	
	parseDefaultValStr = function(self, v)
		return loadstring("return "..v);
	end,
	
	isSameType = function(self, v)
		return true;
	end
}

---Use as a class
CityEngineLua.DATATYPE_ARRAY = { _type = nil };
CityEngineLua.DATATYPE_ARRAY.__index = CityEngineLua.DATATYPE_ARRAY;
CityEngineLua.DATATYPE_ARRAY.New = function(self)
	local me = {};   -- Initialize self, if there is no sentence, then the object created by the class changes, other objects will change
    setmetatable(me, CityEngineLua.DATATYPE_ARRAY);  --Set self's metatable to Class
	me._type = nil;
    return me;
end

CityEngineLua.DATATYPE_ARRAY.bind = function(self)
	if(type(self._type) == "number") then
		self._type = CityEngineLua.datatypes[self._type];
	end
end
	
CityEngineLua.DATATYPE_ARRAY.createFromStream = function(self, stream)
	local size = stream:readUint32();
	local datas = {};
	while(size > 0)
	do
		size = size-1;
		table.insert(datas, self._type:createFromStream(stream));
	end
	return datas;
end
	
CityEngineLua.DATATYPE_ARRAY.addToStream = function(self, stream, v)
	stream:writeUint32(#v);
	for k,va in pairs(v)
	do
		self._type:addToStream(stream, va);
	end
end

CityEngineLua.DATATYPE_ARRAY.parseDefaultValStr = function(self, v)
	return loadstring("return "..v);
end
	
CityEngineLua.DATATYPE_ARRAY.isSameType = function(self, v)
	for k,va in pairs(v)
	do
		if(not self._type:isSameType(va)) then
			return false;
		end
	end
	return true;
end


CityEngineLua.DATATYPE_FIXED_DICT = {dicttype = {}, dictKeys = {}, implementedBy = nil};
CityEngineLua.DATATYPE_FIXED_DICT.__index = CityEngineLua.DATATYPE_FIXED_DICT;

CityEngineLua.DATATYPE_FIXED_DICT.New = function(self)
	local me = {};
	setmetatable(me, CityEngineLua.DATATYPE_FIXED_DICT);
	me.dicttype = {};
	me.dictKeys = {};
	me.implementedBy = nil;
	return me;
end

CityEngineLua.DATATYPE_FIXED_DICT.bind = function(self)
	for itemkey, utype in pairs(self.dicttype) do
		if(type(utype) == "number") then
			self.dicttype[itemkey] = CityEngineLua.datatypes[utype];
		end
	end
end

CityEngineLua.DATATYPE_FIXED_DICT.createFromStream = function(self, stream)
	local datas = {};
	for i, key in ipairs(self.dictKeys) do
		datas[key] = self.dicttype[key]:createFromStream(stream);
	end
	
	return datas;
end

CityEngineLua.DATATYPE_FIXED_DICT.addToStream = function(self, stream, v)
	for i, key in ipairs(self.dictKeys) do
		self.dicttype[key]:addToStream(stream, v[key]);
	end
end

CityEngineLua.DATATYPE_FIXED_DICT.parseDefaultValStr = function(self, v)
	return loadstring("return "..v);
end

CityEngineLua.DATATYPE_FIXED_DICT.isSameType = function(self, v)
	for itemkey,utype in pairs(self.dicttype) do
		if(not utype:isSameType(v[itemkey])) then
			return false;
		end
	end
	return true;
end


CityEngineLua.datatypes = {};
CityEngineLua.datatype2id = {};


CityEngineLua.datatypes["UINT8"]		= CityEngineLua.DATATYPE_UINT8;
CityEngineLua.datatypes["UINT16"]	= CityEngineLua.DATATYPE_UINT16;
CityEngineLua.datatypes["UINT32"]	= CityEngineLua.DATATYPE_UINT32;
CityEngineLua.datatypes["UINT64"]	= CityEngineLua.DATATYPE_UINT64;

CityEngineLua.datatypes["INT8"]		= CityEngineLua.DATATYPE_INT8;
CityEngineLua.datatypes["INT16"]		= CityEngineLua.DATATYPE_INT16;
CityEngineLua.datatypes["INT32"]		= CityEngineLua.DATATYPE_INT32;
CityEngineLua.datatypes["INT64"]		= CityEngineLua.DATATYPE_INT64;

CityEngineLua.datatypes["FLOAT"]		= CityEngineLua.DATATYPE_FLOAT;
CityEngineLua.datatypes["DOUBLE"]	= CityEngineLua.DATATYPE_DOUBLE;

CityEngineLua.datatypes["STRING"]	= CityEngineLua.DATATYPE_STRING;
CityEngineLua.datatypes["VECTOR2"]	= CityEngineLua.DATATYPE_VECTOR2;
CityEngineLua.datatypes["VECTOR3"]	= CityEngineLua.DATATYPE_VECTOR3;
CityEngineLua.datatypes["VECTOR4"]	= CityEngineLua.DATATYPE_VECTOR4;
CityEngineLua.datatypes["PYTHON"]	= CityEngineLua.DATATYPE_PYTHON;
CityEngineLua.datatypes["UNICODE"]	= CityEngineLua.DATATYPE_UNICODE;
CityEngineLua.datatypes["ENTITYCALL"]	= CityEngineLua.DATATYPE_ENTITYCALL;
CityEngineLua.datatypes["BLOB"]		= CityEngineLua.DATATYPE_BLOB;

CityEngineLua.datatypes[1] = CityEngineLua.datatypes["STRING"];
CityEngineLua.datatypes[2] = CityEngineLua.datatypes["UINT8"];
CityEngineLua.datatypes[3] = CityEngineLua.datatypes["UINT16"];
CityEngineLua.datatypes[4] = CityEngineLua.datatypes["UINT32"];
CityEngineLua.datatypes[5] = CityEngineLua.datatypes["UINT64"];
CityEngineLua.datatypes[6] = CityEngineLua.datatypes["INT8"];
CityEngineLua.datatypes[7] = CityEngineLua.datatypes["INT16"];
CityEngineLua.datatypes[8] = CityEngineLua.datatypes["INT32"];
CityEngineLua.datatypes[9] = CityEngineLua.datatypes["INT64"];
CityEngineLua.datatypes[10] = CityEngineLua.datatypes["PYTHON"];
CityEngineLua.datatypes[11] = CityEngineLua.datatypes["BLOB"];
CityEngineLua.datatypes[12] = CityEngineLua.datatypes["UNICODE"];
CityEngineLua.datatypes[13] = CityEngineLua.datatypes["FLOAT"];
CityEngineLua.datatypes[14] = CityEngineLua.datatypes["DOUBLE"];
CityEngineLua.datatypes[15] = CityEngineLua.datatypes["VECTOR2"];
CityEngineLua.datatypes[16] = CityEngineLua.datatypes["VECTOR3"];
CityEngineLua.datatypes[17] = CityEngineLua.datatypes["VECTOR4"];