---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/25/025 17:50
---
StopAndBuildCtrl = class('StopAndBuildCtrl',UIPage)
UIPage:ResgisterOpen(StopAndBuildCtrl) --注册打开的方法
--构建函数
function StopAndBuildCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
end

function StopAndBuildCtrl:bundleName()
    return "StopAndBuildPanel"
end

function StopAndBuildCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj);
end
local panel
function StopAndBuildCtrl:Awake(go)

    self.gameObject = go;
    panel=StopAndBuildPanel
    self.materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    self.materialBehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);
    self.materialBehaviour:AddClick(panel.stopBtn.gameObject,self.OnClick_stop,self);
    self.materialBehaviour:AddClick(panel.removeBtn.gameObject,self.OnClick_remove,self);

      self.materialBehaviour:AddClick((panel.greenBtn1).gameObject,self.OnClick_greenBtn1,self);
      self.materialBehaviour:AddClick((panel.greenBtn2).gameObject,self.OnClick_greenBtn2,self);
      self.materialBehaviour:AddClick((panel.greenBtn3).gameObject,self.OnClick_greenBtn3,self);
      self.materialBehaviour:AddClick((panel.greenBtn4).gameObject,self.OnClick_greenBtn4,self);
      self.materialBehaviour:AddClick((panel.greenBtn5).gameObject,self.OnClick_greenBtn5,self);
      self.materialBehaviour:AddClick((panel.greenBtn6).gameObject,self.OnClick_greenBtn6,self);
      self.materialBehaviour:AddClick((panel.greenBtn7).gameObject,self.OnClick_greenBtn7,self);
      self.materialBehaviour:AddClick((panel.greenBtn8).gameObject,self.OnClick_greenBtn8,self);
      self.materialBehaviour:AddClick((panel.greenBtn9).gameObject,self.OnClick_greenBtn9,self);
    panel:CloseBtn()
    self.datas={}
    for i = 1, 9 do
        local data={}
        table.insert(self.datas,data)
    end
end

--返回
function StopAndBuildCtrl:OnClick_backBtn()
    panel:CloseBtn()
    UIPage.ClosePage()
end


--拆除
function StopAndBuildCtrl:OnClick_remove(ins)
    local data={}

    data.type="remove"
    data.mainText="Confirm removal or not?"
    --data.tips=
    data.callback=function() Event.Brocast("m_delBuilding",ins.m_data.id )
        Event.Brocast("SmallPop","Success",300)
        DataManager.RemoveMyBuildingDetailByBuildID(ins.m_data.id)
        UIPage.ClosePage()
        UIPage.ClosePage()
    end
    ct.OpenCtrl('ReminderCtrl',data)
end

--停业
function StopAndBuildCtrl:OnClick_stop(ins)
    local data={}
    data.type="stop"
    data.mainText="Confirmation of closure?"
    data.callback=function() Event.Brocast("m_shutdownBusiness",ins.m_data.id)
        panel.removeBtn.localScale=Vector3.one
        panel.stopIconRoot.localScale=Vector3.one
    end

    ct.OpenCtrl('ReminderCtrl',data)
end

--todo：刷新
function StopAndBuildCtrl:Refresh()
     local data=self.m_data
    --刷新人物信息
    self:updatePersonInfo(data)
    --刷新按钮
    self:updateBtn(data)
end



local select
--刷新按钮
function StopAndBuildCtrl:updateBtn(buildinghInfo)
    if buildinghInfo.state=="OPERATE" then
        panel.removeBtn.localScale=Vector3.zero
        panel.stopIconRoot.localScale=Vector3.zero
    else
        panel.removeBtn.localScale=Vector3.one
        panel.stopIconRoot.localScale=Vector3.one
    end

    local groundOwnerDatas=buildinghInfo.ctrl.groundOwnerDatas
    local groundDatas=buildinghInfo.ctrl.groundDatas
    local x=PlayerBuildingBaseData[buildinghInfo.mId].x
    if x==1 then
      panel.greenBtn1.localScale=Vector3.one
        self.datas[1].personData=groundOwnerDatas[1]
        self.datas[1].groundData=groundDatas[1]
    elseif  x==2 then
        panel.greenBtn1.localScale=Vector3.one
        panel.greenBtn2.localScale=Vector3.one
        panel.greenBtn4.localScale=Vector3.one
        panel.greenBtn5.localScale=Vector3.one
        local table={1,2,4,5}
        for i, v in ipairs(table) do
            self.datas[v].personData=groundOwnerDatas[i]
            self.datas[v].groundData=groundDatas[i]
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
        end
    end
    self:updateGroundInfo(self.datas[1])
    panel.select1.localScale=Vector3.one
    select=panel.select1
    panel.greenBtn1.parent:SetAsLastSibling()
end

--刷新人物信息
function StopAndBuildCtrl:updatePersonInfo(data)

    local peronInfo=data.ctrl.groundOwnerDatas[#data.ctrl.groundOwnerDatas]
    --panel.rightPerIma.sprite=peronInfo
    panel.rightnameInp.text=peronInfo.name
    panel.rightcommanyInp.text=peronInfo.companyName
    ---*-226188068
    local x=PlayerBuildingBaseData[data.mId].x
    panel.scale.text=x.."x"..x
    local time=getFormatUnixTime(string.sub(data.constructCompleteTs,1,10))
    panel.construct.text=time.year.."/"..time.month.."/"..time.day

end


--刷新左边信息
function StopAndBuildCtrl:updateGroundInfo(data)
    local personData=data.personData
    local groundData=data.groundData
    --**des=""
    --panel.personIma.sprite=personData.des
    panel.nameInp.text=personData.name
    panel.commanyInp.text=personData.companyName
    --- ******************** ---
    if groundData.Data.Rent then
        panel.date.transform.parent.parent.localScale=Vector3.one
        local time=getFormatUnixTime(string.sub(groundData.Data.Rent.rentBeginTs,1,10))
        panel.date.text=time.year.."/"..time.month.."/"..time.day.."-"..time.year.."/"..time.month.."/"..(time.day+groundData.Data.Rent.rentDays)
        panel.dailyRent.text=groundData.Data.Rent.rentPreDay
        panel.deposit.text=groundData.Data.Rent.deposit
    else
        panel.date.transform.parent.parent.localScale=Vector3.zero
    end

    if select then
        select.localScale=Vector3.zero
    end
end

function StopAndBuildCtrl:change(ins,num,btn)
    ins:updateGroundInfo(ins.datas[num])
    btn.transform.parent:Find("select").localScale=Vector3.one
    select=btn.transform.parent:Find("select")
    select.transform.parent:SetAsLastSibling()
end

function StopAndBuildCtrl:OnClick_greenBtn1(ins)
    ins:change(ins,1,self)
end
function StopAndBuildCtrl:OnClick_greenBtn2(ins)
    ins:change(ins,2,self)
end
function StopAndBuildCtrl:OnClick_greenBtn3(ins)
    ins:change(ins,3,self)
end
function StopAndBuildCtrl:OnClick_greenBtn4(ins)
    ins:change(ins,4,self)
end
function StopAndBuildCtrl:OnClick_greenBtn5(ins)
    ins:change(ins,5,self)
end
function StopAndBuildCtrl:OnClick_greenBtn6(ins)
    ins:change(ins,6,self)
end
function StopAndBuildCtrl:OnClick_greenBtn7(ins)
    ins:change(ins,7,self)
end
function StopAndBuildCtrl:OnClick_greenBtn8(ins)
    ins:change(ins,8,self)
end
function StopAndBuildCtrl:OnClick_greenBtn9(ins)
    ins:change(ins,9,self)
end


