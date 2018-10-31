---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/26/026 11:25
---
require 'View/BuildingInfo/AdvertisementItem'

require 'View/BuildingInfo/AddItem'
require'View/BuildingInfo/GoodsItem'
require'View/BuildingInfo/BuildingItem'


local class = require 'Framework/class'
ItemCreatDeleteMgr = class('ItemCreatDeleteMgr')

ItemCreatDeleteMgr.advertisementItemPreb_Path="View/GoodsItem/AdvertisementItem"
ItemCreatDeleteMgr.addItemPreb_Path="View/GoodsItem/addItem"
ItemCreatDeleteMgr.goodsPreb_Path="View/GoodsItem/goodsItem"
ItemCreatDeleteMgr.buildingPreb_Path="View/GoodsItem/buildingItem"

function ItemCreatDeleteMgr:initialize(luabehaviour,creatData)
    if not  self.addedItemList then
        self.addedItemList={}
        self.selectItemList={}
        self.index=0
        --Event.AddListener("c_creatGoods",self.c_creatGoods,self)
   end

    self.behaviour = luabehaviour
    self.buildingData=creatData

    if creatData.buildingType == BuildingType.Municipal then
        self:_creatAdvertisementItem(creatData.count);
    elseif creatData.buildingType == BuildingType.MunicipalManage then
        self:_creatManageItem(creatData.count);
    end
end

function ItemCreatDeleteMgr:_creatAdvertisementItem(count)
    if(not self.AdvertisementItemList ) then
        self.AdvertisementItemList={}
    end

    for i = 1, 50 do
       ---预制的信息
        local prefabData={}
        prefabData.count=i
        prefabData.owner=Buildingowner.master
        ---创建预制
        local itemclone=self:c_creatGoods(self.advertisementItemPreb_Path,AdvertisementPosPanel.scrollcon)
        self.AdvertisementItemList[i]=itemclone
        ---给预制文本赋值
         AdvertisementItem:new(prefabData,itemclone,self.behaviour,self,i)
    end
end

function ItemCreatDeleteMgr:_creatManageItem(count)
    if(not self.addItemList ) then
        self.addItemList={}
    end

    for i = 1, 50 do
     ---创建添加按钮
        ---预制的信息
        local prefabData={}
        prefabData.count=i
        ---创建预制
        local itemclone=self:c_creatGoods(self.addItemPreb_Path,ManageAdvertisementPosPanel.addCon)
                   self.addItemList[i]=itemclone
         ---给预制赋值数据
        AddItem:new(prefabData,itemclone,self.behaviour,self,i)
    end
----------------------------------------------------------------------------------------------------------

    for i = 1, count do
        if(not self.goodsItemList)then
            self.goodsItemList={}
        end

   ---创建商品广告
       ---预制的信息
        local  goodsPrebData={}
        goodsPrebData.count=i
        ---创建预制
        local goods=self:c_creatGoods(self.goodsPreb_Path,ManageAdvertisementPosPanel.goodsCon)
        self.goodsItemList[i]=goods
        --- ---给预制赋值数据
        GoodsItem:new(goodsPrebData,goods,self.behaviour,self,i)
        local t=self
    end
-------------------------------------------------------------------------------------------------------------------
     ---创建建筑广告
     for i = 1, count do
         if not self.buildItemList then
            self.buildItemList={}
         end

         ---预制的信息
         local  buildingPrebData={}
         buildingPrebData.count=i
       ---创建预制
         local buildings=self:c_creatGoods(self.buildingPreb_Path,ManageAdvertisementPosPanel.buildingCon)
          self.buildItemList[i]=buildings
         --- ---给预制赋值数据
       BuildingItem:new(buildingPrebData,buildings,self.behaviour,self,i)
    end
end

---生成预制
function ItemCreatDeleteMgr:c_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent);--.transform
    rect.transform.localScale = Vector3.one;
    rect.transform.localPosition=Vector3.zero
    return go
end


---删除物品
function ItemCreatDeleteMgr:_deleteGoods(ins)
    destroy(ins.ItemList[ins.id])
 end
