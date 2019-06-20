---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Fisher.
--- DateTime: 2019/6/10 9:58
---钱包
WalletCtrl = class('WalletCtrl',UIPanel)
UIPanel:ResgisterOpen(WalletCtrl)

function WalletCtrl:initialize()
    UIPanel.initialize(self,UIType.Normal,UIMode.DoNothing,UICollider.Normal)
end

function WalletCtrl:bundleName()
    return "Assets/CityGame/Resources/View/WalletPanel.prefab"
end

function WalletCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function WalletCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
    self.luaBehaviour:AddClick(self.createBtn.gameObject,self._clickCreateBtn,self)
    self.luaBehaviour:AddClick(self.detailsBtn.gameObject,self._clickDetailsBtn,self)
    self.luaBehaviour:AddClick(self.detailsCloseBtn.gameObject,self._clickDetailsCloseBtn,self)
    self.luaBehaviour:AddClick(self.withdrawBtn.gameObject,self._clickWithdrawBtn,self)
    self.luaBehaviour:AddClick(self.withdrawCloseBtn.gameObject,self._clickWithdrawCloseBtn,self)
    self.luaBehaviour:AddClick(self.topUpBtn.gameObject,self._clickTopUpBtn,self)
    self.luaBehaviour:AddClick(self.QRCodeCloseBtn.gameObject,self._clickQRCodeCloseBtn,self)
    --self.luaBehaviour:AddClick(self.scanningBtn.gameObject,self._clickScanningBtn,self)   扫码暂时关闭
    self.luaBehaviour:AddClick(self.scanCloseBtn.gameObject,self._clickScanCloseBtn,self)
    self.luaBehaviour:AddClick(self.passwordCloseBtn.gameObject,self._clickPasswordCloseBtn,self)
    self.luaBehaviour:AddClick(self.agreeBtn.gameObject,self._clickAgreeBtn,self)
    self.luaBehaviour:AddClick(self.declarationCloseBtn.gameObject,self._clickDeclarationCloseBtn,self)
    self.luaBehaviour:AddClick(self.passwordConfirmBtn.gameObject,self._clickPasswordConfirmBtn,self)
    self.luaBehaviour:AddClick(self.rechargeConfirmBtn.gameObject,self._clickRechargeConfirmBtn,self)
    self.luaBehaviour:AddClick(self.rechargeCloseBtn.gameObject,self._clickRechargeCloseBtn,self)
    self.luaBehaviour:AddClick(self.getBtn.gameObject,self._clickGetBtn,self)
    self.luaBehaviour:AddClick(self.detailsConfirmBtn.gameObject,self._clickDetailsConfirmBtn,self)
    self.luaBehaviour:AddClick(self.phoneRootConfirmBtn.gameObject,self._clickPhoneRootConfirmBtn,self)

    self.confirmInputField.onValueChanged:AddListener(function()
        self:confirmInputButton()
    end)
    self.moneyInput.onValueChanged:AddListener(function()
        self:saveAmount()
    end)
    self.addressInput.onValueChanged:AddListener(function()
        self:saveEthAddr()
    end)
    self.validationInput.onValueChanged:AddListener(function()
        self:savePhoneCode()
    end)
end

function WalletCtrl:Active()
    UIPanel.Active(self)
    Event.AddListener("openQRCode",self.openQRCode,self)
    Event.AddListener("createWalletSucceed",self.createWalletSucceed,self)
    Event.AddListener("reqTopUpSucceed",self.reqTopUpSucceed,self)
    Event.AddListener("reqDisChargeOrderSucceed",self.reqDisChargeOrderSucceed,self)
    Event.AddListener("reqDisChargeSucceed",self.reqDisChargeSucceed,self)
end

function WalletCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
    self.userId = DataManager.GetMyOwnerID()
    DataManager.OpenDetailModel(WalletModel,self.userId)
end

function WalletCtrl:Hide()
    UIPanel.Hide(self)
    Event.RemoveListener("openQRCode",self.openQRCode,self)
    Event.RemoveListener("createWalletSucceed",self.createWalletSucceed,self)
    Event.RemoveListener("reqTopUpSucceed",self.reqTopUpSucceed,self)
    Event.RemoveListener("reqDisChargeOrderSucceed",self.reqDisChargeOrderSucceed,self)
    Event.RemoveListener("reqDisChargeSucceed",self.reqDisChargeSucceed,self)
