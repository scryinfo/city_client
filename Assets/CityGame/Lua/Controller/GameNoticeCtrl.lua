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
local noticeData = {}
local noticeItems = {}

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
    self.m_data.insId = OpenModelInsID.GameNoticeCtrl
    GameNoticeBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    GameNoticeBehaviour:AddClick(GameNoticePanel.bgBtn,self.OnBgBtn,self)
    GameNoticeBehaviour:AddClick(GameNoticePanel.xBtn,self.OnXBtn,self);
    GameNoticeBehaviour:AddClick(GameNoticePanel.jumpBtn,self.OnJumpBtn,self);
    GameNoticeBehaviour:AddClick(GameNoticePanel.hint,self.OnHint,self);

    self.type = 0
    self.nameSize = ""
    self.goodsName = ""
    self.num = 0
    self.time = 0
    self.money = 0
    self.startTime = 0
    self.bonus = 0

    --滑动互用
    self.notices = UnityEngine.UI.LoopScrollDataSource.New()  --行情
    self.notices.mProvideData = GameNoticeCtrl.static.NoticeProvideData
    self.notices.mClearData = GameNoticeCtrl.static.NoticeClearData


    self:_initData();
end

function GameNoticeCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("c_onBg",self.c_onBg,self)
    Event.AddListener("c_OnMailRead",self.c_OnMailRead,self)
    Event.AddListener("c_OnDeleMails",self.c_OnDeleMails,self)
    Event.AddListener("GetBuildingName",self.GetBuildingName,self)  --建筑名字
    Event.AddListener("c_SocietyInfo",self.c_SocietyInfo,self)  --公会名字

    GameNoticePanel.hintText.text = GetLanguage(16010018)

end

function GameNoticeCtrl:Refresh()
    hide = true
    --打开通知Model
    self:initializeData()
    if goId ~= nil and  noticeItems[goId]~= nil then
        noticeItems[goId].newBg.localScale = Vector3.one
        bg = noticeItems[goId].newBg
    end
end

function GameNoticeCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("c_onBg",self.c_onBg,self)
    Event.RemoveListener("c_OnMailRead",self.c_OnMailRead,self)
    Event.RemoveListener("c_OnDeleMails",self.c_OnDeleMails,self)
    Event.RemoveListener("GetBuildingName",self.GetBuildingName,self)  --建筑名字
    Event.RemoveListener("c_SocietyInfo",self.c_SocietyInfo,self)  --公会名字

    bg = nil
    noticeData = {}
    for i, v in pairs(noticeItems) do
        destroy(v.prefab.gameObject)
    end
    noticeItems = {}
end

