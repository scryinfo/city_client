---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/10/23/023 11:29
---

require "Common/define"

require('Framework/UI/UIPage')

require'View/BuildingInfo/SmallPopItem'--小弹窗脚本


local class = require 'Framework/class'
ScienceSellHallCtrl = class('ScienceSellHallCtrl',UIPage)
UIPage:ResgisterOpen(ScienceSellHallCtrl) --注册打开的方法


ScienceSellHallCtrl.SmallPop_Path="View/GoodsItem/TipsParticle"--小弹窗路径

--构建函数
function ScienceSellHallCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None);
    self.prefab = nil
end

function ScienceSellHallCtrl:bundleName()
    return "ScienceSellHallPanel";
end

function ScienceSellHallCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
end
local materialBehaviour
local panel

local top
local down
local redtop
local reddown
function ScienceSellHallCtrl:Awake(go)
    self.gameObject = go;
    panel=ScienceSellHallPanel
    materialBehaviour = self.gameObject:GetComponent('LuaBehaviour');
    materialBehaviour:AddClick(panel.backBtn.gameObject,self.OnClick_backBtn,self);
    materialBehaviour:AddClick(panel.searchBtn.gameObject,self.OnClick_search,self);
    materialBehaviour:AddClick(panel.goodsBtn.gameObject,self.OnClick_goods,self);
    materialBehaviour:AddClick(panel.materialBtn.gameObject,self.OnClick_material,self);

    ---kind sort
    materialBehaviour:AddClick(panel.kindtop.gameObject,self.OnClick_kindsort,self)
    materialBehaviour:AddClick(panel.kinddown.gameObject,self.OnClick_kindsort,self)
    materialBehaviour:AddClick(panel.kindredtop.gameObject,self.OnClick_kindredtop,self)
    materialBehaviour:AddClick(panel.kindreddown.gameObject,self.OnClick_kindreddown,self)
    ---class sort
    materialBehaviour:AddClick(panel.classtop.gameObject,self.OnClick_classsort,self)
    materialBehaviour:AddClick(panel.classdown.gameObject,self.OnClick_classsort,self)
    materialBehaviour:AddClick(panel.classredtop.gameObject,self.OnClick_classredtop,self)
    materialBehaviour:AddClick(panel.classreddown.gameObject,self.OnClick_classreddown,self)
    ---owner sort
    materialBehaviour:AddClick(panel.ownertop.gameObject,self.OnClick_ownersort,self)
    materialBehaviour:AddClick(panel.ownerdown.gameObject,self.OnClick_ownersort,self)
    materialBehaviour:AddClick(panel.ownerredtop.gameObject,self.OnClick_ownerredtop,self)
    materialBehaviour:AddClick(panel.ownerreddown.gameObject,self.OnClick_ownerreddown,self)
    ---level sort
    materialBehaviour:AddClick(panel.leveltop.gameObject,self.OnClick_levelsort,self)
    materialBehaviour:AddClick(panel.leveldown.gameObject,self.OnClick_levelsort,self)
    materialBehaviour:AddClick(panel.levelredtop.gameObject,self.OnClick_levelredtop,self)
    materialBehaviour:AddClick(panel.levelreddown.gameObject,self.OnClick_levelreddown,self)
    ---mylevel sort
    materialBehaviour:AddClick(panel.myleveltop.gameObject,self.OnClick_mylevelsort,self)
    materialBehaviour:AddClick(panel.myleveldown.gameObject,self.OnClick_mylevelsort,self)
    materialBehaviour:AddClick(panel.mylevelredtop.gameObject,self.OnClick_mylevelredtop,self)
    materialBehaviour:AddClick(panel.mylevelreddown.gameObject,self.OnClick_mylevelreddown,self)
    ---score sort
    materialBehaviour:AddClick(panel.scoretop.gameObject,self.OnClick_scorelsort,self)
    materialBehaviour:AddClick(panel.scoredown.gameObject,self.OnClick_scorelsort,self)
    materialBehaviour:AddClick(panel.scoreredtop.gameObject,self.OnClick_scoreredtop,self)
    materialBehaviour:AddClick(panel.scorereddown.gameObject,self.OnClick_scorereddown,self)



    ---小弹窗
    self.root=ScienceSellHallPanel.backBtn.root;
    Event.AddListener("SmallPop",self.c_SmallPop,self)
