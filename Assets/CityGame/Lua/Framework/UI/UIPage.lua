---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/27 10:09
---

require('Framework/UI/UIRoot')
local typeof = tolua.typeof
local UIRoot = UIRoot
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

UIPage = class('UIPage') --this is the same as class('UIPage', Object) or Object:subclass('UIPage') 没有基类的类，默认基类是Object，不需要写而已
UIPage.static.m_allPages={}
UIPage.static.allPages={}
UIPage.static.m_currentPageNodes={}
UIPage.static.currentPageNodes={}

function UIPage:initialize(name)
    self:initialize(name,UIType.Normal,UIMode.DoNothing)
end

function UIPage:initialize(type, mod, col)
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

function UIPage:Awake(obj)
    self.gameObject = obj;
end
function UIPage:Refresh()

end

function UIPage:Hide()
    self.gameObject:SetActive(false)
    self.isActived = false
    if #UIPage.static.m_currentPageNodes <= 1 then
        CameraMove.MoveOutUILayer()
    end
end

function UIPage:Active()
    self.gameObject:SetActive(true);
    self.isActived = true;
end

function UIPage:OnCreate(obj)
    if self.gameObject == nil then
        --把C#中的 LoadPrefab_A 中实例化相关的处理剥离到lua中来，LoadPrefab_A只处理资源加载，
        --这里传入的prefab就是 LoadPrefab_A 加载的原始资源，不能直接使用，需要实例化，否则
        --对它的任何改动都会影响到所有引用该资源的地方
        ------{
        local go = ct.InstantiatePrefab(obj);
        ------}
        go.layer = LayerMask.NameToLayer("UI");
        UnityEngine.GameObject.AddComponent(go, typeof(LuaFramework.LuaBehaviour))
        self.gameObject = go;
        assert(go, "system","[UIPage.Show] "," 没有找到资源： ",uiPath)
        if go == nil then
            ct.log("system","[UIPage.Show]", "资源加载失败: "..uiPath)
        end
        self:AnchorUIGameObject(go)
        self:Awake(go)
        self.isAsyncUI = false
    end

    self:DoShow()

end

function UIPage:DoShow()
    self:Active()
    self:Refresh()
    self:PopNode(self)
end

function UIPage:Show(path, callback)
    if self.gameObject == nil then
        --if self.delegateAsyncLoadUI ~= nil then
        --    local o = self.delegateAsyncLoadUI(self.uiPath)
        --    go = o
        --else
        --    go = Resources.Load(uiPath)
        --end
        --panelMgr:LoadPrefab_A(path, callback, self);
        panelMgr:LoadPrefab_A(path, nil, self, callback);
    else
        self:DoShow()
    end
end

--IEnumerator AsyncShow(Action callback)

function UIPage:CheckIfNeedBackInner()
    if self.type == UIType.Fixed or self.type == UIType.PopUp or self.type == UIType.None then
        return false
    elseif self.mode == UIMode.NoNeedBack or self.mode == UIMode.DoNothing then
        return false
    end
    return true
end

function UIPage:AnchorUIGameObject(ui)
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

function UIPage:ToString()
    return ">Name:" .. self.name .. ",ID:" .. self.id .. ",Type:" .. self.type.ToString() .. ",ShowMode:" .. self.mode.ToString() .. ",Collider:" .. self.collider.ToString()
end

function UIPage:isActive()
    local ret = self.gameObject ~= nil and self.gameObject.activeSelf
    return ret or self.isActived
end

function UIPage:CheckIfNeedBack(page)
    return page ~= nil and page:CheckIfNeedBackInner();
end