end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function WalletCtrl:_getComponent(go)
    --topRoot
    self.closeBtn = go.transform:Find("topRoot/closeBtn")
    self.detailsBtn = go.transform:Find("topRoot/detailsBtn")
    self.topName = go.transform:Find("topRoot/topName")

    --WithoutWalletContent   创建钱包
    self.WithoutWalletContent = go.transform:Find("WithoutWalletContent")
    self.createBtn = go.transform:Find("WithoutWalletContent/createBtn")
    self.createText = go.transform:Find("WithoutWalletContent/createBtn/createText"):GetComponent("Text")

    --DeclarationContent   用户协议
    self.DeclarationContent = go.transform:Find("DeclarationContent")
    self.declarationCloseBtn = go.transform:Find("DeclarationContent/top/closeBtn")
    self.declarationTopName = go.transform:Find("DeclarationContent/top/topName"):GetComponent("Text")
    self.declarationContent = go.transform:Find("DeclarationContent/content/ScrollView/Viewport/Content")
    self.agreeBtn = go.transform:Find("DeclarationContent/content/agreeBtn"):GetComponent("Image")
    self.agreeText = go.transform:Find("DeclarationContent/content/agreeBtn/agreeText"):GetComponent("Text")

    --WalletContent   钱包首页
    self.WalletContent = go.transform:Find("WalletContent")
    self.moneyText = go.transform:Find("WalletContent/moneyBg/moneyText"):GetComponent("Text")
    self.withdrawBtn = go.transform:Find("WalletContent/withdrawBtn")
    self.withdrawText = go.transform:Find("WalletContent/withdrawBtn/withdrawText"):GetComponent("Text")
    self.topUpBtn = go.transform:Find("WalletContent/topUpBtn")

    --DetailsContent   钱包详情
    self.DetailsContent = go.transform:Find("DetailsContent")
    self.detailsCloseBtn = go.transform:Find("DetailsContent/top/closeBtn")
    self.detailsTopName = go.transform:Find("DetailsContent/top/topName"):GetComponent("Text")
    self.detailsContent = go.transform:Find("DetailsContent/content/ScrollView/Viewport/Content")

    --RechargeAmountContent  输入充值金额（新加）
    self.RechargeAmountContent = go.transform:Find("RechargeAmountContent")
    self.rechargeCloseBtn = go.transform:Find("RechargeAmountContent/top/closeBtn")
    self.rechargeTopName = go.transform:Find("RechargeAmountContent/top/topName"):GetComponent("Text")
    self.rechargeText = go.transform:Find("RechargeAmountContent/content/rechargeText"):GetComponent("Text")
    self.rechargeMoneyInput = go.transform:Find("RechargeAmountContent/content/moneyInput"):GetComponent("InputField")
    self.DDDText = go.transform:Find("RechargeAmountContent/content/proportionIcon/DDDText"):GetComponent("Text")
    self.proportionText = go.transform:Find("RechargeAmountContent/content/proportionText"):GetComponent("Text")
    self.rechargeConfirmBtn = go.transform:Find("RechargeAmountContent/content/confirmBtn")
    self.rechargeConfirmBtnText = go.transform:Find("RechargeAmountContent/content/confirmBtn/Text"):GetComponent("Text")
    self.rechargeTipText = go.transform:Find("RechargeAmountContent/content/tipText"):GetComponent("Text")

    --QRCodeContent   二维码
    self.QRCodeContent = go.transform:Find("QRCodeContent")
    self.QRCodeCloseBtn = go.transform:Find("QRCodeContent/top/closeBtn")
    self.QRCodeTopName = go.transform:Find("QRCodeContent/top/topName"):GetComponent("Text")
    self.QRCodeImg = go.transform:Find("QRCodeContent/content/QRCode"):GetComponent("RawImage")
    self.QRCodeAddressText = go.transform:Find("QRCodeContent/content/addressBg/addressText"):GetComponent("Text")
    self.copyBtn = go.transform:Find("QRCodeContent/content/addressBg/copyBtn")
    self.copyText = go.transform:Find("QRCodeContent/content/addressBg/copyBtn/Text"):GetComponent("Text")

    --WithdrawContent   提币
    self.WithdrawContent = go.transform:Find("WithdrawContent")
    self.withdrawCloseBtn = go.transform:Find("WithdrawContent/top/closeBtn")
    self.withdrawTopName = go.transform:Find("WithdrawContent/top/topName"):GetComponent("Text")
    --detailsRoot  提币详情
    self.detailsRoot = go.transform:Find("WithdrawContent/content/detailsRoot")
    self.detailsMoneyText = go.transform:Find("WithdrawContent/content/detailsRoot/withdrawMoneyText"):GetComponent("Text")
    self.moneyInput = go.transform:Find("WithdrawContent/content/detailsRoot/moneyInput"):GetComponent("InputField")
    self.moneyPlaceholder = go.transform:Find("WithdrawContent/content/detailsRoot/moneyInput/Placeholder"):GetComponent("Text")
    self.poundageText = go.transform:Find("WithdrawContent/content/detailsRoot/poundageText"):GetComponent("Text")
    self.tipText = go.transform:Find("WithdrawContent/content/detailsRoot/poundageText/tipText"):GetComponent("Text")
    self.proportionMontyText = go.transform:Find("WithdrawContent/content/detailsRoot/proportionIcon/unitText/montyText"):GetComponent("Text")
    self.detailsAddressText = go.transform:Find("WithdrawContent/content/detailsRoot/addressText"):GetComponent("Text")
    self.addressInput = go.transform:Find("WithdrawContent/content/detailsRoot/addressInput"):GetComponent("InputField")
    self.addressPlaceholder = go.transform:Find("WithdrawContent/content/detailsRoot/addressInput/Placeholder"):GetComponent("Text")
    self.scanningBtn = go.transform:Find("WithdrawContent/content/detailsRoot/scanningBtn")
    self.detailsConfirmBtn = go.transform:Find("WithdrawContent/content/detailsRoot/confirmBtn"):GetComponent("Image")
    self.detailsConfirmText = go.transform:Find("WithdrawContent/content/detailsRoot/confirmBtn/confirmText"):GetComponent("Text")
    --phoneRoot   提币验证
    self.phoneRoot = go.transform:Find("WithdrawContent/content/phoneRoot")
    self.phoneNumberText = go.transform:Find("WithdrawContent/content/phoneRoot/phoneIcon/phoneNumberText"):GetComponent("Text")
    self.phoneText = go.transform:Find("WithdrawContent/content/phoneRoot/phoneBg/phoneText"):GetComponent("Text")
    self.validationNumberText = go.transform:Find("WithdrawContent/content/phoneRoot/validationIcon/validationNumberText"):GetComponent("Text")
    self.validationInput = go.transform:Find("WithdrawContent/content/phoneRoot/validationInput/"):GetComponent("InputField")
    self.validationPlaceholder = go.transform:Find("WithdrawContent/content/phoneRoot/validationInput/Placeholder"):GetComponent("Text")
    self.getBtn = go.transform:Find("WithdrawContent/content/phoneRoot/getBtn"):GetComponent("Image")
    self.getText = go.transform:Find("WithdrawContent/content/phoneRoot/getBtn/getText"):GetComponent("Text")
    self.countdownImage = go.transform:Find("WithdrawContent/content/phoneRoot/countdownBg")
    self.countdownText = go.transform:Find("WithdrawContent/content/phoneRoot/countdownBg/countdownText"):GetComponent("Text")
    self.phoneRootTipIcon = go.transform:Find("WithdrawContent/content/phoneRoot/tipIcon")
    self.phoneRootTipText = go.transform:Find("WithdrawContent/content/phoneRoot/tipIcon/tipText"):GetComponent("Text")
    self.phoneRootConfirmBtn = go.transform:Find("WithdrawContent/content/phoneRoot/confirmBtn"):GetComponent("Image")
    self.phoneRootConfirmText = go.transform:Find("WithdrawContent/content/phoneRoot/confirmBtn/confirmText"):GetComponent("Text")
    --scanQRCodeRoot   扫描二维码
    self.scanQRCodeRoot = go.transform:Find("WithdrawContent/content/scanQRCodeRoot")
    self.cameraImg = go.transform:Find("WithdrawContent/content/scanQRCodeRoot/cameraImg"):GetComponent("RawImage")
    self.scanCloseBtn = go.transform:Find("WithdrawContent/content/scanQRCodeRoot/topBg/closeBtn")
    self.scanTopName = go.transform:Find("WithdrawContent/content/scanQRCodeRoot/topBg/topName"):GetComponent("Text")
    self.scanTipText = go.transform:Find("WithdrawContent/content/scanQRCodeRoot/content/scanTipText"):GetComponent("Text")

    --PasswordContent   支付密码
    self.PasswordContent = go.transform:Find("PasswordContent")
    self.passwordCloseBtn = go.transform:Find("PasswordContent/top/closeBtn")
    self.passwordTopName = go.transform:Find("PasswordContent/top/topName"):GetComponent("Text")
    self.settingPassword = go.transform:Find("PasswordContent/content/settingIcon/settingPassword"):GetComponent("Text")
    self.settingInputField = go.transform:Find("PasswordContent/content/settingInputField"):GetComponent("InputField")
    --self.settingPlaceholder = go.transform:Find("PasswordContent/content/settingInputField/Placeholder"):GetComponent("Text")
    self.confirmPassword = go.transform:Find("PasswordContent/content/confirmIcon/confirmPassword"):GetComponent("Text")
    self.confirmInputField = go.transform:Find("PasswordContent/content/confirmInputField"):GetComponent("InputField")
    --self.confirmPlaceholder = go.transform:Find("PasswordContent/content/confirmInputField/Placeholder"):GetComponent("Text")
    self.passwordConfirmBtn = go.transform:Find("PasswordContent/content/confirmBtn"):GetComponent("Image")
    self.passwordConfirmText = go.transform:Find("PasswordContent/content/confirmBtn/confirmText"):GetComponent("Text")