end
--------------------------------------------------------------------------------------------score sort
---red mylevel down sort
function ScienceSellHallCtrl:OnClick_scorereddown()
    panel.scoreredtop.gameObject:SetActive(true)
    self:SetActive(false)
end

---red mylevel top  sort
function ScienceSellHallCtrl:OnClick_scoreredtop()
    panel.scorereddown.gameObject:SetActive(true)
    self:SetActive(false)
end

---grey score sort
function ScienceSellHallCtrl:OnClick_scorelsort()
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end
    top=panel.scoretop.gameObject
    down=panel.scoredown.gameObject
    reddown= panel.scorereddown.gameObject
    redtop=panel.scoreredtop.gameObject
    ---grey set false ,red down set true
    panel.scoretop.gameObject:SetActive(false)
    panel.scoredown.gameObject:SetActive(false)
    panel.scorereddown.gameObject:SetActive(true)
end

--------------------------------------------------------------------------------------------mylevel sort

---red mylevel down sort
function ScienceSellHallCtrl:OnClick_mylevelreddown()
    panel.mylevelredtop.gameObject:SetActive(true)
    self:SetActive(false)
end

---red mylevel top  sort
function ScienceSellHallCtrl:OnClick_mylevelredtop()
    panel.mylevelreddown.gameObject:SetActive(true)
    self:SetActive(false)
end

---exchange

---grey mylevel sort
function ScienceSellHallCtrl:OnClick_mylevelsort()
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end
    top=panel.myleveltop.gameObject
    down=panel.myleveldown.gameObject
    reddown= panel.mylevelreddown.gameObject
    redtop=panel.mylevelredtop.gameObject
    ---grey set false ,red down set true
    panel.myleveltop.gameObject:SetActive(false)
    panel.myleveldown.gameObject:SetActive(false)
    panel.mylevelreddown.gameObject:SetActive(true)
end
--------------------------------------------------------------------------------------------level sort
---red level down sort
function ScienceSellHallCtrl:OnClick_levelreddown()
    panel.levelredtop.gameObject:SetActive(true)
    self:SetActive(false)
end

---red level top  sort
function ScienceSellHallCtrl:OnClick_levelredtop()
    panel.levelreddown.gameObject:SetActive(true)
    self:SetActive(false)
end

---grey level sort
function ScienceSellHallCtrl:OnClick_levelsort()
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.leveltop.gameObject
    down=panel.leveldown.gameObject
    reddown= panel.levelreddown.gameObject
    redtop=panel.levelredtop.gameObject
    ---grey set false ,red down set true
    panel.leveltop.gameObject:SetActive(false)
    panel.leveldown.gameObject:SetActive(false)
    panel.levelreddown.gameObject:SetActive(true)
end
--------------------------------------------------------------------------------------------owner sort

---red owner down sort
function ScienceSellHallCtrl:OnClick_ownerreddown()
    panel.ownerredtop.gameObject:SetActive(true)
    self:SetActive(false)
end

---red owner top  sort
function ScienceSellHallCtrl:OnClick_ownerredtop()
    panel.ownerreddown.gameObject:SetActive(true)
    self:SetActive(false)
end


---grey owner sort
function ScienceSellHallCtrl:OnClick_ownersort()
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.ownertop.gameObject
    down=panel.ownerdown.gameObject
    reddown= panel.ownerreddown.gameObject
    redtop=panel.ownerredtop.gameObject
    ---grey set false ,red down set true
    panel.ownertop.gameObject:SetActive(false)
    panel.ownerdown.gameObject:SetActive(false)
    panel.ownerreddown.gameObject:SetActive(true)
