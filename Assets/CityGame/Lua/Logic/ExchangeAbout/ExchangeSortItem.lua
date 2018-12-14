---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2018/10/16 10:14
---交易所排序toggle item
ExchangeSortItem = class('ExchangeSortItem')

--初始化方法
function ExchangeSortItem:initialize(transform)
    self.transform = transform;

    local viewTrans = self.transform;
    self.upRoot = viewTrans:Find("up");
    self.upGray = viewTrans:Find("up/gray");
    self.upRed = viewTrans:Find("up/red");
    self.downRoot = viewTrans:Find("down");
    self.downGray = viewTrans:Find("down/gray");
    self.downRed = viewTrans:Find("down/red");
    self:CommonShow()
end
---默认排序时的显示
function ExchangeSortItem:CommonShow()
    self.upRoot.localScale = Vector3.one
    self.downRoot.localScale = Vector3.one

    self.upRed.localScale = Vector3.zero
    self.downRed.localScale = Vector3.zero
end
---由小到大，上面的icon显示
function ExchangeSortItem:SmallerShow()
    self.upRoot.localScale = Vector3.one
    self.upRed.localScale = Vector3.one
    self.downRoot.localScale = Vector3.zero
end
---由大到小
function ExchangeSortItem:BiggerShow()
    self.upRoot.localScale = Vector3.zero
    self.downRed.localScale = Vector3.one
    self.downRoot.localScale = Vector3.one
end