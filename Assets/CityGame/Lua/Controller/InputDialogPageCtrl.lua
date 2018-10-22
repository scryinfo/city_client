---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/4 14:57
---含有input输入框的弹窗

require('Framework/UI/UIPage')
local class = require 'Framework/class'

InputDialogPageCtrl = class('InputDialogPageCtrl',UIPage)

function InputDialogPageCtrl:initialize()
    UIPage.initialize(self, UIType.PopUp, UIMode.DoNothing, UICollider.Normal)
end

function InputDialogPageCtrl:bundleName()
    return "InputDialogPage"
end

function InputDialogPageCtrl:OnCreate(obj )
    UIPage.OnCreate(self, obj)
end

function InputDialogPageCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_initData()

    local dialog = self.gameObject:GetComponent('LuaBehaviour')
    dialog:AddClick(self.closeBtn, self._onClickClose, self);
    dialog:AddClick(self.confimBtn, self._onClickConfim, self);
end

function InputDialogPageCtrl:Refresh()
    self:_initData()
end

function InputDialogPageCtrl:Close()
    self:_removeListener()
end
---寻找组件
function InputDialogPageCtrl:_getComponent(go)
    self.titleText = go.transform:Find("root/titleText").gameObject:GetComponent("Text");
    self.closeBtn = go.transform:Find("root/closeBtn").gameObject;
    self.confimBtn = go.transform:Find("root/confirmBtn").gameObject;
    self.rentInput = go.transform:Find("root/rentInput").gameObject:GetComponent("InputField");
    self.rentInput.onValueChanged:AddListener(function ()
        log("cycle_w6_houseAndGround", "----")
    end)

    self.errorTipRoot = go.transform:Find("root/tipRoot");
    self.errorTipText = go.transform:Find("root/tipRoot/Text").gameObject:GetComponent("Text");
    self.changeNameTipText = go.transform:Find("root/changeNameTipText").gameObject:GetComponent("Text");  --改名字提示 --每七天改一次
end
---初始化
function InputDialogPageCtrl:_initData()
    self.titleText.text = self.m_data.titleInfo;
    self.errorTipRoot.localScale = Vector3.zero;
    self.changeNameTipText.transform.localScale = Vector3.zero

    --根据传入的类型添加监听
    if self.m_data.inputDialogPageServerType == InputDialogPageServerType.UpdateBuildingName then
        self.changeNameTipText.transform.localScale = Vector3.one
        Event.AddListener("c_BuildingNameUpdate", self._changeNameCallBack);  --更改建筑名字 --目前还没有，和服务器协议有关
    end
end
---移出监听
function InputDialogPageCtrl:_removeListener()
    --根据传入的类型添加监听
    if self.m_data.inputDialogPageServerType == InputDialogPageServerType.UpdateBuildingName then
        Event.RemoveListener("c_BuildingNameUpdate", self._bidInfoUpdate);
    --elseif self.m_data.inputDialogPageServerType == InputDialogPageServerType. then

    end
end
---更改名字失败，提示信息更改
function InputDialogPageCtrl:_changeNameCallBack(stream)
    local info = assert(pbl.decode("gs.MetaGroundAuction", stream), "InputDialogPageCtrl:_changeNameCallBack: stream == nil")
    if #info.auction == 0 then
        return
    end

    --判断返回的操作是否成功balabala
    self.errorTipRoot.localScale = Vector3.one;
    self.errorTipText.text = "With sensitive words,Try again";  --根据不同情况选择不同提示语
end
---点击确认按钮
function InputDialogPageCtrl:_onClickConfim(table)
    ---在这的self 是传进来的btn组件，table才是实例
    local inputValue = table.rentInput.text;

    if inputValue == "" or #inputValue < 3 then
        return
    end

    --测试，直接接受到服务器消息
    if table.m_data.btnCallBack then
        table.m_data.btnCallBack()

        table.errorTipRoot.localScale = Vector3.one;
        table.errorTipText.text = "With sensitive words,Try again";  --根据不同情况选择不同提示语
    end

    --如果需要和服务器交互，则不能直接关闭
    if not table.m_data.inputDialogPageServerType then
        table:Hide();
    end

end
---点击关闭按钮
function InputDialogPageCtrl:_onClickClose(table)
    log("cycle_w6_houseAndGround", "InputDialogPageCtrl:_onClickClose")
    table:Hide();
end