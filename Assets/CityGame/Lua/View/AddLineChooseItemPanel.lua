---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/12/4 10:21
---合成表界面
local transform
AddLineChooseItemPanel = {}
local this = AddLineChooseItemPanel

function AddLineChooseItemPanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function AddLineChooseItemPanel.InitPanel()
    this.backBtn = transform:Find("topRoot/backBtn")
    this.searchBtn = transform:Find("topRoot/searchBtn")
    this.leftBtnParentTran = transform:Find("leftBtnParent"):GetComponent("RectTransform")
    this.leftBtn = transform:Find("leftBtnParent/leftBtn")
    this.leftDisableImg = transform:Find("leftBtnParent/disableImg")
    this.rightBtnParentTran = transform:Find("rightBtnParent"):GetComponent("RectTransform")
    this.rightBtn = transform:Find("rightBtnParent/rightBtn"):GetComponent("Button")
    this.rightDisableImg = transform:Find("rightBtnParent/disableImg")

    this.titleText = transform:Find("topRoot/titleText"):GetComponent("Text")
    this.leftTypeToggleTran = transform:Find("leftRoot")
    this.rightTypeToggleTran = transform:Find("rightRoot")
    this.hLine = transform:Find("centerRoot/lineRoot/hLine")
    this.vLine = transform:Find("centerRoot/lineRoot/vLine")
    this._getCenterItems(transform:Find("centerRoot/itemRoot"))

    this.leftToggleMgr = AddLineTogglesMgr:new(this.leftTypeToggleTran, AddLineTogglesSideValue.Left)
    this.rightToggleMgr = AddLineTogglesMgr:new(this.rightTypeToggleTran, AddLineTogglesSideValue.Right)
end
--获取中间的item
function AddLineChooseItemPanel._getCenterItems(viewTran)
    this.centerItems = {}
    local childCount = viewTran.childCount - 1
    for i = 0, childCount - 1 do
        local tran = viewTran:Find("item0"..i + 1)
        this.centerItems[#this.centerItems + 1] = AddLineCompositeItem:new(tran)
    end
    this.productionItem = AddLineCompositeItem:new(viewTran:Find("productionItem"))
end
