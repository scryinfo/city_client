BasePartDetail = class('BasePartDetail')

BasePartDetail.static.OpenDetailPartTime = 0.1
BasePartDetail.static.OpenDetailPartEase = DG.Tweening.Ease.OutCubic

function BasePartDetail:initialize(groupClass,trans,mainPanelLuaBehaviour)
    self.groupClass =  groupClass
    self.go = trans.gameObject
    self.transform = trans
    --Methods left to subclass implementation
    self:_InitTransform()
    self:_InitEvent()
    self:_InitClick(mainPanelLuaBehaviour)
end

-----------------------------------------------------------------External call method-----------------------------------------------------------------

--Show details
function BasePartDetail:Show(data)
    --self.transform.localScale = Vector3.one
    self.transform.localScale = Vector3.New(1,0,1)
    self.transform:DOScale(Vector3.one,BasePartDetail.static.OpenDetailPartTime):SetEase(BasePartDetail.static.OpenDetailPartEase)
    self:RefreshData(data)
end

--Hide details
function BasePartDetail:Hide()
    self.transform.localScale = Vector3.zero
    self:_ChildHide()
end

--Delete Parts
--Clear itself instance, clear
function BasePartDetail:Destroy()
    self:_ResetTransform()
    self:_RemoveEvent()
    self:_RemoveClick()
    self = nil
end

-----------------------------------------------------------------Subclasses need to override methods-----------------------------------------------------------------

--TODO://Subclasses must be rewritten
--Initialize unique components
function  BasePartDetail:_InitTransform()

end

--TODO://Subclasses must be rewritten
--Register to monitor
function  BasePartDetail:_InitEvent()

end

--TODO://Subclasses must be rewritten
--Register click event
--mainPanelLuaBehaviour:LuaBehaviour Quote
function BasePartDetail:_InitClick(mainPanelLuaBehaviour)

end

--TODO://Subclasses must be rewritten
--重置独特组件
function  BasePartDetail:_ResetTransform()

end

--TODO://Subclasses must be rewritten
--移除监听
function  BasePartDetail:_RemoveEvent()

end

--TODO://Subclasses must be rewritten
--移除点击事件
function  BasePartDetail:_RemoveClick()

end

--TODO://Subclasses must be rewritten
--刷新数据--
function BasePartDetail:RefreshData(data)

end

--TODO://用到则重写
--隐藏时的处理--
function BasePartDetail:_ChildHide()

end

-----------------------------------------------------------------子类需重写静态方法-----------------------------------------------------------------

--TODO://Subclasses must be rewritten
--return:对应预制的名字
function BasePartDetail.PrefabName()
    return "BasePartDetail"
end