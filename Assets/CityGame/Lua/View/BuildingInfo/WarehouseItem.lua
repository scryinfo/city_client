local class = require 'Framework/class'

WarehouseItem = class('WarehouseItem')

--初始化方法   数据（接受服务器）
function WarehouseItem:initialize(goodsDataInfo,prefab,inluabehaviour,mgr,id)
    self.prefab = prefab;
    self.goodsDataInfo = goodsDataInfo;
    self._luabehaviour = inluabehaviour;
    self.manager = mgr;
    self.id = id;
    self.bgBtn = self.prefab.transform:Find("bgBtn");  --物品btn，点击勾选物品，默认为false
    self.icon = self.prefab.transform:Find("icon");  --物品Icon
    self.circleGreayImg = self.prefab.transform:Find("circleGreayImg");  --圆
    self.circleTickImg = self.prefab.transform:Find("circleGreayImg/circleTickImg");  --勾选
    self.nameText = self.prefab.transform:Find("nameText"):GetComponent("Text");  --名字
    self.numberText = self.prefab.transform:Find("numberText");  --数量
    self.closeBtn = self.prefab.transform:Find("closeBtn");  --删除btn  默认true
    self.nameText.text = goodsDataInfo.name
    self.numberText.text = goodsDataInfo.number

end