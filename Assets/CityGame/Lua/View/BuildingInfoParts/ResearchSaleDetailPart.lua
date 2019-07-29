---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2019/7/24 16:01
---

ResearchSaleDetailPart = class("ResearchSaleDetailPart", BasePartDetail)

function ResearchSaleDetailPart.PrefabName()
    return "ResearchSaleDetailPart"
end

function ResearchSaleDetailPart:_InitTransform()

end

-- 初始化的时候，监听事件
function  ResearchSaleDetailPart:_InitEvent()
    -- 监听查询出售的内容（_getDatabaseInfo）
    -- 监听上架内容
    -- 监听下架内容
end

function ResearchSaleDetailPart:_InitClick(mainPanelLuaBehaviour)
    -- 给加号点击增加打开ResearchSaleChoiceCtrl的点击，把查询到的资料库的数据传进去
end

-- 销毁的时候，清除数据
function ResearchSaleDetailPart:_ResetTransform()
end

-- 销毁的时候，清除事件
function ResearchSaleDetailPart:_RemoveEvent()
    -- 移除监听查询出售的内容
    -- 移除监听上架内容
    -- 移除监听下架内容
end

function ResearchSaleDetailPart:RefreshData(data)
    -- 监听查询资料库的内容（_getDatabaseInfo）
    -- 如果是本人打开，则需要查询仓库的内容
    -- 向服务器发消息查询出售的内容
    -- 向服务器发消息查询当前资料库的内容
    -- 如果是别人打开，监听使用事件
end

-- 销毁的时候，清除点击事件
function ResearchSaleDetailPart:_RemoveClick()

end

function ResearchSaleDetailPart:_ChildHide()
    -- 移除监听查询资料库的内容
end

function ResearchSaleDetailPart:_getDatabaseInfo(data)
    -- 如果是自己打开，加号需要显示
    -- 如果是别人打开，加号不需要显示如果有正在出售的东西
    -- 如果有正在出售的东西，则生成 ResearchMaterialItem（useType = 2，代表 货架上别人可购买， 4 代表我自己看货架，可以进行调整和下架操作）
end