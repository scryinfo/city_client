--
-- Show case of MemoryReferenceInfo.lua.
--
-- @filename  Example.lua
-- @author    WangYaoqi
-- @date      2017-05-04

local mri = MemoryRefInfo

UnitTest.Exec("abel_w10_MemRef_all", "test_MemRef_all",  function ()
    log("abel_w10_MemRef_all","[test_MemRef_all]  balabalabalabala...............")

    -- Set config.
    mri.m_cConfig.m_bAllMemoryRefFileAddTime = false
    mri.m_cConfig.m_bSingleMemoryRefFileAddTime = false
    mri.m_cConfig.m_bComparedMemoryRefFileAddTime = false

    -- 打印当前 Lua 虚拟机的所有内存引用快照到文件(或者某个对象的所有引用信息快照)到本地文件。
    -- strSavePath - 快照保存路径，不包括文件名。
    -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
    -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
    -- strRootObjectName - 遍历的根节点对象名称，"" 或者 nil 时使用 tostring(cRootObject)
    -- cRootObject - 遍历的根节点对象，默认为 nil 时使用 debug.getregistry()。
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, strRootObjectName, cRootObject)
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshot("./", "1-Before", -1)

    -- Add a global variable.
    local author =
    {
        Name = "yaukeywang",
        Job = "Game Developer",
        Hobby = "Game, Travel, Gym",
        City = "Beijing",
        Country = "China",
        Ask = function (question)
            return "My answer is for your question: " .. question .. "."
        end
    }

    _G.Author = author

    -- Dump memory snapshot again.
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshot("./", "2-After", -1)

    -- 打印当前 Lua 虚拟机中某一个对象的所有相关引用。
    -- strSavePath - 快照保存路径，不包括文件名。
    -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
    -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
    -- strObjectName - 对象显示名称。
    -- cObject - 对象实例。
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, strObjectName, cObject)
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-Object", -1, "Author", _G.Author)

    -- We can also find string references.
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-String", -1, "Author Name", "yaukeywang")

    -- 比较两份内存快照结果文件，打印文件 strResultFilePathAfter 相对于 strResultFilePathBefore 中新增的内容。
    -- strSavePath - 快照保存路径，不包括文件名。
    -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
    -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
    -- strResultFilePathBefore - 第一个内存快照文件。
    -- strResultFilePathAfter - 第二个用于比较的内存快照文件。
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotComparedFile(strSavePath, strExtraFileName, nMaxRescords, strResultFilePathBefore, strResultFilePathAfter)
    mri.m_cMethods.DumpMemorySnapshotComparedFile("./", "Compared", -1, "./LuaMemRefInfo-All-[1-Before].txt", "./LuaMemRefInfo-All-[2-After].txt")

    -- 按照关键字过滤一个内存快照文件然后输出到另一个文件.
    -- strFilePath - 需要被过滤输出的内存快照文件。
    -- strFilter - 过滤关键字
    -- bIncludeFilter - 包含关键字(true)还是排除关键字(false)来输出内容。
    -- bOutputFile - 输出到文件(true)还是 console 控制台(false)。
    -- MemoryReferenceInfo.m_cBases.OutputFilteredResult(strFilePath, strFilter, bIncludeFilter, bOutputFile)
    -- Filter all result include keywords: "Author".
    mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", true, true)

    -- Filter all result exclude keywords: "Author".
    mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", false, true)

    -- All dump finished!
    print("Dump memory snapshot information finished!")
end)

UnitTest.Exec("abel_w10_MemRef_table", "test_MemRef_table",  function ()
    log("abel_w10_MemRef_table","[test_MemRef_table]  balabalabalabala...............")
    mri.m_cConfig.m_bAllMemoryRefFileAddTime = false
    mri.m_cConfig.m_bSingleMemoryRefFileAddTime = false
    mri.m_cConfig.m_bComparedMemoryRefFileAddTime = false
    local author =
    {
        Name = "yaukeywang",
        Job = "Game Developer",
        Hobby = "Game, Travel, Gym",
        City = "Beijing",
        Country = "China",
        Ask = function (question)
            return "My answer is for your question: " .. question .. "."
        end
    }
    -- 打印当前 Lua 虚拟机中某一个对象的所有相关引用。
    -- strSavePath - 快照保存路径，不包括文件名。
    -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
    -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
    -- strObjectName - 对象显示名称。
    -- cObject - 对象实例。
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, strObjectName, cObject)
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-Author before", -1, "Author", _G.Author) --因为没找到，所以没有输出到文本

    -- We can also find string references.
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-String before", -1, "Author Name", "yaukeywang")


    _G.Author = author
    local t1 = author
    t2 = author
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-Author _G.Author = author", -1, "Author", _G.Author)

    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-String _G.Author = author", -1, "Author Name", "yaukeywang")

    _G.Author = nil

    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-Author _G.Author = nil", -1, "Author", _G.Author)

    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-String _G.Author = nil", -1, "Author Name", "yaukeywang")
       -- All dump finished!
    print("Dump memory snapshot information finished!")
