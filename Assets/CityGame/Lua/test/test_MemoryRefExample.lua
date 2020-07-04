--
-- Show case of MemoryReferenceInfo.lua.
--
-- @filename  Example.lua
-- @author    WangYaoqi
-- @date      2017-05-04
UnitTest.TestBlockStart()---------------------------------------------------------


local mri = MemoryRefInfo

UnitTest.Exec("abel_w10_MemRef_all", "test_MemRef_all",  function ()

    ct.log("abel_w10_MemRef_all","[test_MemRef_all]  balabalabalabala...............")
    local getReffun = function()

        --UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "1")
        ct.log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 1")
        -- Print all memory reference snapshots of the current Lua virtual machine to a file (or a snapshot of all reference information of an object) to a local file.
        UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "1",_G.Author) -- to facilitate testing, just look at _G.Author
        ct.log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 1 finished")
        -- strSavePath-Snapshot save path, excluding file name.
        -- strExtraFileName-Add additional information to the file name, can be "" or nil.
        -- nMaxRescords-Maximum number of records to print, -1 print all records.
        -- strRootObjectName-the root node object name to be traversed, tostring(cRootObject) when "" or nil
        -- cRootObject-The root node object to be traversed. Use debug.getregistry() when the default is nil.
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
            ct.log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 2")
            UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "2",_G.Author) --For easy testing, just look at _G.Author
            ct.log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 2 finished")
            return author
        end
        g_testValue = reffun()
        --UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "3")
        ct.log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 3")
        UnitTest.MemoryReferenceAll("abel_w10_MemRef_all", "3",_G.Author) --For easy testing, just look at _G.Author
        ct.log("abel_w10_MemRef_all","[abel_w10_MemRef_all]  MemoryReferenceAll 3 finished")
    end

    --Get reference data in memory
    getReffun() --Temporarily block, so that the test results can be compared

    -- Print all relevant references of an object in the current Lua virtual machine.
    -- strSavePath-Snapshot save path, excluding file name.
    -- strExtraFileName-Add additional information to the file name, can be "" or nil.
    -- nMaxRescords-Maximum number of records to print, -1 print all records.
    -- strObjectName-Object display name.
    -- cObject-object instance.
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, strObjectName, cObject)

    -- Compare two memory snapshot result files and print the file strResultFilePathAfter relative to the new content in strResultFilePathBefore.
    -- strSavePath-Snapshot save path, excluding file name.
    -- strExtraFileName-Add additional information to the file name, can be "" or nil.
    -- nMaxRescords-Maximum number of records to print, -1 print all records.
    -- strResultFilePathBefore-The first memory snapshot file.
    -- strResultFilePathAfter-The second memory snapshot file for comparison.
    -- MemoryReferenceInfo.m_cMethods.DumpMemorySnapshotComparedFile(strSavePath, strExtraFileName, nMaxRescords, strResultFilePathBefore, strResultFilePathAfter)
    UnitTest.MemoryRefResaultCompared("abel_w10_MemRef_all", "1", "2")
    UnitTest.MemoryRefResaultCompared("abel_w10_MemRef_all", "2", "3")
    --mri.m_cMethods.DumpMemorySnapshotComparedFile("./", "Compared", -1, "./LuaMemRefInfo-All-[1-Before].txt", "./LuaMemRefInfo-All-[2-After].txt ")

    -- Filter a memory snapshot file according to keywords and output to another file.
    -- strFilePath-Memory snapshot file that needs to be filtered and output.
    -- strFilter-filter keywords
    -- bIncludeFilter-Include keywords (true) or exclude keywords (false) to output content.
    -- bOutputFile-output to file (true) or console (false).
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
    ct.log("abel_w10_MemRef_table","[test_MemRef_table]  balabalabalabala...............")
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
    -- Print all references to an object in the current Lua virtual machine.
    -- strSavePath-Snapshot save path, excluding file name.
    -- strExtraFileName-Add additional information to the file name, can be "" or nil.
    -- nMaxRescords-Maximum number of records to print, -1 print all records.
    -- strObjectName-Object display name.
    -- cObject-object instance.
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
