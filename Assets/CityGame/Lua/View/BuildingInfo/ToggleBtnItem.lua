
ToggleBtnItem = class('ToggleBtnItem')


---初始化方法   数据（读配置表）
function ToggleBtnItem:initialize(prefab,luaBehaviour,data,ctrl)
    self.prefab = prefab
    self.luaBehaviour = luaBehaviour
    self.data = data
    self.ctrl = ctrl

    --self.ima=prefab.transform:Find("Image"):GetComponent("Image");
    --self.deleteBtn=prefab.transform:Find("Button")
    self.foodtext = prefab.transform:Find("food/foodText"):GetComponent("Text")

    luaBehaviour:AddClick(prefab,self.c_OnClick_Delete,self);
     self:Refresh(data)
end



---==========================================================================================点击函数=============================================================================
--删除
function ToggleBtnItem:c_OnClick_Delete(ins)
   local item = {}
   local type = ins.data.childs
    prints("ToggleBtnItem")

end

--删除2
function ToggleBtnItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
end


---==========================================================================================业务逻辑=============================================================================

function ToggleBtnItem:updateData( data )
    self.data = data
    self.foodtext.text = self.data.name
end

function ToggleBtnItem:updateUI( data )
    --LoadSprite()
    if data.beginProcessTs > 0 then
        local curTime = TimeSynchronized.GetTheCurrentServerTime()
        local hasRunTime = curTime - data.beginProcessTs
    end
end

function ToggleBtnItem:Refresh(data)
    self:updateData(data)
    --self:updateUI(data)
end
----详情
--function BuildingRentWarehouseDetailPart:_earningScrollFunc(go)
--    if  self.renter == nil then
--        self.renter = UnityEngine.UI.LoopScrollDataSource.New()  --租户
--        self.renter.mProvideData = BuildingRentWarehouseDetailPart.static.researchProvideData
--        self.renter.mClearData = BuildingRentWarehouseDetailPart.static.researchClearData
--    end
--end
