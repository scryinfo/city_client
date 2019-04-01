---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/25/025 17:50
---

---====================================================================================框架函数==============================================================================================

StopAndBuildCtrl = class('StopAndBuildCtrl',UIPanel)
UIPanel:ResgisterOpen(StopAndBuildCtrl) --注册打开的方法
--构建函数
function StopAndBuildCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function StopAndBuildCtrl:bundleName()
    return "Assets/CityGame/Resources/View/StopAndBuildPanel.prefab"
end

function StopAndBuildCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj);
end
local panel

--todo：刷新
function StopAndBuildCtrl:Refresh()
    panel:ChangeLanguage()
    local data=self.m_data
    self:switchRoot(panel.buildingInfoRoot,panel.buildingSelectedInfoBtn)

    ----刷新人物信息
    self:updateBuildingInfo(data)
    ----刷新按钮
    self:updateBtn(data)
end
function  StopAndBuildCtrl:Hide()
    UIPanel.Hide(self)
end

function StopAndBuildCtrl:Close()
    UIPanel.Close(self)
end

function StopAndBuildCtrl:Awake(go)
    panel = StopAndBuildPanel
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.materialBehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.materialBehaviour:AddClick(panel.stopBtn.gameObject,self.OnClick_stop,self);
    self.materialBehaviour:AddClick(panel.removeBtn.gameObject,self.OnClick_remove,self);
    self.materialBehaviour:AddClick(panel.removeBtn.gameObject,self.OnClick_remove,self);
    self.materialBehaviour:AddClick(panel.buildingInfoBtn.gameObject,self.OnClick_build,self);
    self.materialBehaviour:AddClick(panel.landInfomationBtn.gameObject,self.OnClick_land,self);
    self.materialBehaviour:AddClick(panel.nameBtn.gameObject,self.OnClick_changeName,self);
----------------------------------------------------------------------------------------------------------
    self.materialBehaviour:AddClick((panel.greenBtn1).gameObject,self.OnClick_greenBtn1,self);
    self.materialBehaviour:AddClick((panel.greenBtn2).gameObject,self.OnClick_greenBtn2,self);
    self.materialBehaviour:AddClick((panel.greenBtn3).gameObject,self.OnClick_greenBtn3,self);
    self.materialBehaviour:AddClick((panel.greenBtn4).gameObject,self.OnClick_greenBtn4,self);
    self.materialBehaviour:AddClick((panel.greenBtn5).gameObject,self.OnClick_greenBtn5,self);
    self.materialBehaviour:AddClick((panel.greenBtn6).gameObject,self.OnClick_greenBtn6,self);
    self.materialBehaviour:AddClick((panel.greenBtn7).gameObject,self.OnClick_greenBtn7,self);
    self.materialBehaviour:AddClick((panel.greenBtn8).gameObject,self.OnClick_greenBtn8,self);
    self.materialBehaviour:AddClick((panel.greenBtn9).gameObject,self.OnClick_greenBtn9,self);
    ----------------------------------------------------------------------------------------------------------
    self.materialBehaviour:AddClick((panel.blueBtn1).gameObject,self.OnClick_greenBtn1,self);
    self.materialBehaviour:AddClick((panel.blueBtn2).gameObject,self.OnClick_greenBtn2,self);
    self.materialBehaviour:AddClick((panel.blueBtn3).gameObject,self.OnClick_greenBtn3,self);
    self.materialBehaviour:AddClick((panel.blueBtn4).gameObject,self.OnClick_greenBtn4,self);
    self.materialBehaviour:AddClick((panel.blueBtn5).gameObject,self.OnClick_greenBtn5,self);
    self.materialBehaviour:AddClick((panel.blueBtn6).gameObject,self.OnClick_greenBtn6,self);
    self.materialBehaviour:AddClick((panel.blueBtn7).gameObject,self.OnClick_greenBtn7,self);
    self.materialBehaviour:AddClick((panel.blueBtn8).gameObject,self.OnClick_greenBtn8,self);
    self.materialBehaviour:AddClick((panel.blueBtn9).gameObject,self.OnClick_greenBtn9,self);

    self.CloseBtn()
    self.datas={}
    for i = 1, 9 do
        local data={}
        table.insert(self.datas,data)
    end
end

---====================================================================================点击函数==============================================================================================
--改名
function StopAndBuildCtrl:OnClick_changeName(ins)

end


--返回
function StopAndBuildCtrl:OnClick_backBtn(ins)
    ins.CloseBtn()
    UIPanel.CloseAllPageExceptMain()
    PlayMusEff(1002)
end

--点击建筑信息
function StopAndBuildCtrl:OnClick_build(ins)
    ins:switchRoot(panel.buildingInfoRoot,panel.buildingSelectedInfoBtn)
