require "Framework/Interface/GameObject"
require "Logic/SkillBox"
require "Logic/Skill"
local log = log

CityEngineLua.Avatar = {
	itemDict = {},
    equipItemDict = {},
};

CityEngineLua.Avatar = CityEngineLua.GameObject:New(CityEngineLua.Avatar);--继承

function CityEngineLua.Avatar:New(me)
    me = me or {};
    setmetatable(me, self);
    self.__index = self;
    return me;
end

function CityEngineLua.Avatar:__init__( )
	if self:isPlayer() then
        Event.AddListener("relive", self.relive);
        Event.AddListener("updatePlayer", self.updatePlayer);
        Event.AddListener("sendChatMessage", self.sendChatMessage);
    end
end

function CityEngineLua.Avatar:updatePlayer(x, y, z, yaw)
    self.position.x = x;
    self.position.y = y;
    self.position.z = z;

    self.direction.z = yaw;
end

function CityEngineLua.Avatar:onEnterWorld()
    if self:isPlayer() then
        Event.Brocast("onAvatarEnterWorld", self);
        SkillBox.Pull();
    end
end

function CityEngineLua.Avatar:relive(type)
    self:cellCall({"relive", type});
end

function CityEngineLua.Avatar:sendChatMessage(msg)
    self:baseCall({"sendChatMessage", self.name .. ": " .. msg});
end

function CityEngineLua.Avatar:useTargetSkill(skillID, target)
    local skill = SkillBox.Get(skillID);
    if (skill == nil) then
        return 4;
    end

    if target == nil then
        return 4;
    end
    local errorCode = skill:validCast(self, target);
    if (errorCode == 0) then         
        skill:use(self, target);
        return errorCode;
    end
    return errorCode;
end

-------client method-----------------------------------

function CityEngineLua.Avatar:ReceiveChatMessage(msg)
    Event.Brocast("ReceiveChatMessage", msg);
end

function CityEngineLua.Avatar:onAddSkill(skillID)
    log(self.className .. "::onAddSkill(" .. skillID .. ")");

    local skill = Skill:New();
    skill.id = skillID;
    skill.name = skillID .. " ";
    if skillID == 1 then
        skill.displayType = 1;
        skill.canUseDistMax = 30;
        skill.skillEffect = "Ice1";
        skill.name = "魔法球";
    elseif skillID == 2 then
        skill.displayType = 1;
        skill.canUseDistMax = 30;
        skill.skillEffect = "Fire1";
        skill.name = "火球";
    elseif skillID == 3 then
        skill.displayType = 1;
        skill.canUseDistMax = 20;
        skill.skillEffect = "Medical1";
        skill.name = "治疗";
    elseif skillID == 4 then
        skill.displayType = 0;
        skill.canUseDistMax = 5;
        skill.skillEffect = "MagicEffect1";
        skill.name = "斩击";
    elseif skillID == 5 then
        skill.displayType = 0;
        skill.canUseDistMax = 5;
        skill.skillEffect = "LightningEffect1";
        skill.name = "挥击";
    elseif skillID == 6 then
        skill.displayType = 0;
        skill.canUseDistMax = 5;
        skill.skillEffect = "BloodEffect1";
        skill.name = "吸血";
    else
        skill.displayType = 0;
        skill.canUseDistMax = 5;
        skill.skillEffect = "";
        skill.name = "未知";
    end;

    SkillBox.Add(skill);

end

function CityEngineLua.Avatar:onRemoveSkill(skillID)
    log(className .. "::onRemoveSkill(" .. skillID .. ")");
    SkillBox.Remove(skillID);
end