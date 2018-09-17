require "Framework/Interface/GameObject"

CityEngineLua.Gate = {
};

CityEngineLua.Gate = CityEngineLua.GameObject:New(CityEngineLua.Gate);--继承

function CityEngineLua.Gate:New(me)
    me = me or {};
    setmetatable(me, self);
    self.__index = self;
    return me;
end