end
-------------------------------------------------------------初始化---------------------------------------------------------------------------------
--初始化UI
function WalletCtrl:initializeUiInfoData()
    self:defaultPanel()
end
--设置多语言
function WalletCtrl:_language()
    self.moneyPlaceholder.text = "请输入提币金额"
    self.addressPlaceholder.text = "请输入钱包地址"
end
--初始化打开钱包时
function WalletCtrl:defaultPanel()
    --读取路径
    local path = CityLuaUtil.getAssetsPath().."/Lua/pb/credential.data"
    local str = ct.file_readString(path)
    if str == nil then
        self.WithoutWalletContent.transform.localScale = Vector3.one
        self.WalletContent.transform.localScale = Vector3.zero
        self.DetailsContent.transform.localScale = Vector3.zero
        self.RechargeAmountContent.transform.localScale = Vector3.zero
        self.QRCodeContent.transform.localScale = Vector3.zero
        self.WithdrawContent.transform.localScale = Vector3.zero
        self.PasswordContent.transform.localScale = Vector3.zero
        --self.DeclarationContent.transform.localScale = Vector3.zero
        self.DeclarationContent.gameObject:SetActive(false)
    else
        self.WithoutWalletContent.transform.localScale = Vector3.zero
        self.WalletContent.transform.localScale = Vector3.one
        self.DetailsContent.transform.localScale = Vector3.zero
        self.RechargeAmountContent.transform.localScale = Vector3.zero
        self.QRCodeContent.transform.localScale = Vector3.zero
        self.WithdrawContent.transform.localScale = Vector3.zero
        self.PasswordContent.transform.localScale = Vector3.zero
        --self.DeclarationContent.transform.localScale = Vector3.zero
        self.DeclarationContent.gameObject:SetActive(false)
    end
