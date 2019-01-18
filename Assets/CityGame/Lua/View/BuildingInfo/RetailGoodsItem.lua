RetailGoodsItem = class('RetailGoodsItem')

--初始化
function RetailGoodsItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id,state,buildingId)
    self.id = id;
    self.prefab = prefab;
    self.inluabehaviour = inluabehaviour;
    self.goodsDataInfo = goodsDataInfo;
    self.manager = mgr
    self.state = state
    self.buildingId = buildingId

    self.shelfImg = self.prefab.transform:Find("shelfImg").gameObject;
    self.goodsicon = self.prefab.transform:Find("details/goodsicon"):GetComponent("Image");
    self.nameText = self.prefab.transform:Find("details/nameText"):GetComponent("Text");
    self.numberText = self.prefab.transform:Find("details/numberText"):GetComponent("Text");
    self.icon = self.prefab.transform:Find("details/icon"):GetComponent("Image");
    self.brandName = self.prefab.transform:Find("details/brandName/brandNameText"):GetComponent("Text");
    self.brandValue = self.prefab.transform:Find("details/brandValue/brandValueText"):GetComponent("Text");
    self.qualityValue = self.prefab.transform:Find("details/qualityValue/qualityValueText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("moneyImg/moneyText"):GetComponent("Text");
    self.detailsBtn = self.prefab.transform:Find("detailsBtn");
    self.XBtn = self.prefab.transform:Find("XBtn");

    --UI信息赋值
    self.nameText.text = Good[self.goodsDataInfo.k.id].name
    self.numberText.text = self.goodsDataInfo.n
    self.brandName.text = "Addypolly"
    self.brandValue.text = "0"
    self.qualityValue.text = self.goodsDataInfo.k.qty
    self.moneyText.text = "E"..self.goodsDataInfo.price..".0000"

    local type = ct.getType(UnityEngine.Sprite)
    panelMgr:LoadPrefab_A(Good[self.goodsDataInfo.k.id].img,type,nil,function(goodData,obj)
        if obj ~= nil then
            local texture = ct.InstantiatePrefab(obj)
            self.goodsicon.sprite = texture
        end
    end)

    self:initializeUiState()
end
--初始化UI状态
function RetailGoodsItem:initializeUiState()
    if self.state then
        self.XBtn.transform.localScale = Vector3.New(0,0,0);
        self.detailsBtn.transform.localScale = Vector3.New(0,0,0);
    else
        self.XBtn.transform.localScale = Vector3.New(1,1,1);
        self.detailsBtn.transform.localScale = Vector3.New(1,1,1);
    end
end