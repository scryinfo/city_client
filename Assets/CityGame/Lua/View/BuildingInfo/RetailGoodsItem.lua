RetailGoodsItem = class('RetailGoodsItem')

--初始化
function RetailGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour,id,state)
    self.id = id;
    self.prefab = prefab;
    self.inluabehaviour = inluabehaviour;
    self.goodsDataInfo = goodsDataInfo;
    self.state = state[1]
    self.buildingId = state[2]
    self.itemId = goodsDataInfo.k.id
    self.producerId = goodsDataInfo.k.producerId
    self.qty = goodsDataInfo.k.qty
    self.num = goodsDataInfo.n
    self.price = goodsDataInfo.price

    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject;
    self.goodsicon = self.prefab.transform:Find("details/goodsicon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text");
    self.icon = self.prefab.transform:Find("details/icon"):GetComponent("Image");
    -----------------------------------------------------------------------------
    --暂时屏蔽
    self.brandValueObj = self.prefab.transform:Find("details/brandValue")
    self.qualityValueObj = self.prefab.transform:Find("details/qualityValue")
    -----------------------------------------------------------------------------

    self.brandName = self.prefab.transform:Find("details/brandName/brandNameText"):GetComponent("Text");
    self.brandValue = self.prefab.transform:Find("details/brandValue/brandValueText"):GetComponent("Text");
    self.qualityValue = self.prefab.transform:Find("details/qualityValue/qualityValueText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text");
    self.detailsBtn = self.prefab.transform:Find("detailsBtn");
    self.XBtn = self.prefab.transform:Find("XBtn");

    -----------------------------------------------------------------------------
    --暂时屏蔽
    self.brandValueObj.gameObject:SetActive(false)
    self.qualityValueObj.gameObject:SetActive(false)
    -----------------------------------------------------------------------------

    --UI信息赋值
    self.nameText.text = GetLanguage(self.goodsDataInfo.k.id)
    self.numberText.text = self.goodsDataInfo.n
    self.brandName.text = GetLanguage(4301011)
    self.brandValue.text = "0"
    self.qualityValue.text = self.goodsDataInfo.k.qty
    self.moneyText.text = "E"..GetClientPriceString(self.goodsDataInfo.price)

    LoadSprite(Good[self.goodsDataInfo.k.id].img,self.goodsicon,false)
    self.inluabehaviour:AddClick(self.XBtn.gameObject,self.OnClick_XBtn,self)
    self.inluabehaviour:AddClick(self.detailsBtn.gameObject,self.OnClick_detailsBtn,self)
    self:initializeUiState()
end
--初始化UI状态
function RetailGoodsItem:initializeUiState()
    if self.state then
        self.XBtn.transform.localScale = Vector3.zero
        --self.detailsBtn.transform.localScale = Vector3.zero
    else
        self.XBtn.transform.localScale = Vector3.one
        --self.detailsBtn.transform.localScale = Vector3.one
    end
end
function RetailGoodsItem:OnClick_XBtn(go)
    PlayMusEff(1002)
    Event.Brocast("m_ReqRetailShelfDel",go.buildingId,go.itemId,go.numberText.text,go.producerId,go.qty)
end
function RetailGoodsItem:OnClick_detailsBtn(ins)
    PlayMusEff(1002)
    Event.Brocast("OpenDetailsBox",ins)
end
function RetailGoodsItem:RefreshID(id)
    self.id = id
end