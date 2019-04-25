local transform;
--local gameObject;

InventPopPanel = {};
local this = InventPopPanel;

--启动事件
function InventPopPanel.Awake(obj)

    transform = obj.transform;
    this.InitPanle();

end
--初始化界面
function InventPopPanel.InitPanle()

    this.countInp = findByName(transform,"countInput"):GetComponent("InputField")
    this.titleText = findByName(transform,"titleText"):GetComponent("Text")
    this.icon = findByName(transform,"icon"):GetComponent("Image")
    this.iconNameText = findByName(transform,"Text"):GetComponent("Text")
    this.oddsText = findByName(transform,"oddsText"):GetComponent("Text")
    this.num = findByName(transform,"num"):GetComponent("Text")
    this.evaTips = findByName(transform,"evaTips"):GetComponent("Text")
    this.Slider = findByName(transform,"Slider"):GetComponent("Slider")
    this.timeText = findByName(transform,"timeText"):GetComponent("Text")
    this.tips = findByName(transform,"tips"):GetComponent("Text")
    this.confimBtnText = findByName(transform,"confimBtnText"):GetComponent("Text")
    this.priceText = findByName(transform,"priceText"):GetComponent("Text")

    this.buyRoot = findByName(transform,"buyRoot")
    this.sellRoot = findByName(transform,"sellRoot")
    this.timeText1 = findByName(this.sellRoot,"timeText"):GetComponent("Text")
    this.tips1 = findByName(this.sellRoot,"tips (1)"):GetComponent("Text")
    this.countInput1 = findByName(this.sellRoot,"countInput1"):GetComponent("InputField")


end

