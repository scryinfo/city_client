
CityEngineLua.EntityCall = {}


CityEngineLua.ENTITYCALL_TYPE_CELL = 0;-- CELL_ENTITYCALL
CityEngineLua.ENTITYCALL_TYPE_BASE = 1;-- BASE_ENTITYCALL



function CityEngineLua.EntityCall:New()
	local me =  {};
	setmetatable(me, self);
	self.__index = self;

	me.id = 0;
	me.className = "";
	me.type = CityEngineLua.ENTITYCALL_TYPE_CELL;
	me.networkInterface_ = CityEngineLua._networkInterface;
	me.bundle = nil;

    return me;
end

function CityEngineLua.EntityCall:isBase( )
	return self.type == CityEngineLua.ENTITYCALL_TYPE_BASE;
end

function CityEngineLua.EntityCall:isCell( )
	return self.type == CityEngineLua.ENTITYCALL_TYPE_CELL;
end


	----Create a new EntityCall

function CityEngineLua.EntityCall:newCall()

	if(self.bundle == nil) then
		self.bundle = CityEngineLua.Bundle:new();
	end
	
	if(self.type == CityEngineLua.ENTITYCALL_TYPE_CELL) then
		self.bundle:newMessage(CityEngineLua.messages["Baseapp_onRemoteCallCellMethodFromClient"]);
	else
		self.bundle:newMessage(CityEngineLua.messages["Entity_onRemoteMethodCall"]);
	end

	self.bundle:writeInt32(self.id);
	
	return self.bundle;
end


	---Send this EntityCall to the server

function CityEngineLua.EntityCall:sendCall(inbundle)

	if(inbundle == nil) then
		inbundle = self.bundle;
	end
	
	inbundle:send();
	
	if(inbundle == self.bundle) then
		self.bundle = nil;
	end
end