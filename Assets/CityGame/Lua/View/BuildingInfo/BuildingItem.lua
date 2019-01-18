---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/29/029 15:13
---

require'View/BuildingInfo/MapAdvertisementItem'
local class = require 'Framework/class'

BuildingItem = class('BuildingItem')
local fontPatn="Assets/CityGame/Resources/Atlas/Municipal/"
---初始化方法   数据（读配置表）
function BuildingItem:initialize(prefabData,prefab,inluabehaviour, mgr, id)
    self.prefab = prefab;
    self.prefabData = prefabData;
    self._luabehaviour = inluabehaviour
    self.manager = mgr
    self.id = id
    self.ItemList=mgr.buildItemList
    self.type=1

    self.iconImg=prefab.transform:Find("iconBG"):GetComponent("Image")
    self.nameText=prefab.transform:Find("iconBG/Text"):GetComponent("Text")
     self.smallText=prefab.transform:Find("Body/Image (7)/Text"):GetComponent("Text")
    self.mediumText=prefab.transform:Find("Body/Image (8)/Text"):GetComponent("Text")
    self.largeText=prefab.transform:Find("Body/Image (11)/Text"):GetComponent("Text")

    local path, name =nil
    if prefabData.name=="公园" then
        path=fontPatn.."park-s.png"
        name="Park"
        self.nameText.text="Park"
        LoadSprite(path,self.iconImg,true)
    elseif  prefabData.name=="住宅" then
        name="House"
        path=fontPatn.."HomeHouse-s.png"
        self.nameText.text="House"
        LoadSprite(fontPatn.."HomeHouse-s.png",self.iconImg,true)
    else
        name="Supermarket"
        path=fontPatn.."supermarket-s.png"
        self.nameText.text="Supermarket"
        LoadSprite(fontPatn.."supermarket-s.png",self.iconImg,true)
    end

    self.smallText.text=prefabData.small
    self.mediumText.text=prefabData.medium
    self.largeText.text=prefabData.large

    self.name=name
    self.path=path
    self.itemId=prefabData.mId
    self._luabehaviour:AddClick(self.prefab, self.OnClick_Add, self);

end

---添加
function BuildingItem:OnClick_Add(go)
    if DataManager.GetMyOwnerID()==DataManager.GetDetailModelByID(MunicipalPanel.buildingId).buildingOwnerId then--自已进入
        ---顶部处理
        go.manager.index=go.manager.index+1
        ---创建映射广告
        local item=go.manager:c_creatGoods(GoodsItem.AddedItem_Path,go.manager.transform)
        ---给映射广告赋值数据
        local prefabData={metaId=go.itemId,path=go.path,name=go.name,personName=DataManager.GetName(),type=go.type}
        MapAdvertisementItem:new(prefabData,item,go._luabehaviour,go.manager,go.manager.index)
        ---选中广告不可在点击
        self:GetComponent("Image").raycastTarget=false;
        ---管理器表添加
        go.manager.addedItemList[go.manager.index]=item
        go.manager.selectItemList[go.manager.index]=self
        go.manager.AdvertisementDataList[go.manager.index]={count=1,type=1,name=go.name,metaId=go.itemId,path=go.path,personName=DataManager.GetName()}

        ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(false);
    else--他人进入
        ---顶部处理
        go.manager.index=go.manager.index+1
        ---创建映射广告
        local item=go.manager:c_creatGoods(GoodsItem.AddedItem_Path,go.manager.transform)
        ---给映射广告赋值数据
        local prefabData={metaId=go.itemId,path=go.path,name=go.name}
        MapAdvertisementItem:new(prefabData,item,go._luabehaviour,go.manager,go.manager.index)
        ---选中广告不可在点击
        self:GetComponent("Image").raycastTarget=false;
        ---管理器表添加
        go.manager.addedItemList[go.manager.index]=item
        go.manager.selectItemList[go.manager.index]=self
        go.manager.AdvertisementDataList[go.manager.index]={count=1,type=1,name=go.name,metaId=go.itemId,slots=go.manager.current.slots,path=go.path,
                                                            personName=DataManager.GetName()}
        ---数字文本加减
        go.manager.current.numText.text=go.manager.current.updateAcount-1
        ---选中广告不可在点击
        self:GetComponent("Image").raycastTarget=false;
        ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(false);
    end
end