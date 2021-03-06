-----
-----
require "Controller/LoginCtrl"
--require "Controller/MaterialCtrl"
require "Controller/WagesAdjustBoxCtrl"
--require "Controller/ProcessingCtrl"
--require "Controller/WarehouseCtrl"
require "Controller/TransportCtrl"
require "Controller/TransportOrderCtrl"
require "Controller/AddTransportCtrl"

require "Controller/SelectAvatarCtrl"
require "Controller/CreateAvatarCtrl"
require "Controller/GameWorldCtrl"
require "Controller/PlayerHeadCtrl"
require "Controller/TargetHeadCtrl"
--require "Controller/ShelfCtrl"

require "Controller/ChooseWarehouseCtrl"
require "Controller/TransportBoxCtrl"
require "Controller/DETAILSBoxCtrl"
require "Controller/MunicipalCtrl"
--require"Controller/AdvertisementPosCtrl"

require "Controller/GroundAuctionCtrl"
require "Controller/HouseCtrl"
require "Controller/GameMainInterfaceCtrl"
require "Controller/BtnDialogPageCtrl"
require "Controller/InputDialogPageCtrl"
require "Model/LoginModel"
require "Model/BuildingInfoModel"
require "Model/HouseModel"
require "Model/MunicipalModel"
require"Model/AdvertisementPosModel"
require"Model/ManageAdvertisementPosModel"
--require "Model/GameMainInterfaceModel"
require "Model/ServerListModel"
require "Model/CreateRoleModel"
--require "Model/MaterialModel"
--require "Model/RetailStoresModel"
--require "Model/ProcessingModel"
require "Model/tempTransportModel"
require "Model/CenterWareHouseModel"
require "Logic/PieChart/PieChart"

CtrlManager = {};
local this = CtrlManager;
local ctrlList = {};	--控制器列表--
local modelList = {};	--模型列表--

function CtrlManager.Init()
	ReadConfigLanguage()
	logWarn("CtrlManager.Init----->>>");
	--默认显示登录界面
	--ct.OpenCtrl('MunicipalCtrl',Vector2.New(0, -300)) --注意传入的是类名
	--ct.OpenCtrl('ScienceSellPopCtrl',Vector2.New(0, -300)) --注意传入的是类名
	MusicManger:Awake()
	UIBubbleManager.Awake() --temp

	--UIPage:ShowPage(LoginCtrl, "LoginCtrl更新所需数据"):setPosition(0, -200);

	--ctrlList[CtrlNames.Login] = LoginCtrl.New();
	--ctrlList[CtrlNames.Wages] = WagesAdjustBoxCtrl.New();
	--测试
	--ctrlList[CtrlNames.Material] = MaterialCtrl.New();
	--ctrlList[CtrlNames.Warehouse] = WarehouseCtrl.New();
	ctrlList[CtrlNames.Transport] = TransportCtrl.New();
	--ctrlList[CtrlNames.Shelf] = ShelfCtrl.New();
	ctrlList[CtrlNames.TransportOrder] = TransportOrderCtrl.New();
	ctrlList[CtrlNames.AddTransport] = AddTransportCtrl.New();

	ctrlList[CtrlNames.SelectAvatar] = SelectAvatarCtrl.New();
	ctrlList[CtrlNames.CreateAvatar] = CreateAvatarCtrl.New();
	ctrlList[CtrlNames.GameWorld] = GameWorldCtrl.New();
	ctrlList[CtrlNames.PlayerHead] = PlayerHeadCtrl.New();
	ctrlList[CtrlNames.TargetHead] = TargetHeadCtrl.New();

    --ctrlList[CtrlNames.GroundAuction] = GroundAuctionCtrl.New();
    --ctrlList[CtrlNames.House] = HouseCtrl.New();

    --modelList[ModelNames.Login] = LoginModel.New();
    --modelList[ModelNames.GroundAuction] = GroundAuctionModel.New();
    --modelList[ModelNames.GameBubbleManager] = GameBubbleManager.New();
	modelList[ModelNames.BuildingInfo] = BuildingInfoModel.New();
	--modelList[ModelNames.House] = HouseModel.New();
	--modelList[modelName.GameMainInterface] = GameMainInterfaceModel.New();
	--modelList[ModelNames.ServerList] = ServerListModel.New();
	--modelList[ModelNames.CreateRole] = CreateRoleModel.New();
	--modelList[ModelNames.Material] = MaterialModel.New();
	--modelList[ModelNames.Processing] = ProcessingModel.New();
	modelList[ModelNames.PlayerTemp] = PlayerTempModel.New();
	--modelList[ModelNames.CenterWareHouse] = CenterWareHouseModel.New();
	--modelList[ModelNames.Municipal]=MunicipalModel.New();
	--modelList[ModelNames.tempTransport] = tempTransportModel.New();

	modelList[ModelNames.AdvertisementPos]=AdvertisementPosModel.New();
	modelList[ModelNames.ManageAdvertisementPos]=ManageAdvertisementPosModel.New();
	modelList[ModelNames.ScienceSellHall]=ScienceSellHallModel.New();
	--饼图测试
	modelList[ModelNames.PieChart] = PieChart.New();
	--modelList[ModelNames.friends] = FriendsModel.New();
	--modelList[ModelNames.Chat] = ChatModel.New();
	return this;
end

--添加控制器--
function CtrlManager.AddCtrl(ctrlName, ctrlObj)
	ctrlList[ctrlName] = ctrlObj;
end

--获取控制器--
function CtrlManager.GetCtrl(ctrlName)
	return ctrlList[ctrlName];
end

--移除控制器--
function CtrlManager.RemoveCtrl(ctrlName)
	ctrlList[ctrlName] = nil;
end

--关闭控制器--
function CtrlManager.Close()
	logWarn('CtrlManager.Close---->>>');
end

-----------------------
--添加模型--
function CtrlManager.AddModel(modelName, ctrlObj)
	modelList[modelName] = ctrlObj;
end

--获取控制器--
function CtrlManager.GetModel(modelName)
	return modelList[modelName];
end

--移除控制器--
function CtrlManager.RemoveModel(modelName)
	modelList[modelName] = nil;
end
