---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/2/27 18:13
---点击其他人Mat Good的界面
MapRightOtherMatGoodPage = class('MapRightOtherMatGoodPage')
MapRightOtherMatGoodPage.moneyColor = "#F4AD07FF"

--初始化方法
function MapRightOtherMatGoodPage:initialize(viewRect)
    self.viewTrans = viewRect.transform

    self.leftBtn = self.viewTrans:Find("leftRightBtnRoot/leftBtn"):GetComponent("Button")
    self.rightBtn = self.viewTrans:Find("leftRightBtnRoot/rightBtn"):GetComponent("Button")
    self.wareHouseRoot = self.viewTrans:Find("wareHouseRoot")
    self.portrait = self.viewTrans:Find("wareHouseRoot/portrait")
    self.btn = self.viewTrans:Find("wareHouseRoot/btn"):GetComponent("Button")
    self.nameText = self.viewTrans:Find("wareHouseRoot/nameText"):GetComponent("Text")

    self.leftRightBtnRoot = self.viewTrans:Find("leftRightBtnRoot")
    self.mapRightMatGoodPrefab = self.viewTrans:Find("MapRightMatGoodItem")
    self.mapRightMatGoodItem = MapRightMatGoodItem:new(self.mapRightMatGoodPrefab.transform)

    self.leftBtn.onClick:AddListener(function ()
        self:_leftChangeBtn()
    end)
    self.rightBtn.onClick:AddListener(function ()
        self:_rightChangeBtn()
    end)
    self.btn.onClick:AddListener(function ()
        self:_clickPortrait()
    end)
end
--
function MapRightOtherMatGoodPage:refreshData(data)
    self.viewTrans.localScale = Vector3.one
    self.data = data
    --暂时不加入仓库
    self.wareHouseRoot.localScale = Vector3.zero

    if #data.sale > 1 then
        self.leftRightBtnRoot.localScale = Vector3.one

        self.currentIndex = 0
        self.totalCount = #data.sale
        self:_rightChangeBtn()  --右翻
    else
        self.leftRightBtnRoot.localScale = Vector3.zero
        self.mapRightMatGoodItem:refreshData(data.sale[1])
    end

    self:_language()
end
--左翻
function MapRightOtherMatGoodPage:_leftChangeBtn()
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
function MapRightOtherMatGoodPage:_rightChangeBtn()
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
--点击仓库头像
function MapRightOtherMatGoodPage:_clickPortrait()
    if self.wareRenterInfo ~= nil then
        ct.OpenCtrl("PersonalHomeDialogPageCtrl", self.wareRenterInfo)
    end
end
--
function MapRightOtherMatGoodPage:_initWareRenterInfo(data)
    local info = data[1]
    if info ~= nil then
        self.nameText.text = info.name
        self.avatar = AvatarManger.GetSmallAvatar(info.faceId, self.portrait,0.2)
    end
end
--多语言
function MapRightOtherMatGoodPage:_language()

end
--关闭
function MapRightOtherMatGoodPage:close()
    self.viewTrans.localScale = Vector3.zero
    if self.avatar ~= nil then
        AvatarManger.CollectAvatar(self.avatar)
    end
end