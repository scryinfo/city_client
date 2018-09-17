require "Framework/Interface/GameObject"

CityEngineLua.Monster = {
};

CityEngineLua.Monster = CityEngineLua.GameObject:New(CityEngineLua.Monster);--继承

function CityEngineLua.Monster:New(me)
    me = me or {};
    setmetatable(me, self);
    self.__index = self;
    return me;
end
