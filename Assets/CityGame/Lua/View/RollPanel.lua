local transform;
--local gameObject;

RollPanel = {};
local this = RollPanel;

--启动事件
function RollPanel.Awake(obj)

    transform = obj.transform;
    this.InitPanle();

end
--初始化界面
function RollPanel.InitPanle()

    this.scrolParent = transform:Find("PopCommpent/Scroll/Viewport/Content")
    this.titleText = transform:Find("PopCommpent/titleText"):GetComponent("Text")

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