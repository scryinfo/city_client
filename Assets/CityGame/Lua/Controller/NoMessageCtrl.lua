---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by password.
--- DateTime: 2018/11/15 14:55
---没有信息
NoMessageCtrl = class('NoMessageCtrl',UIPage)
UIPage:ResgisterOpen(NoMessageCtrl) --注册打开的方法
local gameObject;
local NoMessageBehaviour


function  NoMessageCtrl:bundleName()
    return "NoMessagePanel"
end

function NoMessageCtrl:initialize()
    --UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
    UIPage.initialize(self,UIType.Normal,UIMode.NeedBack,UICollider.None)--可以回退，UI打开后，不隐藏其它的UI
end

--启动事件--
function NoMessageCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
    gameObject = obj;
    self:_initData();

    NoMessageBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    NoMessageBehaviour:AddClick(NoMessagePanel.bgBtn,self.OnBgBtn,self)
    NoMessageBehaviour:AddClick(NoMessagePanel.xBtn,self.OnXBtn,self);
end

--初始化
function NoMessageCtrl:_initData()
    NoMessagePanel.content.text = "目前没有信息"
end

--点击空白背景
function NoMessageCtrl:OnBgBtn()
    UIPage.ClosePage();
end

--点击删除
function NoMessageCtrl:OnXBtn()
    UIPage.ClosePage();
end