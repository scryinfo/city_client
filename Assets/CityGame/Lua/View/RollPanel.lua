
--研究所掷点界面panel

local transform
--local gameObject

RollPanel = {}
local this = RollPanel

--启动事件
function RollPanel.Awake(obj)

    transform = obj.transform
    this.InitPanle()

end
--初始化界面
function RollPanel.InitPanle()

    this.scrolParent = transform:Find("PopCommpent/Scroll/Viewport/Content")
    --this.titleTexts = transform:Find("PopCommpent/titleTexts"):GetComponent("Text")
    this.count1 = transform:Find("resultRoot/Evaresultbg/Image/count"):GetComponent("Text")
    this.count2 = transform:Find("resultRoot/result/Image/count"):GetComponent("Text")
    this.nametexts = transform:Find("PopCommpent/Scroll/nametext"):GetComponent("Text")
    this.evanametexts = transform:Find("PopCommpent/EvaRoot/nameText"):GetComponent("Text")
    this.food = transform:Find("PopCommpent/EvaRoot/food")
    this.cloth = transform:Find("PopCommpent/EvaRoot/cloth")
    this.icon = transform:Find("PopCommpent/EvaRoot/icon")
    this.congratulation1 = transform:Find("resultRoot/Evaresultbg/CONGRATULATIONS!"):GetComponent("Text")
    this.congratulation2 = transform:Find("resultRoot/result/CONGRATULATIONS!"):GetComponent("Text")

    this.emptyTrans = transform:Find("PopCommpent/empty")  --空提示
    this.emptyTransText01 = transform:Find("PopCommpent/empty/contentText"):GetComponent("Text")

    this.totalText = findByName(transform,"totalText"):GetComponent("Text")
    this.EvaRoot = findByName(transform,"EvaRoot")

    this.resultRoot = findByName(transform,"resultRoot")
    this.FailRoot = findByName(transform,"FailRoot")
    this.EvaRoots = findByName(transform,"EvaRoots")
    this.GoodRoot = findByName(transform,"GoodRoot")


    this.FailRootBtn = findByName(transform,"FailRootBtn")
    this.EvaRootBTn = findByName(transform,"EvaRootBTn")
    this.GoodRootBtn = findByName(transform,"GoodRootBtn")

    this.failtitle = findByName(transform,"failtitle"):GetComponent("Text")
    this.failtitleText = findByName(transform,"failtitleText"):GetComponent("Text")
    this.EvaRoottitle = findByName(transform,"failtitleText"):GetComponent("Text")
    this.evatopicText = findByName(transform,"topicText"):GetComponent("Text")
    this.nowEva = findByName(transform,"nowEva"):GetComponent("Text")
    this.failtitleText = findByName(transform,"failtitleText"):GetComponent("Text")
    this.BigEVAtext = findByName(transform,"Text"):GetComponent("Text")

    this.Evaresultbg = transform:Find("resultRoot/Evaresultbg")
    this.Evaresult = transform:Find("resultRoot/Evaresultbg/Evaresult")
    this.evacount = transform:Find("resultRoot/Evaresultbg/Image/count/Text"):GetComponent("Text")
    this.EvaresultBtn = transform:Find("resultRoot/Evaresultbg/bgBtn"):GetComponent("Button")

    this.result = transform:Find("resultRoot/result")
    this.resultBtn = transform:Find("resultRoot/result/EvaRootBTn")
    this.sum = transform:Find("resultRoot/result/sum"):GetComponent("Text")
    this.count = transform:Find("resultRoot/result/Image/count/Text"):GetComponent("Text")

    this.evanotenough = transform:Find("resultRoot/evanotenough")
    this.closeEvaBTn = transform:Find("resultRoot/evanotenough/closeBTn"):GetComponent("Button")


    ---------------------------------------------
    this.mainIcon = findByName(transform,"mainIcon")
    local tempTrans =  this.mainIcon
    this.ima = findByName(tempTrans,"mainIcon"):GetComponent("Image")
    this.nameText = findByName(tempTrans,"Text"):GetComponent("Text")

    this.child1 = findByName(transform,"child1")
    tempTrans = this.child1
    this.child1Ima = findByName(tempTrans,"icon"):GetComponent("Image")
    this.child1ImanNameText = findByName(tempTrans,"Text")

    this.child2 = findByName(transform,"child2")
    tempTrans = this.child2
    this.child2Ima = findByName(tempTrans,"icon"):GetComponent("Image")
    this.child2ImanNameText = findByName(tempTrans,"Text")

    this.child3 = findByName(transform,"child3")
    tempTrans = this.child3
    this.child3Ima = findByName(tempTrans,"icon"):GetComponent("Image")
    this.child3ImanNameText = findByName(tempTrans,"Text")
end

function RollPanel.ChangeLan()

end