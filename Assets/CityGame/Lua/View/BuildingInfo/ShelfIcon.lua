local transform;
local gameObject;

ShelfIcon = {};
local this = ShelfIcon;

--启动事件
function ShelfIcon.Awake(obj)
    gameObject = obj;
    transform = obj.gameObject;

    this.InitPanel();
end
--初始化面板
function ShelfIcon.InitPanel()
    this.shelfImg = transform:Find("shelfImg").gameObject;  --架子.
    this.goodsicon = transform:Find("details/goodsicon").gameObject;  --物品Icon
    this.nameText = transform:Find("details/nameText").gameObject;  --物品名字
    this.numberText = transform:Find("details/numberText").gameObject;  --物品数量
    this.moneyText = transform:Find("moneyImg/moneyText").gameObject;  --物品价格
    this.XBtn = transform:Find("XBtn");  --删除物品
    this.roundImg = transform:Find("roundImg").gameObject;  --选中物品
end