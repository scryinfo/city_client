---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/7/25 15:05
--- 市场数据DetailPart
DataBaseDetailPart = class('DataBaseDetailPart', BasePartDetail)
--
function DataBaseDetailPart:PrefabName()
    return "DataBaseDetailPart"
end
--
function  DataBaseDetailPart:_InitEvent()
    DataManager.ModelRegisterNetMsg(nil,"gscode.OpCode","getScienceStorageData","gs.ScienceStorageData",self.n_OnDataBase,self)
    Event.AddListener("part_SurveyLineUpData",self.SurveyLineUpData,self)
    Event.AddListener("part_UserData",self.UserData,self)
end
--
function DataBaseDetailPart:_InitClick(mainPanelLuaBehaviour)
    self.m_LuaBehaviour = mainPanelLuaBehaviour
end
--
function DataBaseDetailPart:_ResetTransform()

end
--
function DataBaseDetailPart:_RemoveEvent()
    DataManager.ModelNoneInsIdRemoveNetMsg("gscode.OpCode", "getScienceStorageData",self.n_OnDataBase,self)
    Event.RemoveListener("part_SurveyLineUpData",self.SurveyLineUpData,self)
    Event.RemoveListener("part_UserData",self.UserData,self)
end
--
function DataBaseDetailPart:_RemoveClick()
end

function DataBaseDetailPart:Show(data)
    BasePartDetail.Show(self,data)
    DataManager.ModelSendNetMes("gscode.OpCode", "getScienceStorageData","gs.Id",{id = data.info.id})
end

function DataBaseDetailPart:Hide()
    BasePartDetail.Hide(self)
    self.scrollView.gameObject:SetActive(false)
    if self.dataBaseItem then
        for i, v in pairs(self.dataBaseItem) do
            destroy(v.prefab.gameObject)
        end
    end
    self.dataBaseItem = {}
end
--
function DataBaseDetailPart:RefreshData(data)
    if data == nil then
        return
    end
    self.m_data = data

    --多語言
    --self.emptyText.text = GetLanguage()
end

--
function DataBaseDetailPart:_InitTransform()
    self:_getComponent(self.transform)

end
--
function DataBaseDetailPart:_getComponent(transform)
    self.empty = transform:Find("contentRoot/empty")
    self.emptyText = transform:Find("contentRoot/empty/Image/Text"):GetComponent("Text")
    self.scrollView = transform:Find("contentRoot/Scroll View")
    self.content = transform:Find("contentRoot/Scroll View/Viewport/Content"):GetComponent("RectTransform")
end
--
function DataBaseDetailPart:_initFunc()

end

--服务器回调
function DataBaseDetailPart:n_OnDataBase(info)
    if info.store == nil then
        self.empty.localScale = Vector3.one
        self.scrollView.gameObject:SetActive(false)
    else
        self.empty.localScale = Vector3.zero
        self.scrollView.gameObject:SetActive(true)
        if info.store then
            self.dataBaseItem = {}
            for i, v in ipairs(info.store) do
                local function callback(prefab)
                    self.dataBaseItem[i] = DataBaseCardItem:new(self.m_LuaBehaviour,prefab,v,info.buildingId)
                end
                createPrefab("Assets/CityGame/Resources/View/GoodsItem/DataBaseCardItem.prefab",self.content, callback)
            end
        end
    end
end

--调查线变换回调
function DataBaseDetailPart:SurveyLineUpData(info)
    if self.dataBaseItem then
        for i, v in pairs(self.dataBaseItem) do
            if v.type == info.iKey.id then
               v.num.text = "x" .. info.nowCountInStore
            end
        end
    end
end

--使用点数回调
function DataBaseDetailPart:UserData(info)
    for i, v in pairs(self.dataBaseItem) do
        if v.type == info.itemId then
            v.num.text = "x" .. ((v.storeNum + v.lockedNum) - info.num)
            return
        end
    end
end
