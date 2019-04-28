---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mengpengfei.
--- DateTime: 2019/4/27 8:56
---仓库销毁二次确认弹框

DeleteItemBoxCtrl = class("DeleteItemBoxCtrl",UIPanel)
UIPanel:ResgisterOpen(DeleteItemBoxCtrl)

function DeleteItemBoxCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.Normal)
end

function DeleteItemBoxCtrl:bundleName()
    return "Assets/CityGame/Resources/View/DeleteItemBoxPanel.prefab"
end

function DeleteItemBoxCtrl:OnCreate(obj)
    UIPanel.OnCreate(self,obj)
end

function DeleteItemBoxCtrl:Awake(go)
    self.gameObject = go
    self:_getComponent(go)
    self:_language()
    self.luaBehaviour = self.gameObject:GetComponent('LuaBehaviour')
    self.luaBehaviour:AddClick(self.closeBtn.gameObject,self._clickCloseBtn,self)
end
function DeleteItemBoxCtrl:Active()
    UIPanel.Active(self)

end
function DeleteItemBoxCtrl:Refresh()
    self:initializeUiInfoData()
end

function DeleteItemBoxCtrl:Hide()
    UIPanel.Hide(self)

end
-------------------------------------------------------------获取组件-------------------------------------------------------------------------------
function DeleteItemBoxCtrl:_getComponent(go)
    --top
    self.closeBtn = go.transform:Find("contentRoot/top/closeBtn")
    self.topName = go.transform:Find("contentRoot/top/topName"):GetComponent("Text")
    --content goodInfo
    self.iconImg = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/iconImg"):GetComponent("Image")
    self.nameText = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/nameBg/nameText"):GetComponent("Text")
    --如果是原料就隐藏
    self.goods = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods")
    self.levelImg = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/levelImg"):GetComponent("Image")
    self.brandNameText = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/detailsBg/brandNameText"):GetComponent("Text")
    self.brandValue = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/detailsBg/scoreBg/brandIcon/brandValue"):GetComponent("Text")
    self.qualityValue = go.transform:Find("contentRoot/content/goodInfoBg/goodInfo/goods/detailsBg/scoreBg/qualityIcon/qualityValue"):GetComponent("Text")

    self.numberSlider = go.transform:Find("contentRoot/content/goodInfoBg/numberSlider"):GetComponent("Slider")
    self.tipText = go.transform:Find("contentRoot/content/goodInfoBg/tipText"):GetComponent("Text")
    self.confirmBtn = go.transform:Find("contentRoot/bottom/confirmBtn")

end
-------------------------------------------------------------初始化---------------------------------------------------------------------------------
--初始化UI数据
function DeleteItemBoxCtrl:initializeUiInfoData()

end
--设置多语言
function DeleteItemBoxCtrl:_language()
    self.tipText.text = "There is no product yet!".."\n".."just go to produce some.good luck."
end
-------------------------------------------------------------点击函数---------------------------------------------------------------------------------
--关闭
function DeleteItemBoxCtrl:_clickCloseBtn()
    PlayMusEff(1002)
    UIPanel.ClosePage()
end