function GameNoticeCtrl:initializeData()
    if self.m_data then
        DataManager.OpenDetailModel(GameNoticeModel,self.insId )
        for i, v in pairs(self.m_data.mails) do
            noticeData[i] = {}
            noticeData[i].header = GetLanguage(Notice[v.type].header)
            noticeData[i].content = Notice[v.type].content
            noticeData[i].redirect = Notice[v.type].redirect
            noticeData[i].state = v.read
            noticeData[i].uuidParas = v.uuidParas
            noticeData[i].intParasArr = v.intParasArr
            noticeData[i].from = GetLanguage(16010023)
            noticeData[i].time = v.ts
            noticeData[i].paras = v.paras
            noticeData[i].tparas = v.tparas
            noticeData[i].id = v.id
            noticeData[i].type = v.type
        end
        GameNoticePanel.noticeScroll:ActiveLoopScroll(self.notices, #noticeData,"View/GoodsItem/MessageItem")
    end
end

--初始化
function GameNoticeCtrl:_initData()
    GameNoticePanel.jumpBtn.transform.localScale = Vector3.zero
    GameNoticePanel.right.localScale = Vector3.zero
    GameNoticePanel.hedaer.text = ""
    GameNoticePanel.time.text = ""
    GameNoticePanel.rightContent.text = GetLanguage(16010021)
end

--滑动互用
GameNoticeCtrl.static.NoticeProvideData = function(transform, idx)

    idx = idx + 1
    local item = NoticeItem:new(noticeData[#noticeData-idx+1],transform,GameNoticeBehaviour,noticeData[#noticeData-idx+1].id,noticeData[#noticeData-idx+1].type,GameNoticeCtrl)
    noticeItems[item.id] = item
end

GameNoticeCtrl.static.NoticeClearData = function(transform)

end

--点击空白背景返回
function GameNoticeCtrl:OnBgBtn(go)
    PlayMusEff(1002)
    GameNoticePanel.hintItem.localScale = Vector3.zero
    GameNoticePanel.right.localScale = Vector3.zero
    go:Hide()
    UIPanel.ClosePage();
    DataManager.DetailModelRpcNoRet(OpenModelInsID.GameMainInterfaceCtrl , 'm_GetAllMails')
end

--点击xbutton
function GameNoticeCtrl:OnXBtn(go)
    PlayMusEff(1002)
    local data={ReminderType = ReminderType.Warning,ReminderSelectType = ReminderSelectType.Select,
                content = GetLanguage(16010020),func = function()
            DataManager.DetailModelRpcNoRet(go.insId , 'm_delMail',goId)
        end  }
    ct.OpenCtrl('NewReminderCtrl',data)
end

--读取邮件
function GameNoticeCtrl:c_onBg(go)
    if go.state == false then
        DataManager.DetailModelRpcNoRet(self.insId , 'm_mailRead',go.id)
    else
        GameNoticeCtrl:c_OnMailRead(go.id)
    end
end

--读取邮件回调
function GameNoticeCtrl:c_OnMailRead(ids)
    --打开内容面板
    GameNoticePanel.right.localScale = Vector3.one
    -- [[显示新背景
    if bg ~= nil then
        bg.localScale = Vector3.zero
    end
    noticeItems[ids].newBg.localScale = Vector3.one
    if  noticeItems[ids].hint ~= nil then
        noticeItems[ids].hint.localScale = Vector3.zero
        for i, v in pairs(noticeData) do
            if v.id == ids then
                v.state = true
            end
        end
    end
    bg = noticeItems[ids].newBg
    --
    -- [[显示跳转按钮
    if Notice[noticeItems[ids].typeId].redirect == "" then
        GameNoticePanel.jumpBtn.transform.localScale = Vector3.zero
    else
        GameNoticePanel.jumpBtn.transform.localScale = Vector3.one
    end
    -- ]]
    -- [[显示内容
    GameNoticePanel.hedaer.text = noticeItems[ids].itemHedaer.text
    GameNoticePanel.time.text = noticeItems[ids].itemTime.text
    --GameNoticePanel.rightContent.text = Notice[go.typeId].content
    --GameNoticePanel.rightContent.text = go.content
    GameNoticePanel.timeLeft.transform.localScale = Vector3.one
    GameNoticePanel.timeLeft.text = GetLanguage(16010017 ,noticeItems[ids].day)
    -- ]]
    --if go.typeId ==1 then
    --    GameNoticePanel.GoodsScrollView:SetActive(true)
    --else
    --    GameNoticePanel.GoodsScrollView:SetActive(false)
    --end
    id =  noticeItems[ids].typeId
    goId = ids
end

--删除通知回调
function GameNoticeCtrl:c_OnDeleMails(go)
     Event.Brocast("SmallPop",GetLanguage(16010029),ReminderType.Succeed)
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
    if isShow then
        GameNoticePanel.hintItem.localScale = Vector3.one
    else
        GameNoticePanel.hintItem.localScale = Vector3.zero
    end
    isShowHint = isShow
end

--删除通知方法
function GameNoticeCtrl:_deleteNotice(id)
    GameNoticePanel.timeLeft.transform.localScale = Vector3.zero
    --  [[删除邮件实例与表中数据
    if id == nil then
        return
    end
    destroy(noticeItems[id].prefab.gameObject)
    noticeItems[id] = nil
    id = nil
    bg = nil
    self:_initData()
    if next(noticeItems )== nil then
        UIPanel.ClosePage();
        ct.OpenCtrl("NoMessageCtrl")
    end
end

function GameNoticeCtrl:GetBuildingName(name)
    if GameNoticeCtrl.type == 1 then
        GameNoticeCtrl.content = GetLanguage(16020001,name,GameNoticeCtrl.nameSize)
    elseif GameNoticeCtrl.type == 2 then
        GameNoticeCtrl.content = GetLanguage(16020002,name,GameNoticeCtrl.nameSize)
    elseif GameNoticeCtrl.type == 3 then
        GameNoticeCtrl.content = GetLanguage(16020004,name,GameNoticeCtrl.nameSize,GameNoticeCtrl.goodsName,GameNoticeCtrl.num)
    elseif GameNoticeCtrl.type == 5 then
        GameNoticeCtrl.content = GetLanguage(16020012,name,GameNoticeCtrl.time,GameNoticeCtrl.money,GameNoticeCtrl.startTime)
    elseif GameNoticeCtrl.type == 6 then
        GameNoticeCtrl.content = GetLanguage(16020013,name,GameNoticeCtrl.time,GameNoticeCtrl.money,GameNoticeCtrl.startTime)
    elseif GameNoticeCtrl.type == 7 then
        GameNoticeCtrl.content = GetLanguage(16020014,name,GameNoticeCtrl.time,GameNoticeCtrl.nameSize,GameNoticeCtrl.bonus)
    elseif GameNoticeCtrl.type == 8 then
        GameNoticeCtrl.content = GetLanguage(16020015,name,GameNoticeCtrl.goodsName,GameNoticeCtrl.money,GameNoticeCtrl.num)
    elseif GameNoticeCtrl.type == 9 then
        GameNoticeCtrl.content = GetLanguage(16020015,name,GameNoticeCtrl.goodsName,GameNoticeCtrl.money,GameNoticeCtrl.num)
    end
    GameNoticePanel.rightContent.text = GameNoticeCtrl.content
end

function GameNoticeCtrl:c_SocietyInfo(name)
    if GameNoticeCtrl.type == 14 then
        GameNoticeCtrl.content = GetLanguage(16020022,name)
    elseif GameNoticeCtrl.type == 15 then
        GameNoticeCtrl.content = GetLanguage(16020023,name)
    elseif GameNoticeCtrl.type == 16 then
        GameNoticeCtrl.content = GetLanguage(16020024,name)
    end
    GameNoticePanel.rightContent.text = GameNoticeCtrl.content
end
