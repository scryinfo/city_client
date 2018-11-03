require "Framework/Interface/GameObject"
local log = log

CityEngineLua.Account = {
	avatars = {},
};

CityEngineLua.Account = CityEngineLua.GameObject:New(CityEngineLua.Account);--继承

function CityEngineLua.Account:New(me)
    me = me or {};
    setmetatable(me, self);
    self.__index = self;
    return me;
end

function CityEngineLua.Account:__init__( )
	--Event.Brocast("c_LoginSuccessfully", true)
    self:baseCall({"reqAvatarList"});
end

function CityEngineLua.Account:protobuftest()
    --[[
    local msg = person_pb.Person()
    msg.id = 100
    msg.name = "foo"
    msg.email = "bar"
    local pb_data = msg:SerializeToString()

    -- Parse Example
    local msg = person_pb.Person()
    msg:ParseFromString(pb_data)
    logDebug(msg.id, msg.name, msg.email)
    ]]--
    --mod.PERSON_EMAIL_FIELD;
    --local msg1 = pb.person_pb;

end

function CityEngineLua.Account:reqCreateAvatar(name, roleType)
    local role = 1;
    if (roleType == "战士") then
        role = 1;
    elseif (roleType == "法师") then
        role = 2;
    end
    self:baseCall({ "reqCreateAvatar", name, role });
end

function CityEngineLua.Account:reqRemoveAvatar(name)
    ct.log("Account::reqRemoveAvatar: name=" .. name);
    self:baseCall({"reqRemoveAvatar", name});
end

function CityEngineLua.Account:reqSelectAvatarGame(dbid)
    ct.log("Account::reqSelectAvatarGame: dbid=" .. tostring(dbid));
    self:baseCall({"selectAvatarGame", dbid});
end

--------------回调-------------------------------------------
function CityEngineLua.Account:onReqAvatarList( infos )
    self.avatars = {};

    local listinfos = infos["values"];

    ct.log("Account::onReqAvatarList: avatarsize=" .. #listinfos);
    
    for i, info in ipairs(listinfos) do
        ct.log("Account::onReqAvatarList: name" .. i .. "=" .. info["name"]);
        self.avatars[info["dbid"]] = info;
    end
    self:protobuftest();
    Event.Brocast("onReqAvatarList", self.avatars);
end

function CityEngineLua.Account:onCreateAvatarResult(retcode, info)
    if (retcode == 0) then
        self.avatars[info["dbid"]] = info;
        ct.log("Account::onCreateAvatarResult: name=" .. info["name"]);
    else
        ct.log("Account::onCreateAvatarResult: retcode=" .. retcode);
        if (retcode == 3) then
            ct.log("角色数量不能超过三个！");
        end
    end

    Event.Brocast("onCreateAvatarResult", retcode, self.avatars);
end

function CityEngineLua.Account:onRemoveAvatar(dbid)
    ct.log("Account::onRemoveAvatar: dbid=" .. tostring(dbid));


    for k,v in pairs(self.avatars) do
        if(k == dbid) then
            self.avatars[k] = nil;
        end
    end
    -- ui event
    Event.Brocast("onRemoveAvatar", dbid, self.avatars);
end