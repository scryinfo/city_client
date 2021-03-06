---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/25/025 17:50
---

---====================================================================================Framework==============================================================================================

StopAndBuildCtrl = class('StopAndBuildCtrl',UIPanel)
UIPanel:ResgisterOpen(StopAndBuildCtrl) --How to open the registration
--Build function
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

--todo：Refresh
function StopAndBuildCtrl:Refresh()
    self:ChangeLanguage()
    local data=self.m_data
    self:switchRoot(panel.buildingInfoRoot,panel.buildingSelectedInfoBtn)

    ----Refresh character information
    self:updateBuildingInfo(data)
    ----Refresh button
    self:updateBtn(data)
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

---====================================================================================click function==============================================================================================
--Rename
function StopAndBuildCtrl:OnClick_changeName(ins)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(25040001)
    data.inputDefaultStr = GetLanguage(37030002)
    data.btnCallBack = function(name)
        if ins.m_data.id ~= nil then
            DataManager.ModelSendNetMes("gscode.OpCode", "setBuildingInfo","gs.SetBuildingInfo",{ id = ins.m_data.id, name = name})
            panel.buildingNameText.text = name
        end
    end
    ct.OpenCtrl("InputDialogPageCtrl", data)
end

--return
function StopAndBuildCtrl:OnClick_backBtn(ins)
    ins.CloseBtn()
    UIPanel.ClosePage()
    PlayMusEff(1002)
end

--Click building information
function StopAndBuildCtrl:OnClick_build(ins)
    ins:switchRoot(panel.buildingInfoRoot,panel.buildingSelectedInfoBtn)
end

--Click on Land Information
function StopAndBuildCtrl:OnClick_land(ins)
    ins:switchRoot(panel.landInfoRoot,panel.landInfomationSelectedBtn)
end

--remove
function StopAndBuildCtrl:OnClick_remove(ins)
    local data={ ins= ins,func= function()
                        Event.Brocast("m_delBuilding",ins.m_data.id )
                        Event.Brocast("SmallPop",GetLanguage(40010015),300)
                        DataManager.RemoveMyBuildingDetailByBuildID(ins.m_data.id)
                        UIPanel.CloseAllPageExceptMain()
                       end  }

    ct.OpenCtrl('ReminderTipsCtrl',data)
    PlayMusEff(1002)
end

--Closed
function StopAndBuildCtrl:OnClick_stop(ins)
     local data={ins = ins,func = function()
                       Event.Brocast("m_shutdownBusiness",ins.m_data.id)
                       panel.removeBtn.localScale=Vector3.one
                       panel.stopBtn.localScale=Vector3.zero
                       end  }

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
---====================================================================================Business code==============================================================================================
local root,btn
local select
---Refresh button
function StopAndBuildCtrl:updateBtn(buildinghInfo)
    if buildinghInfo.ownerId == DataManager.GetMyOwnerID() then
        panel.nameBtn.localScale = Vector3.one
    else
        panel.nameBtn.localScale = Vector3.zero
    end

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

    --The upper left corner (the first one) is turned on by default
    self:updateGroundInfo(self.datas[1])
    panel.select1.localScale = Vector3.one
    select=panel.select1
    panel.greenBtn1.parent:SetAsLastSibling()
end

--Refresh building information
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

--Update land information
function StopAndBuildCtrl:updateGroundInfo(data)
    local personData=data.personData
    local groundData=data.groundData

    if groundData  and  groundData.Data and  groundData.Data.rent then            --Hirer
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
            panel.sexIma.localScale=Vector3.one
            panel.sexIma1.localScale=Vector3.zero
        else
            panel.sexIma.localScale=Vector3.zero
            panel.sexIma1.localScale=Vector3.one
        end
    else                                                                            --Landowner
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

--Toggle land button
function StopAndBuildCtrl:switchGroundBtn(ins,num,btn)
    ins:updateGroundInfo(ins.datas[num])
    btn.transform.parent:Find("select").localScale=Vector3.one
    select=btn.transform.parent:Find("select")
    select.transform.parent:SetAsLastSibling()
    PlayMusEff(1002)
end

--Switch panel
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

--During initialization, hide all buttons
function StopAndBuildCtrl.CloseBtn()
    panel.greenBtn1.localScale = Vector3.zero
    panel.greenBtn2.localScale = Vector3.zero
    panel.greenBtn3.localScale = Vector3.zero
    panel.greenBtn4.localScale = Vector3.zero
    panel.greenBtn5.localScale = Vector3.zero
    panel.greenBtn6.localScale = Vector3.zero
    panel.greenBtn7.localScale = Vector3.zero
    panel.greenBtn8.localScale = Vector3.zero
    panel.greenBtn9.localScale = Vector3.zero

    panel.blueBtn1.localScale = Vector3.zero
    panel.blueBtn2.localScale = Vector3.zero
    panel.blueBtn3.localScale = Vector3.zero
    panel.blueBtn4.localScale = Vector3.zero
    panel.blueBtn5.localScale = Vector3.zero
    panel.blueBtn6.localScale = Vector3.zero
    panel.blueBtn7.localScale = Vector3.zero
    panel.blueBtn8.localScale = Vector3.zero
    panel.blueBtn9.localScale = Vector3.zero
    panel.select1.localScale = Vector3.zero
end

--multi-language
function StopAndBuildCtrl.ChangeLanguage()
    --panel.topicText
    --panel.buildingInfoText
    --panel.buildingSelectedInfoText
    --panel.landInfomationText
    --panel.landInfomationSelectedText
    --panel.buildTimeNameText
    --panel.buyTimeNameText
    --panel.ownerRentNameText
    --panel.operatorText.text=GetLanguage(40010002)
    --panel.groundInfoText.text=GetLanguage(40010001)
    --panel.scaleText.text=GetLanguage(40010003)
    --panel.constructText.text=GetLanguage(40010004)
    --panel.tips.text=GetLanguage(40010007)
    --panel.dateText.text=GetLanguage(40010005)
    --panel.dailyRentText.text=GetLanguage(40010006)
    --panel.depositText.text=GetLanguage(40010017)
    --panel.stopText.text=GetLanguage(40010016)
end