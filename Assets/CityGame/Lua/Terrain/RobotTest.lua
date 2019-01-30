--压力测试脚本
--
RobotIns={}

RobotTest=class('RobotTest',ModelBase)


local this

local co
local tuoken
--todo:是否激活脚本
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
            --todo：创建连接并连接账号服
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
---连接账号服的回调
--todo:username需要全局
function RobotTest:login_callback()
    --清空所有网络注册
    DataManager.UnAllModelRegisterNetMsg()
    --动态注册所有as协议
    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","login","as.Login",this.n_AsLogin,this)--新版model网络注册

    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","chooseGameServer","as.ChoseCameServerACK",this.n_ChooseGameServer,this)

    DataManager.ModelRegisterNetMsg(nil,"ascode.OpCode","getServerList","as.AllGameServerInfo",this.n_AllGameServerInfo,this)

    ----1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","login")
    ----2、 填充 protobuf 内部协议数据
    local msglogion = {
        account = acount
    }
    -- 序列化成二进制数据
    local pb_login = assert(pbl.encode("as.Login", msglogion))
    --发包
  CityEngineLua.Bundle:newAndSendMsg(msgId,pb_login);
end


--todo:网络回调注册  只需要注册一次
---TODO：暂时用回调累加法 来 判定携程的释放
function RobotTest:OnRegisNet()

    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","addBuilding"), this.n_OnReceiveAddBuilding)
    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","groundChange"), this.n_OnReceiveGroundChange)

end

function RobotTest:OnRegisNets()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","login","gs.LoginACK",this.n_GsLoginSuccessfully,this)

    CityEngineLua.Message:registerNetMsg(pbl.enum("gscode.OpCode","roleLogin"),this.n_OnRoleLogin);

    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","createRole","gs.RoleInfo",this.n_CreateNewRole,this)--新版model网络注册

end


--todo:网络回调------------------------------------------------------------------------------------------------------------
--2.5《《《《《《《《《《《《《《《《《《《《
---登录as回调 发送获取服务器列表协议
function RobotTest.n_AsLogin()
    --1、 获取协议id
    local msgId = pbl.enum("ascode.OpCode","getServerList")
    ----2、 填充 protobuf 内部协议数据
    --local msglogion = pb.as.Login()
    --msglogion.account = this.username
    --local pb_login = msglogion:SerializeToString()  -- Parse Example
    ----3、 获取 protobuf 数据大小
    --local pb_size = #pb_login
    ----4、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,nil)

end

--3《《《《《《《《《《《《《《《《《《《《
---服务器列表回调
function RobotTest:n_AllGameServerInfo(msg)
    --todo：选择服务器
    DataManager.ModelSendNetMes("ascode.OpCode", "chooseGameServer",
            "as.ChoseGameServer",{ serverId =msg.infos[1].serverId})
end
--4《《《《《《《《《《《《《《《《《《《《
-----选择游戏服务器后回调, 发送登录游戏服务器的请求
function RobotTest:n_ChooseGameServer(token)
   --todo:连接gs
    tuoken=token.code
    this._networkInterface:reset()
    this._networkInterface = City.NetworkInterface.New();
    CityEngineLua._networkInterface= this._networkInterface
    this._networkInterface:connectTo("192.168.0.51", "20000", this.onConnectTo_baseapp_callback, nil);

end
--5《《《《《《《《《《《《《《《《《《《《
---连接gs成功的回调  发送gs登录
function RobotTest:onConnectTo_baseapp_callback()
    --清空所有网络注册
    DataManager.UnAllModelRegisterNetMsg()
    --gs 登录
    this:OnRegisNet()
    this:OnRegisNets()

    ----1、 获取协议id
    local msgId = pbl.enum("gscode.OpCode","login")
    ----2、 填充 protobuf 内部协议数据
    local lMsg = { account = acount, token =tuoken}
    local pMsg = assert(pbl.encode("gs.Login", lMsg))
    ----3、 创建包，填入数据并发包
    CityEngineLua.Bundle:newAndSendMsg(msgId,pMsg);

end
--6《《《《《《《《《《《《《《《《《《《《
---gs登录成功回调
function RobotTest:n_GsLoginSuccessfully()
    --todo：创角
    DataManager.ModelSendNetMes("gscode.OpCode", "createRole","gs.CreateRole",
            { male =male ,name =name ,companyName =cNmae ,faceId = headIma })

end
--7《《《《《《《《《《《《《《《《《《《《
---创角回调后 角色登录
function RobotTest:n_CreateNewRole(pMsg)
    DataManager.ModelSendNetMes("gscode.OpCode", "roleLogin","gs.Id",{ id = pMsg.id })
end

--8《《《《《《《《《《《《《《《《《《《《
function RobotTest.n_OnRoleLogin( stream )
    --todo:发送创建建筑协议
    local t=stream
    --买地
    for i, ground in ipairs(grounds) do
        PlayerTempModel.tempTestAddGroung(ground.x1,ground.y1, ground.x2,ground.y2)
    end
    --造建筑
    for i, build in ipairs(builds) do
        PlayerTempModel.m_ReqAddBuilding(build.id, math.floor(build.x) ,  math.floor(build.y))
    end

end

--携程是否继续
function  RobotTest:isContinue()
    startNum= startNum+1
    if startNum >=endNum then
        coroutine.resume(co)
    end
end

--造建筑回调
function  RobotTest.n_OnReceiveAddBuilding(stream)
    this:isContinue()
end

--买地回调
function  RobotTest.n_OnReceiveGroundChange(stream)
    this:isContinue()
end
