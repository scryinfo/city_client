---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 10:53
--- 中心仓库
local transform;
local gameObject;

CenterWareHousePanel = {};
local this = CenterWareHousePanel;

--启动事件--
function CenterWareHousePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function CenterWareHousePanel.InitPanel()
    this.backBtn = transform:Find("topRoot/BackButton").gameObject;--返回按钮
    this.number = transform:Find("topRoot/Capacity/Slider/Number").gameObject;--仓库商品个数
    this.total = transform:Find("topRoot/Capacity/Slider/TotalNumber").gameObject;--仓库总容量
    this.slider = transform:Find("topRoot/Capacity/Slider");
    this.arrowBtn = transform:Find("topRoot/Sorting/arrowBtn"):GetComponent("RectTransform"); -- Open下拉列表
    this.nameBtn = transform:Find("topRoot/ListTable/List/nameBtn").gameObject;  --名字排序
    this.quantityBtn = transform:Find("topRoot/ListTable/List/quantityBtn").gameObject;  --数量排序
    this.levelBtn = transform:Find("topRoot/ListTable/List/levelBtn").gameObject; --评分排序
    this.scoreBtn = transform:Find("topRoot/ListTable/List/scoreBtn").gameObject;--等级排序
    this.nowText = transform:Find("topRoot/Sorting/bg/nowText"):GetComponent("Text");
    this.list = transform:Find("topRoot/ListTable/List"):GetComponent("RectTransform");

    this.content = transform:Find("Scroll View/Viewport/Content"):GetComponent("RectTransform");
    this.scrollView = transform:Find("Scroll View"):GetComponent("RectTransform");
    this.addItem = transform:Find("Scroll View/Viewport/Content/AddItem").gameObject;--扩容
    this.addBtn = transform:Find("Scroll View/Viewport/Content/AddItem/AddButton").gameObject; --扩容按钮
    this.addCapacity = transform:Find("Scroll View/Viewport/Content/AddItem/WareHouseBG/AddCapacity").gameObject--容量
    this.money = transform:Find("Scroll View/Viewport/Content/AddItem/MoneyBG/Money").gameObject--所需金额

    this.bg = transform:Find("rightRoot/bg"):GetComponent("RectTransform");
    this.transport = transform:Find("rightRoot/bg/transport").gameObject;
    this.transportCloseBtn = transform:Find("rightRoot/bg/transport/closeBtn").gameObject;
    this.transportConfirmBtn = transform:Find("rightRoot/bg/transport/confirmBtn").gameObject;
    this.transportConfirm = transform:Find("rightRoot/bg/transport/confirm").gameObject;
    this.moneyText = transform:Find("rightRoot/bg/transport/moneyItem/moneyText").gameObject:GetComponent("Text");
    this.transportopenBtn = transform:Find("rightRoot/bg/transport/warehouseName/openBtn").gameObject;
    this.nameText = transform:Find("rightRoot/bg/transport/warehouseName").gameObject:GetComponent("InputField");
    this.tspContent = transform:Find("rightRoot/bg/transport/ScrollView/Viewport/Content").gameObject:GetComponent("RectTransform");

    this.transportBtn = transform:Find("TransportButton").gameObject--运输按钮

end
