local transform
AddProductionLinePanel = {}
local this = AddProductionLinePanel

function AddProductionLinePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function AddProductionLinePanel.InitPanel()
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

    this.leftToggleMgr = AddProductionLineMgr:new(this.leftInfo, AddLineButtonPosValue.Left)
    this.rightToggleMgr = AddProductionLineMgr:new(this.rightInfo, AddLineButtonPosValue.Right)
end

function AddProductionLinePanel._getCenterItems(viewTran)
    this.centerItems = {}
    local childCount = viewTran.childCount - 1
    for i = 0, childCount - 1 do
        local tran = viewTran:Find("item0"..i + 1)
        this.centerItems[#this.centerItems + 1] = AddDetailItem:new(tran)
    end
    this.productionItem = AddDetailItem:new(viewTran:Find("productionItem"))
end
