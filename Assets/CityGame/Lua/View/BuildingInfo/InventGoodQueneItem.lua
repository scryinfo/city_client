
InventGoodQueneItem = class('InventGoodQueneItem')


---初始化方法   数据（读配置表）
function InventGoodQueneItem:initialize(data,prefab,luaBehaviour)
    self.prefab=prefab.gameObject

    self.transform = prefab.transform;
    self.bg = self.transform:Find("bg")
    self.myBg = self.transform:Find("myBg")
    self.head = self.transform:Find("player/head/headBg")
    self.name = self.transform:Find("player/head/headBg/name"):GetComponent("Text")
    self.goodsImage = self.transform:Find("goods/goodsImage"):GetComponent("Image")
    self.goodsText = self.transform:Find("goods/goodsImage/goodsText"):GetComponent("Text")
    self.slider = self.transform:Find("details/Slider"):GetComponent("Slider")
    self.nowTime = self.transform:Find("details/Slider/time"):GetComponent("Text")
    self.timePrice = self.transform:Find("details/timePrice")
    self.time = self.transform:Find("details/timePrice/time/Text"):GetComponent("Text")
    self.price = self.transform:Find("details/timePrice/price/Text"):GetComponent("Text")
    self.startTime = self.transform:Find("startTime/time"):GetComponent("Text")
    self.delete = self.transform:Find("startTime/time/deleteBg").gameObject
    self.rollBtn = findByName(self.transform,"rollBtn")
    self.rollBtnText = findByName(self.transform,"rollBtnText"):GetComponent("Text")

    luaBehaviour:AddClick(self.delete,self.c_OnClick_Delete,self)
    luaBehaviour:AddClick(self.rollBtn.gameObject,self.c_OnClick_Roll,self)

    self:Refresh(data)
end
---==========================================================================================点击函数=============================================================================
--删除
function InventGoodQueneItem:c_OnClick_Delete(ins)
    DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_ReqLabDeleteLine',ins.data.id)
end

--删除
function InventGoodQueneItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
end

---==========================================================================================业务逻辑=============================================================================

function InventGoodQueneItem:updateData( data )
    self.data=data
end

function InventGoodQueneItem:updateUI(data)

    --类型名字和图片
    --goodCategory
    --self.goodsText.text = GetLanguage(dataInfo.productionType)

    --赋值开始时间
    if data.queneTime then
        local ts = getFormatUnixTime(data.queneTime/1000)
        self.startTime.text = ts.year .. "/" .. ts.month .. "/" .. ts.day .. " " .. ts.hour .. " " .. ts.minute
    end
    --赋值Detail
    if data.beginProcessTs > 0 then
        if data.availableRoll >0 then
            self.rollBtn.localScale = Vector3.one
            self.rollBtnText.text = "x" .. tostring(data.availableRoll)
        else
            self.rollBtn.localScale = Vector3.zero
        end

        self.timePrice.localScale = Vector3.zero
        self.slider.transform.localScale = Vector3.one
        self.nowTime.text = tostring((data.availableRoll + data.usedRoll)) .. "/" .. tostring(data.times)
        self.slider.value = ((data.availableRoll + data.usedRoll)/data.times)
    else
        self.rollBtn.localScale = Vector3.zero
        self.timePrice.localScale = Vector3.one
        self.slider.transform.localScale = Vector3.zero
        self.time.text = data.times
        self.price.text =data.pay
    end

    --加载头像和名字
    PlayerInfoManger.GetInfos({data.proposerId}, self.c_OnHead, self)

    --自已与他人区分
    local playerId = DataManager.GetMyOwnerID()      --自己的唯一id
    if playerId == data.proposerId then
        self.myBg.localScale = Vector3.one
        if LaboratoryCtrl.static.buildingOwnerId == data.proposerId then
            self.delete.transform.localScale = Vector3.one
        else
            self.delete.transform.localScale = Vector3.zero
        end
    else
        self.myBg.localScale = Vector3.zero
    end

    if data.beginProcessTs>0 then
        self.delete.transform.localScale = Vector3.zero
    end

end

function InventGoodQueneItem:Refresh(data)
    self:updateData(data)
    self:updateUI(data)
end
--加载头像和名字
function InventGoodQueneItem:c_OnHead(info)
    AvatarManger.GetSmallAvatar(info[1].faceId,self.head.transform,0.15)
    self.name.text = info[1].name
end