end)

--文档
--[[
在这里再简单说下工具使用。
　　首先 require 这个脚本，例如：local mri = require(MemoryReferenceInfo)。
　　然后在某个地方打印一份内存快照：

collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshot("./", "All", -1)

　　快照文件的内容，每一行是一个引用对象信息，所有的信息按照引用次数降序排列，每一行被 tab 分成了3列，分别是：对象类型/地址，
    引用链，引用次数。整个文件可以使用 Excel 打开，会自动归为3列，方便阅读，重新排序。

　　文件内容中重点部分是引用链的信息，例如 "function: 0x7f85f8e0e3f0 registry.2[_G].Author.Ask[line:33@file:example.lua] 1"
    这条信息说明的是：表 "registry" 的成员 "2"（也就是表 "_G"）引用了表 "Author"，表 "Author" 有一个成员 "Ask" 引用了 "function: 0x7f85f8e0e3f0"，
    函数位置在文件 "example.lua" 中的第33行，一共被引用了1次。这样就能快速的定位什么对象在哪里被引用，一共被引用了多少次。

　　"DumpMemorySnapshot" 这个方法最后两个参数是“根节点对象名称“和“搜索根节点对象”，默认值为 "registry" 和 "debug.getregistry()"，
    在大多数使用的时候不需要修改使用默认值即可，但是当你想从别的根节点开始搜索来缩小范围，例如从 "_G" 来搜索，你可以手动设置这两个参数，例如：

-- Only dump memory snapshot searched from "_G".
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshot("./", "All", -1, "_G", _G)

　　当整个程序运行一段时间后，再打印一份内存快照（可以打印多份），接下来最重要的工作就是对比快照分析增加的泄露点。
    在这个工具中，提供了一个名为 “DumpMemorySnapshotComparedFile” 的接口来实现这个对比功能，切记不要自己用文件对比工具来对比两份快照（有朋友这样用过），
    因为快照内容是根据引用计数来降序排序的，时间不同内容也不同，顺序也不同，所以普通的文件对比工具在这里是无法生效的。使用方法：

mri.m_cMethods.DumpMemorySnapshotComparedFile("./", "Compared", -1,
"./LuaMemRefInfo-All-[1-Before].txt",
"./LuaMemRefInfo-All-[2-After].txt")

这个方法会生成一个新文件，里面是出现在第二份快照里但是没有并出现在第一份快照里的数据，这就是新增内容。

　　无论是那种类型的数据，如果 dump 后数据过大，但是想查看某个特定的数据，可以使用过滤器来生成一个新文件，可以选择新文件生成的内容是包含关键字，还是排除关键字，例如：

-- 输出文件里所有包含关键字 “Author” 的内容。（不区分大小写）
mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", true, true)

--输出文件里所有不包含关键字 “Author” 的内容。（不区分大小写）
-- Filter all result exclude keywords: "Author".
mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", false, true)

　　另外，如果想查看某个对象到底被哪些地方引用着，可以使用接口 "DumpMemorySnapshotSingleObject"，例如：

--输出所有引用对象 "_G.Author" 的地方。
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-Object", -1, "Author", _G.Author)

-- 输出所有引用字符串 "yaukeywang" 的地方。
collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshotSingleObject("./", "SingleObjRef-String", -1, "Author Name", "yaukeywang")

　　通过以上几个主要的方法配合使用，就可以快速的查出内存泄漏，即使在手机上也可以使用，比如打印时将保存路径指向 sd 卡目录，例如如果使用 Unity 里的 Lua，可以使用：

collectgarbage("collect")
mri.m_cMethods.DumpMemorySnapshot(UnityEngine.Application.persistentPath, "All", -1)

它将输出一份快照文件到 sd 卡目录下。

　　现在新加了一个配置选项，一般例如 "DumpMemorySnapshot" 这个方法都是指定一个保存路径和额外信息，然后保存的文件名最后每次都会加上当前的时间戳，方便根据时间来区分不同的快照，
    也避免需要频繁的设置和修改文件名，也避免同一个地方不同时间的快照被不断覆盖，这个时间戳选项默认开启，可以通过 "mri.m_cConfig.m_bAllMemoryRefFileAddTime = false" 来关闭，
    配置的设置放置在 "require" 后，Dump 之前，其它几个 Dump 的接口也都有是否附加时间戳到文件名的选项，具体参看源码。

　　除了以上的方法，还提供了一些其它的接口可以使用，更详细的使用请参考 GitHub 上的 ReadMe 和源码中的接口定义说明，都写的很详细了，"Example.lua" 中也演示了常用接口的使用方法。

　　最后，最近完善了下这个工具，增加了字符串类型的输出，所以上面的那张搜索路径图，路径上可以再添加一个 "string"。
    同时需要注意：为了能在同一行显示所有字符串（以方便其他方法对数据进行处理，例如对比差异增量，Excel 排序统计等），
    字符串在显示的时候所有的回车和换行符：'\r', '\n' 都被显式的替换成了 '\\n'，需要阅读数据的时候注意。

]]--
