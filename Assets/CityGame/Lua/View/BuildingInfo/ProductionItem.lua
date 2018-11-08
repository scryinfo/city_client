ProductionItem = class('ProductionItem')

--初始化方法
function ProductionItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.goodsIcon = self.prefab.transform:Find("goodsIcon");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.selectedBtn = self.prefab.transform:Find("selectedBtn");
    self.textImg = self.prefab.transform:Find("textImg"):GetComponent("RectTransform");  --是否在生产中
    self.selectedImg = self.prefab.transform:Find("selectedImg"):GetComponent("RectTransform");  --是否选中
    self.name = goodsDataInfo.name;
    self.nameText.text = self.name;
    self.itemId = goodsDataInfo.itemId;

    self._luabehaviour:AddClick(self.selectedBtn.gameObject,self.OnClick_selectedBtn,self);

    ----本地消息注册
    --Event.AddListener("c_ProductionItemdefault",self.c_ProductionItemdefault,self);
    --Event.AddListener("c_ProductionItemSelected",self.c_ProductionItemSelected,self);

end
--选择
function ProductionItem:OnClick_selectedBtn(ins)
    Event.Brocast("_selectedProductionLine",ins.id,ins.itemId,ins.name);
end
--
----Item状态 默认状态
--function ProductionItem:c_ProductionItemdefault()
--    self.self.selectedImg.transform.localScale = Vector3.zero
--end
--
----Item状态 选中
--function ProductionItem:c_ProductionItemSelected()
--    self.selectedImg.transform.localScale = Vector3.one
--end
