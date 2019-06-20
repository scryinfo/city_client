PopCommpent = class('PopCommpent')


function PopCommpent:initialize(panelPrefab,LuaBehaviour,basectrl)
    local transform = panelPrefab.transform

    self.closeBtn=transform:Find("PopCommpent/closeBtn")
    self.confirmBtn=transform:Find("PopCommpent/confimBtn")
    self.titleText=transform:Find("PopCommpent/titleText"):GetComponent('Text')

    LuaBehaviour:AddClick(self.confirmBtn.gameObject,self.OnClick_confirm,self)
    LuaBehaviour:AddClick(self.closeBtn.gameObject,self.OnClick_close,self)

    self.ctrl=basectrl
end

---====================================================================================点击函数==============================================================================================
--确定
function PopCommpent:OnClick_confirm(ins)
    if ins.m_data then
        --实例
        local instance=ins.m_data.ins
        instance.ctrl=ins.ctrl
        --回调
        local funcs=ins.m_data.func
        --调用
        funcs(instance)
    end
    UIPanel.ClosePage()
    PlayMusEff(1002)
end

--关闭
function PopCommpent:OnClick_close()
    UIPanel.ClosePage()
    PlayMusEff(1002)
end

---====================================================================================外部调用==============================================================================================

--刷新
function PopCommpent:Refesh(m_data)
   --多语言
    self.titleText.text=GetLanguage(10040004)
   --刷新回调
   self.m_data=m_data
end

--刷新数据
function PopCommpent:RefeshData(m_data)
    --刷新回调
    self.m_data=m_data
end

-- 设置确认按钮的位置
function PopCommpent:SetConfirmPos(v3)
    --刷新回调
    self.confirmBtn.localPosition = v3
end