---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/27 10:09
---
local class = require 'Framework/class'
require('Framework/UI/UIRoot')
local UIRoot = UIRoot
UIType = {
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
end

function UIPage:Awake(obj)
    self.gameObject = obj;
end

function UIPage:Refresh()

end

function UIPage:Active()

end

function UIPage:Hide()
    self.gameObject:SetActive(false)
    self.isActived = false
    self.m_data = nil
end

function UIPage:Active()
    self.gameObject:SetActive(true);
    self.isActived = true;
end

function UIPage:OnCreate(go)
    if self.gameObject == nil then
        self.gameObject = go;
        assert(go, "system","[UIPage.Show] "," 没有找到资源： ",uiPath)
        if go == nil then
            log("system","[UIPage.Show]", "资源加载失败: "..uiPath)
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
        --panelMgr:CreatePanel(path, callback, self);
        panelMgr:CreatePanel(path, callback, self);
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
            log("system","page popup is nil.")
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

function  UIPage:ClearNodes()
    UIPage.static.m_currentPageNodes:Clear();
end

function  UIPage:ShowPage(pageInstance,callback)
    ShowPage(pageInstance, callback)
end

function  UIPage:ShowPage(callback, pageData, isAsync)
    pageName = self.uiPath
    if pageName == "" then
        log("system","[UI] show page error with :" , pageName , " maybe nil instance.");
        return
    end

    if UIPage.static.m_allPages == nil then
        UIPage.static.m_allPages = {}
    end

    local page = nil;
    if UIPage.m_allPages[pageName] ~= nil then
        page = UIPage.static.m_allPages[pageName]
    else
        UIPage.static.m_allPages[pageName] = self
        page = self;
    end

    --//if active before,wont active again.
    --//if (page.isActive() == false)
    --//before show should set this data if need. maybe.!!
    page.m_data = pageData;

    if self.isAsync then
        page:Show(callback)
    else
        page:Show(self.uiPath, callback);
    end
end


function UIPage:ClosePage()
    --//Debug.Log("Back&Close PageNodes Count:" + m_currentPageNodes.Count);
    local pageNodes = UIPage.static.m_currentPageNodes
    if pageNodes == nil or #pageNodes <= 0 then return;    end

    local closePage = pageNodes[#pageNodes];
    table.remove(pageNodes, #pageNodes)
    --//show older page.
    --//TODO:Sub pages.belong to root node.
    if #pageNodes > 0 then
        local page = pageNodes[#pageNodes];
        if page.isAsyncUI == ture then
            page:ShowPage(function()
            closePage:Hide();
            end);
        else
            page:ShowPage();
            --//after show to hide().
            closePage:Hide();
        end
    end
end

function UIPage:ClosePage(target)
    if target == nil then return end;
    local pageNodes = UIPage.static.m_currentPageNodes
    if target:isActive() == false then
        if pageNodes ~= nil then
            for i = 0, #pageNodes do
                if pageNodes[i] == target then
                    table.remove(pageNodes, i)
                    break;
                end
            end
        return;
        end
    end

    if pageNodes ~= nil and #pageNodes >= 1 and pageNodes[#pageNodes] == target then
        table.remove(pageNodes, #pageNodes)
        --//show older page.
        --//TODO:Sub pages.belong to root node.
        if #pageNodes > 0 then
            local page = pageNodes[#pageNodes];
            if page.isAsyncUI == true then
                page:ShowPage(function()
                    target:Hide();
                 end);
            else
                page:ShowPage();
                target:Hide();
            end
            return;
        end
    elseif target.CheckIfNeedBack() then
        for i = 0, #pageNodes do
            if pageNodes[i] == target then
                table.remove(pageNodes, i)
                target:Hide();
                break;
            end
        end
    end
    target:Hide();
end

function UIPage:ClosePage(pageName)
    if UIPage.static.m_allPages ~= nil and UIPage.static.m_allPages[pageName] then
        ClosePage(UIPage.static.m_allPages[pageName])
    else
        log("system",pageName , " havnt show yet!");
    end
end


































