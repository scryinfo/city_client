---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/11/28 16:05
---

FriendsMgr = class('FriendsMgr')
FriendsMgr.static.Notice_PATH = "View/Friends/FriendsItem";

function FriendsMgr:initialize()
    ct.log("tina_w15_friends", "FriendsMgr:initialize")
    self:initData()
end

--初始化数据
function FriendsMgr:initData()
    --分别存储好友主页面Item,群组主界面Item,好友管理Item,黑名单Item,好友申请Item，添加好友Item的路径，实例，父对象，加载的资源
    self.allItems =
    {
        { path = "View/Friends/FriendsItem", items = {}, parent = FriendsPanel.friendsContent, prefab = nil},
        { path = "View/Friends/GroupItem", items = {}, parent = FriendsPanel.groupContent, prefab = nil},
        { path = "View/Friends/FriendsItem", items = {}, parent = nil, prefab = nil},
        { path = "View/Friends/FriendsItem", items = {}, parent = nil, prefab = nil},
        { path = "View/Friends/FriendsItem", items = {}, parent = nil, prefab = nil},
        { path = "View/Friends/FriendsItem", items = {}, parent = nil, prefab = nil},
        { path = "View/Friends/GroupItem", items = {}, parent = nil, prefab = nil}
    }
    self:_loadPrefab()
end

-- 根据初始化数据加载资源，并保存，留待后面使用
function FriendsMgr:_loadPrefab()
    for k, v in pairs(self.allItems) do
        v.prefab = UnityEngine.Resources.Load(v.path)
    end
    ct.log("tina_w15_friends","1111")
end

function FriendsMgr:_createFriendsAndGroupItems(luaBehaviour,data)
    self.luaBehaviour = luaBehaviour
    self.data = data
    --for k, v in ipairs(data) do
    --    for i, j in ipairs(v.data) do
    --        local item = self:_createItem(k, j)
    --        table.insert(self.allItems[k].items, item)
    --    end
    --end
end

function FriendsMgr:_createListItems(type)
    self.allItems[type].parent = FriendslistPanel.listContent
    if type == self.panelType then

    else
        if self.panelType then
            for _, v in pairs(self.allItems[self.panelType].items) do
                GameObject.Destroy(v.prefab)
            end

            self.allItems[self.panelType].items = {}
        end

        local userdata
        if type == 2 or type == 7 then
            userdata = self.data[2].data
        elseif type == 1 or type == 3 or type == 4 or type == 5 or type == 6 then
            userdata = self.data[1].data
        end

        for _, j in ipairs(userdata) do
            local item = self:_createItem(type, j)
            table.insert(self.allItems[type].items, item)
        end

        self.panelType = type
    end
end

-- itemTypeIndex 创建item的类型参见self.allItems
function FriendsMgr:_createItem(itemTypeIndex, data)
    local go = UnityEngine.GameObject.Instantiate(self.allItems[itemTypeIndex].prefab)
    go.transform:SetParent(self.allItems[itemTypeIndex].parent)
    go.transform.localScale = Vector3.one
    local luaItem
    if itemTypeIndex == 1 then
        luaItem = FriendsItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    elseif  itemTypeIndex == 2 then
        luaItem = GroupItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    elseif  itemTypeIndex == 3 then
        luaItem = FriendsItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    elseif  itemTypeIndex == 4 then
        luaItem = FriendsItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    elseif  itemTypeIndex == 5 then
        luaItem = FriendsItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    elseif  itemTypeIndex == 6 then
        luaItem = FriendsItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    elseif  itemTypeIndex == 7 then
        luaItem = GroupItem:new(itemTypeIndex, self.luaBehaviour, go, data)
    end
    return luaItem
end

function FriendsMgr:_setFriendsItemBtnState()
    for _, v in ipairs(self.allItems[1].items) do
        v:_setBtnState()
    end
end

function FriendsMgr:_setGroupItemBtnState()
    for _, v in ipairs(self.allItems[2].items) do
        v:_setBtnState()
    end
end