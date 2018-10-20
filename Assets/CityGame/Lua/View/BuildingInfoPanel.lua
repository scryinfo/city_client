---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/4 16:38
---
require "View/BuildingInfoRightPanel"
require "Common/define"

local transform

BuildingInfoPanel = {};
local this = BuildingInfoPanel;

function BuildingInfoPanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function BuildingInfoPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot");  --右侧建筑信息
    this.leftRootTran = transform:Find("leftRoot");  --左侧转让状态
    this.transferingRootTran = transform:Find("bottomRoot/transferIngRoot");  --正在转让中的显示
    this.nomalInfoRootTran = transform:Find("bottomRoot/nomalInfoRoot");  --非转让中的显示

    this.playerProtaitImg = transform:Find("bottomRoot/playerProtaitImg").gameObject:GetComponent("Image");  --玩家头像
    this.groundPriceText = transform:Find("bottomRoot/groundPriceText").gameObject:GetComponent("Text");  --土地价格
    this.buildPriceText = transform:Find("bottomRoot/buildPriceText").gameObject:GetComponent("Text");  --建筑价格
    this.transferPriceText = transform:Find("leftRoot/tranasferState/transferPriceText").gameObject:GetComponent("Text");  --转让价格

    this.buyBtn = transform:Find("bottomRoot/transferIngRoot/buyBtn").gameObject:GetComponent("Button");  --购买按钮 --当点开其他玩家转让建筑时才能购买
    this.cancelTransferBtn = transform:Find("bottomRoot/transferIngRoot/cancelTransferBtn").gameObject:GetComponent("Button");  --取消转让按钮 --当点中自己的转让气泡
    this.transferBtn = transform:Find("bottomRoot/nomalInfoRoot/transferBtn").gameObject:GetComponent("Button");  --转让
    this.dismantleBtn = transform:Find("bottomRoot/nomalInfoRoot/dismantleBtn").gameObject:GetComponent("Button");  --拆除

    --this.transferInput = transform:Find("bottomRoot/transferRoot/transferInput").gameObject:GetComponent("InputField");
end

--创建完成之后，设置右侧信息的父物体
function BuildingInfoPanel.OnCreatRightInfo()
    BuildingInfoRightPanel.SetParentTran(this.rightRootTran)
end

--数据初始化
function BuildingInfoPanel.InitDate(buildingTransferData)
    --如果是正在转让的建筑
    if buildingTransferData.isTransfering then
        this.leftRootTran.localScale = Vector3.one
        this.transferingRootTran.localScale = Vector3.one
        this.nomalInfoRootTran.localScale = Vector3.zero

        --增加判断，如果传进来的拥有者ID == 自己的ID 则显示取消转让按钮
        --否则显示购买按钮
        if buildingTransferData.playerID == 1001 then
            this.buyBtn.transform.localScale = Vector3.zero
            this.cancelTransferBtn.transform.localScale = Vector3.one
        else
            this.buyBtn.transform.localScale = Vector3.one
            this.cancelTransferBtn.transform.localScale = Vector3.zero
        end
    else
        this.leftRootTran.localScale = Vector3.zero
        this.transferingRootTran.localScale = Vector3.zero
        this.nomalInfoRootTran.localScale = Vector3.one
    end

    this.groundPriceText.text = "土地购买价格："..buildingTransferData.groundPrice
    this.buildPriceText.text = "建造价格："..buildingTransferData.buildPrice
    BuildingInfoRightPanel.InitData(getmetatable(buildingTransferData))
end

--转让成功
function BuildingInfoPanel.TransferSuccess(info)
    this.leftRootTran.localScale = Vector3.one
    this.transferingRootTran.localScale = Vector3.one
    this.nomalInfoRootTran.localScale = Vector3.zero
    this.transferPriceText.text = info  --显示转让金额

    this.cancelTransferBtn.transform.localScale = Vector3.one
    this.buyBtn.transform.localScale = Vector3.zero
end

--转让价格变化 --该情况只属于打开别人的建筑的时候，建筑转让价格的变化 -需要加上建筑ID ~= 自己的ID的判定
function BuildingInfoPanel.TransferInfoChange(info)
    this.transferPriceText.text = info.price
end
