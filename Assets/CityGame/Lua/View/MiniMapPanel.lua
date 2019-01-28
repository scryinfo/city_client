local transform
local gameObject

MiniMapPanel = {}
local this = MiniMapPanel



--启动事件--
function MiniMapPanel.Awake(obj)
    gameObject = obj
    transform = obj.transform

    this.InitPanel()
end

--初始化面板--
function MiniMapPanel.InitPanel()
    --按钮和滑动条
    this.bg_back = transform:Find("BackGround").gameObject
    this.btn_back = transform:Find("MapBG/Btn_Back").gameObject
    this.btn_enlarge = transform:Find("MapBG/Btn_Enlarge").gameObject
    this.btn_narrow = transform:Find("MapBG/Btn_Narrow").gameObject
    this.slider_Scale = transform:Find("MapBG/ScaleSlider").gameObject:GetComponent("Slider")
    --预制根节点
    this.root_home = transform:Find("MapBG/MapMask/MiniMapBg/HomeRoot").gameObject
    this.root_factory = transform:Find("MapBG/MapMask/MiniMapBg/FactoryRoot").gameObject
    this.root_material = transform:Find("MapBG/MapMask/MiniMapBg/MaterialRoot").gameObject
    this.root_supermarket = transform:Find("MapBG/MapMask/MiniMapBg/SupermarketRoot").gameObject
    this.root_system = transform:Find("MapBG/MapMask/MiniMapBg/SystemRoot").gameObject
    --预制
    this.prefab_HomeItem = transform:Find("MapBG/MapMask/HomeItem").gameObject
    this.prefab_FactoryItem = transform:Find("MapBG/MapMask/FactoryItem").gameObject
    this.prefab_MaterialItem = transform:Find("MapBG/MapMask/MaterialItem").gameObject
    this.prefab_SupermarketItem = transform:Find("MapBG/MapMask/SupermarketItem").gameObject
    this.prefab_CentralItem = transform:Find("MapBG/MapMask/CentralItem").gameObject
    --放大缩小用这个
    this.rect_MiniMapBg = transform:Find("MapBG/MapMask/MiniMapBg").gameObject:GetComponent("RectTransform")

end

--单击事件--
function MiniMapPanel.OnDestroy()

end

