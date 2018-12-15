BuyDetailsItem = class('BuyDetailsItem')

--初始化方法
function BuyDetailsItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id,itemId)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour
    self.id = id;

    self.goodsIcon = self.prefab.transform:Find("goodsbg/goodsIcon");
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");
    self.inputNumber = self.prefab.transform:Find("InputNumber"):GetComponent("InputField");
    self.numberScrollbar = self.prefab.transform:Find("numberScrollbar"):GetComponent("Slider");
    self.tipMoneyText = self.prefab.transform:Find("buttombg/tipMoneyText"):GetComponent("Text");
    self.moneyText = self.prefab.transform:Find("buttombg/moneyImg/moneyText"):GetComponent("Text");
    self.closeBtn = self.prefab.transform:Find("closeBtn");


    --点击事件
    self._luabehaviour:AddClick(self.closeBtn.gameObject,self.OnClick_closeBtn,self);
end
--删除
function BuyDetailsItem:OnClick_closeBtn()

end
--刷新滑动条
function BuyDetailsItem:scrollbarInfo()

end
--刷新输入框
function BuyDetailsItem:inputInfo()

end