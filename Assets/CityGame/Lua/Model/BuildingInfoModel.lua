---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/4 17:58
---
-----

BuildingInfoModel= {};
local this = BuildingInfoModel;

--构建函数--
function BuildingInfoModel.New()
    return this;
end

function BuildingInfoModel.Awake()
    this:OnCreate();
end

---测试
function BuildingInfoModel.Update()
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.Q) then
        this.rightFinish = false
        this.bottomFinish = false

        local msgBuildTransfer = {}
        local msgBuildTransferRightInfo = {}  --右侧需要显示的信息
        setmetatable(msgBuildTransfer, msgBuildTransferRightInfo)

        msgBuildTransferRightInfo.width = 2
        msgBuildTransferRightInfo.height = 3
        msgBuildTransferRightInfo.buildTime = 2018/09/05
        msgBuildTransferRightInfo.usedTime = 36
        msgBuildTransferRightInfo.oldPercent = 50

        --setmetatable(msgBuildTransfer, msgBuildTransferRightInfo)
        msgBuildTransfer.playerProtaitPath = ""
        msgBuildTransfer.playerID = 1001
        msgBuildTransfer.groundPrice = 1234
        msgBuildTransfer.buildPrice = 9876

        this.CreatBuildingInfoPanel(msgBuildTransfer)
    end

    --右侧加载完毕
    if this.rightFinish and this.bottomFinish then

        BuildingInfoPanel.InitDate(this.buildingInfo)
        this.rightFinish = false
        this.bottomFinish = false
    end

    --转让成功消息
    if UnityEngine.Input.GetKeyDown(UnityEngine.KeyCode.W) then
        BuildingInfoPanel.TransferSuccess(256984)
        BuildingTransferPanel.Close()
    end
end

--启动事件--
function BuildingInfoModel.OnCreate()
    --UpdateBeat:Add(this.Update, this);
    --网络回调注册
    --CityEngineLua.Message:registerNetMsg(pb.gsCode.login,BuildingInfoModel.TransferSuccess);
end

--创建信息UI
function BuildingInfoModel.CreatBuildingInfoPanel(panelInfo)
    this.buildingInfo = panelInfo
    this.rightFinish = false
    this.bottomFinish = false

    panelMgr:LoadPrefab_A('BuildingInfo', this.OnPanelCreated, this);
    --将右侧的界面加入
    panelMgr:LoadPrefab_A('BuildingInfoRight', this.OnRightPanelCreated, this);
end

--当界面生成完毕之后，添加监听
function BuildingInfoModel.OnPanelCreated(panelObj)
    local groundAuctionBehaviour = panelObj:GetComponent('LuaBehaviour');
    groundAuctionBehaviour:AddClick(BuildingInfoPanel.transferBtn.gameObject, this.OpenTransferPage);
    groundAuctionBehaviour:AddClick(BuildingInfoPanel.buyBtn.gameObject, this.SendBuyInfoToServer);
    groundAuctionBehaviour:AddClick(BuildingInfoPanel.cancelTransferBtn.gameObject, this.SendCancelTransferToServer);
    groundAuctionBehaviour:AddClick(BuildingInfoPanel.dismantleBtn.gameObject, this.SendDismantleToServer);

    this.bottomFinish = true
end

--右侧panel加载完毕
function BuildingInfoModel.OnRightPanelCreated(rightPanelObj)
    logDebug("转让界面，右侧加载完毕")
    BuildingInfoPanel.OnCreatRightInfo()
    this.rightFinish = true
end

--打开转让界面
function BuildingInfoModel.OpenTransferPage()
    panelMgr:LoadPrefab_A('BuildingTransfer');

end

--- 客户端请求 ---
--向服务器发送消息
function BuildingInfoModel.SendTransferInfoToServer(transferPrice)
    --先暂定，服务器需要的是建筑ID和转让费
    --等服务器的协议定好再添加

    logDebug("确认转让："..transferPrice)
    local transferBubbleInfo = this.buildingInfo
    transferBubbleInfo.area = {}
    transferBubbleInfo.area.x = 0
    transferBubbleInfo.area.y = 0

    transferBubbleInfo.bubbleType = BubblleType.BuildingTransfer
    transferBubbleInfo.func = function(info)
        if info.bubbleType ~= BubblleType.BuildingTransfer then
            return
        end
        info.isTransfering = true
        this.CreatBuildingInfoPanel(info)  --打开转让界面
    end

    GameBubbleManager.CreatBubble(transferBubbleInfo)
end

--买地
function BuildingInfoModel.SendBuyInfoToServer()
    logDebug("---- lalala 买别人转让的地了！！！")
    --还需判断拥有者是不是自己才行 --目前不知道是不是直接在建筑信息里拿
end

--取消转让
function BuildingInfoModel.SendCancelTransferToServer()
    logDebug("---- aaaaa 取消转让 ！！！")

end

--拆除
function BuildingInfoModel.SendDismantleToServer()
    logDebug("---- bbbbb 拆除 ！！！")

end

--- 服务器回调 ---
--转让成功
function BuildingInfoModel.TransferSuccess(stream)
    --反序列化---

    BuildingInfoPanel.TransferSuccess(stream)
end

--点进其他人的转让建筑时，转让金额发生了变化
function BuildingInfoModel.TransferInfoChange(stream)
    --temp--
    
    BuildingInfoPanel.TransferInfoChange(stream)
end

--建筑信息改变 --这个Emmm 可以是自己的建筑，也可以是别人的建筑
function BuildingInfoModel.BuildingInfoUpdate(stream)
    BuildingInfoRightPanel.UpdateInfo(stream)
end

--关闭事件--
function BuildingInfoModel.Close()
    --Event.RemoveListener("OnLogin", this.OnLogin);
end
