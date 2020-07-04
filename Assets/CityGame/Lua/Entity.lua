-------------------------------------------------------------------------------------------
--												entity
-----------------------------------------------------------------------------------------*/


CityEngineLua.Entity =
{
	-- The position and orientation of the current player's last synchronization to the server
	-- These two properties are for the engine CityEngine.cs, do not modify it elsewhere
	_entityLastLocalPos = Vector3.New(0.0, 0.0, 0.0),
	_entityLastLocalDir = Vector3.New(0.0, 0.0, 0.0),

	id = 0,
	className = "",
	position = Vector3.New(0.0, 0.0, 0.0),
	direction = Vector3.New(0.0, 0.0, 0.0),
	velocity = 0.0,

	isOnGround = true,
		
	baseEntityCall = nil,
	cellEntityCall = nil,
	
	-- set to true after enterworld
	inWorld = false,


	-- For players themselves, it indicates whether they are controlled by other players;
	-- For other entities, it indicates whether I control this entity
	isControlled = false;
	
	-- Set to true after __init__ is called
	inited = false,		
	renderObj = nil,
	
}

CityEngineLua.Entity.New = function( self , me )
	me = me or {};
	setmetatable(me, self);
	self.__index = self;
    return me;  
end

CityEngineLua.Entity.__init__ = function(self)
end

CityEngineLua.Entity.callPropertysSetMethods = function(self)

	local currModule = CityEngineLua.moduledefs[self.className];
	for k,v in pairs(currModule.propertys) do
		local propertydata = v;
		local properUtype = propertydata[1];
		local name = propertydata[3];
		local setmethod = propertydata[6];
		local flags = propertydata[7];
		local oldval = self[name];
		
		if(setmethod ~= nil) then
			-- The base class attribute or the cell class attribute will trigger the set_* method after entering the world
			if(flags == 0x00000020 or flags == 0x00000040) then
				if(self.inited and not self.inWorld) then
					setmethod(self, oldval);
				end
			else
				if(self.inWorld) then
					setmethod(self, oldval);
				end
			end
		end
	end
end

CityEngineLua.Entity.onDestroy = function(self)
end

CityEngineLua.Entity.isPlayer = function(self)
	return self.id == CityEngineLua.entity_id;
end

CityEngineLua.Entity.baseCall = function(self, arguments)
	if(#arguments < 1) then
		ct.log('CityEngineLua.Entity::baseCall: not fount interfaceName~');
		return;
	end

	if(self.baseEntityCall == nil) then 
		ct.log('CityEngineLua.Entity::baseCall: baseEntityCall is None~');
		return;			
	end
	
	local method = CityEngineLua.moduledefs[self.className].base_methods[arguments[1]];
	local methodID = method[1];
	local args = method[4];
	
	if(#arguments - 1 ~= #args) then
		ct.log("CityEngineLua.Entity::baseCall: args(" .. (#arguments - 1) .. "~= " .. #args .. ") size is error!");
		return;
	end
	
	self.baseEntityCall:newCall();
	self.baseEntityCall.bundle:writeUint16(0);
	self.baseEntityCall.bundle:writeUint16(methodID);


	for i=1, #args do
		if(args[i]:isSameType(arguments[i + 1])) then
			args[i]:addToStream(self.baseEntityCall.bundle, arguments[i + 1]);
        end     
	end
	
	self.baseEntityCall:sendCall(nil);
end

CityEngineLua.Entity.cellCall = function(self, arguments)
	if(#arguments < 1) then
		ct.log('CityEngineLua.Entity::cellCall: not fount interfaceName!');
		return;
	end
	
	if(self.cellEntityCall == nil) then
		ct.log('CityEngineLua.Entity::cellCall: cellEntityCall is None!');
		return;			
	end
	
	local method = CityEngineLua.moduledefs[self.className].cell_methods[arguments[1]];
	local methodID = method[1];
	local args = method[4];
	
	if(#arguments - 1 ~= #args) then
		ct.log("CityEngineLua.Entity::cellCall: args(" .. (#arguments - 1) .. "~= " .. #args .. ") size is error!");
		return;
	end
	
	self.cellEntityCall:newCall();
	self.cellEntityCall.bundle:writeUint16(0);
	self.cellEntityCall.bundle:writeUint16(methodID);
	
	for i=1, #args do
		if(args[i]:isSameType(arguments[i + 1])) then
			args[i]:addToStream(self.cellEntityCall.bundle, arguments[i + 1]);
		end
	end
	
	self.cellEntityCall:sendCall(nil);
end
	
CityEngineLua.Entity.enterWorld = function(self)
	--ct.log(self.className .. '::enterWorld: ' .. self.id);
	self.inWorld = true;
	self:onEnterWorld();
	
	Event.Brocast("onEnterWorld", self);
end

CityEngineLua.Entity.onEnterWorld = function(self)
end
	
CityEngineLua.Entity.leaveWorld = function(self)
	--ct.log(self.className .. '::leaveWorld: ' .. self.id);
	self.inWorld = false;
	self.onLeaveWorld();
	
	Event.Brocast("onLeaveWorld", self);
end

CityEngineLua.Entity.onLeaveWorld = function(self)
end
	
CityEngineLua.Entity.enterSpace = function(self)
	ct.log(self.className .. '::enterSpace: ' .. self.id);
	self.onEnterSpace();
	--City.Event.fire("onEnterSpace", self);
end

CityEngineLua.Entity.onEnterSpace = function(self)
end
	
CityEngineLua.Entity.leaveSpace = function(self)
	ct.log(self.className .. '::leaveSpace: ' .. self.id);
	self.onLeaveSpace();
	--City.Event.fire("onLeaveSpace", self);
end

CityEngineLua.Entity.onLeaveSpace = function(self)
end


CityEngineLua.Entity.onUpdateVolatileData = function(self)
end


-- For players themselves, it indicates whether they are controlled by other players;
-- For other entities, it indicates whether I control this entity
CityEngineLua.Entity.onControlled = function(self, isControlled_)
end
