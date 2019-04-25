----City项目的全局数据
local uTime = UnityEngine.Time
local gettime = tolua.gettime

local loginner = print
local getIdHead = function(id)
	return "["..id.."]";
end
ct ={
	G_LOG = true, --是否输出日志， 为false的话，不输出任何日志
	G_DEBUGLOG = true, --是否打开调试日志
	G_UNITTEST = true,	--是否打开单元测试
	G_PERFORMANCETEST = false,	--是否打开性能测试
	G_TIMEOUT_NET = 12,
	G_LAST_HARTBEAT = uTime.time,
	log = function(logid,s,...)
		if s == nil then
			return
		end
		local plgid = TestGroup.get_TestGroupId(logid)
		local palgid = TestGroup.get_ActiveTestGroupId(logid)
		if plgid == nil or  palgid == nil then
			return
		end
		assert(s)
		loginner(getIdHead(plgid) .. s,...);
	end
}
CtrlNames = {
	Login = "LoginCtrl",
	SelectAvatar = "SelectAvatarCtrl",
	CreateAvatar = "CreateAvatarCtrl",
	GameWorld = "GameWorldCtrl",
	PlayerHead = "PlayerHeadCtrl",
	TargetHead = "TargetHeadCtrl",

	Wages = "WagesCtrl",
	Warehouse = "WarehouseCtrl",
	Transport = "TransportCtrl",
	Shelf = "ShelfCtrl",
	TransportOrder = "TransportOrderCtrl",
	AddTransport = "AddTransportCtrl",
	GroundAuction = "GroundAuctionCtrl",  --拍卖
	House = "HouseCtrl",  --住宅
	GameMainInterface = "GameMainInterfaceCtrl",--游戏主界面
	RoleManager = "RoleManagerCtrl",--角色管理界面
	ServerList = "ServerListCtrl",--选服页面
	CreateRole = "CreateRoleCtrl",--创角页面

	Material = "MaterialCtrl", --原料厂
	Processing = "ProcessingCtrl",  --加工厂
	RetailStores = "RetailStoresCtrl",  --零售店
	BtnDialogPage = "BtnDialogPageCtrl",  --单个按钮的弹窗
	InputDialogPage = "InputDialogPageCtrl",  --单个输入框的弹窗
	Exchange = "ExchangeCtrl",  --交易所

	TestExchangeCtrl = "TestExchangeCtrl",  --测试啊测试
	TestLoopScoreCtrl = "TestLoopScoreCtrl",  --测试啊测试
	TestExchangeScrollItemCtrl = "TestExchangeScrollItemCtrl",  --测试啊测试
	CenterWareHouse = "CenterWareHouseCtrl", --中心仓库
	MessageTooltip = "MessageTooltipCtrl",--玩家信息提示框
	MunicipalCtrl="MunicipalCtrl",--市镇设施
	AdvertisementPosCtrl="AdvertisementPosCtrl",--广告位
	GameNoitce = "GameNoticeCtrl", --通知
	NoMessage = "NoMessageCtrl" --没有信息
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
	GameMainInterface = "GameMainInterfaceModel",--游戏主界面
	RoleManager = "RoleManagerModel",--游戏管理界面
	ServerList = "ServerListModel",--选服页面
	CreateRole = "CreateRoleModel",--创角页面
	Material = "MaterialModel",  --原料厂
	RetailStores = "RetailStoresModel",  --零售店
	Processing = "ProcessingModel",  --加工厂
	tempTransport = "tempTransportModel",   --临时运输
	Exchange = "ExchangeModel",  --交易所
	ExchangeTransaction = "ExchangeTransactionModel",  --交易界面
	ExchangeDetail = "ExchangeDetailModel",  --交易物品详情界面
	PlayerTemp = "PlayerTempModel",  --玩家数据，临时创建
	CenterWareHouse = "CenterWareHouseModel",--中心仓库
	Municipal="MunicipalModel",--市镇设施
	AdvertisementPos="AdvertisementPos",
	ManageAdvertisementPos="ManageAdvertisementPos",
	ScienceSellHall="ScienceSellHallModel",--科技交易所
	friends = "FriendsModel", -- 好友
	Laboratory = "LaboratoryModel",  --研究所
	Chat = "ChatModel", -- 聊天
	GroundTrans = "GroundTransModel",  --土地交易
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
	GroundAuction = 1,  --土地拍卖
	BuildingTransfer = 2,  --建筑转让
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
	Middle=2,
}

--建筑类型
BuildingType =
{
	House = 0,  --住宅
	MaterialFactory = 1,  --原料厂
	Municipal = 2,--推广
	ProcessingFactory = 4,  --加工厂
	Laboratory = 5,  --研究所
	RetailShop = 6,  --零售店
	TalentCenter = 7,--人才中心
}
--建筑所属
Buildingowner=
{
   master=1,--主人的
   other=2,--其他人的
}

LanguageType={
	Chinese=0,
	English=1,
}

BuildingBubbleType={
	small=1,
	big=2,
    close=3,
}

--仓库 --货架 --运输(通用)
BuildingInType =
{
	Shelf = 0,  --货架
	Warehouse = 1,  --仓库
	Transport = 2,  --运输
	ProductionLine = 3,  --生产线
	RetailShelf = 4,  --零售店货架
}

--单输入框会响应的服务器协议类型
InputDialogPageServerType =
{
	UpdateBuildingName = 0,  --修改建筑名称
}

--相机移动状态类型
TouchStateType =
{
	NormalState = 0, 	--正常状态（可点击，可拖拽）
	ConstructState = 1, --修建建筑状态（不可点击，可拖拽）
	UIState = 2, 		--UI查看状态(不可点击，不可拖拽）
}

Util = LuaFramework.Util;
AppConst = LuaFramework.AppConst;
LuaHelper = LuaFramework.LuaHelper;

resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
buildMgr = LuaHelper.GetBuildManager();
rayMgr = LuaHelper.GetRayManager();

WWW = UnityEngine.WWW;
GameObject = UnityEngine.GameObject;

