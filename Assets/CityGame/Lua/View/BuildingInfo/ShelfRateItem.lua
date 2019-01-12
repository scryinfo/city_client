require('Controller/ShelfCtrl')


ShelfRateItem = class('ShelfRateItem')
ShelfRateItem.static.TOTAL_H = 455  --整个Item的高度
ShelfRateItem.static.CONTENT_H = 412  --显示内容的高度
ShelfRateItem.static.TOP_H = 100  --top条的高度
ShelfRateItem.static.Goods_PATH = "View/GoodsItem/SmallShelfRateItem"
--主页信息货架，生产线，只作显示
ct.homePage =
{
    shelf  = 0,  --货架
    productionLine = 1,  --生产线
}
--初始化方法  数据需要接受服务器发送的数据
function ShelfRateItem:initialize(shelfData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.shelfData = shelfData;
    self.toggleData = toggleData;   --位于toggle的第四个   左边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");  --关闭状态
    self.openBtns = self.viewRect.transform:Find("topRoot/close/openBtns");  --打开按钮
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");  --跳转页面
    self.content = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content");


    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject,function()
        clickOpenFunc(mgrTable,self.toggleData)
    end);

    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        if self.shelfData.buildingType == BuildingType.MaterialFactory then
            ct.OpenCtrl("ShelfCtrl",self.shelfData)
        elseif self.shelfData.buildingType == BuildingType.ProcessingFactory then
            ct.OpenCtrl("ShelfCtrl",self.shelfData)
        elseif self.shelfData.buildingType == BuildingType.RetailShop then
            ct.OpenCtrl("RetailShelfCtrl",self.shelfData)
        end
    end);
    self:initializeInfo(self.shelfData.shelf.good)

    Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self)
    Event.AddListener("shelfRefreshInfo",self.shelfRefreshInfo,self)
    Event.AddListener("delRefreshInfo",self.delRefreshInfo,self)
end

--获取是第几个点击了
function ShelfRateItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function ShelfRateItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, ShelfRateItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --打开显示内容
    --self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置
    return Vector2.New(targetMovePos.x,targetMovePos.y - ShelfRateItem.static.TOTAL_H);
end

--关闭
function ShelfRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - ShelfRateItem.static.TOP_H);
end

--初始化数据
function ShelfRateItem:initializeInfo(data)
    if not data then
        return;
    end
    for i,v in pairs(data) do
        local homePageType = ct.homePage.shelf
        local prefab = creatGoods(ShelfRateItem.static.Goods_PATH,self.content)
        local SmallShelfRateItem = HomePageDisplay:new(homePageType,v,prefab)
        --if not self.SmallShelfRateItemTab then
        --    self.SmallShelfRateItemTab = {}
        --end
        --self.SmallShelfRateItemTab[i] = SmallShelfRateItem
    end
end
--货架添加时添加
function ShelfRateItem:shelfRefreshInfo(data)
    if not data then
        return;
    end
    local homePageType = ct.homePage.shelf
    local prefab = creatGoods(ShelfRateItem.static.Goods_PATH,self.content)
    local SmallShelfRateItem = HomePageDisplay:new(homePageType,data,prefab)
    if not self.tempShowTable then
        self.tempShowTable = {}
    end
    self.tempShowTable[data.k.id] = SmallShelfRateItem
end
--货架下架时删除
function ShelfRateItem:delRefreshInfo(data)
    if not data then
        return
    end
    for i,v in pairs(self.tempShowTable) do
        if i == data.item.key.id then
            destroy(v.prefab.gameObject)
        end
    end
end
--刷新数据
function ShelfRateItem:updateInfo(data)
    self.shelfData.shelf.good = data.shelf.good
    self:initializeInfo()
end