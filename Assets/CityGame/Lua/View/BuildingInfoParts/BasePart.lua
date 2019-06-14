BasePart = class('BasePart')

BasePart.static.OpenDetailPartTime = 0.1
BasePart.static.sizeHeight = 200

--Self,posX,sizeWidth，Index
function BasePart:initialize(trans,groupClass,posX,sizeWidth,partIndex,mainPanelLuaBehaviour)
    self.go = trans.gameObject
    self.transform = trans
    self.rect = trans:GetComponent("RectTransform")
    self.groupClass =  groupClass
    self.partIndex = partIndex
    --创建详情
    local detailClass = self.GetDetailClass()
    local partDetailGo = groupClass:GetPartDatailGameObject(detailClass.PrefabName())
    self.partDetail = detailClass:new(groupClass,partDetailGo,mainPanelLuaBehaviour)
    --通用组件的查找
    self.selectTransform =  self.transform:Find("SelectBtn")
    self.unselectTransform =  self.transform:Find("UnselectBtn")
    --初始化位置
    self:_Init(posX,sizeWidth)
    --留给子类实现的方法
    self:_InitTransform()
    --
    self:_ResetTransform()
    --通用按钮的事件
    self:_InitClick(mainPanelLuaBehaviour)
end

-------------------------------------------------------------------私有函数--------------------------------------------

--初始化位置等参数
function BasePart:_Init(posX,sizeWidth)
    self.rect.anchoredPosition = Vector3.New(posX,0,0)
    self.transform.sizeDelta = Vector2.New(sizeWidth,BasePart.static.sizeHeight)
end

--初始化独特点击事件
--mainPanelLuaBehaviour:LuaBehaviour的引用
function BasePart:_InitClick(mainPanelLuaBehaviour)
    --点击打开界面
    mainPanelLuaBehaviour:AddClick(self.go, function()
        self.groupClass.SwitchingOptions(self.groupClass,self.partIndex)
    end)
    --点击关闭界面
    mainPanelLuaBehaviour:AddClick(self.selectTransform.gameObject, function()
        --注：暂定方案为不做处理
        --关闭所有界面
        self.groupClass.TurnOffAllOptions(self.groupClass)
    end)
    self:_InitChildClick(mainPanelLuaBehaviour)
end

--移除监听
function  BasePart:_RemoveClick()
    self.go.transform:GetComponent("Button").onClick:RemoveAllListeners()
    self.selectTransform:GetComponent("Button").onClick:RemoveAllListeners()
    self:_RemoveChildClick()
end

-----------------------------------------------------------------外部调用方法-----------------------------------------------------------------

--选中状态，并显示详情
function BasePart:ShowDetail(data)
    --切换为选中状态
    self.selectTransform.localScale = Vector3.one
    self.unselectTransform.localScale = Vector3.zero
    --显示详情
    self.partDetail:Show(data)
end

--未选中状态，并隐藏详情
function BasePart:HideDetail()
    --切换为未选中状态
    self.selectTransform.localScale = Vector3.zero
    self.unselectTransform.localScale = Vector3.one
    --隐藏详情
    self.partDetail:Hide()
end

--刷新数据--
function BasePart:Refresh(data)
    --刷新自身数据
    self:RefreshData(data)
    --刷新详情数据
    self.partDetail:RefreshData(data)
end

--删除Parts
--清除自身实例，清除
function BasePart:Destroy()
    self:_ResetTransform()
    self:_RemoveClick()
    self.partDetail:Destroy()
    self = nil
end

-----------------------------------------------------------------子类需重写方法-----------------------------------------------------------------

--TODO://子类需要则重写
--特殊按钮
function  BasePart:_InitChildClick(mainPanelLuaBehaviour)

end

--TODO://子类需要则重写
--特殊按钮移除事件
function  BasePart:_RemoveChildClick()

end

--TODO://子类务必重写
--初始化独特组件
function  BasePart:_InitTransform()

end

--TODO://子类务必重写
--重置独特组件
function  BasePart:_ResetTransform()

end

--TODO://子类务必重写
--刷新数据--
function BasePart:RefreshData(data)

end

-----------------------------------------------------------------子类需重写静态方法-----------------------------------------------------------------

--TODO://子类务必重写
--return:对应预制的名字
function BasePart.PrefabName()
    return "BasePart"
end

--TODO://子类务必重写
--return:对应详情界面Class
function BasePart.GetDetailClass()
    return BasePartDetail
end