end

--点击土地信息
function StopAndBuildCtrl:OnClick_land(ins)
    ins:switchRoot(panel.landInfoRoot,panel.landInfomationSelectedBtn)
end

--拆除
function StopAndBuildCtrl:OnClick_remove(ins)
    local data={}

    data.type="remove"
    data.mainText=GetLanguage(40010013)
    data.callback=function() Event.Brocast("m_delBuilding",ins.m_data.id )
        Event.Brocast("SmallPop",GetLanguage(40010015),300)
        DataManager.RemoveMyBuildingDetailByBuildID(ins.m_data.id)
        UIPanel.CloseAllPageExceptMain()
    end
    ct.OpenCtrl('ReminderCtrl',data)
    PlayMusEff(1002)

end

--停业
function StopAndBuildCtrl:OnClick_stop(ins)
    local data={}
    data.type="stop"
    data.mainText=GetLanguage(40010009)
    data.callback=function() Event.Brocast("m_shutdownBusiness",ins.m_data.id)
        panel.removeBtn.localScale=Vector3.one
        panel.stopBtn.localScale=Vector3.zero
    end

    ct.OpenCtrl('ReminderCtrl',data)
    PlayMusEff(1002)
end

function StopAndBuildCtrl:OnClick_greenBtn1(ins)
    ins:switchGroundBtn(ins,1,self)
end
function StopAndBuildCtrl:OnClick_greenBtn2(ins)
    ins:switchGroundBtn(ins,2,self)
end
function StopAndBuildCtrl:OnClick_greenBtn3(ins)
    ins:switchGroundBtn(ins,3,self)
end
function StopAndBuildCtrl:OnClick_greenBtn4(ins)
    ins:switchGroundBtn(ins,4,self)
end
function StopAndBuildCtrl:OnClick_greenBtn5(ins)
    ins:switchGroundBtn(ins,5,self)
end
function StopAndBuildCtrl:OnClick_greenBtn6(ins)
    ins:switchGroundBtn(ins,6,self)
end
function StopAndBuildCtrl:OnClick_greenBtn7(ins)
    ins:switchGroundBtn(ins,7,self)
end
function StopAndBuildCtrl:OnClick_greenBtn8(ins)
    ins:switchGroundBtn(ins,8,self)
end
function StopAndBuildCtrl:OnClick_greenBtn9(ins)
    ins:switchGroundBtn(ins,9,self)
end
---====================================================================================业务代码==============================================================================================
local root,btn
local select
--刷新按钮
function StopAndBuildCtrl:updateBtn(buildinghInfo)
    if buildinghInfo.state == "OPERATE" then
        panel.stopBtn.localScale = Vector3.one
        panel.removeBtn.localScale = Vector3.zero
    else
        panel.stopBtn.localScale = Vector3.zero
        panel.removeBtn.localScale = Vector3.one
    end

    if DataManager.GetMyOwnerID() ~= buildinghInfo.ownerId then
        panel.removeBtn.localScale = Vector3.zero
        panel.stopBtn.localScale = Vector3.zero
    end

    local groundOwnerDatas = buildinghInfo.ctrl.groundOwnerDatas
    local groundDatas = buildinghInfo.ctrl.groundDatas
    local x = PlayerBuildingBaseData[buildinghInfo.mId].x
    if x == 1 then
      panel.greenBtn1.localScale = Vector3.one
        self.datas[1].personData = groundOwnerDatas[1]
        self.datas[1].groundData = groundDatas[1]
        if groundDatas[1].Data.rent then
            panel["blueBtn1"].localScale=Vector3.one
        end
    elseif  x == 2 then
        panel.greenBtn1.localScale = Vector3.one
        panel.greenBtn2.localScale = Vector3.one
        panel.greenBtn4.localScale = Vector3.one
        panel.greenBtn5.localScale = Vector3.one
        local table={1,2,4,5}
        for i, v in ipairs(table) do
            self.datas[v].personData=groundOwnerDatas[i]
            self.datas[v].groundData=groundDatas[i]
            if groundDatas[i].Data.rent then
                panel[("blueBtn"..tostring(i))].localScale=Vector3.one
            end
        end
    else
        panel.greenBtn1.localScale=Vector3.one
        panel.greenBtn2.localScale=Vector3.one
        panel.greenBtn3.localScale=Vector3.one
        panel.greenBtn4.localScale=Vector3.one
        panel.greenBtn5.localScale=Vector3.one
        panel.greenBtn6.localScale=Vector3.one
        panel.greenBtn7.localScale=Vector3.one
        panel.greenBtn8.localScale=Vector3.one
        panel.greenBtn9.localScale=Vector3.one
        for i, v in ipairs(self.datas) do
            self.datas[i].personData=groundOwnerDatas[i]
            self.datas[i].groundData=groundDatas[i]
            if groundDatas[i].Data.rent then
                panel[("blueBtn"..tostring(i))].localScale=Vector3.one
            end
        end
    end

    self:updateGroundInfo(self.datas[1])
    panel.select1.localScale=Vector3.one
    select=panel.select1
    panel.greenBtn1.parent:SetAsLastSibling()
