ConstructItem = class('ConstructItem')

function ConstructItem:initialize(data, viewRect, mainPanelLuaBehaviour)
    self.viewRect = viewRect;
    self.data = data;

    local viewTrans = self.viewRect;
    self.nameText = viewTrans:Find("name/nameText"):GetComponent("Text");
    self.iconImg = viewTrans:Find("name/iconBg/Image"):GetComponent("Image");
    self:_initData()

    self.collectBtn.onClick:RemoveAllListeners();
    self.collectBtn.onClick:AddListener(function ()
        self:_clickCollectBtn()
    end)
end

--初始化界面
function ConstructItem:_initData()
    local data = self.data

end

--点击Item中1*1建筑按钮
function ConstructItem:_clickConstructBtn1()

end
--点击Item中2*2建筑按钮
function ConstructItem:_clickConstructBtn2()

end
--点击Item中3*3建筑按钮
function ConstructItem:_clickConstructBtn3()

end

