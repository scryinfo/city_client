local transform
local gameObject

LoadingPanel = {}
local this = LoadingPanel

--启动事件--
function LoadingPanel.Awake(obj)
    gameObject = obj
    transform = obj.transform
    this.InitPanel()
end

--初始化面板--
function LoadingPanel.InitPanel()
    --按钮和滑动条
    this.rotateIconTrans = transform:Find("BackGround/rotateIcon").gameObject.transform
    this.content = transform:Find("BackGround/Text"):GetComponent("Text")

end