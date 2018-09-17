--
-- Created by IntelliJ IDEA.
-- AUTHOR: ChenCY
-- Date: 2018/7/3 13:24
--

CityEngineLua.EntityDef = {}

CityEngineLua.datatypes = {};
CityEngineLua.datatype2id = {};

function CityEngineLua.EntityDef:New()
    local me =  {};
    setmetatable(me, self);
    self.__index = self;

    me.initDataType()
    me.bindMessageDataType()

    return me;
end

function CityEngineLua.EntityDef.clear()
    CityEngineLua.datatypes = {};
    CityEngineLua.datatype2id = {};

    CityEngineLua.EntityDef.initDataType()
    CityEngineLua.EntityDef.bindMessageDataType()
end

function CityEngineLua.EntityDef.initDataType()
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
end

function CityEngineLua.EntityDef.bindMessageDataType()
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
end