end

--------------------------------------------------------------------------------------------class sort
---red class down sort
function ScienceSellHallCtrl:OnClick_classreddown()
    panel.classredtop.gameObject:SetActive(true)
    self:SetActive(false)
end

---red class top  sort
function ScienceSellHallCtrl:OnClick_classredtop()
    panel.classreddown.gameObject:SetActive(true)
    self:SetActive(false)
end

---grey class sort
function ScienceSellHallCtrl:OnClick_classsort()
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.classtop.gameObject
    down=panel.classdown.gameObject
    reddown= panel.classreddown.gameObject
    redtop=panel.classredtop.gameObject
    ---grey set false ,red down set true
    panel.classtop.gameObject:SetActive(false)
    panel.classdown.gameObject:SetActive(false)
    panel.classreddown.gameObject:SetActive(true)
end
--------------------------------------------------------------------------------------------- kind  sort
---red kind down sort
function ScienceSellHallCtrl:OnClick_kindreddown()
    panel.kindredtop.gameObject:SetActive(true)
    self:SetActive(false)
end

---red kind top  sort
function ScienceSellHallCtrl:OnClick_kindredtop()
       panel.kindreddown.gameObject:SetActive(true)
       self:SetActive(false)
end

---grey kind sort
function ScienceSellHallCtrl:OnClick_kindsort()
    ---exchange
    if top then
        top:SetActive(true)
        down:SetActive(true)
        redtop:SetActive(false)
        reddown:SetActive(false)
    end

    top=panel.kindtop.gameObject
    down=panel.kinddown.gameObject
    reddown= panel.kindreddown.gameObject
    redtop=panel.kindredtop.gameObject
   ---grey set false ,red down set true
    panel.kindtop.gameObject:SetActive(false)
    panel.kinddown.gameObject:SetActive(false)
    panel.kindreddown.gameObject:SetActive(true)
end
---------------------------------------------------------------------------------------------
---material
function ScienceSellHallCtrl:OnClick_material()
    ---btn
    panel.goodsBtn.gameObject:SetActive(true)
    panel.goodsBtngtey.gameObject:SetActive(false)
    panel.materialBtngrey.gameObject:SetActive(true)
    panel.materialBtn.gameObject:SetActive(false)
    ---scroll gameObject
    panel.goodsScroll.gameObject:SetActive(false)
    panel.materialScroll.gameObject:SetActive(true)
end

---goods
function ScienceSellHallCtrl:OnClick_goods()
    ---btn
    panel.goodsBtn.gameObject:SetActive(false)
    panel.goodsBtngtey.gameObject:SetActive(true)
    panel.materialBtngrey.gameObject:SetActive(false)
    panel.materialBtn.gameObject:SetActive(true)
    ---scroll gameObject
    panel.goodsScroll.gameObject:SetActive(true)
    panel.materialScroll.gameObject:SetActive(false)
end

------------------------------------------------------------------------------------------------

--返回
function ScienceSellHallCtrl:OnClick_backBtn()
    UIPage.ClosePage();

end

--打开信息界面
function ScienceSellHallCtrl:OnClick_search()

end
--刷新
function ScienceSellHallCtrl:Refresh()


end

---生成预制
function ScienceSellHallCtrl:c_creatGoods(path,parent)
    local prefab = UnityEngine.Resources.Load(path);
    local go = UnityEngine.GameObject.Instantiate(prefab);
    local rect = go.transform:GetComponent("RectTransform");
    go.transform:SetParent(parent);--.transform
    rect.transform.localScale = Vector3.one;
    rect.transform.localPosition=Vector3.zero
    return go
end
---小弹窗
function ScienceSellHallCtrl:c_SmallPop(string)
    if not self.prefab  then
        self.prefab =self:c_creatGoods(self.SmallPop_Path,self.root)
    end
    SmallPopItem:new(string,self.prefab ,self);
end



