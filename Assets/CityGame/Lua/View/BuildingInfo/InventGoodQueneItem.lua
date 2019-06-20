
InventGoodQueneItem = class('InventGoodQueneItem')

local second
local isUpdata
---初始化方法   数据（读配置表）
function InventGoodQueneItem:initialize(data,prefab,luaBehaviour,ctrl)
    self.prefab=prefab.gameObject
    self.data = data
    self.transform = prefab.transform;
    self.bg = self.transform:Find("bg")
    self.myBg = self.transform:Find("myBg")
    self.head = self.transform:Find("player/head/headBg")
    self.name = self.transform:Find("player/head/headBg/name"):GetComponent("Text")
    self.goodsImage = self.transform:Find("goods/goodsImage"):GetComponent("Image")
    self.goodsText = self.transform:Find("goods/goodsText"):GetComponent("Text")
    self.slider = self.transform:Find("details/Slider"):GetComponent("Slider")
    self.nowTime = self.transform:Find("details/Slider/time"):GetComponent("Text")
    self.timePrice = self.transform:Find("details/timePrice")
    self.time = self.transform:Find("details/timePrice/time/Text"):GetComponent("Text")
    self.price = self.transform:Find("details/timePrice/price/Text"):GetComponent("Text")
    self.startTime = self.transform:Find("startTime/time"):GetComponent("Text")
    self.delete = self.transform:Find("startTime/time/deleteBg").gameObject
    self.rollBtn = self.transform:Find("startTime/rollBtn")
    self.rollBtnText = self.transform:Find("startTime/rollBtn/rollBtnText"):GetComponent("Text")
    self.counttimetext = self.transform:Find("details/counttime"):GetComponent("Text")
    self.waiting = 0
    isUpdata = true
    luaBehaviour:AddClick(self.delete,self.c_OnClick_Delete,self)
    luaBehaviour:AddClick(self.rollBtn.gameObject,self.c_OnClick_Roll,self)

    self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
    if self.currentTime >= self.data.beginProcessTs and self.currentTime <= self.data.beginProcessTs + self.data.times*3600000  then
        local  function UpData()
            if not isUpdata then
                return
            end
            if self.bg:Equals(nil) then
                return
            end
            --倒计时
            self.waiting = self.waiting -1
            if self.waiting <= 0 then
                self.currentTime = TimeSynchronized.GetTheCurrentServerTime()    --服务器当前时间(毫秒)
                local ts =getTimeBySec( (self.currentTime - self.data.beginProcessTs)/1000)
                --local downtime = getTimeBySec((self.data.times * 3600000 - ts)/1000)
                self.counttimetext.text = ts.hour.. ":" .. ts.minute .. ":" .. ts.second .. "/" .. math.floor(self.data.times).. "h"
                self.waiting = 1
            end
        end
        ctrl:SetFunc(UpData)
    else
        self.counttimetext.text = nil
    end
    self:Refresh(data)
end
---==========================================================================================点击函数=============================================================================
--删除
function InventGoodQueneItem:c_OnClick_Delete(go)
    local data={ins = go,content = GetLanguage(28040043),func = function()
        DataManager.DetailModelRpcNoRet(LaboratoryCtrl.static.insId, 'm_ReqLabDeleteLine',go.data.id)
    end  }
    ct.OpenCtrl('ReminderCtrl',data)
end

--删除
function InventGoodQueneItem:c_OnClick_Roll(ins)
    ct.OpenCtrl("RollCtrl" , ins.data)
end

---==========================================================================================业务逻辑=============================================================================


function InventGoodQueneItem:updateData( data )
    self.data=data
    self:updateUI(data)
end

function InventGoodQueneItem:updateUI(data)
    if data.goodCategory ~= 0 then
        for i, configData in ipairs(InventConfig) do
            if configData.type == tostring(data.goodCategory) then
                LoadSprite(configData.iconPath , self.goodsImage,true)
                self.goodsText.text = GetLanguage(tonumber(configData.name))
            end
        end
    else
        LoadSprite("Assets/CityGame/Resources/Atlas/Laboratory/queue/icon-EVA-s.png" , self.goodsImage,true)
        self.goodsText.text = GetLanguage(28040031)
    end
    --类型名字和图片
    --goodCategory
    --self.goodsText.text = GetLanguage(dataInfo.productionType)

    --赋值开始时间
    if data.queneTime then
        local ts = getFormatUnixTime(data.queneTime/1000)
        self.startTime.text = ts.year .. "/" .. ts.month .. "/" .. ts.day .. " " .. ts.hour .. ":" .. ts.minute
    end
    --赋值Detail
    if data.beginProcessTs > 0  then
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
    if playerId == data.proposerId then -- 自己的线
        self.myBg.localScale = Vector3.one
        if LaboratoryCtrl.static.buildingOwnerId == data.proposerId then -- 并且是自己的建筑
            if data.availableRoll > 0 then -- 第一条线
                self.delete.transform.localScale = Vector3.zero
            else
                self.delete.transform.localScale = Vector3.one
            end
        else -- 不是自己的建筑
            self.delete.transform.localScale = Vector3.zero
        end
    else -- 不是自己的线
        self.myBg.localScale = Vector3.zero
        self.delete.transform.localScale = Vector3.zero
        self.rollBtn.localScale = Vector3.zero
    end

    --if data.beginProcessTs>0 and  data.ids==1 then
    --    self.delete.transform.localScale = Vector3.zero
    --end

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

function InventGoodQueneItem:updateSlider(data)
    currTime = TimeSynchronized.GetTheCurrentServerTime()
    local remmindTime = currTime - data.beginProcessTs
end
--关闭界面后关闭更新
function InventGoodQueneItem:CloseUpdata()
    isUpdata = false
end