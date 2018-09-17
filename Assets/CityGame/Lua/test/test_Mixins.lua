---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/8/21 11:12
---

local class = require 'Framework/class'
HasWings = { -- HasWings is a module, not a class. It can be "included" into classes
    fly = function(self)
        print('flap flap flap I am a ' .. self.class.name)
    end
}

Animal = class('Animal')

Insect = class('Insect', Animal) -- or Animal:subclass('Insect')

Worm = class('Worm', Insect) -- worms don't have wings

Bee = class('Bee', Insect)
Bee:include(HasWings) --Bees have wings. This adds fly() to Bee

Mammal = class('Mammal', Animal)

Fox = class('Fox', Mammal) -- foxes don't have wings, but are mammals

Bat = class('Bat', Mammal)
Bat:include(HasWings) --Bats have wings, too.


--[[
Output:
flap flap flap I am a Bee
flap flap flap I am a Bat
]]--