end
-------------------------------------------------------------点击函数---------------------------------------------------------------------------------
--退出钱包
function WalletCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--打开用户协议
function WalletCtrl:_clickCreateBtn(ins)
    PlayMusEff(1002)
    ins:openUserAgreement()
end
--关闭用户协议
function WalletCtrl:_clickDeclarationCloseBtn(ins)
    PlayMusEff(1002)
    ins:closeUserAgreement()
end
--用户协议页面确定按钮打开设置密码
function WalletCtrl:_clickAgreeBtn(ins)
    PlayMusEff(1002)
    ins:openPaymentPassword()
end
--设置密码页面确定
function WalletCtrl:_clickPasswordConfirmBtn(ins)
    PlayMusEff(1002)
    ins:confirmPasswordBtn()
end
--关闭设置密码
function WalletCtrl:_clickPasswordCloseBtn(ins)
    PlayMusEff(1002)
    ins:closePaymentPassword()
end
--打开详情
function WalletCtrl:_clickDetailsBtn(ins)
    PlayMusEff(1002)
    ins:openDetails()
end
--关闭详情
function WalletCtrl:_clickDetailsCloseBtn(ins)
    PlayMusEff(1002)
    ins:closeDetails()
end
--打开提币
function WalletCtrl:_clickWithdrawBtn(ins)
    PlayMusEff(1002)
    ins:openWithdrawContent()
