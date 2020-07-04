local transform
local gameObject

LoadingPanel = {}
local this = LoadingPanel

--Start event--
function LoadingPanel.Awake(obj)
    gameObject = obj
    transform = obj.transform
    this.InitPanel()
end

--Initialize the panel--
function LoadingPanel.InitPanel()
    --Buttons and sliders
    this.rotateIconTrans = transform:Find("BackGround/rotateIcon").gameObject.transform
    this.content = transform:Find("BackGround/Text"):GetComponent("Text")

end