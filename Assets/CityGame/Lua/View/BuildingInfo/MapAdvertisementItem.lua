---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/30/030 18:15
---

require('Framework/UI/UIPage')
local class = require 'Framework/class'

MapAdvertisementItem = class('MapAdvertisementItem')

---初始化方法   数据（读配置表）
function MapAdvertisementItem:initialize(prefabData,prefab,inluabehaviour,mgr,index)

    self.prefabData = prefabData;
    self.prefab = prefab;
    self._luabehaviour = inluabehaviour
    self.manager=mgr
    self.index=index


    self.plusBtn=prefab.transform:Find("bg/numImage/plusBtn");
    self.cutBtnBtn=prefab.transform:Find("bg/numImage/cutBtn");
    self.numtext=prefab.transform:Find("bg/numImage/Text"):GetComponent("Text");
    self.personNameText=prefab.transform:Find("nameImage/Text"):GetComponent("Text");
    self.icon=prefab.transform:Find("icon"):GetComponent("Image");
    self.bdName=prefab.transform:Find("icon/nameImage/nameText"):GetComponent("Text");

    self.personNameText.text=prefabData.personName
    LoadSprite(prefabData.path,self.icon,true)
    self.bdName.text=prefabData.name

    self._luabehaviour:AddClick(self.cutBtnBtn.gameObject, self.OnClick_cut, self);
    self._luabehaviour:AddClick(self.plusBtn.gameObject, self.OnClick_Plus, self);

    if prefabData.count then
        self.numtext.text=prefabData.count
    end

    self.personName=prefabData.personName
    self.path=prefabData.path
    self.name=prefabData.name
    self.type=prefabData.type
    self.itemId=prefabData.metaId
end

---添加
function MapAdvertisementItem:OnClick_cut(go)
    if DataManager.GetMyOwnerID()==DataManager.GetDetailModelByID(MunicipalPanel.buildingId).buildingOwnerId then--自已进入
        if go.numtext.text-1==0 then
            ---消除自身
            destroy(self.transform.parent.parent.parent.gameObject)
            ---选中广告还原
            go.manager.selectItemList[go.index]:GetComponent("Image").raycastTarget=true;
            ---表数据清除
            go.manager.addedItemList[go.index]=nil
            go.manager.selectItemList[go.index]=nil

            go.manager.AdvertisementDataList[go.index]=nil
            return
        end
        go.numtext.text=go.numtext.text-1
        go.manager.AdvertisementDataList[go.index]={count=go.numtext.text,type=go.type,name=go.name,metaId=go.itemId,personName=go.personName,path=go.path}


    else--他人进入
        if go.numtext.text-1==0 then
            ---消除自身
            destroy(self.transform.parent.parent.parent.gameObject)
            ---选中广告还原
            go.manager.selectItemList[go.index]:GetComponent("Image").raycastTarget=true;
            ---表数据清除
            go.manager.addedItemList[go.index]=nil
            go.manager.selectItemList[go.index]=nil

            go.manager.AdvertisementDataList[go.index]=nil
            ---处理添加文本显示
            go.manager.current.numText.text=go.manager.current.numText.text+1
            return
        end
        go.numtext.text=go.numtext.text-1
        go.manager.AdvertisementDataList[go.index]={count=go.numtext.text,type=go.type,name=go.name,metaId=go.itemId,slots=go.manager.current.slots
        ,personName=go.personName,path=go.path}
        ---处理添加文本显示
        go.manager.current.numText.text=go.manager.current.numText.text+1
        go.manager.current.prefab:SetActive(true)
    end
end

function MapAdvertisementItem:OnClick_Plus(ins)

    if DataManager.GetMyOwnerID()==DataManager.GetDetailModelByID(MunicipalPanel.buildingId).buildingOwnerId then--自已进入
        ins.numtext.text=ins.numtext.text+1
        ins.manager.AdvertisementDataList[ins.index]={count=ins.numtext.text,type=ins.type,name=ins.name,metaId=ins.itemId,personName=ins.personName,path=ins.path}

    else--他人进入
        if tonumber(ins.numtext.text)>=ins.manager.current.selfAcount then
              return
        end
        ins.numtext.text=ins.numtext.text+1
        ins.manager.AdvertisementDataList[ins.index]={count=ins.numtext.text,type=ins.type,name=ins.name,metaId=ins.itemId,slots=ins.manager.current.slots
        ,personName=ins.personName,path=ins.path}
        ---处理添加文本显示
        ins.manager.current.numText.text=ins.manager.current.numText.text-1
        if ins.manager.current.numText.text=="0" then
            ins.manager.current.prefab:SetActive(false)
        end
    end
end