end
--关闭提币
function WalletCtrl:_clickWithdrawCloseBtn(ins)
    PlayMusEff(1002)
    ins:closeWithdrawContent()
end
--打开密码弹框(新加)
function WalletCtrl:_clickRechargeConfirmBtn(ins)
    PlayMusEff(1002)
    if ins.rechargeMoneyInput.text == "" or ins.rechargeMoneyInput.text == 0 then
        Event.Brocast("SmallPop","请输入充值金额", ReminderType.Warning)
        return
    end
    local data = {}
    data.userId = ins.userId
    data.amount = tostring(ins.rechargeMoneyInput.text)
    ct.OpenCtrl("WalletBoxCtrl",data)
end
--关闭密码弹窗（新加）
function WalletCtrl:_clickRechargeCloseBtn(ins)
    PlayMusEff(1002)
    ins:closeRechargeAmountContent()
end
--打开二维码
function WalletCtrl:_clickTopUpBtn(ins)
    PlayMusEff(1002)
    ins:openRechargeAmountContent()
end
--关闭二维码
function WalletCtrl:_clickQRCodeCloseBtn(ins)
    PlayMusEff(1002)
    ins:closeQRCode()
end
--打开扫描二维码
function WalletCtrl:_clickScanningBtn(ins)
    PlayMusEff(1002)
    ins:openScanningQRCode()
end
--关闭扫描二维码
function WalletCtrl:_clickScanCloseBtn(ins)
    PlayMusEff(1002)
    ins:closeScanningQRCode()
end
--打开弹窗
function WalletCtrl:_clickDetailsConfirmBtn(ins)
    PlayMusEff(1002)
    if ins.moneyInput.text == nil or ins.moneyInput.text == "" or ins.addressInput.text == nil or ins.addressInput.text == "" then
        Event.Brocast("SmallPop","请输入正确的金额和地址", ReminderType.Warning)
        return
    end
    local data={ReminderType = ReminderType.Common,ReminderSelectType = ReminderSelectType.Select,
                content = "确认提币金额",func = function()
            Event.Brocast("ReqDisChargeOrder",ins.userId)
        end}
    ct.OpenCtrl("NewReminderCtrl",data)
end
--请求提币并获取验证码
function WalletCtrl:_clickGetBtn(ins)
    PlayMusEff(1002)
    ins.timing = 60
    ins.countdownImage.transform.localScale = Vector3.one
    UpdateBeat:Add(ins.UpdateTiming,ins)
    Event.Brocast("ReqDisCharge",ins.userId,ins.PurchaseId,ins.pubkeyStr,ins.ethAddr,ins.Amount,ins.second,ins.sm.ToHexString(ins.sig))
end
--点击NEXT发送验证码
function WalletCtrl:_clickPhoneRootConfirmBtn(ins)
    Event.Brocast("ReqValidationPhoneCode",ins.userId,ins.phoneCode)
end
-----------------------------------------------------------------------监听函数-----------------------------------------------------------------------
--检测两次输入密码是否相同
function WalletCtrl:confirmInputButton()
    if self.settingInputField.text == nil or self.settingInputField.text == "" or self.confirmInputField.text == nil or self.confirmInputField.text == "" then
        LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-gray.png",self.passwordConfirmBtn,false)
        self.passwordConfirmBtn:GetComponent("Button").interactable = false
    end
    if self.settingInputField.text ~= nil and self.settingInputField.text ~= "" and self.confirmInputField.text ~= nil and self.confirmInputField.text ~= "" then
        if self.settingInputField.text == self.confirmInputField.text then
            LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-92x180.png",self.passwordConfirmBtn,false)
            self.passwordConfirmBtn:GetComponent("Button").interactable = true
        else
            LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-gray.png",self.passwordConfirmBtn,false)
            self.passwordConfirmBtn:GetComponent("Button").interactable = false
        end
    end
