local transform;
local gameObject;

ChooseWarehousePanel = {};
local this = ChooseWarehousePanel;

function ChooseWarehousePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
end
function ChooseWarehousePanel.InitPanel()
    this.returnBtn = transform:Find("returnBtn");
    this.searchBtn = transform:Find("searchBtn");
    this.arrowBtn = transform:Find("Right/SortingBtn/arrowBtn");
    this.nowText = transform:Find("Right/SortingBtn/bg/nowText"):GetComponent("Text");
    this.list = transform:Find("Right/SortingBtn/ListTable/List").gameObject;
    this.nameBtn = transform:Find("Right/SortingBtn/ListTable/List/nameBtn");
    this.quantityBtn = transform:Find("Right/SortingBtn/ListTable/List/quantityBtn");
    this.priceBtn = transform:Find("Right/SortingBtn/ListTable/List/priceBtn");
    this.timeBtn = transform:Find("Right/SortingBtn/ListTable/List/timeBtn");
    --Mine
    this.faceImg = transform:Find("Left/mine/FriendsLineItem/face");
    this.nameText = transform:Find("Left/mine/FriendsLineItem/name");
    this.boxImg = transform:Find("Left/mine/FriendsLineItem/box").gameObject;
    this.bgBtn = transform:Find("Left/mine/FriendsLineItem/bg");
    --Addresslist  ScrollView
    this.leftcontent = transform:Find("Left/ScrollView/Viewport/Content");
    --Right  ScrollView
    this.rightContent = transform:Find("Right/ScrollView/Viewport/Content");
end
function ChooseWarehousePanel.OnDestroy()
    logWarn("OnDestroy ChooseWarehousePanel--->>>");
end