
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/1/16 21:12
---
BubbleMessageCtrl = class('BubbleMessageCtrl',UIPanel)
UIPanel:ResgisterOpen(BubbleMessageCtrl) --注册打开的方法

local path="Assets/CityGame/Resources/Atlas/UIBubble/"
local pool={}
local panel ,LuaBehaviour,isShow,this

BubbleMessageCtrl.configPath={
  [1]={path=path.."bubb-mua.png"},
  [2]={path=path.."bubb-rejoice.png"},
  [3]={path=path.."bubb-angry.png"},
  [4]={path=path.."bubb-rawdeal.png"},
  [5]={path=path.."bubb-commodity.png"},
}

local m_EmojiIconSpriteList = {}

--添加EmojiIcon的sprite列表
local function AddEmojiIcon(name,sprite)
    if m_EmojiIconSpriteList == nil or type(m_EmojiIconSpriteList) ~= 'table' then
        m_EmojiIconSpriteList = {}
    end
    if name ~= nil and sprite ~= nil then
        m_EmojiIconSpriteList[name] = sprite
    end
end

local function JudgeHasEmojiIcon(name)
    if m_EmojiIconSpriteList == nil or m_EmojiIconSpriteList[name] == nil  then
        return false
    else
        return true
    end
end

local function GetEmojiIcon(name)
    if m_EmojiIconSpriteList == nil or m_EmojiIconSpriteList[name] == nil  then
        return nil
    else
        return m_EmojiIconSpriteList[name]
    end
end

local SpriteType = nil
local function LoadEmojiIcon(name,iIcon)
    if SpriteType == nil then
        SpriteType = ct.getType(UnityEngine.Sprite)
    end
    panelMgr:LoadPrefab_A(name, SpriteType, iIcon, function(Icon, obj )
        if Icon == nil then
            return
        end
        if obj ~= nil  then
            local texture = ct.InstantiatePrefab(obj)
            AddEmojiIcon(name,texture)
            if Icon then
                Icon.sprite = texture
            end
        end
    end)
end

--设置ICon的Sprite
function BubbleMessageCtrl.SetEmojiIconSpite(name , tempImage)
    if JudgeHasEmojiIcon() == true then
        tempImage.sprite = GetEmojiIcon(name)
    else
        LoadEmojiIcon(name , tempImage)
    end
end



---==========================================================================================私有函数============================================================================================
--临时对象池是做法
local  function InsAndObjectPool(config,class,prefabPath,parent,this)
    if not pool[class] then
        pool[class]={}
    end
    --对象池创建物体
    local tempList={}
    for i, value in ipairs(config) do
        local ins =pool[class][1]
        if ins then  --有实例
            value.id=i
            ins:updateData(value)
            ins.prefab:SetActive(true)
            table.insert(tempList,ins)
            table.remove(pool[class],1)
        else--无实例
            local prefab=creatGoods(prefabPath,parent)
            value.id=i
            local ins=class:new(prefab,LuaBehaviour,value,this)
            table.insert(tempList,ins)
        end
    end
    --多余实例隐藏
    if #pool[class]>0 then
        for key, ins in ipairs(pool[class]) do
            ins.prefab:SetActive(false)
            table.insert(tempList,ins)
            pool[class][key]=nil
        end
    end
    --所有实例归还对象池
    for i, ins in ipairs(tempList) do
        table.insert(pool[class],ins)
    end
end

---==========================================================================================框架函数============================================================================================
function  BubbleMessageCtrl:bundleName()
    return "Assets/CityGame/Resources/View/BubbleMessagePanel.prefab"
end

function BubbleMessageCtrl:initialize()
    UIPanel.initialize(self,UIType.PopUp,UIMode.DoNothing,UICollider.None)--可以回退，UI打开后，隐藏其它面板
end

function BubbleMessageCtrl:Refresh()
    panel.inputFrame.text = ""
    DataManager.OpenDetailModel(BubbleMessageModel,OpenModelInsID.BubbleMessageCtrl)
    InsAndObjectPool(BubbleMessageCtrl.configPath,SmallBubbleItem,"View/BubbleItems/samllBubble",panel.scrollParent,self)
end

function  BubbleMessageCtrl:Awake(go)
    isShow=true
    self.gameObject = go
    this=self
    panel=BubbleMessagePanel
    LuaBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    LuaBehaviour:AddClick(panel.closeBtn.gameObject,self.c_OnClick_backBtn,self);
    LuaBehaviour:AddClick(panel.confirmBtn.gameObject,self.c_OnClick_confirm,self);
    LuaBehaviour:AddClick(panel.isShow.gameObject,self.c_OnClick_isShow,self);


end

---==========================================================================================业务代码===================================================================================================

function BubbleMessageCtrl:begin()

end

---==========================================================================================点击函数===================================================================================================
--返回
function BubbleMessageCtrl:c_OnClick_backBtn(ins)
    UIPanel.ClosePage()
end

--确定
function BubbleMessageCtrl:c_OnClick_confirm(ins)
    local des = panel.inputFrame.text
    if panel.inputFrame.text == "" then
        des=" "
    end
    Event.Brocast("m_setBuildingInfo",ins.m_data,des,ins.bubbleId,isShow)
    Event.Brocast("c_BuildingTopChangeData", {des = des, emoticon = ins.bubbleId})
    UIPanel.ClosePage()
end

--是否展示气泡
function BubbleMessageCtrl:c_OnClick_isShow(ins)
    if panel.yesIcon.localScale.x==1  then
        panel.yesIcon.localScale=Vector3.zero
        isShow=false
    else
        panel.yesIcon.localScale=Vector3.one
        isShow=true
    end
end



