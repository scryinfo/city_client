--全局设置
CityGlobal ={
	G_LOG = true, --是否输出日志， 为false的话，不输出任何日志
	G_DEBUGLOG = true, --是否打开调试日志
	G_UNITTEST = true,	--是否打开单元测试
	G_PERFORMANCETEST = false,	--是否打开性能测试
}

CtrlNames = {
	Login = "LoginCtrl",
	SelectAvatar = "SelectAvatarCtrl",
	CreateAvatar = "CreateAvatarCtrl",
	GameWorld = "GameWorldCtrl",
	PlayerHead = "PlayerHeadCtrl",
	TargetHead = "TargetHeadCtrl",
	GroundAuction = "GroundAuctionCtrl",  --拍卖
	House = "HouseCtrl",  --住宅
}

ModelNames = {
	Login = "LoginModel",
	SelectAvatar = "SelectAvatarModel",
	CreateAvatar = "CreateAvatarModel",
	GameWorld = "GameWorldModel",
	PlayerHead = "PlayerHeadModel",
	TargetHead = "TargetHeadModel",
	PieChart = "PieChart",  --饼图测试
	GroundAuction = "GroundAuctionModel",  --拍卖
	GameBubbleManager = "GameBubbleManager",  --游戏中的气泡
	BuildingInfo = "BuildingInfoModel",  --建筑信息
	House = "HouseModel",  --住宅
}

PanelNames = {
	"LoginPanel",
	"TopBarPanel",
	"MainPagePanel",
	"NoticePanel",
	"SkillPagePanel",
	"LineChartPanel",
	"SelectAvatarPanel",
	"CreateAvatarPanel",
	"GameWorldPanel",
	"PlayerHeadPanel",
	"TargetHeadPanel",
	"GroundAuctionPanel",  --拍卖
	"BuildingInfoRightPanel",  --建筑右侧信息小界面
	"BuildingInfoPanel",  --建筑信息界面
	"BuildingTransferPanel",  --转让界面
	"HousePanel",  --住宅
}

SYSEVENT =
{
	SYSEVENT_DEFAULT = 0,
	SYSEVENT_DISCONNECT =1,
}

SERVER_TYPE =
{
	SERVER_TYPE_AS = 0, --account server
	SERVER_TYPE_GS =1, --game server
}

SocketError =
{
	SocketError = -1,
	Success = 0,
	OperationAborted = 995,
	IOPending = 997,
	Interrupted = 10004,
	AccessDenied = 10013,
	Fault = 10014,
	InvalidArgument = 10022,
	TooManyOpenSockets = 10024,
	WouldBlock = 10035,
	InProgress = 10036,
	AlreadyInProgress = 10037,
	NotSocket = 10038,
	DestinationAddressRequired = 10039,
	MessageSize = 10040,
	ProtocolType = 10041,
	ProtocolOption = 10042,
	ProtocolNotSupported = 10043,
	SocketNotSupported = 10044,
	OperationNotSupported = 10045,
	ProtocolFamilyNotSupported = 10046,
	AddressFamilyNotSupported = 10047,
	AddressAlreadyInUse = 10048,
	AddressNotAvailable = 10049,
	NetworkDown = 10050,
	NetworkUnreachable = 10051,
	NetworkReset = 10052,
	ConnectionAborted = 10053,
	ConnectionReset = 10054,
	NoBufferSpaceAvailable = 10055,
	IsConnected = 10056,
	NotConnected = 10057,
	Shutdown = 10058,
	TimedOut = 10060,
	ConnectionRefused = 10061,
	HostDown = 10064,
	HostUnreachable = 10065,
	ProcessLimit = 10067,
	SystemNotReady = 10091,
	VersionNotSupported = 10092,
	NotInitialized = 10093,
	Disconnecting = 10101,
	TypeNotFound = 10109,
	HostNotFound = 11001,
	TryAgain = 11002,
	NoRecovery = 11003,
	NoData = 11004
}

--建筑气泡类型
BubblleType =
{
	Default = 0,
	GroundAuction = 1,
	BuildingTransfer = 2,
}

--建筑首页左右侧信息小组件的状态
BuildingInfoToggleState =
{
	Close = 0,
	Open = 1.
}

--建筑首页对应toggle组件在左还是右
BuildingInfoTogglePos =
{
	Left = 0,
	Right = 1,
}

--建筑类型
BuildingType =
{
	House = 0,
	MaterialFactory = 1,
}

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;

