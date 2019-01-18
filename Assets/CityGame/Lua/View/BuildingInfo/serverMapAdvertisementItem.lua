---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/11/16/016 14:10
---


require('Framework/UI/UIPage')
local class = require 'Framework/class'

serverMapAdvertisementItem = class('serverMapAdvertisementItem')

---初始化方法   数据（读配置表）
function serverMapAdvertisementItem:initialize(prefabData,prefab,inluabehaviour,mgr,index)

    self.prefabData = prefabData;
    self.prefab = prefab;
    self._luabehaviour = inluabehaviour
    self.manager=mgr
    self.index=index
    self.metaId=prefabData.metaId


    self.numtext=prefab.transform:Find("bg/numImage/Text"):GetComponent("Text");
    self.peopleCount=prefab.transform:Find("showPanel/peoplecount/peoplecountText"):GetComponent("Text");
    self.dayText=prefab.transform:Find("bg/day/dayText"):GetComponent("Text");
    self.plusBtn=prefab.transform:Find("bg/numImage/plusBtn");
    self.cutBtnBtn=prefab.transform:Find("bg/numImage/cutBtn");
    self.personNameText=prefab.transform:Find("nameImage/Text"):GetComponent("Text");
    self.icon=prefab.transform:Find("icon"):GetComponent("Image");
    self.bdName=prefab.transform:Find("icon/nameImage/nameText"):GetComponent("Text");


    self._luabehaviour:AddClick(self.cutBtnBtn.gameObject, self.OnClick_cut, self);
    self._luabehaviour:AddClick(self.plusBtn.gameObject, self.OnClick_Plus, self);

    if prefabData.slot then
        self.days=prefabData.slot.days
        self.ads=prefabData.ads
        local temp={}
        for i, ad in pairs(prefabData.ads) do
           table.insert(temp,ad.slot)
        end
        self.slots=temp
    end

    if prefabData.count then
        self.numtext.text=prefabData.count
        self.selfcount=prefabData.count
        self.updatecount=prefabData.count
    end

    if prefabData.type=="GOOD" then
        self.type=0
    else
        self.type=1
    end

    if prefabData.npcFlow then
       self.peopleCount.text=prefabData.npcFlow

        local beginTs=tostring(prefabData.beginTs)
        beginTs=string.sub(beginTs,1,10)
        local passTime=os.time()-beginTs
        self.dayText.text=string.sub(getFormatUnixTime(passTime).day,2,2).."d"
    end


     if prefabData.name then
            self.personNameText.text=prefabData.personName
            LoadSprite(prefabData.path,self.icon,true)
            self.bdName.text=prefabData.name
     end

end

---添加
function serverMapAdvertisementItem:OnClick_cut(go)
    ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(false);
    if DataManager.GetMyOwnerID()==DataManager.GetDetailModelByID(MunicipalPanel.buildingId).buildingOwnerId then--自已进入
        if go.numtext.text-1==0 then
            go.manager.serverMapAdvertisementINSList[go.metaId].updatecount=0
            ---消除自身
            self.transform.parent.parent.parent.gameObject:SetActive(false)
            ---对应广告还原
            -- go.manager.selectItemList[go.index]:GetComponent("Image").raycastTarget=true;
            ---表数据清除
            --self.manager.serverMapAdvertisementItemList[go.index]=nil
            go.manager.insList[go.metaId].prefab.transform:GetComponent("Image").raycastTarget=true;
            return
        end
        go.numtext.text=go.numtext.text-1
        go.updatecount=go.numtext.text

    else---他人进入

        if  go.numtext.text=="0" then
            go.manager.insList[go.metaId].prefab.transform:GetComponent("Image").raycastTarget=true;
            return
        end
        --自身数量减少
        go.numtext.text=go.numtext.text-1
        go.updatecount=go.numtext.text
        --槽位增加
        if   go.manager.current then
            go.manager.current.angleRoot.localScale=Vector3.zero
        end
        for i, addItemIns in pairs(go.manager.addItemInSList) do
            if addItemIns.days == go.days then
                addItemIns.prefab:SetActive(true)
                addItemIns.angleRoot.localScale=Vector3.one
                addItemIns.prefab.transform:SetAsFirstSibling()
                go.manager.current=addItemIns
            end
        end
        go.manager.current.numText.text=go.manager.current.numText.text+1
    end
end

function serverMapAdvertisementItem:OnClick_Plus(ins)
    if DataManager.GetMyOwnerID()==DataManager.GetDetailModelByID(MunicipalPanel.buildingId).buildingOwnerId  then--自已进入
        ins.numtext.text=ins.numtext.text+1
        ins.updatecount=ins.numtext.text

    else-----他人进入
        --限制上限

        if ins.manager.current.numText.text=="0" then
            return
        end
        --自身数量增加
        ins.numtext.text=ins.numtext.text+1
        ins.updatecount=ins.numtext.text
        if   ins.manager.current then
            ins.manager.current.angleRoot.localScale=Vector3.zero
        end
        for i, addItemIns in pairs(ins.manager.addItemInSList) do
            if addItemIns.days == ins.days then
                addItemIns.prefab:SetActive(true)
                addItemIns.angleRoot.localScale=Vector3.one
                --addItemIns.prefab.transform:SetAsFirstSibling()
                ins.manager.current=addItemIns
            end
        end
        --槽位减少
        ins.manager.current.numText.text=ins.manager.current.numText.text-1
    end


    ManageAdvertisementPosPanel.greyBtn.gameObject:SetActive(false);
end


