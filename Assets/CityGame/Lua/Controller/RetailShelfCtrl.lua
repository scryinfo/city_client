RetailShelfCtrl = class('RetailShelfCtrl',UIPage)
UIPage:ResgisterOpen(RetailShelfCtrl)

local isShowList
local isShowLists
RetailShelfCtrl.retailShelfGoods = {}
RetailShelfCtrl.retailShelfUIData = {}
function RetailShelfCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function RetailShelfCtrl:bundleName()
    return "RetailShelfPanel"
end

function RetailShelfCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
end

function RetailShelfCtrl:Awake(go)
    self.gameObject = go
    self.retailShelf = self.gameObject:GetComponent('LuaBehaviour')
    self.retailShelf:AddClick(RetailShelfPanel.return_Btn.gameObject, self.OnClick_return_Btn, self)
    self.retailShelf:AddClick(RetailShelfPanel.arrowBtn.gameObject,self.OnClick_arrowBtn,self)
    self.retailShelf:AddClick(RetailShelfPanel.levelArrowBtn.gameObject,self.OnClick_levelArrowBtn,self)
    self.retailShelf:AddClick(RetailShelfPanel.nameBtn.gameObject,self.OnClick_OnName,self)
    self.retailShelf:AddClick(RetailShelfPanel.quantityBtn.gameObject,self.OnClick_OnNumber,self)
    self.retailShelf:AddClick(RetailShelfPanel.priceBtn.gameObject,self.OnClick_OnPrice,self)
    self.retailShelf:AddClick(RetailShelfPanel.allBtn.gameObject,self.OnClick_OnAll,self)
    self.retailShelf:AddClick(RetailShelfPanel.normalBtn.gameObject,self.OnClick_OnNormal,self)
    self.retailShelf:AddClick(RetailShelfPanel.middleBtn.gameObject,self.OnClick_OnMiddle,self)
    self.retailShelf:AddClick(RetailShelfPanel.seniorBtn.gameObject,self.OnClick_OnSenior,self)
    self.retailShelf:AddClick(RetailShelfPanel.addBtn.gameObject,self.OnClick_addBtn,self)

    isShowList = false;
    isShowLists = false;
end

function RetailShelfCtrl:Refresh()
    if self.m_data == nil then
        return;
    end
    RetailShelfPanel.capacitySlider.maxValue = PlayerBuildingBaseData[self.m_data.info.mId].shelfCapacity;
    RetailShelfPanel.capacitySlider.value = self:getShelfCapacity(self.m_data.shelf)
    RetailShelfPanel.numberText.text = getColorString(RetailShelfPanel.capacitySlider.value,RetailShelfPanel.capacitySlider.maxValue,"blue","white")
end
--打开名字数量价格排序
function RetailShelfCtrl:OnClick_arrowBtn(go)
    go:OnClick_OpenList(not isShowList,0)
end
--打开等级评分排序
function RetailShelfCtrl:OnClick_levelArrowBtn(go)
    go:OnClick_OpenList(not isShowLists,1)
end
--排序列表
function RetailShelfCtrl:OnClick_OpenList(isShow,number)
    if isShow then
        if number == 0 then
            RetailShelfPanel.listTable:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.arrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowList = isShow
        elseif number == 1 then
            RetailShelfPanel.listTables:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.levelArrowBtn:DORotate(Vector3.New(0,0,180),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowLists = isShow
        end
    else
        if number == 0 then
            RetailShelfPanel.listTable:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.arrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowList = isShow
        elseif number == 1 then
            RetailShelfPanel.listTables:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            RetailShelfPanel.levelArrowBtn:DORotate(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
            isShowLists = isShow
        end
    end
end

--点击添加按钮Add
function RetailShelfCtrl:OnClick_addBtn(go)
    local data = {}
    data.buildingData = BuildingType.RetailShop;
    go.GoodsUnifyMgr = GoodsUnifyMgr:new(go.retailShelf,data);
end

--名字排序
function RetailShelfCtrl:OnClick_OnName(go)
    RetailShelfPanel.nowText.text = "By name";
    go:OnClick_OpenList(not isShowList,0)
end
--数量排序
function RetailShelfCtrl:OnClick_OnNumber(go)
    RetailShelfPanel.nowText.text = "By quantity";
    go:OnClick_OpenList(not isShowList,0)
end
--价格排序
function RetailShelfCtrl:OnClick_OnPrice(go)
    RetailShelfPanel.nowText.text = "By price";
    go:OnClick_OpenList(not isShowList,0)
end
--全部排序
function RetailShelfCtrl:OnClick_OnAll(go)
    RetailShelfPanel.levelnowText.text = "All";
    go:OnClick_OpenList(not isShowLists,1)
end
--低等级排序
function RetailShelfCtrl:OnClick_OnNormal(go)
    RetailShelfPanel.levelnowText.text = "Normal";
    go:OnClick_OpenList(not isShowLists,1)
end
--中等级排序
function RetailShelfCtrl:OnClick_OnMiddle(go)
    RetailShelfPanel.levelnowText.text = "Middle";
    go:OnClick_OpenList(not isShowLists,1)
end
--高等级排序
function RetailShelfCtrl:OnClick_OnSenior(go)
    RetailShelfPanel.levelnowText.text = "Senior";
    go:OnClick_OpenList(not isShowLists,1)
end
--获取零售店货架容量
function RetailShelfCtrl:getShelfCapacity(table)
    local shelfCapacity = 0;
    if not table.inHand then
        shelfCapacity = 0;
        return shelfCapacity;
    else
        for k,v in pairs(table.inHand) do
            shelfCapacity = shelfCapacity + v.n
        end
        return shelfCapacity;
    end
end
function RetailShelfCtrl:OnClick_return_Btn()
    UIPage.ClosePage();
end