end
--检测保存输入要提币的金额
function WalletCtrl:saveAmount()
    self.Amount = self.moneyInput.text
end
--检测保存输入的钱包地址
function WalletCtrl:saveEthAddr()
    self.ethAddr = self.addressInput.text
end
--检测保存输入的手机验证码
function WalletCtrl:savePhoneCode()
    self.phoneCode = self.validationInput.text
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
--打开用户协议
function WalletCtrl:openUserAgreement()
    self.declarationContent.localPosition = Vector2(0,0)
    self.DeclarationContent.gameObject:SetActive(true)
    --暂时默认打开用户协议就能点击下一步（后边可能要改成看完之后才能点击确定）
    --LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-92x180.png",ins.agreeBtn,false)
    --ins.agreeBtn:GetComponent("Button").interactable = false
end
--关闭用户协议
function WalletCtrl:closeUserAgreement()
    --ins.DeclarationContent.transform.localScale = Vector3.zero
    self.DeclarationContent.gameObject:SetActive(false)
end
--用户协议页面确定按钮打开设置密码
function WalletCtrl:openPaymentPassword()
    --ins.DeclarationContent.transform.localScale = Vector3.zero
    self.DeclarationContent.gameObject:SetActive(false)
    self.PasswordContent.transform.localScale = Vector3.one
    LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-gray.png",self.passwordConfirmBtn,false)
    self.passwordConfirmBtn:GetComponent("Button").interactable = false
end
--关闭设置密码
function WalletCtrl:closePaymentPassword()
    self.PasswordContent.transform.localScale = Vector3.zero
end
--设置密码页面确定
function WalletCtrl:confirmPasswordBtn()
    ---创建钱包
    --生产密钥
    self:creatKey()
    local userName = DataManager.GetName()
    local pubKey = self.pubkey
    Event.Brocast("ReqCreateWallet",self.userId,userName,pubKey)
end
--打开详情
function WalletCtrl:openDetails()
    self.DetailsContent.transform.localScale = Vector3.one
end
--关闭详情
function WalletCtrl:closeDetails()
    self.DetailsContent.transform.localScale = Vector3.zero
end
--打开提币
function WalletCtrl:openWithdrawContent()
    self.moneyInput.text = ""
    self.poundageText.text = "E".."0.0000".."(0.3%)"
    self.proportionMontyText.text = "0.0000"
    self.addressInput.text = ""
    self.WithdrawContent.transform.localScale = Vector3.one
    self.detailsRoot.transform.localScale = Vector3.one
    self.phoneRoot.transform.localScale = Vector3.zero
    self.scanQRCodeRoot.transform.localScale = Vector3.zero
    LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-92x180.png",self.detailsConfirmBtn,false)
    self.detailsConfirmBtn:GetComponent("Button").interactable = true
end
--关闭提币
function WalletCtrl:closeWithdrawContent()
    self.WithdrawContent.transform.localScale = Vector3.zero
    UpdateBeat:Remove(self.UpdateTiming,self)
end
--打开钱包充值金额（新加）
function WalletCtrl:openRechargeAmountContent()
    self.RechargeAmountContent.transform.localScale = Vector3.one
    self.rechargeMoneyInput.text = ""
    self.DDDText.text = "0.0000".."(DDD)"
end
--关闭钱包充值金额（新加）
function WalletCtrl:closeRechargeAmountContent()
    self.RechargeAmountContent.transform.localScale = Vector3.zero
end
--打开二维码
function WalletCtrl:openQRCode(data)
    self:closeRechargeAmountContent()
    self.QRCodeContent.transform.localScale = Vector3.one
    --self.QRCodeImg
    self.QRCodeAddressText.text = data.RechargeRequestRes.EthAddr
end
--关闭二维码
function WalletCtrl:closeQRCode()
    self.QRCodeContent.transform.localScale = Vector3.zero
end
--打开扫描二维码
function WalletCtrl:openScanningQRCode()
    self.scanQRCodeRoot.transform.localScale = Vector3.one
end
--关闭扫描二维码
function WalletCtrl:closeScanningQRCode()
    self.scanQRCodeRoot.transform.localScale = Vector3.zero
