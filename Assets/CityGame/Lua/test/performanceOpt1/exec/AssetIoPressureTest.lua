---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/11/13 16:52
---
UnitTest.TestBlockStart()-------------------------------------------------------
--[[
1、 测试目的 (项目中密集型IO场景及内存管理分析.txt 对应测试)
    1、 确定总量为1000-2000个128*128大小的Icon分散存好还是拼装好
        1、 IO操作卡顿情况
        2、 GPU压力
        3、 内存用量压力
    2、
--]]

--测试数据准备{
local testcount = 1000
local ResPathList = {}
if UnityEngine.Application.isEditor then
    for i = 1, testcount do
        ResPathList[i] = 'TempIcon/A'..i
    end
else
    for i = 1, testcount do
        --ResPathList[i] = CityLuaUtil.getAssetsPath()..'/tempIcon_a'..i..'.unity3d'
        ResPathList[i] = 'TempIcon/A'..i
    end
end

local ptype = CityLuaUtil.getSpriteType()
local Icon_Prefab = UnityEngine.Resources.Load("View/TestCycle/Icon_Prefab")
local loadedOjb = ct.InstantiatePrefab(Icon_Prefab);
local Icon =  loadedOjb.transform:GetComponent("Image")
local pSprite = Icon.sprite
local type = Icon_Prefab.GetType(pSprite)
reslist={} --改成全局的看看
--加载测试
local testLoadFun = function(reslist)
    for i = 1, testcount do
        panelMgr:LoadPrefab_A(ResPathList[i], ptype, nil,function(self, obj )
            reslist[i] = obj
            if obj ~= nil then
                ct.log('abel_w17_load_s128_n1000_S','[testLoadFun] UnityEngine.Resources.Load file '..obj.name)
            end
        end)
    end
end

--卸载测试
local testUnLoadFun = function(reslist)
    for i = 1, testcount do
        UnityEngine.Resources.UnloadAsset(reslist[i])
    end
end

--加载和实例化
local testLoadAndInsFun = function(pblist, inslist)
    for i = 1, testcount do
        pblist[i] = UnityEngine.Resources.Load(ResPathList[i],type)
        inslist[i] = UnityEngine.GameObject.Instantiate(pblist[i])
    end
end

--卸载
local testUnLoadAndDestoryInsFun = function(pblist, inslist)
    for i = 1, testcount do
        destroy(inslist[i])
        UnityEngine.Resources.UnloadAsset(pblist[i])
    end
end

--测试数据准备}
UnitTest.Exec("abel_w17_load_s128_n1000_S", "abel_w17_load_s128_n1000_S",  function ()

    --Load 测试------------------------------------------------------------------------------------------------------------{
    --load 内存用量
    collectgarbage("collect")
    ct.log('abel_w17_load_s128_n1000_S','[abel_w17_load_s128_n1000_S_mem] hoho')

    testLoadFun(reslist)

    local timer = FrameTimer.New(function()
        testUnLoadFun(reslist)
        reslist=nil
    end, 90, 0)
    timer:Start()

    --UnitTest.MemoryConsumptionTest("abel_w17_load_s128_n1000_S","abel_w17_load_s128_n1000_S_mem",function()
    --    testLoadFun(reslist)
    --end)
    -- 5470-4524 = 946 kb
    -- 5355-4520 = 835 kb
    -- 5355-4519 = 836 kb
    -- 5355-4519 = 836 kb
    --正常1000个128图标尺寸应该为 16*1000 = 15.625M
    --编辑器中看， 一个icon压缩为ect2的话，大小为8k， 那也不止 836 kb, 这里的 836 kb应该不是真正把资源加载到内存中了，
    --那么真正的资源加载发生在上面时候？
    --[[
    local timer = FrameTimer.New(function()
        --测试unload内存用量
        collectgarbage("collect")
        ct.log('abel_w17_Unload_s128_n1000_S','[abel_w17_Unload_s128_n1000_S_mem]')
        UnitTest.MemoryConsumptionTest("abel_w17_Unload_s128_n1000_S","abel_w17_Unload_s128_n1000_S_mem",function()
            testUnLoadFun(reslist)
        end)
        local timer = FrameTimer.New(function()
            --Instantiate 内存用量, 看看内存是否是预期的
            collectgarbage("collect")
            ct.log('abel_w17_load_Instantiate_s128_n1000_S_mem','[abel_w17_load_Instantiate_s128_n1000_S_mem]')
            UnitTest.MemoryConsumptionTest("abel_w17_load_Instantiate_s128_n1000_S_mem","abel_w17_load_Instantiate_s128_n1000_S_mem",function()
                local prefablist = {}
                local inslist = {}
                testLoadAndInsFun(prefablist, inslist)
            end)
            local timer = FrameTimer.New(function()
                local prefablist = {}
                local inslist = {}
                testLoadAndInsFun(prefablist, inslist)
                collectgarbage("collect")
                --内存开销
                ct.log('abel_w17_UnLoadAndDestory_s128_n1000_S','[abel_w17_UnLoadAndDestory_s128_n1000_S]')
                UnitTest.MemoryConsumptionTest("abel_w17_UnLoadAndDestory_s128_n1000_S","abel_w17_UnLoadAndDestory_s128_n1000_S",function()
                    testUnLoadAndDestoryInsFun(prefablist, inslist)
                end)
            end, 10, 0)
            --timer:Start()
        end, 10, 0)
        --timer:Start()
    end, 10, 0)
    timer:Start()
    --Instantiate 测试------------------------------------------------------------------------------------------------------------
    --]]
end)

UnitTest.Exec("abel_w17_load_s128_n1000_S_IoTime", "abel_w17_load_s128_n1000_S_IoTime",  function ()

    --load IO执行时间
    local reslist = {}
    collectgarbage("collect")
    UnitTest.PerformanceTest("abel_w17_load_s128_n1000_S_IoTime","[同步加载1000个尺寸为128的执行时间]", function()
        testLoadFun(reslist)
    end)
    --测试unload IO操作时间
    testLoadFun(reslist)
    collectgarbage("collect")
    UnitTest.PerformanceTest("abel_w17_Unload_s128_n1000_S_IoTime","[同步加载1000个尺寸为128的执行时间]", function()
        testUnLoadFun(reslist)
    end)
    --IO执行时间
    collectgarbage("collect")
    UnitTest.PerformanceTest("abel_w17_load_Instantiate_s128_n1000","[同步加载并实例化1000个尺寸为128的执行时间]", function()
        local prefablist = {}
        local inslist = {}
        testLoadAndInsFun(prefablist, inslist)
    end)
    --IO执行时间
    testLoadAndInsFun(prefablist, inslist)
    collectgarbage("collect")
    UnitTest.PerformanceTest("abel_w17_unload_Desotyr_s128_n1000","[同步卸载并销毁1000个尺寸为128的实例的执行时间]", function()
        testUnLoadAndDestoryInsFun(prefablist, inslist)
    end)
end)



--同步加载prefab资源对比测试
UnitTest.Exec("abel_w17_load_s128_n400_Sync", "abel_w17_load_s128_n400_Sync",  function ()
    --测试数据准备{
    local testcount = 10
    local ResPathList = {}
    for i = 1, testcount do
        ResPathList[i] = 'View/TempIcon/A'..i
    end
    --测试数据准备}
    local exectime1 = UnitTest.PerformanceTest("abel_w17_load_s128_n400_Sync","[同步加载400个尺寸为128的 Icon: Resource.Load]", function()
        local prefab = UnityEngine.Resources.Load( 'View/TempIcon/Image');

        for i = 1, testcount do
            --加载 prefab 资源
            local resLoad = UnityEngine.Resources.Load(ResPathList[i])
            local go = UnityEngine.GameObject.Instantiate(prefab)
            --go.transform:GetComponent("Image").sprite = resLoad
            local xxx = 0
        end
    end)

    local exectime1 = UnitTest.PerformanceTest("abel_w17_load_s128_n400_Sync","[同步加载400个尺寸为128的 Icon: AssetBundle.Load]", function()

    end)

    ct.OpenCtrl('TestSliderCtrl',ResPathList)
end)

--异步加载prefab资源
UnitTest.Exec("abel_w17_load_s128_n400_ASync", "abel_w17_load_s128_n400_ASync",  function ()
    UnitTest.PerformanceTest("abel_w17_load_s128_n400_ASync","[异步加载400个尺寸为128的 Icon: LoadPrefab]", function()

    end)
end)
--卸载资源测试 AssetBundle.Unload、 UnloadUnusedAssets
UnitTest.Exec("abel_w17_unload_s128_n400", "abel_w17_unload_s128_n400",  function ()
    UnitTest.PerformanceTest("abel_w17_unload_s128_n400","[异步加载400个尺寸为128的 Icon LoadPrefab]", function()

    end)
end)

--测试 Instantiate 及对应 destory 的性能开销
UnitTest.Exec("abel_w17_Instantiate_destory_s128_n400", "abel_w17_Instantiate_destory_s128_n400",  function ()
    UnitTest.PerformanceTest("abel_w17_Instantiate_destory_s128_n400","[Instantiate 及对应 destory 的性能开销]", function()

    end)
end)

--分散打包资源的加载及销毁测试
--每帧创建和销毁100个128尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s128_n100_memory", "abel_w17_Icon_load_s128_n100_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s128_n100_memory","[分散打包资源的加载及销毁测试 100个128尺寸]", function()

    end)
