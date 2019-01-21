---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/21/021 18:07
---

DetailGuidCtrl = class('DetailGuidCtrl',UIPage)
UIPage:ResgisterOpen(DetailGuidCtrl) --注册打开的方法

local luaBehaviour;
local panel;

DetailGuidCtrl.btnItem_Path="View/GoodsItem/buildBtn"
DetailGuidCtrl.detailItem_Path="View/GoodsItem/detailItem"
DetailGuidCtrl.detailItem1_Path="View/GoodsItem/detailItem1"

function DetailGuidCtrl:initialize()
    UIPage.initialize(self,UIType.Normal,UIMode.HideOther,UICollider.None)--可以回退，UI打开后，隐藏其它面板
end

function  DetailGuidCtrl:bundleName()
    return "Assets/CityGame/Resources/View/DetailGuidPanel.prefab"
end

--启动事件--
function DetailGuidCtrl:OnCreate(obj)
    UIPage.OnCreate(self,obj)
end

function DetailGuidCtrl:Awake(obj)
    panel = DetailGuidPanel;
    self.btnInsList={}
    self.detailInsList={}
    self.detail1InsList={}
    luaBehaviour = obj:GetComponent('LuaBehaviour');
    luaBehaviour:AddClick(panel.backBtn.gameObject,self.onClick_Close,self);
    luaBehaviour:AddClick(panel.detailBtn.gameObject,self.detailBtn,self);
    luaBehaviour:AddClick(obj,function ()  panel.scroll.localScale=Vector3.zero   end,self);
end



function DetailGuidCtrl:Refresh()
    local data=self.m_data
    ---刷新Item
    self:updateItem(data.name)
---******************************************************--
    DetailGuidPanel.detailIma.localScale=Vector3.one
    DetailGuidPanel.scroll.localScale=Vector3.zero
end

function DetailGuidCtrl:detailBtn()
    panel.scroll.localScale=Vector3.one
    panel.detailIma.localScale=Vector3.zero
    PlayMusEff(1002)
end

function DetailGuidCtrl:onClick_Close(ins)
    ins:Hide()
end

---刷新按钮
function DetailGuidCtrl:updateItem(names)
        for i, v in pairs(GuidBookConfig) do
            if i==names then
                local temp= GuidBookConfig[names]
                local tempList={}
                --刷新按钮
                for btnname, arr in pairs(temp) do
                    if self.btnInsList[1]then--有实例
                        self.btnInsList[1]:updateData(names,btnname)
                        self.btnInsList[1].prefab:SetActive(true)
                        table.insert(tempList,self.btnInsList[1])
                        table.remove(self.btnInsList,1)
                    else--无实例
                        local prefab =creatGoods(DetailGuidCtrl.btnItem_Path,panel.btnCon)
                        local ins=BuidBtnItem:new(prefab,luaBehaviour,self)
                        ins:updateData(names,btnname)
                        table.insert(tempList,ins)
                    end
                end
                ---还原
              --  if #self.btnInsList>0 then
                    for key, ins in pairs(self.btnInsList) do
                        ins.prefab:SetActive(false)
                        table.insert(tempList,ins)
                        self.btnInsList[key]=nil
                        --table.remove(self.btnInsList,1)
                    end
               -- end
               -- self.btnInsList={}
                for i, ins in pairs(tempList) do
                    table.insert(self.btnInsList,ins)
                end

            end
        end
    ---*************************************************
    local default=nil
    for i, v in pairs(GuidBookConfig[names]) do
        default=i
        break
    end
      self:updateIntroduce(names,default)
end

---刷新介绍
function DetailGuidCtrl:updateIntroduce(topicName,mainName)
    local temp= GuidBookConfig[topicName]
    local num=1
    local tempList={}
    local tempList1={}
    for name, content in pairs(temp) do

        if mainName then--选择
            if name==mainName then
                panel.detailText.text=mainName
                for key,string in pairs(content) do
                    if num%2==1 then

                        if self.detailInsList[1] then
                            self.detailInsList[1]:updateData(key,string)
                            self.detailInsList[1].prefab:SetActive(true)
                            table.insert(tempList,self.detailInsList[1])
                            table.remove(self.detailInsList,1)
                        else
                            local prefab =creatGoods(DetailGuidCtrl.detailItem_Path,panel.showCon)
                            local ins=DetailItem:new(prefab)
                            ins:updateData(key,string)
                            table.insert(tempList,ins)
                        end

                    else
                        if self.detail1InsList[1] then
                            self.detail1InsList[1]:updateData(key,string)
                            self.detail1InsList[1].prefab:SetActive(true)
                            table.insert(tempList1,self.detail1InsList[1])
                            table.remove(self.detail1InsList,1)
                        else
                            local prefab =creatGoods(DetailGuidCtrl.detailItem1_Path,panel.showCon)
                            local ins=DetailItem1:new(prefab)
                            prefab.name=num*3
                            ins:updateData(key,string)
                            table.insert(tempList1,ins)
                        end
                    end
                    num=num+1
                end
                ---还原
                --if #self.detailInsList>0 then
                    for i, ins in pairs(self.detailInsList) do
                        ins.prefab:SetActive(false)
                        table.insert(tempList,ins)
                        self.detailInsList[i]=nil
                     -- table.remove(self.detailInsList,1)
                    end
               -- end
              --  if #self.detail1InsList>0 then
                    for i, ins in pairs(self.detail1InsList) do
                        ins.prefab:SetActive(false)
                        table.insert(tempList1,ins)
                        self.detail1InsList[i]=nil
                       --table.remove(self.detail1InsList,1)
                    end
               -- end

              --  self.detailInsList={}
                --self.detail1InsList={}
                for i, ins in pairs(tempList) do
                    table.insert(self.detailInsList,ins)
                end

                for i, ins in pairs(tempList1) do
                    table.insert(self.detail1InsList,ins)
                end

                return
            end
        end
    end
end



function  DetailGuidCtrl:Hide()
    UIPanel.Hide(self)
end

function DetailGuidCtrl:Close()
    UIPanel.Close(self)
end

