---
--- Created by Allen.
--- DateTime: 2019/1/1
---

require('Framework/UI/UIRoot')
local UIRoot = UIRoot
--[[
UIType = {
    Bubble = 0,     --气泡
    Normal =1 ,
    Fixed =2 ,
    PopUp =3 ,
    None =4 ,      --独立的窗口
}

UIMode =
{
    DoNothing =1,
    HideOther =2,     -- 闭其他界面
    NeedBack =3,      -- 点击返回按钮关闭当前,不关闭其他界面(需要调整好层级关系)
    NoNeedBack =4,    -- 关闭TopBar,关闭其他界面,不加入backSequence队列
}

UICollider =
{
    None =1,      -- 显示该界面不包含碰撞背景
    Normal=2,    --碰撞透明背景
    WithBg=3,    -- 碰撞非透明背景
}
--]]
UIPanel = class('UIPanel')
UIPanel.static.m_allPages={}            --界面GameObject管理
UIPanel.static.m_instancePageNodes={}   --界面实例顺序管理（new）
UIPanel.static.m_BubblePageNodes={}     --气泡界面实例顺序管理（new）
UIPanel.static.m_FixedPageNodes={}      --固定界面实例顺序管理（new）

UIPanel.static.MainCtrl = nil




---------------------------------------------------------------------------------------框架内函数不可调用/继承---------------------------------------------------------------------------------------

--初始化

function UIPanel:initialize()
    self:initialize(self,UIType.Normal,UIMode.DoNothing,UICollider.Normal)
end
function UIPanel:initialize(type, mod, col)
    self.mode = mod
    self.collider = col
    self.type = type
    self.id = -1
    self.uiPath = ""
    self.gameObject = nil
    self.transform = nil
    self.isAsyncUI = false
    self.isActived = false
    self.m_data = nil
    self.data = nil
    self.delegateAsyncLoadUI = nil
    self.offset = Vector2.New(0, 0)
end

--检查界面实例（Ctrl）是否打开
function UIPanel:isActive()
    local ret = self.gameObject ~= nil and self.gameObject.activeSelf
    return ret or self.isActived
end

--打开页面实例
--inClass : Ctrl类
--pageData：Ctrl实例数据
function  UIPanel.ShowPageByClass(inClass,pageData)
    local pageName = inClass.name
    if pageName == "" then
        ct.log("system","[UI] show page error with :" , pageName , " maybe nil instance.");
        return
    end
    if UIPanel.static.m_allPages == nil then
        UIPanel.static.m_allPages = {}
    end
    --pageInstance：Ctrl类实例
    local pageInstance
    if UIPanel.static.m_allPages[pageName] ~= nil then
        pageInstance = UIPanel.static.m_allPages[pageName]
    else
        pageInstance = inClass:new()
        UIPanel.static.m_allPages[pageName] = pageInstance
    end
    UIPanel.PopNode(pageInstance,inClass,pageData)
    UIPanel.ShowPageInstance(pageInstance, pageData)
    return pageInstance
end

--将节点压栈,只在打开界面的时候执行
--pageInstance:Ctrl类实例
--inClass: Ctrl类
--pageData：Ctrl实例数据
function UIPanel.PopNode(pageInstance,inClass,pageData)
    --实例判空
    if pageInstance == nil then
        ct.log("system","pageInstance popup is nil.")
        return
    end
    if UIPanel.static.m_instancePageNodes == nil then
        UIPanel.static.m_instancePageNodes = {}
    end
    --如果打开的是普通界面，隐藏跟之前的界面
    if pageInstance.type == UIType.Normal then
        UIPanel.HideOldPage()
    end
    --将界面压入栈内
    if inClass ~= nil then
        local tempPageNode  = {}
        tempPageNode.page = pageInstance            --界面实例Ctrl（会重复）
        tempPageNode.pageClass = inClass            --界面实例的Ctrl类
        tempPageNode.pageType = pageInstance.type   --界面实例的层级类型
        tempPageNode.pageData = pageData            --界面实例的实例数据（重要）
        table.insert(UIPanel.static.m_instancePageNodes,tempPageNode)
    end
