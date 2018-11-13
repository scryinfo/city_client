---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/10/25 11:11
---中心仓库

local isShowList;
local switchIsShow;
local isSelect;
local itemId = {}
local centerWareHousetBehaviour
local newtotalCapacity
local listTrue = Vector3.New(0,0,180)
local listFalse = Vector3.New(0,0,0)

local class = require 'Framework/class'
CenterWareHouseCtrl = class('CenterWareHouseCtrl',UIPage)
UIPage:ResgisterOpen(CenterWareHouseCtrl) --注册打开的方法

function  CenterWareHouseCtrl:bundleName()
    return "CenterWareHousePanel"
end

function CenterWareHouseCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    --UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

function CenterWareHouseCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    self.totalCapacity = self.m_data;--仓库总容量
    self.number = 500;--商品个数
    self.money = 1000;--扩容所需金额
    self:_initData();
    isShowList = false;
    switchIsShow = false;
    isSelect = true;


    centerWareHousetBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.backBtn,self.c_OnBackBtn,self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.addBtn,self.c_OnAddBtn,self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportBtn,self.c_TransportBtn,self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportCloseBtn,self.c_transportCloseBtn,self)
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportConfirmBtn,self.c_transportConfirmBtn,self)
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.transportopenBtn,self.c_transportopenBtn,self)

    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.arrowBtn.gameObject,self.OnClick_OnSorting, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.nameBtn,self.OnClick_OnName, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.quantityBtn,self.OnClick_OnNumber, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.levelBtn,self.OnClick_OnlevelBtn, self);
    centerWareHousetBehaviour:AddClick(CenterWareHousePanel.scoreBtn,self.OnClick_OnscoreBtn, self);
    WareHouseGoodsMgr:_creatItemGoods(centerWareHousetBehaviour,isSelect);
    self. WareHouseGoodsMgr = WareHouseGoodsMgr:new()
    Event.AddListener("c_GsExtendBag",self.c_GsExtendBag,self);
    Event.AddListener("c_OnDelete",self.c_OnDelete,self);
    Event.AddListener("c_OnBGItem",self.c_OnBGItem,self);
    Event.AddListener("c_OnTransportBG",self.c_OnTransportBG,self);
    Event.AddListener("c_OnxBtn",self.c_OnxBtn,self);
    Event.AddListener("c_transport",self.c_transport,self);

end
--初始化
function CenterWareHouseCtrl:_initData()
    CenterWareHousePanel.number:GetComponent("Text").text = self.number;
    CenterWareHousePanel.total:GetComponent("Text").text =self.number .. "/" ..  self.totalCapacity;
    CenterWareHousePanel.slider:GetComponent("Slider").value = self.number/ self.totalCapacity;
    CenterWareHousePanel.money:GetComponent("Text").text = self.money;
end

--点击删除
function CenterWareHouseCtrl:c_OnDelete(go)
    local data = {}
    data.titleInfo = "提示"
    data.contentInfo = "确认销毁吗"
    data.tipInfo = "物品将永久消失"
    data.btnCallBack = function ()
        Event.Brocast("m_DeleteItem",go)
        go.manager:_deleteGoods(go.id)
    end
    ct.OpenCtrl('BtnDialogPageCtrl',data)
end

--点击BG
function CenterWareHouseCtrl:c_OnBGItem()
    local data = {}
    data.madeBy = "来自Rodger公司"
    data.playerName = " rodger"
    ct.OpenCtrl('MessageTooltipCtrl',data)
end

--点击运输后的BG
function CenterWareHouseCtrl:c_OnTransportBG(go)
    if itemId[go.id] == nil then
        itemId[go.id] = go.id
        local goodsDataInfo = {};
        goodsDataInfo.name =  go.goodsDataInfo.name;
        goodsDataInfo.number = go.goodsDataInfo.number;
        goodsDataInfo.id = go.id;
        goodsDataInfo.itemId = go.itemId
        go.manager:_creatTransportGoods(goodsDataInfo);
        go.select_while:SetActive(false);
    else
        go.manager:_deleteTspGoods(go.id);
        itemId[go.id] = nil
    end
end

--点击删除运输物品
function CenterWareHouseCtrl:c_OnxBtn(go)
    go.manager:_deleteTspGoods(go.id);
    itemId[go.id] = nil
end

--返回按钮
function CenterWareHouseCtrl:c_OnBackBtn()
    ct.log("rodger_w8_GameMainInterface","[test_creatTransportGoods]  测试完毕",1234)
    UIPage.ClosePage();
