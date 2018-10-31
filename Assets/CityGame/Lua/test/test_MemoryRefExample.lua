--
-- Show case of MemoryReferenceInfo.lua.
--
-- @filename  Example.lua
-- @author    WangYaoqi
-- @date      2017-05-04
UnitTest.TestBlockStart()---------------------------------------------------------


local mri = MemoryRefInfo

UnitTest.Exec("abel_w10_MemRef_all", "test_MemRef_all",  function ()

    log("abel_w10_MemRef_all","[test_MemRef_all]  balabalabalabala...............")
    local getReffun = function()

        --UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "1")
        log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 1")
        -- 打印当前 Lua 虚拟机的所有内存引用快照到文件(或者某个对象的所有引用信息快照)到本地文件。
        UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "1",_G.Author) --方便测试，先只看 _G.Author
        log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 1 finished")
        -- strSavePath - 快照保存路径，不包括文件名。
        -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
        -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
        -- strRootObjectName - 遍历的根节点对象名称，"" 或者 nil 时使用 tostring(cRootObject)
        -- cRootObject - 遍历的根节点对象，默认为 nil 时使用 debug.getregistry()。
        -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, strRootObjectName, cRootObject)
        -- Add a global variable.

        function reffun()
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
            local author1 =
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
            --UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "2")
            log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 2")
            UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "2",_G.Author) --方便测试，先只看 _G.Author
            log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 2 finished")
            return author
        end
        g_testValue = reffun()
        --UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "3")
        log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 3")
        UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "3",_G.Author) --方便测试，先只看 _G.Author
        log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 3 finished")
    end

    --获取内存中的引用数据
    getReffun() --暂时屏蔽，以便测试结果比对路径

    -- 打印当前 Lua 虚拟机中某一个对象的所有相关引用。
    -- strSavePath - 快照保存路径，不包括文件名。
    -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
    -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
    -- strObjectName - 对象显示名称。
    -- cObject - 对象实例。
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, strObjectName, cObject)

    -- 比较两份内存快照结果文件，打印文件 strResultFilePathAfter 相对于 strResultFilePathBefore 中新增的内容。
    -- strSavePath - 快照保存路径，不包括文件名。
    -- strExtraFileName - 添加额外的信息到文件名，可以为 "" 或者 nil。
    -- nMaxRescords - 最多打印多少条记录，-1 打印所有记录。
    -- strResultFilePathBefore - 第一个内存快照文件。
    -- strResultFilePathAfter - 第二个用于比较的内存快照文件。
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotComparedFile(strSavePath, strExtraFileName, nMaxRescords, strResultFilePathBefore, strResultFilePathAfter)
    UnitTest.MemoryRefResaultCompared("abel_w10_MemRef_all", "1", "2")
    UnitTest.MemoryRefResaultCompared("abel_w10_MemRef_all", "2", "3")
    --mri.m_cMethods.DumpMemorySnapshotComparedFile("./", "Compared", -1, "./LuaMemRefInfo-All-[1-Before].txt", "./LuaMemRefInfo-All-[2-After].txt")

    -- 按照关键字过滤一个内存快照文件然后输出到另一个文件.
    -- strFilePath - 需要被过滤输出的内存快照文件。
    -- strFilter - 过滤关键字
    -- bIncludeFilter - 包含关键字(true)还是排除关键字(false)来输出内容。
    -- bOutputFile - 输出到文件(true)还是 console 控制台(false)。
    -- MemoryReferenceInfo.m_cBases.OutputFilteredResult(strFilePath, strFilter, bIncludeFilter, bOutputFile)
    -- Filter all result include keywords: "Author".
    UnitTest.MemoryRefResaultFiltered("abel_w10_MemRef_all", "1", "Author", true)
    --mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", true, true)

    -- Filter all result exclude keywords: "Author".
    UnitTest.MemoryRefResaultFiltered("abel_w10_MemRef_all", "1", "Author", false)
    --mri.m_cBases.OutputFilteredResult("./LuaMemRefInfo-All-[2-After].txt", "Author", false, true)

    -- All dump finished!
    print("Dump memory snapshot information finished!")
end)

UnitTest.Exec("abel_w10_MemRef_table", "test_MemRef_table",  function ()
    log("abel_w10_MemRef_table","[test_MemRef_table]  balabalabalabala...............")
    UnitTest.MemoryReferenceOne("abel_w10_MemRef_table", "Author_1",_G.Author)
    local author_2 =
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
    _G.Author = author_2
    UnitTest.MemoryReferenceOne("abel_w10_MemRef_table", "Author_2",_G.Author)
    g_Value = author_2
    UnitTest.MemoryReferenceOne("abel_w10_MemRef_table", "Author_3",_G.Author)
    g_Value = nil
    UnitTest.MemoryReferenceOne("abel_w10_MemRef_table", "Author_4",_G.Author)
    _G.Author = nil
    UnitTest.MemoryReferenceOne("abel_w10_MemRef_table","Author_5",_G.Author)
    -- All dump finished!
    print("Dump memory snapshot information finished!")
end)
UnitTest.TestBlockEnd()-----------------------------------------------------------
