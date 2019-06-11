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
    self.luaBehaviour:AddClick(self.scanningBtn.gameObject,self._clickScanningBtn,self)
    self.luaBehaviour:AddClick(self.scanCloseBtn.gameObject,self._clickScanCloseBtn,self)
    self.luaBehaviour:AddClick(self.passwordCloseBtn.gameObject,self._clickPasswordCloseBtn,self)
    self.luaBehaviour:AddClick(self.agreeBtn.gameObject,self._clickAgreeBtn,self)
    self.luaBehaviour:AddClick(self.declarationCloseBtn.gameObject,self._clickDeclarationCloseBtn,self)
    self.luaBehaviour:AddClick(self.passwordConfirmBtn.gameObject,self._clickPasswordConfirmBtn,self)

    self.confirmInputField.onValueChanged:AddListener(function()
        self:confirmInputButton()
    end)
end

function WalletCtrl:Refresh()
    self:_language()
    self:initializeUiInfoData()
end

function WalletCtrl:Hide()
    UIPanel.Hide(self)
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
    self.getBtn = go.transform:Find("WithdrawContent/content/phoneRoot/getBtn")
    self.getText = go.transform:Find("WithdrawContent/content/phoneRoot/getBtn/getText"):GetComponent("Text")
    self.countdownText = go.transform:Find("WithdrawContent/content/phoneRoot/countdownBg/countdownText"):GetComponent("Text")
    self.phoneRootTipIcon = go.transform:Find("WithdrawContent/content/phoneRoot/tipIcon")
    self.phoneRootTipText = go.transform:Find("WithdrawContent/content/phoneRoot/tipIcon/tipText"):GetComponent("Text")
    self.phoneRootConfirmBtn = go.transform:Find("WithdrawContent/content/phoneRoot/confirmBtn")
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
    --self.moneyText.text = CityEngineLua.username
    self:defaultPanel()
end
--设置多语言
function WalletCtrl:_language()
    self.moneyPlaceholder.text = "请输入提币金额"
    self.addressPlaceholder.text = "请输入钱包地址"

end
--打开钱包时，暂时默认为设置支付密码
function WalletCtrl:defaultPanel()
    self.WithoutWalletContent.transform.localScale = Vector3.one
    self.WalletContent.transform.localScale = Vector3.zero
    self.DetailsContent.transform.localScale = Vector3.zero
    self.QRCodeContent.transform.localScale = Vector3.zero
    self.WithdrawContent.transform.localScale = Vector3.zero
    self.PasswordContent.transform.localScale = Vector3.zero
    --self.DeclarationContent.transform.localScale = Vector3.zero
    self.DeclarationContent.gameObject:SetActive(false)
end
-------------------------------------------------------------点击函数---------------------------------------------------------------------------------
--退出钱包
function WalletCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end
--打开用户协议页面
function WalletCtrl:_clickCreateBtn(ins)
    PlayMusEff(1002)
    ins.DeclarationContent.gameObject:SetActive(true)
    --ins.declarationContent.transform.localPosition = Vector2(0,0)
    --ins.DeclarationContent.transform.localScale = Vector3.one
    --暂时默认打开用户协议就能点击下一步（后边可能要改成看完之后才能点击确定）
    --LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-92x180.png",ins.agreeBtn,false)
    --ins.agreeBtn:GetComponent("Button").interactable = false
end
--关闭用户协议页面
function WalletCtrl:_clickDeclarationCloseBtn(ins)
    PlayMusEff(1002)
    --ins.DeclarationContent.transform.localScale = Vector3.zero
    ins.DeclarationContent.gameObject:SetActive(false)
end
--用户协议页面确定按钮打开设置密码
function WalletCtrl:_clickAgreeBtn(ins)
    PlayMusEff(1002)
    --ins.DeclarationContent.transform.localScale = Vector3.zero
    ins.DeclarationContent.gameObject:SetActive(false)
    ins.PasswordContent.transform.localScale = Vector3.one
    LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-gray.png",ins.passwordConfirmBtn,false)
    ins.passwordConfirmBtn:GetComponent("Button").interactable = false
end
--设置密码页面确定
function WalletCtrl:_clickPasswordConfirmBtn(ins)
    ins.PasswordContent.transform.localScale = Vector3.zero
    ins.WithoutWalletContent.transform.localScale = Vector3.zero
    ins.WalletContent.transform.localScale = Vector3.one
end
--关闭设置密码页面
function WalletCtrl:_clickPasswordCloseBtn(ins)
    PlayMusEff(1002)
    ins.PasswordContent.transform.localScale = Vector3.zero
end
--打开详情页面
function WalletCtrl:_clickDetailsBtn(ins)
    PlayMusEff(1002)
    ins.DetailsContent.transform.localScale = Vector3.one
end
--关闭详情页面
function WalletCtrl:_clickDetailsCloseBtn(ins)
    PlayMusEff(1002)
    ins.DetailsContent.transform.localScale = Vector3.zero
end
--打开提币页面
function WalletCtrl:_clickWithdrawBtn(ins)
    PlayMusEff(1002)
    ins.moneyInput.text = ""
    ins.poundageText.text = "E".."0.0000".."(0.3%)"
    ins.proportionMontyText.text = "0.0000"
    ins.addressInput.text = ""
    ins.WithdrawContent.transform.localScale = Vector3.one
    ins.detailsRoot.transform.localScale = Vector3.one
    ins.phoneRoot.transform.localScale = Vector3.zero
    ins.scanQRCodeRoot.transform.localScale = Vector3.zero
    LoadSprite("Assets/CityGame/Resources/Atlas/Wallet/button-gray.png",ins.detailsConfirmBtn,false)
    ins.detailsConfirmBtn:GetComponent("Button").interactable = false
end
--关闭提币页面
function WalletCtrl:_clickWithdrawCloseBtn(ins)
    PlayMusEff(1002)
    ins.WithdrawContent.transform.localScale = Vector3.zero
end
--打开二维码页面
function WalletCtrl:_clickTopUpBtn(ins)
    PlayMusEff(1002)
    ins.QRCodeContent.transform.localScale = Vector3.one
    --ins.QRCodeImg
    ins.QRCodeAddressText.text = "钱包地址"
end
--关闭二维码页面
function WalletCtrl:_clickQRCodeCloseBtn(ins)
    PlayMusEff(1002)
    ins.QRCodeContent.transform.localScale = Vector3.zero
end
--打开扫描二维码
function WalletCtrl:_clickScanningBtn(ins)
    PlayMusEff(1002)
    ins.scanQRCodeRoot.transform.localScale = Vector3.one
end
--关闭扫描二维码
function WalletCtrl:_clickScanCloseBtn(ins)
    PlayMusEff(1002)
    ins.scanQRCodeRoot.transform.localScale = Vector3.zero
end
-------------------------------------------------------------监听函数---------------------------------------------------------------------------------
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