function UIPage:PopNode(page)
    if UIPage.static.m_currentPageNodes == nil then
        UIPage.static.m_currentPageNodes = {};

        if page == nil then
            --Debug.LogError("[UI] page popup is nil.");
            ct.log("system","page popup is nil.")
            return
        end
    end
    --sub pages should not need back.
    if self:CheckIfNeedBack(page) == false then
        return
    end
    local _isFound = false
    local pageNodes = UIPage.static.m_currentPageNodes
    for i = 1, #pageNodes do
        if pageNodes[i] == (page) then
            table.remove(pageNodes, i)
            pageNodes[#pageNodes+1] = page;
            _isFound = true;
            break;
        end
    end
    --if dont found in old nodes
    --should add in nodelist.
    if not _isFound then
        pageNodes[#pageNodes+1] = page;
    end

    --//after pop should hide the old node if need.
    self:HideOldNodes();
end

function  UIPage:HideOldNodes()
    local pageNodes = UIPage.static.m_currentPageNodes
    if #pageNodes < 0 then  return end
    local topPage = pageNodes[#pageNodes]
    if topPage.mode == UIMode.HideOther then
        --form bottm to top.
        for i = 1, #pageNodes - 1  do
            if(pageNodes[i]:isActive()) then
                pageNodes[i]:Hide();
            end
        end
    end
end

function UIPage:Close()
    ct.log("system","请使用UIPage派生类自己的Close方法，尽量不要调用基类的 Close 方法")
    destroy(self.gameObject);
end

--清空栈中所有的UI实例，销毁其对应perfab资源
function  UIPage:ClearAllPages()
    --清空当前page
    UIPage.static.m_currentPageNodes = nil
    UIPage.static.m_currentPageNodes = {};

    --销毁栈中所有UI资源
    for k,v in pairs(UIPage.static.m_allPages) do
        v:Close();
    end
    UIPage.static.m_allPages = nil
    UIPage.static.m_allPages = {}
end

function  UIPage:ShowPage(inClass,pageData)
    return UIPage:ShowPageByClass(inClass, pageData, true)
end

function  UIPage:ShowPageInstance(pageInstance,pageData)
    if pageData ~= nil then
        pageInstance.m_data = pageData;
    end
    if pageInstance.isAsync then
        pageInstance:Show(pageInstance.OnCreate)
    else
        pageInstance:Show(pageInstance.bundleName(), pageInstance.OnCreate);
    end
end

function  UIPage:ShowPageByClass(inClass,pageData)
    --pageName = inClass.bundleName()
    pageName = inClass.name
    callback = inClass.OnCreate
    if pageName == "" then
        ct.log("system","[UI] show page error with :" , pageName , " maybe nil instance.");
        return
    end

    if UIPage.static.m_allPages == nil then
        UIPage.static.m_allPages = {}
    end

    local pageInstance = nil;
    if UIPage.static.m_allPages[pageName] ~= nil then
        pageInstance = UIPage.static.m_allPages[pageName]
    else
        pageInstance = inClass:new()
        UIPage.static.m_allPages[pageName] = pageInstance
    end
    self:ShowPageInstance(pageInstance, pageData)
    return pageInstance
end

function UIPage:setPosition(x,y)
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

function UIPage:ClosePage()
    --//Debug.ct.log("Back&Close PageNodes Count:" + m_currentPageNodes.Count);
    local pageNodes = UIPage.static.m_currentPageNodes
    if pageNodes == nil or #pageNodes <= 1 then return;    end

    local closePage = pageNodes[#pageNodes];
    table.remove(pageNodes, #pageNodes)
    --//show older page.
    --//TODO:Sub pages.belong to root node.
    if #pageNodes > 0 then
        local page = pageNodes[#pageNodes];
        if page.isAsyncUI == false then
            local data = closePage:Hide()
            UIPage:ShowPageInstance(page,data)
        else
            UIPage:ShowPageInstance(page)
            closePage:Hide();
        end
    end
end
--
--function UIPage:ClosePage(target)
--    if target == nil then return end;
--    local pageNodes = UIPage.static.m_currentPageNodes
--    if target:isActive() == false then
--        if pageNodes ~= nil then
--            for i = 0, #pageNodes do
--                if pageNodes[i] == target then
--                    table.remove(pageNodes, i)
--                    break;
--                end
--            end
--        return;
--        end
--    end
--
--    if pageNodes ~= nil and #pageNodes >= 1 and pageNodes[#pageNodes] == target then
--        table.remove(pageNodes, #pageNodes)
--        --//show older page.
--        --//TODO:Sub pages.belong to root node.
--        if #pageNodes > 0 then
--            local page = pageNodes[#pageNodes];
--            if page.isAsyncUI == true then
--                page:ShowPage(function()
--                    target:Hide();
--                 end);
--            else
--                page:ShowPage();
--                target:Hide();
--            end
--            return;
--        end
--    elseif target.CheckIfNeedBack() then
--        for i = 0, #pageNodes do
--            if pageNodes[i] == target then
--                table.remove(pageNodes, i)
--                target:Hide();
--                break;
--            end
--        end
--    end
--    target:Hide();
--end

function UIPage:ClosePageByName(pageName)
    if UIPage.static.m_allPages ~= nil and UIPage.static.m_allPages[pageName] then
        UIPage:ClosePage(UIPage.static.m_allPages[pageName])
    else
        ct.log("system",pageName , " havnt show yet!");
    end
end

--注册 Controller 的打开的类方法，因为打开方法是在该Controller实例化之前，所以在每个 Controller 类声明后调用就可以
function UIPage:ResgisterOpen(inClass)
    Event.AddListener('c_OnOpen'..inClass.name, function (data)
        UIPage:ShowPage(inClass,data)
    end);
end

--controller的rpc方法
--ctrlRpc是有返回值的rpc
function ct.ctrlRpc(ctrlName, modelMethord, ...)
    local arg = {...}
    local ctrl = UIPage.static.m_allPages[ctrlName]
    if arg[#arg] ~= nil then
        arg[#arg](ctrl[modelMethord](ctrl,...))
    else
        ct.log('system', 'ctrlRpcRet need callback function')
    end
end
--ctrlRpcNoRet 是没有返回值的rpc
function ct.ctrlRpcNoRet(ctrlName, modelMethord, ...)
    local ctrl = UIPage.static.m_allPages[ctrlName]
    ctrl[modelMethord](ctrl,...)
end



































