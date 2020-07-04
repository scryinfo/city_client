--Stress test script
--
RobotIns={}

RobotTest=class('RobotTest',ModelBase)


local this

local co
local tuoken
--todo:Whether to activate the script
function RobotTest:initialize()
    self.isActive=false
    this=self
    this:Start()
end

function RobotTest.Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.B) then
        this.CreateRobot()
    end
end


local acount,builds ,grounds,headIma,male,name,cNmae,startNum,endNum
function RobotTest:Start()
    if  not this.isActive then    return      end

    UpdateBeat:Add(this.Update, this)
    co= coroutine.create(function ()

        for i, Robot in ipairs(RobotConfig) do
             --todo：Create connection and connect account service
            acount=Robot.acount
            builds=Robot.buildings
            grounds=Robot.ground
            startNum=0
            endNum=#builds+#grounds
            headIma=Robot.headIma
            male=Robot.male
            name=Robot.name
            cNmae=Robot.commpanyName

            CityEngineLua._networkInterface:reset()
            this._networkInterface=City.NetworkInterface.New();
            CityEngineLua._networkInterface= this._networkInterface
            this._networkInterface:connectTo("192.168.0.51", "9001", this.login_callback, nil);

            coroutine.yield()
        end
    end)
end

--1《《《《《《《《《《《《《《《《《《《《

function RobotTest:CreateRobot()
    coroutine.resume(co)
end

--2《《《《《《《《《《《《《《《《《《《《
---Callback for connecting to account service
--todo:username Need global
function RobotTest:login_callback()
    --Clear all network registrations
    DataManager.UnAllModelRegisterNetMsg()
    --Register all as protocols dynamically
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","login","as.Login",this.n_AsLogin,this)--New version of online registration

    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","chooseGameServer","as.ChoseCameServerACK",this.n_ChooseGameServer,this)

    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","getServerList","as.AllGameServerInfo",this.n_AllGameServerInfo,this)

    ----1、 Acquisition Agreement id
    local msgId = pbl.enum("ascode.OpCode","login")
    ----2、 Fill in protobuf internal agreement data 
    local msglogion = {
        account = acount
    }
    -- Serialized into binary data
    local pb_login = assert(pbl.encode("as.Login", msglogion))
    --Outsourcing
  CityEngineLua.Bundle:newAndSendMsg(msgId,pb_login);
end


--todo:Network callback registration only needs to be registered once
---TODO：Temporarily use the callback accumulation method to determine 
function RobotTest:OnRegisNet()

    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addBuilding"), this.n_OnReceiveAddBuilding)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","groundChange"), this.n_OnReceiveGroundChange)

end

function RobotTest:OnRegisNets()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","login","gs.LoginACK",this.n_GsLoginSuccessfully,this)

    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),this.n_OnRoleLogin);

    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","createRole","gs.RoleInfo",this.n_CreateNewRole,this)--New version of online registration

end


--todo:Network callback------------------------------------------------------------------------------------------------------------
--2.5《《《《《《《《《《《《《《《《《《《《
---Login callback Send protocol to get server list
function RobotTest.n_AsLogin()
    --1、 Acquisition Agreement id
    local msgId = pbl.enum("ascode.OpCode","getServerList")
    ----2、 Fill protobuf internal protocol data
    --local msglogion = pb.as.Login()
    --msglogion.account = this.username
    --local pb_login = msglogion:SerializeToString()  -- Parse Example
    ----3、 Get protobuf data size
    --local pb_size = #pb_login
    ----4、Create a package and fill in data concurrently
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)

end

--3《《《《《《《《《《《《《《《《《《《《
---Server list callback
function RobotTest:n_AllGameServerInfo(msg)
    --todo： Select server
    DataManager.ModelSendNetMes("ascode.OpCode", "chooseGameServer",
            "as.ChoseGameServer",{ serverId =msg.infos[1].serverId})
end
--4《《《《《《《《《《《《《《《《《《《《
-----Callback after selecting a game server and sending a request to log in
function RobotTest:n_ChooseGameServer(token)
   --todo:Connect gs
    tuoken=token.code
    this._networkInterface:reset()
    this._networkInterface = City.NetworkInterface.New();
    CityEngineLua._networkInterface= this._networkInterface
    this._networkInterface:connectTo("192.168.0.51", "20000", this.onConnectTo_baseapp_callback, nil);

end
--5《《《《《《《《《《《《《《《《《《《《
---Callback for successful gs connection Send gs login
function RobotTest:onConnectTo_baseapp_callback()
    --Clear all network registrations
    DataManager.UnAllModelRegisterNetMsg()
    --gs log in
    this:OnRegisNet()
    this:OnRegisNets()

    ----1、 Acquisition Agreement id
    local msgId = pbl.enum("gscode.OpCode","login")
    ----2、 Fill in protobuf internal agreement data  
    local lMsg = { account = acount, token =tuoken}
    local pMsg = assert(pbl.encode("gs.Login", lMsg))
    ----3、 Create a package and fill in data concurrently
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);

end
--6《《《《《《《《《《《《《《《《《《《《
---gs Login success callback
function RobotTest:n_GsLoginSuccessfully()
    --todo：Creating angle
    DataManager.ModelSendNetMes("gscode.OpCode", "createRole","gs.CreateRole",
            { male =male ,name =name ,companyName =cNmae ,faceId = headIma })

end
--7《《《《《《《《《《《《《《《《《《《《
---After the corner is called back, role login
function RobotTest:n_CreateNewRole(pMsg)
    DataManager.ModelSendNetMes("gscode.OpCode", "roleLogin","gs.Id",{ id = pMsg.id })
end

--8《《《《《《《《《《《《《《《《《《《《
function RobotTest.n_OnRoleLogin( stream )
    --todo:Send to create building agreement

    local t=stream
    --Land purchase
    for i, ground in ipairs(grounds) do
        PlayerTempModel.tempTestAddGroung(ground.x1,ground.y1, ground.x2,ground.y2)
    end
    --Building
    for i, build in ipairs(builds) do
        PlayerTempModel.m_ReqAddBuilding(build.id, math.floor(build.x) ,  math.floor(build.y))
    end

end

--Whether Ctrip continues
function  RobotTest:isContinue()
    startNum= startNum+1
    if startNum >=endNum then
        coroutine.resume(co)
    end
end

--Building callback
function  RobotTest.n_OnReceiveAddBuilding(stream)
    this:isContinue()
end

--Land purchase callback
function  RobotTest.n_OnReceiveGroundChange(stream)
    this:isContinue()
end
