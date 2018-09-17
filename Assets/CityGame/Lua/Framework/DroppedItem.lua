require "Framework/Interface/GameObject"

CityEngineLua.DroppedItem = {
};

CityEngineLua.DroppedItem = CityEngineLua.GameObject:New(CityEngineLua.DroppedItem);--继承

function CityEngineLua.DroppedItem:New(me)
    me = me or {};
    setmetatable(me, self);
    self.__index = self;
    return me;
end
