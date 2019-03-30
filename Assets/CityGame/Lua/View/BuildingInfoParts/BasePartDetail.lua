BasePartDetail = class('BasePartDetail')

BasePartDetail.static.OpenDetailPartTime = 0.1
BasePartDetail.static.OpenDetailPartEase = DG.Tweening.Ease.OutCubic

function BasePartDetail:initialize(groupClass,trans,mainPanelLuaBehaviour)
    self.groupClass =  groupClass
    self.go = trans.gameObject
    self.transform = trans
    --留给子类实现的方法
    self:_InitTransform()
    self:_InitEvent()
    self:_InitClick(mainPanelLuaBehaviour)
end

-----------------------------------------------------------------外部调用方法-----------------------------------------------------------------

--显示详情
function BasePartDetail:Show(data)
    --self.transform.localScale = Vector3.one
    self.transform.localScale = Vector3.New(1,0,1)
    self.transform:DOScale(Vector3.one,BasePartDetail.static.OpenDetailPartTime):SetEase(BasePartDetail.static.OpenDetailPartEase)
    self:RefreshData(data)
end

--隐藏详情
function BasePartDetail:Hide()
    self.transform.localScale = Vector3.zero
end

--删除Parts
--清除自身实例，清除
function BasePartDetail:Destroy()
    self:_ResetTransform()
    self:_RemoveEvent()
    self:_RemoveClick()
    self = nil
end

-----------------------------------------------------------------子类需重写方法-----------------------------------------------------------------

--TODO://子类务必重写
--初始化独特组件
function  BasePartDetail:_InitTransform()

end

--TODO://子类务必重写
--注册监听
function  BasePartDetail:_InitEvent()

end

--TODO://子类务必重写
--注册点击事件
--mainPanelLuaBehaviour:LuaBehaviour的引用
function BasePartDetail:_InitClick(mainPanelLuaBehaviour)

end

--TODO://子类务必重写
--重置独特组件
function  BasePartDetail:_ResetTransform()

end

--TODO://子类务必重写
--移除监听
function  BasePartDetail:_RemoveEvent()

end

--TODO://子类务必重写
--移除点击事件
function  BasePartDetail:_RemoveClick()

end

--TODO://子类务必重写
--刷新数据--
function BasePartDetail:RefreshData(data)

end

-----------------------------------------------------------------子类需重写静态方法-----------------------------------------------------------------

--TODO://子类务必重写
--return:对应预制的名字
function BasePartDetail.PrefabName()
    return "BasePartDetail"
end