ProductionItem = class('ProductionItem')

--Initialization method
function ProductionItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.goodsIcon = self.prefab.transform:Find("goodsIcon");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.selectedBtn = self.prefab.transform:Find("selectedBtn");
    self.textImg = self.prefab.transform:Find("textImg"):GetComponent("RectTransform");  --Is it in production
    self.selectedImg = self.prefab.transform:Find("selectedImg"):GetComponent("RectTransform");  --Whether selected
    self.name = goodsDataInfo.name;
    self.nameText.text = self.name;
    self.itemId = goodsDataInfo.itemId;

    self._luabehaviour:AddClick(self.selectedBtn.gameObject,self.OnClick_selectedBtn,self);

    ----Local message registration
    --Event.AddListener("c_ProductionItemdefault",self.c_ProductionItemdefault,self);
    --Event.AddListener("c_ProductionItemSelected",self.c_ProductionItemSelected,self);

end
--select
function ProductionItem:OnClick_selectedBtn(ins)
    Event.Brocast("_selectedProductionLine",ins.id,ins.itemId,ins.name);
end
--
----Item status Default status
--function ProductionItem:c_ProductionItemdefault()
--    self.self.selectedImg.transform.localScale = Vector3.zero
--end
--
----Item status selected
--function ProductionItem:c_ProductionItemSelected()
--    self.selectedImg.transform.localScale = Vector3.one
--end