end)

--每帧创建和销毁50个128尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s128_n50_memory", "abel_w17_Icon_load_s128_n50_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s128_n50_memory","[分散打包资源的加载及销毁测试 50个128尺寸]", function()

    end)
end)

--每帧创建和销毁100个256尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s256_n100_memory", "abel_w17_Icon_load_s256_n100_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s256_n100_memory","[分散打包资源的加载及销毁测试 100个128尺寸]", function()

    end)
end)
--每帧创建和销毁50个256尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s256_n50_memory", "abel_w17_Icon_load_s128_n50_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s256_n50_memory","[分散打包资源的加载及销毁测试 50个128尺寸]", function()

    end)
end)

--每帧创建和销毁100个1024尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s1024_n100_memory", "abel_w17_Icon_load_s1024_n100_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s1024_n100_memory","[分散打包资源的加载及销毁测试 100个1024尺寸]", function()

    end)
end)
--每帧创建和销毁50个1024尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s1024_n50_memory", "abel_w17_Icon_load_s1024_n50_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s1024_n50_memory","[分散打包资源的加载及销毁测试 50个1024尺寸]", function()

    end)
end)

--每帧创建和销毁100个2048尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s2048_n100_memory", "abel_w17_Icon_load_s2048_n100_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s2048_n100_memory","[分散打包资源的加载及销毁测试 100个2048尺寸]", function()

    end)
end)
--每帧创建和销毁50个2048尺寸的Icon
UnitTest.Exec("abel_w17_Icon_load_s2048_n50_memory", "abel_w17_Icon_load_s2048_n50_memory",  function ()
    UnitTest.PerformanceTest("abel_w17_Icon_load_s2048_n50_memory","[分散打包资源的加载及销毁测试 50个1024尺寸]", function()

    end)
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------