end
function CenterWareHouseCtrl:Refresh()
    ct.log("rodger_w8_GameMainInterface","[test_Refresh]  测试完毕",self.m_data)
end
--扩容按钮
function CenterWareHouseCtrl:c_OnAddBtn(go)
    Event.Brocast("m_extendBag");
end

function CenterWareHouseCtrl:c_GsExtendBag()
        self.totalCapacity = self.totalCapacity+100
        self.money = self.money*2;
        self:_initData();
end

--运输按钮
function CenterWareHouseCtrl:c_TransportBtn(go)
    CenterWareHousePanel.addItem:SetActive(false);
    isSelect = false;
    WareHouseGoodsMgr:_setActiva(isSelect)
    CenterWareHouseCtrl:OnClick_transportBtn(not switchIsShow);
end

--选择仓库按钮
function CenterWareHouseCtrl:c_transportopenBtn()
    ct.OpenCtrl('ChooseWarehouseCtrl');
end

--开始运输按钮
function CenterWareHouseCtrl:c_transportConfirmBtn(go)
--[[    ct.OpenCtrl('TransportBoxCtrl')]]
    for i, v in pairs(WareHouseGoodsMgr.allTspItem) do
       -- ct.log("rodger_w8_GameMainInterface","[test_creatTransportGoods]  测试完毕",PlayerTempModel.roleData.buys.materialFactory[1].info.id)
        Event.Brocast("m_ReqTransport",PlayerTempModel.roleData.bagId,PlayerTempModel.roleData.buys.materialFactory[1].info.id,v.itemId,v.inputText.text)
    end
    WareHouseGoodsMgr:ClearAll()
    itemId = {}
    WareHouseGoodsMgr:EnabledAll()
end

--开始运输回调
function CenterWareHouseCtrl:c_transport(msg)
    local table = self.WareHouseGoodsMgr.items
    for i,v in pairs(table) do
        if v.itemId == msg.itemId then
            if v.goodsDataInfo.number == msg.n then
                WareHouseGoodsMgr:_deleteGoods(i)
            else
                v.numberText.text = v.goodsDataInfo.number - msg.n;
            end
        end
    end
end

function CenterWareHouseCtrl:c_transportCloseBtn()
    CenterWareHousePanel.addItem:SetActive(true);
    isSelect = true;
    WareHouseGoodsMgr:_setActiva(isSelect)
    CenterWareHouseCtrl:OnClick_transportBtn(not switchIsShow);
end

function CenterWareHouseCtrl.OnClick_OnSorting(go)
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end

--根据名字排序
function CenterWareHouseCtrl.OnClick_OnName(go)
    CenterWareHousePanel.nowText.text = "By name";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end
--根据数量排序
function CenterWareHouseCtrl.OnClick_OnNumber(go)
    CenterWareHousePanel.nowText.text = "By quantity";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end
--根据水平排序
function CenterWareHouseCtrl.OnClick_OnlevelBtn(go)
    CenterWareHousePanel.nowText.text = "By level";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end
--根据分数排序
function CenterWareHouseCtrl.OnClick_OnscoreBtn(go)
    CenterWareHousePanel.nowText.text = "By score";
    CenterWareHouseCtrl.OnClick_OpenList(not isShowList);
end
function CenterWareHouseCtrl.OnClick_OpenList(isShow)
    if isShow then
        --ShelfPanel.list:SetActive(true);
        CenterWareHousePanel.list:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.arrowBtn:DORotate(listTrue,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    else
        --ShelfPanel.list:SetActive(false);
        CenterWareHousePanel.list:DOScale(Vector3.New(0,0,0),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.arrowBtn:DORotate(listFalse,0.1):SetEase(DG.Tweening.Ease.OutCubic);
    end
    isShowList = isShow;
end

--打开运输面板
function CenterWareHouseCtrl:OnClick_transportBtn(isShow)
    if isShow then
        CenterWareHousePanel.bg:DOScale(Vector3.New(1,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.transport:SetActive(true);
        CenterWareHousePanel.content.offsetMax = Vector2.New(-770,0);
    else

        CenterWareHousePanel.bg:DOScale(Vector3.New(0,1,1),0.1):SetEase(DG.Tweening.Ease.OutCubic);
        CenterWareHousePanel.transport:SetActive(false);
        CenterWareHousePanel.content.offsetMax = Vector2.New(0,0);
    end
    switchIsShow = isShow;
end