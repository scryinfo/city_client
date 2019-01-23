---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/13 14:31
---通知
GameNoticeCtrl = class('GameNoticeCtrl',UIPanel)
UIPanel:ResgisterOpen(GameNoticeCtrl) --注册打开的方法
local GameNoticeBehaviour
local bg = nil
local isShowHint =false
local id = nil  -- 类型Id
local goId = nil --实例Id
local hide

function  GameNoticeCtrl:bundleName()
    return "Assets/CityGame/Resources/View/GameNoticePanel.prefab"
end

function GameNoticeCtrl:initialize()
    --UIPanel.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPanel.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function GameNoticeCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)

end

function GameNoticeCtrl:Awake()
    self.insId = OpenModelInsID.GameNoticeCtrl
    GameNoticeBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    GameNoticeBehaviour:AddClick(GameNoticePanel.bgBtn,self.OnBgBtn,self)
    GameNoticeBehaviour:AddClick(GameNoticePanel.xBtn,self.OnXBtn,self);
    GameNoticeBehaviour:AddClick(GameNoticePanel.delete,self.OnDelete,self);
    GameNoticeBehaviour:AddClick(GameNoticePanel.jumpBtn,self.OnJumpBtn,self);
    GameNoticeBehaviour:AddClick(GameNoticePanel.hint,self.OnHint,self);

    self:_initData();

    self.NoticeMgr = NoticeMgr:new()
end

function GameNoticeCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_onBg",self.c_onBg,self)
    Event.AddListener("c_OnMailRead",self.c_OnMailRead,self)
    Event.AddListener("c_OnDeleMails",self.c_OnDeleMails,self)

end

function GameNoticeCtrl:Refresh()
    hide = true
    --打开通知Model
    self:initializeData()
    NoticeMgr:_createNotice(GameNoticeBehaviour,self.m_data)
    if goId ~= nil then
        NoticeMgr.notice[goId].newBg:SetActive(true)
        bg =  NoticeMgr.notice[goId].newBg
    end
end

function GameNoticeCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_onBg",self.c_onBg,self)
    Event.RemoveListener("c_OnMailRead",self.c_OnMailRead,self)
    Event.RemoveListener("c_OnDeleMails",self.c_OnDeleMails,self)

    bg = nil
    NoticeMgr:_dleNotice()
end

function GameNoticeCtrl:initializeData()
    if self.m_data then
        DataManager.OpenDetailModel(GameNoticeModel,self.insId )
    end
end

--初始化
function GameNoticeCtrl:_initData()
    GameNoticePanel.jumpBtn:SetActive(false)
    GameNoticePanel.hedaer.text = ""
    GameNoticePanel.time.text = ""
    GameNoticePanel.rightContent.text = "请选择左边的邮件"
end

--点击空白背景返回
function GameNoticeCtrl:OnBgBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage();
end

--点击xbutton
function GameNoticeCtrl:OnXBtn()
    PlayMusEff(1002)
    GameNoticeCtrl:OnBgBtn()
end

--读取邮件
function GameNoticeCtrl:c_onBg(go)
    if go.state == false then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_mailRead',go.id)
    else
        GameNoticeCtrl:c_OnMailRead(go)
    end
end

--读取邮件回调
function GameNoticeCtrl:c_OnMailRead(go)
    -- [[显示新背景
    if bg ~= nil then
        bg:SetActive(false)
    end
    go.newBg:SetActive(true)
    if go.hint ~= nil then
        go.hint.localScale = Vector3.zero
    end
    bg =  go.newBg
    --
    -- [[显示跳转按钮
    if Notice[go.typeId].redirect == "" then
        GameNoticePanel.jumpBtn:SetActive(false)
    else
        GameNoticePanel.jumpBtn:SetActive(true)
    end
    -- ]]
    -- [[显示内容
    GameNoticePanel.hedaer.text = go.itemHedaer.text
    GameNoticePanel.time.text = go.itemTime.text
    --GameNoticePanel.rightContent.text = Notice[go.typeId].content
    --GameNoticePanel.rightContent.text = go.content
    GameNoticePanel.timeLeft.transform.localScale = Vector3.one
    GameNoticePanel.timeLeft.text = GetLanguage(13010003,go.day)
    -- ]]
    if go.typeId ==1 then
        GameNoticePanel.GoodsScrollView:SetActive(true)
    else
        GameNoticePanel.GoodsScrollView:SetActive(false)
    end
    id = go.typeId
    goId = go.id
    GameNoticePanel.delete:SetActive(true)
end

--删除通知
function GameNoticeCtrl:OnDelete(go)
    PlayMusEff(1002)
    local data = {}
    data.titleInfo = GetLanguage(13010061)
    data.contentInfo = GetLanguage(13010062)
    data.tipInfo = ""
    data.btnCallBack = function ()
        DataManager.DetailModelRpcNoRet(go.insId , 'm_delMail',goId)
        --GameNoticeCtrl:c_OnDeleMails(go)
    end
    ct.OpenCtrl('BtnDialogPageCtrl',data)
end

--删除通知回调
function GameNoticeCtrl:c_OnDeleMails(go)

     GameNoticeCtrl:_deleteNotice(go)
end

--跳转场景
function GameNoticeCtrl:OnJumpBtn(go)
    PlayMusEff(1002)
    ct.OpenCtrl(Notice[id].redirect)
end

--剩余时间显示
function GameNoticeCtrl:OnHint()
    PlayMusEff(1002)
    GameNoticeCtrl:_setActiva(not isShowHint)
end

--控制剩余时间显隐
function GameNoticeCtrl:_setActiva(isShow)
    GameNoticePanel.hintItem:SetActive(isShow)
    GameNoticePanel.hintText.text = GetLanguage(13010004)
    isShowHint = isShow
end

--删除通知方法
function GameNoticeCtrl:_deleteNotice(go)
    GameNoticePanel.timeLeft.transform.localScale = Vector3.zero
    --  [[删除邮件实例与表中数据
    if go == nil then
        return
    end
  go.prefab:SetActive(false)
    local id = go.id
    --NoticeMgr.notice.id = nil
    -- ]]
    -- [[刷新表中ID
--[[    local i = 1
    for k,v in ipairs(NoticeMgr.notice)  do
        NoticeMgr.notice[i]:RefreshID(i)
        i = i + 1
    end]]
    -- ]]
    id = nil
    if NoticeMgr.notice == nil then
        UIPanel.ClosePage();
        ct.OpenCtrl("NoMessageCtrl")
    end
    bg = nil
    self:_initData()
    GameNoticePanel.delete:SetActive(false)
end
