require "Framework/Interface/GameObject"

CityEngineLua.NPC = {
};

CityEngineLua.NPC = CityEngineLua.GameObject:New(CityEngineLua.NPC);--继承

function CityEngineLua.NPC:New(me)
    me = me or {};
    setmetatable(me, self);
    self.__index = self;
    return me;
end
