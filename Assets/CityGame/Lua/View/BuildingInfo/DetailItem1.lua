---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2018/12/22/022 14:45
---


DetailItem1 = class('DetailItem1')
---初始化方法   数据（读配置表）
function DetailItem1:initialize(prefab)
    self.prefab=prefab
    self.topicText=prefab.transform:Find("detailItem/top/topic/Text"):GetComponent("Text");
    self.contentText=prefab.transform:Find("detailItem/Text"):GetComponent("Text");
    self.ima=prefab.transform:Find("detailItem/body/Image"):GetComponent("Image");

end
---添加
function DetailItem1:updateData(topic,content,ima)
    self.topicText.text="   "..topic
    self.contentText.text=content
    --self.ima.sprite=ima
end
