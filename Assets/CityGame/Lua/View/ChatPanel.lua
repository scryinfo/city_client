---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Tina.
--- DateTime: 2018/12/14 10:05
---
local transform

ChatPanel = {}
local this = ChatPanel

function ChatPanel.Awake(obj)
    ct.log("tina_w9_friends", "ChatPanel.Awake")
    transform = obj.transform
    this.InitPanel()
end

function ChatPanel.InitPanel()
    ct.log("tina_w9_friends", "ChatPanel.InitPanel")
    this.backBtn = transform:Find("BackBtn").gameObject

    -- 玩家信息节点管理
    --this.backChatBtn = transform:Find("BackChatBtn").gameObject
    this.playerInfoRoot = transform:Find("PlayerInfoRoot").gameObject

    -- 世界分页
    this.worldToggle = transform:Find("LeftRoot/TopRoot/WorldToggle"):GetComponent("Toggle")
    this.worldOpen = transform:Find("LeftRoot/TopRoot/WorldToggle/Open").gameObject
    this.worldClose = transform:Find("LeftRoot/TopRoot/WorldToggle/Close").gameObject
    this.worldOpenText = transform:Find("LeftRoot/TopRoot/WorldToggle/Open/Text"):GetComponent("Text")
    this.worldCloseText = transform:Find("LeftRoot/TopRoot/WorldToggle/Close/Text"):GetComponent("Text")

    -- 好友分页
    this.friendsToggle = transform:Find("LeftRoot/TopRoot/FriendsToggle"):GetComponent("Toggle")
    this.friendsOpen = transform:Find("LeftRoot/TopRoot/FriendsToggle/Open").gameObject
    this.friendsClose = transform:Find("LeftRoot/TopRoot/FriendsToggle/Close").gameObject
    this.friendsOpenText = transform:Find("LeftRoot/TopRoot/FriendsToggle/Open/Text"):GetComponent("Text")
    this.friendsCloseText = transform:Find("LeftRoot/TopRoot/FriendsToggle/Close/Text"):GetComponent("Text")

    -- 陌生人分页
    this.strangersToggle = transform:Find("LeftRoot/TopRoot/StrangersToggle"):GetComponent("Toggle")
    this.strangersOpen  = transform:Find("LeftRoot/TopRoot/StrangersToggle/Open").gameObject
    this.strangersClose  = transform:Find("LeftRoot/TopRoot/StrangersToggle/Close").gameObject
    this.strangersOpenText  = transform:Find("LeftRoot/TopRoot/StrangersToggle/Open/Text"):GetComponent("Text")
    this.strangersCloseText  = transform:Find("LeftRoot/TopRoot/StrangersToggle/Close/Text"):GetComponent("Text")

    -- 好友、陌生人红点
    this.friendsNoticeImage = transform:Find("LeftRoot/TopRoot/FriendsToggle/NoticeImage").gameObject
    this.strangersNoticeImage = transform:Find("LeftRoot/TopRoot/StrangersToggle/NoticeImage").gameObject

    -- 显示节点
    this.worldRoot = transform:Find("LeftRoot/MiddleRoot/WorldRoot").gameObject
    this.friendsRoot = transform:Find("LeftRoot/MiddleRoot/FriendsRoot").gameObject
    this.strangersRoot = transform:Find("LeftRoot/MiddleRoot/StrangersRoot").gameObject
    this.expressionRoot = transform:Find("LeftRoot/ExpressionRoot").gameObject

    -- 表情显示、按钮、返回
    this.expressionContent = transform:Find("LeftRoot/ExpressionRoot/Scroll View/Content")
    this.expressionBtn = transform:Find("LeftRoot/BottomRoot/ExpressionBtn").gameObject
    this.backExpressionBtn = transform:Find("LeftRoot/ExpressionRoot/BackExpressionBtn").gameObject

    -- 好友列表节点、个数
    this.friendsPlayerContent = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/LeftRoot/Scroll View/Viewport/Content")
    this.friendsNum = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/LeftRoot/FriendsNum"):GetComponent("Text")

    -- 世界聊天节点、滑动条
    this.worldContent = transform:Find("LeftRoot/MiddleRoot/WorldRoot/Scroll View/Viewport/Content")
    this.worldVerticalScrollbar = transform:Find("LeftRoot/MiddleRoot/WorldRoot/Scroll View/VerticalScrollbar"):GetComponent("Scrollbar")

    -- 好友聊天节点、滑动条、查看聊天记录
    this.friendsScrollView = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRoot/Scroll View"):GetComponent("ScrollRect")
    this.friendsContent = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRoot/Scroll View/Viewport/Content")
    this.friendsVerticalScrollbar = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRoot/Scroll View/VerticalScrollbar"):GetComponent("Scrollbar")
    this.chatRecordsBtn = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRoot/ChatRecordsBtn").gameObject

    -- 输入、发送消息
    this.chatInputField = transform:Find("LeftRoot/BottomRoot/InputField"):GetComponent("InputField")
    this.sendBtn = transform:Find("LeftRoot/BottomRoot/SendBtn").gameObject

    -- 玩家信息显示及操作
    this.nameText = transform:Find("PlayerInfoRoot/NameText"):GetComponent("Text")
    this.companyText = transform:Find("PlayerInfoRoot/ShowCompanyBtn/CompanyText"):GetComponent("Text")
    this.shieldBtn = transform:Find("PlayerInfoRoot/ShieldBtn").gameObject
    this.addFriendsBtn = transform:Find("PlayerInfoRoot/AddFriendsBtn").gameObject
    this.chatBtn = transform:Find("PlayerInfoRoot/ChatBtn").gameObject

    -- 陌生人列表节点、个数
    this.strangersPlayerContent = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/LeftRoot/Scroll View/Viewport/Content")
    this.strangersPlayerNum = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/LeftRoot/StrangersNum"):GetComponent("Text")

    -- 陌生人聊天节点、滑动条
    this.strangersScrollView = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/ChatRoot/Scroll View"):GetComponent("ScrollRect")
    this.strangersContent = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/ChatRoot/Scroll View/Viewport/Content")
    this.strangersVerticalScrollbar = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/ChatRoot/Scroll View/VerticalScrollbar"):GetComponent("Scrollbar")

    -- 玩家个人信息和公司信息显示按钮
    this.showPersonalInfoBtn = transform:Find("PlayerInfoRoot/ShowPersonalInfoBtn").gameObject
    this.showCompanyBtn = transform:Find("PlayerInfoRoot/ShowCompanyBtn").gameObject

    -- 聊天记录
    this.chatRecordsRoot = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot").gameObject
    this.deleteChatRecordsBtn = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/DeleteBtn").gameObject
    this.chatRecordsContent = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/Scroll View/Viewport/Content")
    this.pageText = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/PageText"):GetComponent("Text")
    this.prevBtn = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/PrevBtn").gameObject
    this.prevClose = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/PrevBtn/CloseImage").gameObject
    this.prevOpen = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/PrevBtn/OpenImage").gameObject
    this.prevButton = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/PrevBtn"):GetComponent("Button")
    this.nextBtn = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/NextBtn").gameObject
    this.nextClose = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/NextBtn/CloseImage").gameObject
    this.nextOpen = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/NextBtn/OpenImage").gameObject
    this.nextButton = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/NextBtn"):GetComponent("Button")

    -- 没内容小狐狸提示
    this.worldNoContentRoot = transform:Find("LeftRoot/MiddleRoot/WorldRoot/NoContentRoot").gameObject
    this.worldNoContentText = transform:Find("LeftRoot/MiddleRoot/WorldRoot/NoContentRoot/Image/Bg/Text"):GetComponent("Text")
    this.chatRecordsTitleText = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRecordsRoot/TitleText"):GetComponent("Text")
    this.friendsNoContentRoot = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/NoContentRoot").gameObject
    this.friendsNoContentText = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/NoContentRoot/Image/Bg/Text"):GetComponent("Text")
    this.friendsChatNoContentRoot = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRoot/NoContentRoot").gameObject
    this.friendsChatNoContentText = transform:Find("LeftRoot/MiddleRoot/FriendsRoot/ChatRoot/NoContentRoot/Bg/Text"):GetComponent("Text")
    this.strangersNoContentRoot = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/NoContentRoot").gameObject
    this.strangersNoContentText = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/NoContentRoot/Image/Bg/Text"):GetComponent("Text")
    this.strangersChatNoContentRoot = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/ChatRoot/NoContentRoot").gameObject
    this.strangersChatNoContentText = transform:Find("LeftRoot/MiddleRoot/StrangersRoot/ChatRoot/NoContentRoot/Bg/Text"):GetComponent("Text")
end
