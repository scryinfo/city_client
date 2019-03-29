BasePartDetail = class('BasePartDetail')


function BasePartDetail.PrefabName()
    return "BasePartDetail"
end

function BasePartDetail:initialize(groupClass,go)
    self.groupClass =  groupClass
    self.go = go
    self.transform = go.transform
end

--显示详情
function BasePartDetail:Show()
    self.transform.localScale = Vector3.one
    self:Refresh()
end

--TODO://子类需要重写刷新详情
function BasePartDetail:RefreshData(data)

end

--隐藏详情
function BasePartDetail:Hide()
    self.transform.localScale = Vector3.zero
end


--删除Parts
--清除自身GameObject，清除
function BasePartDetail:Destroy()


end