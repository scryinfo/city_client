---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---小地图搜索类型
MapRightMatGoodPage = class('MapRightMatGoodPage')

--初始化方法
function MapRightMatGoodPage:initialize(viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")

    self.closeBtn = self.viewRect.transform:Find("topRoot/closeBtn"):GetComponent("Button")
    self.protaitImg = self.viewRect.transform:Find("topRoot/protaitRoot/bg/protaitImg"):GetComponent("Image")
    self.nameText = self.viewRect.transform:Find("topRoot/nameText"):GetComponent("Text")
    self.companyText = self.viewRect.transform:Find("topRoot/companyText"):GetComponent("Text")
    self.buildingNameText = self.viewRect.transform:Find("topRoot/bg/buildingNameText"):GetComponent("Text")
    self.femaleIconTran = self.viewRect.transform:Find("topRoot/nameText/femaleIcon")
    self.manIconTran = self.viewRect.transform:Find("topRoot/nameText/manIcon")

    --btn
    self.goHereBtn = self.viewRect.transform:Find("bottomRoot/btnRoot/goHereBtn"):GetComponent("Button")
    self.leftBtn = self.viewRect.transform:Find("bottomRoot/leftRightBtnRoot/leftBtn"):GetComponent("Button")
    self.rightBtn = self.viewRect.transform:Find("bottomRoot/leftRightBtnRoot/rightBtn"):GetComponent("Button")
    self.leftRightBtnRoot = self.viewRect.transform:Find("bottomRoot/leftRightBtnRoot")
    self.mapRightMatGoodPrefab = self.viewRect.transform:Find("bottomRoot/MapRightMatGoodItem")
    self.mapRightMatGoodItem = MapRightMatGoodItem:new(self.mapRightMatGoodPrefab.transform)

    self.goHereText01 = self.viewRect.transform:Find("bottomRoot/btnRoot/goHereBtn/Text"):GetComponent("Text")
    --old
    self.closeBtn.onClick:AddListener(function ()
        self:_clickFunc()
    end)
    self.goHereBtn.onClick:AddListener(function ()
        self:_clickFunc()
    end)
    self.leftBtn.onClick:AddListener(function ()
        self:_clickFunc()
    end)
    self.rightBtn.onClick:AddListener(function ()
        self:_clickFunc()
    end)
    --

    self:resetState()
end
--
function MapRightMatGoodPage:refreshData(data)
    self.viewRect.anchoredPosition = Vector2.zero
    self.data = data
    if data.playerInfo ~= nil then
        self.nameText.text = data.playerInfo.name
        self.companyText.text = data.playerInfo.companyName
        if data.male == true then
            self.manIconTran.localScale = Vector3.one
            self.femaleIconTran.localScale = Vector3.zero
        else
            self.manIconTran.localScale = Vector3.zero
            self.femaleIconTran.localScale = Vector3.one
        end
        --self.protaitImg = data.playerInfo.faceId
    end
    self.buildingNameText.text = data.buildingBase.name
    if #data.detailData.sale > 1 then
        self.leftRightBtnRoot.localScale = Vector3.one

        self.currentIndex = 0
        self.totalCount = #data.detailData.sale
        self:_rightChangeBtn()  --右翻
    else
        self.leftRightBtnRoot.localScale = Vector3.zero
        self.mapRightMatGoodItem:refreshData(data.detailData.sale)
    end
end
--重置状态
function MapRightMatGoodPage:resetState()
    self:_language()
end
--多语言
function MapRightMatGoodPage:_language()
    --正式代码
    --self.goHereText01.text = GetLanguage()
    self.goHereText01.text = "Go here"
end
--关闭
function MapRightMatGoodPage:_closeBtn()
    self.viewRect.anchoredPosition = Vector2.New(506, 0)
end
--去地图上的一个建筑
function MapRightMatGoodPage:_goHereBtn()

end
--左翻
function MapRightMatGoodPage:_leftChangeBtn()
    if self.currentIndex == 1 then
        self.leftBtn.localScale = Vector3.zero
        return
    else
        self.currentIndex = self.currentIndex - 1
        self.mapRightMatGoodItem:refreshData(self.data.sale[self.currentIndex])
        if self.currentIndex == 1 then
            self.leftBtn.localScale = Vector3.zero
        end
    end
end
--右翻
function MapRightMatGoodPage:_rightChangeBtn()
    if self.currentIndex == self.totalCount then
        self.rightBtn.localScale = Vector3.zero
        return
    else
        self.currentIndex = self.currentIndex + 1
        self.mapRightMatGoodItem:refreshData(self.data.sale[self.currentIndex])
        if self.currentIndex == self.totalCount then
            self.rightBtn.localScale = Vector3.zero
        end
    end
end