end

--刷新建筑信息
function StopAndBuildCtrl:updateBuildingInfo(data)

    local peronInfo=data.ctrl.groundOwnerDatas[#data.ctrl.groundOwnerDatas]

    --if  self.avatarRightData then
    --    AvatarManger.CollectAvatar(self.avatarRightData)
    --end
    --self.avatarRightData= AvatarManger.GetSmallAvatar(peronInfo.faceId,panel.rightPerIma.transform,0.2)

    --panel.rightnameInp.text=peronInfo.name
    panel.buildingNameText.text=data.name
    ---*-226188068
    --local x=PlayerBuildingBaseData[data.mId].x
    --panel.scale.text=x.."x"..x
    LoadSprite(PlayerBuildingBaseData[data.mId].imgPath,panel.buildingIconIma)
    local time=getFormatUnixTime(string.sub(data.constructCompleteTs,1,10))
    panel.buildTimeText.text=time.year.."/"..time.month.."/"..time.day
end

--刷新土地信息
function StopAndBuildCtrl:updateGroundInfo(data)
    local personData=data.personData
    local groundData=data.groundData

    if groundData  and  groundData.Data and  groundData.Data.rent then            --租聘者
        panel.leasePersonInfoRoot.localScale=Vector3.one
        panel.owenerPersonInfoRoot.localScale=Vector3.zero

        if self.avatarLeftData then
            AvatarManger.CollectAvatar(self.avatarLeftData)
        end

        self.avatarLeftData= AvatarManger.GetSmallAvatar(personData.faceId,panel.lease.transform,0.2)
        panel.nameText.text=personData.name
        panel.commpanyNameText.text=personData.companyName

        local time=getFormatUnixTime(string.sub(groundData.Data.rent.rentBeginTs,1,10))
        panel.leaseText.text=time.year.."/"..time.month.."/"..time.day.."-"..time.year.."/"..time.month.."/"..(time.day+groundData.Data.rent.rentDays)
        panel.rentText.text=groundData.Data.rent.rentPreDay/10000
        if personData.male then
            LoadSprite("Assets/CityGame/Resources/Atlas/buildAndstop/buildAndstop1/male.png",panel.sexIma)
        else
            LoadSprite("Assets/CityGame/Resources/Atlas/buildAndstop/buildAndstop1/famale.png",panel.sexIma)
        end
    else                                                                            --土地主人
        panel.leasePersonInfoRoot.localScale=Vector3.zero
        panel.owenerPersonInfoRoot.localScale=Vector3.one

        panel.ownerRentText.text=(groundData.Data.auctionPrice/10000)
        local time=getFormatUnixTime(string.sub(groundData.Data.auctionTs,1,10))
        panel.buyTimeText.text=time.year.."/"..time.month.."/"..time.day

        --panel.buyTimeText.text=groundData.Data.rent.rentPreDay
    end

    if select then
        select.localScale=Vector3.zero
    end
end

--切换土地按钮
function StopAndBuildCtrl:switchGroundBtn(ins,num,btn)
    ins:updateGroundInfo(ins.datas[num])
    btn.transform.parent:Find("select").localScale=Vector3.one
    select=btn.transform.parent:Find("select")
    select.transform.parent:SetAsLastSibling()
    PlayMusEff(1002)
end

--切换面板
function StopAndBuildCtrl:switchRoot(panel,btN)
    if root then
        --root.localScale=Vector3.zero
        --btn.localScale=Vector3.zero
        root.gameObject:SetActive(false)
        btn.gameObject:SetActive(false)
    end
    --panel.localScale=Vector3.one
    --btN.localScale=Vector3.one
    panel.gameObject:SetActive(true)
    btN.gameObject:SetActive(true)
    root=panel
    btn=btN
end

--初始化的时候，将所有按钮隐藏
function StopAndBuildCtrl.CloseBtn()
    StopAndBuildPanel.greenBtn1.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn2.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn3.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn4.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn5.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn6.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn7.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn8.localScale = Vector3.zero
    StopAndBuildPanel.greenBtn9.localScale = Vector3.zero

    StopAndBuildPanel.blueBtn1.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn2.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn3.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn4.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn5.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn6.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn7.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn8.localScale = Vector3.zero
    StopAndBuildPanel.blueBtn9.localScale = Vector3.zero
    StopAndBuildPanel.select1.localScale = Vector3.zero
end
