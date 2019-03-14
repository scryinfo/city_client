---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---自己的建筑
MapRightSystemPage = class('MapRightSystemPage', MapRightPageBase)

--初始化方法
function MapRightSystemPage:initialize(viewRect)
    self.viewRect = viewRect:GetComponent("RectTransform")

    self.closeBtn = self.viewRect.transform:Find("topRoot/closeBtn"):GetComponent("Button")
    --btn
    self.goHereBtn = self.viewRect.transform:Find("bottomRoot/btnRoot/goHereBtn"):GetComponent("Button")
    self.goHereText01 = self.viewRect.transform:Find("bottomRoot/btnRoot/goHereBtn/Text"):GetComponent("Text")

    self.closeBtn.onClick:AddListener(function ()
        self:close()
    end)
    self.goHereBtn.onClick:AddListener(function ()
        self:_goHereBtn()
    end)
end
--
function MapRightSystemPage:refreshData(data)
    self.viewRect.anchoredPosition = Vector2.zero
    self.data = data
    self:openShow()
end
--重置状态
function MapRightSystemPage:openShow()
    self:_language()
    self.viewRect.anchoredPosition = Vector2.zero
end
--多语言
function MapRightSystemPage:_language()
    --正式代码
    --self.goHereText01.text = GetLanguage()
    self.goHereText01.text = "Go here"
end
--关闭
function MapRightSystemPage:close()
    self.viewRect.anchoredPosition = Vector2.New(506, 0)
end
--去地图上的一个建筑
function MapRightSystemPage:_goHereBtn()
    local temp = {x = BagPosInfo[1].bagX, y = BagPosInfo[1].bagY}
    MapBubbleManager.GoHereFunc({pos = temp})
end