end

--隐藏之前界面
function UIPanel.HideOldPage()
    local insNodes  = UIPanel.static.m_instancePageNodes
    local nodeCount = #insNodes
    while (nodeCount >= 1 ) do
        insNodes[nodeCount].page:Hide()
        if insNodes[nodeCount].pageType == UIType.Normal then
            break
        end
        nodeCount = nodeCount -1
    end
end

--打开界面实例
--将参数写入self.m_data
function  UIPanel.ShowPageInstance(pageInstance,pageData)
    if pageData ~= nil then
        pageInstance.m_data = pageData;
    end
    pageInstance:Show(pageInstance.bundleName(), pageInstance.OnCreate);
end

--打开页面实例，调用DoShow
function UIPanel:Show(path, callback)
    if self.gameObject == nil then
        panelMgr:LoadPrefab_A(path, nil, self, callback)
    else
        self:DoShow()
    end
end


--创建界面实例
--创建完成调用DOShow
function UIPanel:OnCreate(obj)
    if self.gameObject == nil then
        local go = ct.InstantiatePrefab(obj)
        go.layer = LayerMask.NameToLayer("UI")
        UnityEngine.GameObject.AddComponent(go, typeof(LuaFramework.LuaBehaviour))
        self.gameObject = go
        assert(go, "system","[UIPanel.Show] "," 没有找到资源： ",uiPath)
        if go == nil then
            ct.log("system","[UIPanel.Show]", "资源加载失败: "..uiPath)
        end
        self:AnchorUIGameObject(go)
        self:Awake(go)
        self.isAsyncUI = false
    end
    self:DoShow()
end

--设置界面锚点
function UIPanel:AnchorUIGameObject(ui)
    if UIRoot.Instance() == nil or ui == nil then return end
    self.gameObject = ui
    self.transform = ui.transform

    local rect = self.transform:GetComponent("RectTransform");
    if rect then
        rect:DOAnchorPosX(self.offset.x, 0)
        rect:DOAnchorPosY(self.offset.y, 0)
    end

    local anchorPos = Vector3.zero
    local sizeDel = Vector3.zero
    local scale  = Vector3.one

    local rect = ui:GetComponent("RectTransform")
    if rect ~= nil then
        anchorPos = rect.anchoredPosition
        sizeDel= rect.sizeDelta
        scale = rect.localScale
    else
        anchorPos = rect.anchoredPosition.localPosition
        scale = rect.localScale.localScale
    end

    if self.type == UIType.Fixed then
        ui.transform:SetParent(UIRoot.getFixedRoot())
    elseif self.type == UIType.Normal then
        ui.transform:SetParent(UIRoot.getNormalRoot())
    elseif self.type == UIType.PopUp then
        ui.transform:SetParent(UIRoot.getPopupRoot())
    elseif self.type == UIType.Bubble then
        ui.transform:SetParent(UIRoot.getBubbleRoot())
    end


    if ui:GetComponent("RectTransform") ~= nil then
        rect.anchoredPosition = anchorPos
        rect.sizeDelta = sizeDel
        rect.localScale = scale
    else
        ui.transform.localPosition = anchorPos
        ui.transform.localScale = scale
    end
end

--设置UI位置
function UIPanel:setPosition(x,y)
    self.offset.x = x
    self.offset.y = y
    if self.transform then
        local rect = self.transform:GetComponent("RectTransform");
        if rect then
            rect:DOAnchorPosX(self.offset.x, 0)
            rect:DOAnchorPosY(self.offset.y, 0)
        end
    end
end

--DoShow，页面调用打开时调用
function UIPanel:DoShow()
    if self.gameObject ~= nil then
        self.gameObject.transform:SetAsLastSibling()
    end
    self:Active()
    self:Refresh()
end

