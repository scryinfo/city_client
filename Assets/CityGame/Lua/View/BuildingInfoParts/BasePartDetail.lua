BasePartDetail = class('BasePartDetail')


function BasePartDetail.PrefabName()
    return "BasePartDetail"
end

function BasePartDetail:initialize(groupClass,trans,mainPanelLuaBehaviour)
    self.groupClass =  groupClass
    self.go = trans.gameObject
    self.transform = trans
    --留给子类实现的方法
    self:_InitTransform()
    self:_InitClick(mainPanelLuaBehaviour)
end

--TODO://子类务必重写，初始化独特组件
function  BasePartDetail:_InitTransform()

end

--TODO:初始化独特点击事件
--mainPanelLuaBehaviour:LuaBehaviour的引用
function BasePartDetail:_InitClick(mainPanelLuaBehaviour)

end

--TODO://子类需要重写刷新详情
function BasePartDetail:RefreshData(data)

end

--显示详情
function BasePartDetail:Show()
    self.transform.localScale = Vector3.one
    self:Refresh()
end

--隐藏详情
function BasePartDetail:Hide()
    self.transform.localScale = Vector3.zero
end


--删除Parts
--清除自身GameObject，清除
function BasePartDetail:Destroy()


end