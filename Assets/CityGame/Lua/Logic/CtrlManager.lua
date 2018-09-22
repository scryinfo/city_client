require "Common/define"
require "Controller/LoginCtrl"
require "Controller/SelectAvatarCtrl"
require "Controller/CreateAvatarCtrl"
require "Controller/GameWorldCtrl"
require "Controller/PlayerHeadCtrl"
require "Controller/TargetHeadCtrl"
require "Controller/GroundAuctionCtrl"
require "Model/LoginModel"
require "Model/GroundAuctionModel"
require "Model/BuildingInfoModel"
require "Logic/PieChart/PieChart"
require "Logic/GameBubble/GameBubbleManager"

CtrlManager = {};
local this = CtrlManager;
local ctrlList = {};	--控制器列表--
local modelList = {};	--模型列表--

function CtrlManager.Init()
	logWarn("CtrlManager.Init----->>>");

	ctrlList[CtrlNames.Login] = LoginCtrl.New();
	ctrlList[CtrlNames.Login].testValue = 1
	ctrlList[CtrlNames.SelectAvatar] = SelectAvatarCtrl.New();
	ctrlList[CtrlNames.CreateAvatar] = CreateAvatarCtrl.New();
	ctrlList[CtrlNames.GameWorld] = GameWorldCtrl.New();
	ctrlList[CtrlNames.PlayerHead] = PlayerHeadCtrl.New();
	ctrlList[CtrlNames.TargetHead] = TargetHeadCtrl.New();
	ctrlList[CtrlNames.GroundAuction] = GroundAuctionCtrl.New();

	modelList[ModelNames.Login] = LoginModel.New();
	modelList[ModelNames.GroundAuction] = GroundAuctionModel.New();
	modelList[ModelNames.GameBubbleManager] = GameBubbleManager.New();
	modelList[ModelNames.BuildingInfo] = BuildingInfoModel.New();

	--饼图测试
	modelList[ModelNames.PieChart] = PieChart.New();
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