--关闭m_instancePageNodes最顶层的页面
function UIPanel.ClosePopNode()
    local pageNodes = UIPanel.static.m_instancePageNodes
    pageNodes[#pageNodes].page:Hide()
    table.remove(pageNodes, #pageNodes)
    --如果关闭界面后到主界面，则退出相机的UI界面模式
    --粗暴模式
    if #pageNodes <= 1 then
        CameraMove.MoveOutUILayer()
    end
    --[[
    --精确模式
    if UIPanel.static.MainCtrl ~= nil then
        if pageNodes ~= nil and #pageNodes >= 1 and pageNodes[#pageNodes].pageClass == UIPanel.static.MainCtrl then
            CameraMove.MoveOutUILayer()
        end
    end
    --]]
end

---------------------------------------------------------------------------------------子类具体可继承实现函数---------------------------------------------------------------------------------------

--注册 Controller 的打开的类方法，因为打开方法是在该Controller实例化之前，所以在每个 Controller 类声明后调用就可以（必须写）
function UIPanel:ResgisterOpen(inClass)
    Event.AddListener('c_OnOpen'..inClass.name, function (data)
        UIPanel.ShowPageByClass(inClass,data)
    end)
end

--函数生命周期顺序
-- Awake -> （Active -> Refresh  -> Hide） -> Close

--子类需重写
--主要职责
--1.注册点击事件
--2.初始化子组件【A】
function UIPanel:Awake(obj)
    self.gameObject = obj
end

--子类需重写
--主要职责
--1.显示界面【继承父类即可，亦可自己重写过度动画】
--2.初始化无网络数据
--3.注册监听事件
function UIPanel:Active()
    self.gameObject:SetActive(true)
    self.isActived = true
end

--子类需重写
--主要职责
--1.确认打开对应Model
--2.初始化子组件【B】
--3.刷新数据
function UIPanel:Refresh()
    ct.log("system","请使用UIPanel派生类自己的Refresh方法，尽量不要调用基类的 Refresh 方法")
end

--子类需重写
--主要职责
--1.隐藏界面【继承父类即可，亦可自己重写过度动画】
--2.注销监听事件
--3.销毁子组件【B】
function UIPanel:Hide()
    self.gameObject:SetActive(false)
    self.isActived = false
end

--子类需重写
--1.清空数据
--2.从堆栈中清除界面
--3.销毁子组件【A】
--4.销毁界面GameObject【继承父类即可】
function UIPanel:Close()
    destroy(self.gameObject)
end

---------------------------------------------------------------------------------------外部调用方法---------------------------------------------------------------------------------------
--[[
--设置主界面,游戏开始时调用
function UIPanel.SetMainPanel(mainClass)
    UIPanel.static.MainCtrl = mainClass
end
--]]

--获取m_allPages
function UIPanel.GetAllPages()
    return UIPanel.static.m_allPages
end

--关闭当前最新打开的窗口
--Normal及PopUp使用
--关闭当前最顶窗口（无论是Normal还是PopUp）
--规则：当关闭界面之后的栈顶界面是PopUp界面,则继续往下打开界面直到Normal界面
function UIPanel.ClosePage()
    local pageNodes = UIPanel.static.m_instancePageNodes
    --判空,为1是因为界面不能为空界面，至少都应该会有主界面
    if pageNodes == nil or #pageNodes <= 1 then
        ct.log("system","m_instancePageNodes is nil.")
        return
    end
    --关闭当前窗口（即栈顶界面）
    UIPanel.ClosePopNode()
    --打开旧界面
    local NodeCount = #pageNodes
    local Node
    while( NodeCount > 0 ) do
        Node = pageNodes[NodeCount]
        --如果是已经打开的界面，则表示之前到Normal的界面应该都是打开了的（即NPP界面关掉了最上层的P界面，此时NP界面不变）
        --那么不应做任何其他操作
        if Node.page:isActive() == true then
            break
        end
        UIPanel.ShowPageInstance(Node.page,Node.pageData)
        --如果是打开了正常界面，那么不再往下继续打开了
        if  Node.pageType == UIType.Normal then
            break
        end
        NodeCount = NodeCount - 1
    end
end

--关闭所有窗口（到主窗口）【特定】
--Normal及PopUp使用
--关闭当前最顶窗口（无论是Normal还是PopUp）
function UIPanel.CloseAllPageExceptMain()
    local pageNodes = UIPanel.static.m_instancePageNodes
    --注：不能回退到没有主界面，所以最小为1
    if pageNodes ==  nil or  #pageNodes < 1 then
        ct.log("system","m_instancePageNodes is nil.")
        return
    end
    while( #pageNodes > 1 ) do
        UIPanel.ClosePopNode()
    end
    local Node = pageNodes[#pageNodes]
    UIPanel.ShowPageInstance(Node.page,Node.pageData)
end

--回退到指定窗口【只能回退到第一个界面实例】
--注：不能回退到没有主界面
function UIPanel.BackToPage(backtoPageClass)
    local pageNodes = UIPanel.static.m_instancePageNodes
    if pageNodes == nil or #pageNodes < 1 then
        ct.log("system","m_instancePageNodes is nil.")
        return
    end
    --注：不能回退到没有主界面，所以最小为1
    local Node
    while( #pageNodes > 1 ) do
        Node = pageNodes[#pageNodes]
        if Node.pageClass == backtoPageClass then
            UIPanel.ShowPageInstance(Node.page,Node.pageData)
            break
        end
        UIPanel.ClosePopNode()
    end
end

--回退到指定窗口的实例
--注：不能回退到没有主界面
function UIPanel.BackToPageInstance(backtoPageClass,instanceData)
    local pageNodes = UIPanel.static.m_instancePageNodes
    if pageNodes == nil or #pageNodes < 1 then
        ct.log("system","m_instancePageNodes is nil.")
        return
    end
    --注：不能回退到没有主界面，所以最小为1
    local Node
    while( #pageNodes > 1 ) do
        Node = pageNodes[#pageNodes]
        if Node.pageClass == backtoPageClass then
            local isIns = true
            if instanceData == nil then
                isIns = false
            else
                for key, value in pairs(instanceData) do
                    if Node.pageData[key] ~= value then
                        isIns = false
                    end
                end
            end
            if isIns == true then
                UIPanel.ShowPageInstance(Node.page,Node.pageData)
                break
            end
            end
        UIPanel.ClosePopNode()
    end
end

--清空栈中所有的UI实例，销毁其对应perfab资源
--切换场景时调用，退出游戏时可用
--检查通知每个页面Ctrl销毁
function  UIPanel.ClearAllPages()
    --清空当前page
    UIPanel.static.m_instancePageNodes = nil
    UIPanel.static.m_instancePageNodes = {}

    --销毁栈中所有Ctrl
    for k,v in pairs(UIPanel.static.m_allPages) do
        v:Close()
    end
    UIPanel.static.m_allPages = nil
    UIPanel.static.m_allPages = {}
end

--查看某个界面是否存在实例并打开状态
 --pageClass:该界面实例的所属Ctrl类
function UIPanel.CheckPageIsActive(pageClass)
    local pageNodes = UIPanel.static.m_instancePageNodes
    if pageNodes ~= nil then
        for key, Node in pairs(pageNodes) do
            if Node.pageClass == pageClass and Node.page:isActive() == true then
                return true
            end
        end
    end
    return false
end

--打印堆栈结构
function UIPanel.LogPageStackStructure()
    local pageNodes = UIPanel.static.m_instancePageNodes
    if pageNodes == nil or #pageNodes < 1 then
        ct.log("system","m_instancePageNodes is nil.")
        return
    end
    ct.log("system","======================打印Panel堆栈=========================")
    for i = 1, #pageNodes  do
        ct.log("system","第".. i .."个Panle为：".. pageNodes[i].pageClass.name)
    end
end



































