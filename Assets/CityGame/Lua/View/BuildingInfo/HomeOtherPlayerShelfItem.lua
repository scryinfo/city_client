
HomeOtherPlayerShelfItem = class('HomeOtherPlayerShelfItem')
HomeOtherPlayerShelfItem.static.TOTAL_H = 775  --整个Item的高度
HomeOtherPlayerShelfItem.static.CONTENT_H = 732  --显示内容的高度
HomeOtherPlayerShelfItem.static.TOP_H = 100  --top条的高度

--初始化方法  数据需要接受服务器发送的数据
function HomeOtherPlayerShelfItem:initialize(OtherPlayerShelfData, clickOpenFunc, viewRect, mainPanelLuaBehaviour, toggleData, mgrTable)
    self.viewRect = viewRect;
    self.productionData = OtherPlayerShelfData;
    self.toggleData = toggleData;    --位于toggle的第一个   右边

    self.contentRoot = self.viewRect.transform:Find("contentRoot"):GetComponent("RectTransform");  --内容Rect
    self.openStateTran = self.viewRect.transform:Find("topRoot/open");  --打开状态
    self.closeStateTran = self.viewRect.transform:Find("topRoot/close");    --关闭状态
    self.toDoBtns = self.viewRect.transform:Find("topRoot/open/toDoBtns");   --打开按钮
    self.content = self.viewRect.transform:Find("contentRoot/ScrollView/Viewport/Content")

    mainPanelLuaBehaviour:AddClick(self.toDoBtns.gameObject,function()
        if not self.viewRect.gameObject.activeSelf then
            return
        end
        if self.productionData.buildingType == BuildingType.MaterialFactory then
            ct.OpenCtrl("ShelfCtrl",self.productionData)
        elseif self.productionData.buildingType == BuildingType.ProcessingFactory then
            ct.OpenCtrl("ShelfCtrl",self.productionData)
        end
    end);

    self:initializeInfo(self.productionData.shelf.good)
end

--初始化数据
function HomeOtherPlayerShelfItem:initializeInfo(data)
    if not data then
        return;
    end
    for i,v in pairs(data) do
        local homePageType = ct.homePage.shelf
        local prefabData={}
        --prefabData.prefab = self:_creatGoods(ShelfRateItem.static.Goods_PATH,self.content)
        prefabData.prefab = creatGoods(ShelfRateItem.static.Goods_PATH,self.content)
        local SmallShelfRateItem = HomePageDisplay:new(homePageType,data[i],prefabData.prefab)
        if not self.SmallShelfRateItemTab then
            self.SmallShelfRateItemTab = {}
        end
        self.SmallShelfRateItemTab[i] = SmallShelfRateItem
    end
end

--获取是第几次点击了
function HomeOtherPlayerShelfItem:getToggleIndex()
    return self.toggleData.index;
end

--打开
function HomeOtherPlayerShelfItem:openToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Open;

    self.openStateTran.localScale = Vector3.one;
    self.closeStateTran.localScale = Vector3.zero;

    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x, HomeOtherPlayerShelfItem.static.CONTENT_H), BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    --self.contentRoot.sizeDelta = Vector2.New(self.contentRoot.sizeDelta.x, OccupancyRateItem.static.CONTENT_H) --打开显示内容
    --self.viewRect.anchoredPosition = targetMovePos  --移动到目标位置
    return Vector2.New(targetMovePos.x, targetMovePos.y - HomeOtherPlayerShelfItem.static.TOTAL_H);
end

--关闭
function HomeOtherPlayerShelfItem:closeToggleItem(targetMovePos)
    self.buildingInfoToggleState = BuildingInfoToggleState.Close;

    self.openStateTran.localScale = Vector3.zero;
    self.closeStateTran.localScale = Vector3.one;

    self.contentRoot:DOSizeDelta(Vector2.New(self.contentRoot.sizeDelta.x,0),BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);
    self.viewRect:DOAnchorPos(targetMovePos, BuildingInfoToggleGroupMgr.static.ITEM_MOVE_TIME):SetEase(DG.Tweening.Ease.OutCubic);

    return Vector2.New(targetMovePos.x,targetMovePos.y - HomeOtherPlayerShelfItem.static.TOP_H);
end

----生成预制
--function HomeOtherPlayerShelfItem:_creatGoods(path,parent)
--    local prefab = UnityEngine.Resources.Load(path);
--    local go = UnityEngine.GameObject.Instantiate(prefab);
--    local rect = go.transform:GetComponent("RectTransform");
--    go.transform:SetParent(parent.transform);
--    rect.transform.localScale = Vector3.one;
--    return go
--end