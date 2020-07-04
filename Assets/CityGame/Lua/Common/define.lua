----Global data of the City project
local uTime = UnityEngine.Time
local gettime = tolua.gettime

local loginner = print
local getIdHead = function(id)
	return "["..id.."]";
end
ct ={
	G_LOG = true, --Whether to output logs, if false, no logs are output
	G_DEBUGLOG = true, --Whether to open the debug log
	G_UNITTEST = true,	--Whether to open unit tests
	G_PERFORMANCETEST = false,	--Whether to open the performance test
	G_TIMEOUT_NET = 12,
	G_LAST_HARTBEAT = uTime.time,
	G_Last_SendHARTBEATTime = uTime.time,
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
	GroundAuction = "GroundAuctionCtrl",  --auction
	House = "HouseCtrl",  --Residential
	GameMainInterface = "GameMainInterfaceCtrl",--Game main interface
	RoleManager = "RoleManagerCtrl",--Role management interface
	ServerList = "ServerListCtrl",--Service page
	CreateRole = "CreateRoleCtrl",--Corner page

	Material = "MaterialCtrl", --Raw material factory
	Processing = "ProcessingCtrl",  --Processing plant
	RetailStores = "RetailStoresCtrl",  --Retail store
	BtnDialogPage = "BtnDialogPageCtrl",  --Single button popup
	InputDialogPage = "InputDialogPageCtrl",  --Pop-up window for a single input box
	Exchange = "ExchangeCtrl",  --Exchange

	TestExchangeCtrl = "TestExchangeCtrl",  --Test test
	TestLoopScoreCtrl = "TestLoopScoreCtrl", 
	TestExchangeScrollItemCtrl = "TestExchangeScrollItemCtrl",  
	CenterWareHouse = "CenterWareHouseCtrl", --Central warehouse
	MessageTooltip = "MessageTooltipCtrl",--Player information prompt box
	MunicipalCtrl="MunicipalCtrl",--Town facilities
	AdvertisementPosCtrl="AdvertisementPosCtrl",--Ad slot
	GameNoitce = "GameNoticeCtrl", --Notice
	NoMessage = "NoMessageCtrl" --No message
}

ModelNames = {
	Login = "LoginModel",
	SelectAvatar = "SelectAvatarModel",
	CreateAvatar = "CreateAvatarModel",
	GameWorld = "GameWorldModel",
	PlayerHead = "PlayerHeadModel",
	TargetHead = "TargetHeadModel",
	PieChart = "PieChart",  --Pie chart test
	GroundAuction = "GroundAuctionModel",  --auction
	GameBubbleManager = "GameBubbleManager",  --Bubbles in the game
	BuildingInfo = "BuildingInfoModel",  --Building information
	House = "HouseModel",  --Residential
	GameMainInterface = "GameMainInterfaceModel",--Game main interface
	RoleManager = "RoleManagerModel",--Game management interface
	ServerList = "ServerListModel",--Service page
	CreateRole = "CreateRoleModel",--Corner page
	Material = "MaterialModel",  --Raw material factory
	RetailStores = "RetailStoresModel",  --Retail store
	Processing = "ProcessingModel",  --Processing plant
	tempTransport = "tempTransportModel",   --Temporary transportation
	Exchange = "ExchangeModel",  --Exchange
	ExchangeTransaction = "ExchangeTransactionModel",  --Trading interface
	ExchangeDetail = "ExchangeDetailModel",  --Trading item details interface
	PlayerTemp = "PlayerTempModel",  --Player data, temporarily created
	CenterWareHouse = "CenterWareHouseModel",--Central warehouse
	Municipal="MunicipalModel",--Town facilities
	AdvertisementPos="AdvertisementPos",
	ManageAdvertisementPos="ManageAdvertisementPos",
	ScienceSellHall="ScienceSellHallModel",--Technology Exchange
	friends = "FriendsModel", -- Buddy
	Laboratory = "LaboratoryModel",  --graduate School
	Chat = "ChatModel", -- to chat with
	GroundTrans = "GroundTransModel",  --Land transaction
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

--Building bubble type
BubblleType =
{
	Default = 0,
	GroundAuction = 1,  --Land auction
	BuildingTransfer = 2,  --Building transfer
}

--Status of information widgets on the left and right sides of the building home
BuildingInfoToggleState =
{
	Close = 0,
	Open = 1.
}

--Does the homepage of the building correspond to the toggle component on the left or right
BuildingInfoTogglePos =
{
	Left = 0,
	Right = 1,
	Middle=2,
}

--Building Type
BuildingType =
{
	House = 0,  --Residential
	MaterialFactory = 1,  --Raw material factory
	Municipal = 2,--Promote
	ProcessingFactory = 4,  --Processing plant
	Laboratory = 5,  --graduate School
	RetailShop = 6,  --Retail store
	WareHouse = 7,--Distribution center
}

LanguageType={
	Chinese = 0,
	English = 1,
	Korean = 2,
	Japanese = 3,
}

BuildingBubbleType={
	small =1 ,
	show = 2,
    close = 3,
}

--The type of server protocol that the single input box will respond to
InputDialogPageServerType =
{
	UpdateBuildingName = 0,  --Modify building name
}
--Item Item Status Type
GoodsItemStateType =
{
	addShelf = 1,   --Put on shelf
	transport = 2,  --transport
	buy = 3,		--buy
}
--Warehouse classification
ItemScreening =
{
	all = 1,   		--All
	material = 2,   --raw material
	goods = 3,		--commodity
}

--Camera movement status type
TouchStateType =
{
	NormalState = 0, 	--Normal state (clickable, draggable)
	ConstructState = 1, --Construction status (not clickable, draggable)
	UIState = 2, 		--UI view status (not clickable or draggable)
}

--Tip box type
ReminderType =
{
	Common = 0,    --Common prompt box (blue or white)
	Warning = 1,    --Warning prompt box (red)
	Succeed = 2,    --Success prompt box (yellow)
}

--Prompt whether it is selective (whether there is a cancel button)
ReminderSelectType =
{
	Select = 0,
	NotChoose = 1,
}

--Mobile character type
MobileRolesType ={
	pedestrians = 0,
	cars = 1
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