end
--关闭提币详情打开手机验证
function WalletCtrl:openPhoneCode()
    self.detailsRoot.transform.localScale = Vector3.zero
    self.phoneRoot.transform.localScale = Vector3.one
    self.phoneText.text = CityEngineLua.username
    self.validationInput.text = ""
    LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-92x180.png",self.phoneRootConfirmBtn,false)
    self.countdownImage.transform.localScale = Vector3.zero
    self.phoneRootTipIcon.transform.localScale = Vector3.zero
end
---------------------------------------------------------------------回调函数---------------------------------------------------------------------------
--创建钱包成功回调
function WalletCtrl:createWalletSucceed(data)
    if data then
        self.PasswordContent.transform.localScale = Vector3.zero
        self.WithoutWalletContent.transform.localScale = Vector3.zero
        self.WalletContent.transform.localScale = Vector3.one
        self.moneyText.text = DataManager.GetMoneyByString()
        Event.Brocast("SmallPop", GetLanguage(33010013), ReminderType.Succeed)
    end
end
--充值请求成功回调
function WalletCtrl:reqTopUpSucceed(data)
    if data then
        self:openQRCode(data)
        Event.Brocast("SmallPop", "操作成功", ReminderType.Succeed)
    end
end
--提币订单请求成功
function WalletCtrl:reqDisChargeOrderSucceed(data)
    if data ~= nil then
        ---封装一个方法，打开手机验证---
        self:openPhoneCode()
        -------------------------------------------------------------
        self.PurchaseId = data.PurchaseId
        local serverNowTime = TimeSynchronized.GetTheCurrentServerTime()
        local privateKeyStr = self:parsing()
        self.sm = City.signer_ct.New()
        local pubkey = self.sm.GetPublicKeyFromPrivateKey(privateKeyStr)
        self.pubkeyStr = self.sm.ToHexString(pubkey)
        --暂时发秒
        self.second = math.ceil(serverNowTime / 1000)
        self.sm:pushHexSting(data.PurchaseId)
        self.sm:pushSha256Hex(self.ethAddr)
        self.sm:pushHexSting(self.Amount)
        self.sm:pushLong(self.second)
        --生成签名(用于验证关键数据是否被篡改)
        self.sig = self.sm:sign(privateKeyStr);
    end
end
--提币成功
function WalletCtrl:reqDisChargeSucceed(data)
    if data ~= nil then
        self:closeWithdrawContent()
    end
end
-------------------------------------------------------------------------------------------------------------------------------------------------------
--生成密钥
function WalletCtrl:creatKey()
    --生成
    local privateKey = City.CityLuaUtil.NewGuid()

    --支付密码
    local passWord = tostring(self.confirmInputField.text)
    local privateKeyEncrypted = City.signer_ct.Encrypt(passWord, privateKey)

    --保存密钥
    local path = CityLuaUtil.getAssetsPath().."/Lua/pb/credential.data"
    ct.file_saveString(path,privateKeyEncrypted)

    --保存支付密码
    local passWordPath = CityLuaUtil.getAssetsPath().."/Lua/pb/passWard.data"
    ct.file_saveString(passWordPath,tostring(self.confirmInputField.text))

    local privateKeyEncryptedSaved = ct.file_readString(path)
    local privateKeyNewEncrypted = City.signer_ct.Decrypt(passWord, privateKeyEncryptedSaved)

    --生成公钥
    self.pubkey = City.signer_ct.GetPublicKeyFromPrivateKey(privateKeyNewEncrypted);
end
--解析支付密码和私钥
function WalletCtrl:parsing()
    local privateKeyPath = CityLuaUtil.getAssetsPath().."/Lua/pb/credential.data"
    local privateKeyStr = ct.file_readString(privateKeyPath)
    local passWordPath = CityLuaUtil.getAssetsPath().."/Lua/pb/passWard.data"
    local passWordStr = ct.file_readString(passWordPath)
    local privateKeyNewEncrypted = City.signer_ct.Decrypt(passWordStr, privateKeyStr)
    return privateKeyNewEncrypted
end
--刷新获取验证码时间
function WalletCtrl:UpdateTiming()
    if self.timing >= 1 then
        self.timing = self.timing - UnityEngine.Time.unscaledDeltaTime
        self.countdownText.text = math.floor(self.timing).."s..."
    else
        self.countdownImage.transform.localScale = Vector3.zero
        UpdateBeat:Remove(self.UpdateTiming,self)
    end
end









