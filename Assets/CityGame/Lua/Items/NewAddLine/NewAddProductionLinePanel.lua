local transform
NewAddProductionLinePanel = {}
local this = NewAddProductionLinePanel

function NewAddProductionLinePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function NewAddProductionLinePanel.InitPanel()
    this.nameText = transform:Find("Topbg/nameText"):GetComponent("Text")
    this.returnBtn = transform:Find("Topbg/Button/returnBtn")
    this.leftBtnParent = transform:Find("leftBtnParent"):GetComponent("RectTransform")
    this.leftBtn = transform:Find("leftBtnParent/leftBtn"):GetComponent("Button")
    this.leftDisableImg = transform:Find("leftBtnParent/disableImg")
    this.rightBtnParent = transform:Find("rightBtnParent"):GetComponent("RectTransform")
    this.rightBtn = transform:Find("rightBtnParent/rightBtn"):GetComponent("Button")
    this.rightDisableImg = transform:Find("rightBtnParent/disableImg")
    this.leftInfo = transform:Find("leftInfo")
    this.rightInfo = transform:Find("rightInfo")
    this.hLine = transform:Find("centerRoot/lineRoot/hLine")
    this.vLine = transform:Find("centerRoot/lineRoot/vLine")
    this._getCenterItems(transform:Find("centerRoot/itemRoot"))

    this.leftToggleMgr = AddLineMgrNew:new(this.leftInfo, AddLineSideValue.Left)
    this.rightToggleMgr = AddLineMgrNew:new(this.rightInfo, AddLineSideValue.Right)
end

function NewAddProductionLinePanel._getCenterItems(viewTran)
    this.centerItems = {}
    local childCount = viewTran.childCount - 1
    for i = 0, childCount - 1 do
        local tran = viewTran:Find("item0"..i + 1)
        this.centerItems[#this.centerItems + 1] = AddLineCenterItem:new(tran)
    end
    this.productionItem = AddLineCenterItem:new(viewTran:Find("productionItem"))
end
