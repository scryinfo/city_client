---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/9/19 13:02
--[[
一、分组的作用
    1、 测试用例分组，避免无关测试用例占用运行时间
    2、 日志/log也采用相同分组策略，避免无关日志干扰开发
二、使用方法
1、 激活分组
	示例:
    TestGroup.active_TestGroup("abel_w3")
	* 激活 id 为 "abel_w3" 的分组，激活之后，所有使用该分组id的所有测试和日志都能正常运行
2、 在具体的单元测试定义中注册分组
	1、 require：
		UnitTest = require ('test/testFrameWork/UnitTest')
	2、 定义测试用例
		示例:
		UnitTest.Exec("abel_w4", "test_pb11111",  function ()
			log("abel_w4","[test_pb11111]  测试完毕")
		end)
		* 这里的"abel_w4"就是测试分组的Id，如果该测试分组没有被激活，那么该单元测试是不会执行到的
		* test_pb11111 是测试用例函数的名字
		* function 后面是测试用例的函数体
3、 在非单元测试的代码中使用测试分组
    1、 在普通的代码中使用测试分组只有一种情况，那就是日志分组，避免无关日志的干扰
	2、 我们项目的日志统一使用 log(...) 这个接口，要注意： lua自带的 print 方法现在是用不了的。
		示例：
			log("abel_w4","[test_pb11111]  测试完毕")
			* 这里的 "abel_w4" 是分组id， 如果该id对应的分组没有被激活，这个 log 将会无效；
三、 说明：
	1、 测试用例的定义实际调用的是这个方法：
		function UnitTest.Exec(unitGroupId, funcName, func)
		参数中的 unitGroupId 就是测试分组的Id
	2、 方法参数说明
		1、 unitGroupId 测试组Id
			1、 命名格式： 英文名_工作周_额外信息，  比如： allen_w6_temp
			2、 作用： 测试分组的唯一ID，一个分组ID可以被多个测试用例和log命令共享，该ID的分组一旦通过 active_TestGroup激活之后，所用共享该ID的测试用例和Log命令都会被执行
		2、 funcName 测试用例的函数名
			1、 函数名必须以 test_ 开头，比如： test_login ，否则是不会被执行到的
			2、 要求全局唯一
		3、 func 测试用例的方法实现
]]--
local ProFi = require ('test/testFrameWork/memory/ProFi')
local mri = MemoryRefInfo
CityGlobal.mkMemoryProfile()
UnitTest = {}
function UnitTest.Exec(unitGroupId, funcName, func)
    if TestGroup.get_TestGroupId(unitGroupId) == nil  then
        return
    end
    addToTestGropu(funcName,unitGroupId)
    _G[funcName] = func
end

--CPU使用分析， 只能在 UnitTest.Exec 内部使用
function UnitTest.PerformanceTest(groupid, info,func)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    --log(groupid,info)
    local startTime = os.clock()
    func(groupid)
    local endTime = os.clock()
    local outtime = endTime - startTime
    log(groupid, info, "执行时间: ", outtime)
    return outtime
end

--内存用量分析, 生成 func 执行前后的内存用量到文件夹 MemoryProfile 中
function UnitTest.MemoryConsumptionTest(groupid, funcName,func)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    log(groupid, funcName)
    ProFi:reset()
    collectgarbage("collect")
    ProFi:checkMemory( 0, funcName..'-------------' )
    ProFi:writeReport( funcName..'_0_before.txt' )
    collectgarbage("collect")
    ProFi:start()
    func(groupid)
    ProFi:stop()
    ProFi:checkMemory( 0, funcName..'-------------' )
    ProFi:writeReport( funcName..'_1_after.txt' )
    ProFi:reset()
    collectgarbage("collect")
    ProFi:checkMemory( 0, funcName..'-------------' )
    ProFi:writeReport( funcName..'_2_finished.txt' )
end

--文件命名约定
function UnitTest.GetDumpAllFileName(groupid, filename)
    return "["..groupid.."]".."_DumpAll_"..filename
end

function UnitTest.GetDumpOneFileName(groupid, filename)
    return "["..groupid.."]".."_DumpOne_"..filename
end

function UnitTest.GetValidPath(groupid, filename)
    return UnitTest.GetDumpAllFileName(groupid, filename)..".txt"
end

--全局内存引用分析
function UnitTest.MemoryReferenceAll(groupid, fileName, rootObj)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    local root = nil
    if rootObj ~= nil then
        root  = rootObj
    end
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshot(CityGlobal.getMemoryProfile().."/", UnitTest.GetDumpAllFileName(groupid,fileName), -1, tostring(root), root)
end

--指定物体内存引用分析， 只能在 UnitTest.Exec 内部使用
function UnitTest.MemoryReferenceOne(groupid, markid,object)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    collectgarbage("collect")
    mri.m_cMethods.DumpMemorySnapshotSingleObject(CityGlobal.getMemoryProfile().."/", UnitTest.GetDumpOneFileName(groupid,markid), -1, objectName, object)
end

--比较两个文件的引用信息差异
function UnitTest.MemoryRefResaultCompared(groupid, firstfile, secondfile)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    mri.m_cMethods.DumpMemorySnapshotComparedFile(CityGlobal.getMemoryProfile().."/", "Compared_"..UnitTest.GetDumpAllFileName(groupid, firstfile).."-"..secondfile, -1,  UnitTest.GetValidPath(groupid, firstfile), UnitTest.GetValidPath(groupid, secondfile))
end

--在指定文件中过滤特定对象的引用统计信息
function UnitTest.MemoryRefResaultFiltered(groupid, strFilePath, strFilter, bIncludeFilter)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    mri.m_cBases.OutputFilteredResult(UnitTest.GetDumpAllFileName(groupid,strFilePath), strFilter, bIncludeFilter, true)
end

--使用下面这个接口可以在特定的时间和条件下执行对应的单元测试，采用消息机制，需要在对应的单元测试中注册相应的 event 消息
function UnitTest.Exec_now(groupid, event,...)
    if TestGroup.get_TestGroupId(groupid) == nil  then return end
    Event.Brocast(event,...);
end

return UnitTest