---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/9/4 16:38
---
require "View/BuildingInfoRightPanel"
-----

local transform

BuildingInfoPanel = {};
local this = BuildingInfoPanel;

function BuildingInfoPanel.Awake(obj)
    transform = obj.transform;

    this.InitPanel();
end

function BuildingInfoPanel.InitPanel()
    this.rightRootTran = transform:Find("rightRoot");  --Building information on the right
    this.leftRootTran = transform:Find("leftRoot");  --Left transfer status
    this.transferingRootTran = transform:Find("bottomRoot/transferIngRoot");  --Display in transfer
    this.nomalInfoRootTran = transform:Find("bottomRoot/nomalInfoRoot");  --Non-transferable display

    this.playerProtaitImg = transform:Find("bottomRoot/playerProtaitImg").gameObject:GetComponent("Image");  --Player avatar
    this.groundPriceText = transform:Find("bottomRoot/groundPriceText").gameObject:GetComponent("Text");  --land price
    this.buildPriceText = transform:Find("bottomRoot/buildPriceText").gameObject:GetComponent("Text");  --Building price
    this.transferPriceText = transform:Find("leftRoot/tranasferState/transferPriceText").gameObject:GetComponent("Text");  --Transfer price

    this.buyBtn = transform:Find("bottomRoot/transferIngRoot/buyBtn").gameObject:GetComponent("Button");  --Purchase button - can only be purchased when other players transfer buildings
    this.cancelTransferBtn = transform:Find("bottomRoot/transferIngRoot/cancelTransferBtn").gameObject:GetComponent("Button");  --Cancel transfer button - click on your own transfer bubble
    this.transferBtn = transform:Find("bottomRoot/nomalInfoRoot/transferBtn").gameObject:GetComponent("Button");  --transfer
    this.dismantleBtn = transform:Find("bottomRoot/nomalInfoRoot/dismantleBtn").gameObject:GetComponent("Button");  --tear down

    --this.transferInput = transform:Find("bottomRoot/transferRoot/transferInput").gameObject:GetComponent("InputField");
end

--After the creation is complete, set the parent object of the right information
function BuildingInfoPanel.OnCreatRightInfo()
    BuildingInfoRightPanel.SetParentTran(this.rightRootTran)
end

--Data initialization
function BuildingInfoPanel.InitDate(buildingTransferData)
    --If it is a building being transferred
    if buildingTransferData.isTransfering then
        this.leftRootTran.localScale = Vector3.one
        this.transferingRootTran.localScale = Vector3.one
        this.nomalInfoRootTran.localScale = Vector3.zero

        --Increase judgment, if the transferred owner ID == own ID, the cancel transfer button is displayed
        -- Otherwise show the buy button
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

--Successful transfer
function BuildingInfoPanel.TransferSuccess(info)
    this.leftRootTran.localScale = Vector3.one
    this.transferingRootTran.localScale = Vector3.one
    this.nomalInfoRootTran.localScale = Vector3.zero
    this.transferPriceText.text = info  --Show transfer amount

    this.cancelTransferBtn.transform.localScale = Vector3.one
    this.buyBtn.transform.localScale = Vector3.zero
end

--Change in transfer price-this situation only belongs to the change in the transfer price of the building when someone else’s building is opened-you need to add the building ID ~= your own ID
function BuildingInfoPanel.TransferInfoChange(info)
    this.transferPriceText.text = info.price
end
