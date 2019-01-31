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
    self.openName = self.viewRect.transform:Find("topRoot/open/nameText"):GetComponent("Text");
    self.closeName = self.viewRect.transform:Find("topRoot/close/nameText"):GetComponent("Text");


    mainPanelLuaBehaviour:AddClick(self.openBtns.gameObject,function()
        PlayMusEff(1002)
        clickOpenFunc(mgrTable,self.toggleData)
    end);

    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        PlayMusEff(1002)
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
    self.openName.text = GetLanguage(25020004)
    self.closeName.text = GetLanguage(25020004)
    self.SmallShelfRateItemTab = {}
    self:initializeInfo(self.shelfData.shelf.good)

    --Event.AddListener("c_onOccupancyValueChange",self.updateInfo,self)
    --Event.AddListener("shelfRefreshInfo",self.shelfRefreshInfo,self)
    Event.AddListener("delGoodRefreshInfo",self.delGoodRefreshInfo,self)
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
    return Vector2.New(targetMovePos.x,targetMovePos.y - ShelfRateItem.static.TOTAL_H - 5);
end

--关闭
function ShelfRateItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - ShelfRateItem.static.TOP_H - 5);
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
        if not self.SmallShelfRateItemTab then
            self.SmallShelfRateItemTab = {}
        end
        self.SmallShelfRateItemTab[i] = SmallShelfRateItem
    end
    ShelfRateItem.shelfTab = self.SmallShelfRateItemTab
end
----货架添加时添加
--function ShelfRateItem:shelfRefreshInfo(data)
--    if not data then
--        return;
--    end
--    local isShow = false
--    if #self.SmallShelfRateItemTab == 0 then
--        isShow = true
--    else
--        for i,v in pairs(self.SmallShelfRateItemTab) do
--            if v.itemId == data.k.id then
--                v.numberText.text = data.n
--                v.moneyText.text = "E"..data.price..".0000"
--                isShow = false
--                break
--            else
--                isShow = true
--            end
--        end
--    end
--    if isShow == true then
--        local homePageType = ct.homePage.shelf
--        local prefab = creatGoods(ShelfRateItem.static.Goods_PATH,self.content)
--        local SmallShelfRateItem = HomePageDisplay:new(homePageType,data,prefab)
--        self.SmallShelfRateItemTab[#self.SmallShelfRateItemTab + 1] = SmallShelfRateItem
--    end
--    ShelfRateItem.shelfTab = self.SmallShelfRateItemTab
--end
--货架下架时删除
function ShelfRateItem:delGoodRefreshInfo(data)
    if not data then
        return
    end
    for i,v in pairs(self.SmallShelfRateItemTab) do
        if v.itemId == data.item.key.id then
            destroy(v.prefab)
            --table.remove(self.SmallShelfRateItemTa,i)
        end
        ShelfRateItem.shelfTab = self.SmallShelfRateItemTab
        table.remove(ShelfRateItem.shelfTab,i)
    end
end
--刷新数据
function ShelfRateItem:updateInfo(data)
    self.shelfData = data
    self.shelfData.shelf.good = data.shelf.good
    self:initializeInfo(self.shelfData.shelf.good)
end