---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/5/27 11:37
---
FlightSelectPlaceItem = class('FlightSelectPlaceItem')

--初始化方法
function FlightSelectPlaceItem:initialize(viewRect, data)
    self.viewRect = viewRect.transform

    self.btn = self.viewRect:Find("btn"):GetComponent("Button")
    self.Text = self.viewRect:Find("Text"):GetComponent("Text")

    self.btn.onClick:RemoveAllListeners()
    self.btn.onClick:AddListener(function ()
        Event.Brocast("FlightChoosePlaceEvent", data)
    end)

    self:initData(data)
end
--刷新数据
function FlightSelectPlaceItem:initData(data)
    self.Text.text = data.value
end
--
function FlightSelectPlaceItem:Close()

end
