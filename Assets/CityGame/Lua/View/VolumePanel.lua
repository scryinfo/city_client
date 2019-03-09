---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/2/28 17:44
---交易量panel
local transform;
local gameObject;

VolumePanel = {};
local this = VolumePanel;

--启动事件--
function VolumePanel.Awake(obj)
    gameObject = obj;
    transform = obj.transform;

    this.InitPanel();
    logWarn("Awake lua--->>"..gameObject.name);
end

--初始化面板--
function VolumePanel.InitPanel()
    --top
    this.back = transform:Find("return").gameObject --返回
    this.name = transform:Find("name"):GetComponent("Text");
    this.volumeText = transform:Find("Volume/volumeImage/volumeText"):GetComponent("Text")  --交易量
    --left

    this.citzen = transform:Find("leftBg/citzen/citzenText"):GetComponent("Text");   --市民
    this.turnover = transform:Find("leftBg/moneyBg/turnover/turnoverText"):GetComponent("Text"); --营业额
    this.money = transform:Find("leftBg/moneyBg/money/moneyText"):GetComponent("Text"); --营业额
    this.city = transform:Find("leftBg/moneyBg/numberBg/city/hint/Text"):GetComponent("Text"); --城市市民
    this.adult = transform:Find("leftBg/moneyBg/numberBg/adult/adultImage/adultText"):GetComponent("Text"); --成年人
    this.old = transform:Find("leftBg/moneyBg/numberBg/old/oldImage/oldText"):GetComponent("Text"); --老人
    this.youth = transform:Find("leftBg/moneyBg/numberBg/youth/youthImage/youthText"):GetComponent("Text"); --青年人

    --right
    this.clotherBtn = transform:Find("rightBg/clotherBtn").gameObject; --clotherBtn
    this.clotherBtnText = transform:Find("rightBg/clotherBtn/clotherBtnText"):GetComponent("Text");
    this.clothes = transform:Find("rightBg/clothes");    --clothes
    this.clothes = transform:Find("rightBg/clothes/clothesText"):GetComponent("Text");
    this.foodBtn = transform:Find("rightBg/foodBtn").gameObject; --foodBtn
    this.foodBtnText = transform:Find("rightBg/foodBtn/foodBtnText"):GetComponent("Text");
    this.food = transform:Find("rightBg/food");    --food
    this.foodText = transform:Find("rightBg/food/foodText"):GetComponent("Text");
    this.requirement = transform:Find("rightBg/requirementLine/requirementText"):GetComponent("Text"); --Prospective requirement
    this.undateTime = transform:Find("rightBg/updateImage/undateTime"):GetComponent("Text"); --更新时间倒计时
    this.content = transform:Find("rightBg/Scroll View/Viewport/Content");
    this.scroll = transform:Find("rightBg/Scroll View/Viewport"):GetComponent("ActiveLoopScrollRect");
end