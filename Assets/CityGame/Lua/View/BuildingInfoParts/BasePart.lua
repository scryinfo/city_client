BasePart = class('BasePart')

BasePart.static.sizeHeight = 200
BasePart.static.DetailClass = BasePartDetail

--对应预制的名字
function BasePart.PrefabName()
    return "BasePart"
end

--获取对应详情界面Class
function BasePart:GetDetailClass()
    return BasePartDetail
end

--Self,posX,sizeWidth，Index
function BasePart:initialize(trans,groupClass,posX,sizeWidth,partIndex,mainPanelLuaBehaviour)
    self.go = trans.gameObject
    self.transform = trans
    self.groupClass =  groupClass
    self.partIndex = partIndex
    --创建详情
    local detailClass = self:GetDetailClass()
    local partDetailGo = groupClass:GetPartDatailGameObject(detailClass.PrefabName())
    self.partDetail = detailClass:new(groupClass,partDetailGo,mainPanelLuaBehaviour)
    --通用组件的查找
    self.selectTransform =  self.transform:Find("SelectBtn")
    self.unselectTransform =  self.transform:Find("UnselectBtn")
    --通用按钮的事件
    --点击打开界面
    mainPanelLuaBehaviour:AddClick(self.go, function()
        groupClass.SwitchingOptions(groupClass,partIndex)
    end)
    --点击关闭界面
    mainPanelLuaBehaviour:AddClick(self.selectTransform.gameObject, function()
        --注：暂定方案为不做处理
        --关闭所有界面
        --groupClass.TurnOffAllOptions(groupClass)
    end)
    self:_Init(posX,sizeWidth)
    --留给子类实现的方法
    self:_InitTransform()
    self:_InitClick(mainPanelLuaBehaviour)
end

--初始化位置等
function BasePart:_Init(posX,sizeWidth)
    self.transform.localPosition = Vector3.New(posX,0,0)
    self.transform.sizeDelta = Vector2.New(sizeWidth,BasePart.static.sizeHeight)
end


--TODO://子类务必重写，初始化独特组件
function  BasePart:_InitTransform()

end

--TODO:初始化独特点击事件（暂时需求用不到）
--mainPanelLuaBehaviour:LuaBehaviour的引用
function BasePart:_InitClick(mainPanelLuaBehaviour)


end


-----------------------------------------------------------------外部调用方法--------------------------------------------------

--刷新数据--
--TODO://子类根据需求刷新
function BasePart:RefreshData(data)
    --刷新详情数据
    self.partDetail:RefreshData(data)
end

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


--删除Parts
--清除自身GameObject，清除
function BasePart:Destroy()

end