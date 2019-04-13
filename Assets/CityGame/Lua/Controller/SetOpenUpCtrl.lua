---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2019/4/3 18:02
---广告公司对外开放设置面板
SetOpenUpCtrl = class('SetOpenUpCtrl',UIPanel)
UIPanel:ResgisterOpen(SetOpenUpCtrl)

local setOpenUpBehaviour

function SetOpenUpCtrl:bundleName()
    return "Assets/CityGame/Resources/View/SetOpenUpPanel.prefab"
end

function SetOpenUpCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.PopUp,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end
function SetOpenUpCtrl:Awake()
    setOpenUpBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.xBtn,self.OnxBtn,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.open,self.OnOpen,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.close,self.OnClose,self);
    setOpenUpBehaviour:AddClick(SetOpenUpPanel.confirm,self.OnConfirm,self);
    self:initData()
end

function SetOpenUpCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_Revenue",self.c_Revenue,self)
end

function SetOpenUpCtrl:Refresh()
    --self.openUp = self.m_data.openUp
    self.openUp = false
    if self.openUp then
        SetOpenUpPanel.open.transform.localScale = Vector3.one
        SetOpenUpPanel.close.transform.localScale = Vector3.zero
        SetOpenUpPanel.price.interactable = true
        SetOpenUpPanel.time.interactable = true
    else
        SetOpenUpPanel.open.transform.localScale = Vector3.zero
        SetOpenUpPanel.close.transform.localScale = Vector3.one
        SetOpenUpPanel.price.interactable = false
        SetOpenUpPanel.time.interactable = false
    end
end

function SetOpenUpCtrl:Hide()
    UIPanel.Hide(self)

end

function SetOpenUpCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function SetOpenUpCtrl:initData()
end

function SetOpenUpCtrl:OnxBtn()
    UIPanel.ClosePage()
end

--开启对外开放
function SetOpenUpCtrl:OnOpen(go)
    go.openUp = false
    SetOpenUpPanel.close.transform.localScale = Vector3.one
    SetOpenUpPanel.open.transform.localScale = Vector3.zero
    SetOpenUpPanel.price.text = ""
    SetOpenUpPanel.time.text = ""
    SetOpenUpPanel.price.interactable = false
    SetOpenUpPanel.time.interactable = false
end

--关闭对外开放
function SetOpenUpCtrl:OnClose(go)
    go.openUp = true
    SetOpenUpPanel.close.transform.localScale = Vector3.zero
    SetOpenUpPanel.open.transform.localScale = Vector3.one
    SetOpenUpPanel.price.interactable = true
    SetOpenUpPanel.time.interactable = true
end

--点击确定
function SetOpenUpCtrl:OnConfirm(go)
    if go.openUp then
        if SetOpenUpPanel.time.text == "" or tonumber(SetOpenUpPanel.time.text ) == 0 then
            Event.Brocast("SmallPop","时间不能为0",300)
        end
    end
end