---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by xuyafang.
--- DateTime: 2019/1/16 21:12
---
local transform
BubbleMessagePanel = {}
local this = BubbleMessagePanel

function BubbleMessagePanel.Awake(obj)
    transform = obj.transform
    this.InitPanel()
end

function BubbleMessagePanel.InitPanel()
    this.closeBtn = transform:Find("PopCommpent/closeBtn")
    this.cantconfirmBtn = transform:Find("PopCommpent/cantconfimBtn")
    this.confirmBtn = transform:Find("PopCommpent/confimBtn")
    this.hideBtn = transform:Find("PopCommpent/hideBtn")
    this.hideText = transform:Find("PopCommpent/hideBtn/Text"):GetComponent("Text")
    this.titleText = transform:Find("PopCommpent/titleText"):GetComponent("Text")

    this.scrollParent = transform:Find("PopCommpent/root/Scroll View/Viewport/Content")
    this.inputFrame = transform:Find("PopCommpent/root/enter/InputField"):GetComponent("InputField")
    this.inputFramePlaceholder = transform:Find("PopCommpent/root/enter/InputField/Placeholder"):GetComponent("Text")
    this.title = transform:Find("PopCommpent/root/title"):GetComponent("Text")

    this.emojiTitle = transform:Find("PopCommpent/root/emojiTitle"):GetComponent("Text")
end

function BubbleMessagePanel.InitLanguage()
    this.emojiTitle.text = GetLanguage(29010001) --选择标签
    this.titleText.text = GetLanguage(29010002) --panel的标题
    this.title.text = GetLanguage(29010001) --选择气泡的标题
    this.hideText.text = GetLanguage(29010011) --隐藏按钮
    this.inputFramePlaceholder.text = GetLanguage(29010008) --默认输入内容
end
