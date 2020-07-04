local transform

InventPopPanel = {}
local this = InventPopPanel

--Start event
function InventPopPanel.Awake(obj)
    transform = obj.transform
    this.InitPanle()
end

--Initialize the interface
function InventPopPanel.InitPanle()
    this.countInp = findByName(transform,"countInput"):GetComponent("InputField")
    this.titleText = transform:Find("PopCommpent/titleText"):GetComponent("Text")
    this.icon = transform:Find("PopCommpent/top/icon"):GetComponent("Image")
    this.iconNameText = transform:Find("PopCommpent/top/icon/Text"):GetComponent("Text")
    this.oddsText = findByName(transform,"oddsText"):GetComponent("Text")
    this.num = findByName(transform,"num"):GetComponent("Text")
    this.evaTips = transform:Find("PopCommpent/top/evaTips"):GetComponent("Text")
    this.Slider = findByName(transform,"Slider"):GetComponent("Slider")
    this.timeText = findByName(transform,"timeText"):GetComponent("Text")
    this.tips = findByName(transform,"tips"):GetComponent("Text")
    this.confimBtnText = findByName(transform,"confimBtnText"):GetComponent("Text")
    this.price = transform:Find("PopCommpent/price")
    this.priceText = findByName(transform,"priceText"):GetComponent("Text")
    this.buyRoot = transform:Find("PopCommpent/buyRoot")
    this.sellRoot = findByName(transform,"sellRoot")
    this.timeText1 = findByName(this.sellRoot,"timeText"):GetComponent("Text")
    this.tips1 = findByName(this.sellRoot,"tips (1)"):GetComponent("Text")
    this.countInput1 = findByName(this.sellRoot,"countInput1"):GetComponent("InputField")
end

