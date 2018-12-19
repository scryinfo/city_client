---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/11/13 16:52
---
UnitTest.TestBlockStart()-------------------------------------------------------
local typeof = tolua.typeof
--基本测试数据准备{
--目前的测试是1000个160*160贴图的资源IO测试
local testcount = 1000  --资源加载数量
local ResPathList = {}  --资源路径
for i = 1, testcount do
    ResPathList[i] = 'TempIcon/A'..i
end

local ResPathListS = {}  --资源路径
for i = 1, testcount do
    ResPathListS[i] = 'TempIcon/A'..i
end
--基本测试数据准备}

--异步方式加载、卸载的内存测试,
--[[
    测试说明：
    1、 运行时只会使用这种方式加载
    2、 由于是异步的需要使用timer来延迟卸载
    3、 由于是异步的，所以只能用于测试资源加载的内存销毁情况，而不能测试资源加载的IO时延，
        IO时延测试放在后续同步加载的测试分组 abel_w17_load_unload_s160_time 中
--]]

--异步加载测试
local testLoadFun = function(inBundlelist, inAssertlist,type)
    for i = 1, testcount do
        panelMgr:LoadPrefab_A(ResPathList[i], type, nil,function(self, obj ,ab)
            inBundlelist[#inBundlelist +1] = ab
            inAssertlist[#inAssertlist] = obj
        end)
    end
end

UnitTest.Exec("abel_w17_load_A_sprite_s160_mem", "abel_w17_load_A_sprite_s160_mem",  function ()
    local bundlelist ={}        --存放bundle的表
    local assetlist ={}

    local timer0 = FrameTimer.New(function()
        collectgarbage("collect")
        ct.log('abel_w17_load_A_sprite_s160_mem','[abel_w17_load_A_sprite_s160_mem] testLoadFun')
        testLoadFun(bundlelist, assetlist,ct.getType(UnityEngine.Sprite))
        collectgarbage("collect")
    end, 10, 0)
    timer0:Start()
end)

UnitTest.Exec("abel_w17_load_A_texture_s160_mem", "abel_w17_load_A_texture_s160_mem",  function ()
    local bundlelist ={}        --存放bundle的表
    local assetlist ={}

    local timer0 = FrameTimer.New(function()
        collectgarbage("collect")
        ct.log('abel_w17_load_A_texture_s160_mem','[abel_w17_load_A_texture_s160_mem] testLoadFun')
        testLoadFun(bundlelist, assetlist)
    end, 10, 0)
    timer0:Start()
end)

UnitTest.Exec("abel_w17_load_A_unload_force_s160_mem", "abel_w17_load_A_unload_force_s160_mem",  function ()
    local bundlelist ={}        --存放bundle的表
    local assetlist ={}
    -- unloadAllLoadedObjects 方式卸载测试
    local TestUnLoadFun_force = function(reslist )
        ct.log('abel_w17_load_A_unload_force_s160_mem','[testUnLoadFun] #reslist = '..#reslist)
        for k,v in pairs(reslist ) do
            UnityEngine.AssetBundle.Unload(v,true)
            v = nil
        end
        --如果 unloadAllLoadedObjects 为true，那么 bundle 和 asset 都可以卸载掉
    end

    local timer0 = FrameTimer.New(function()
        collectgarbage("collect")
        ct.log('abel_w17_load_A_unload_force_s160_mem','[abel_w17_load_A_unload_force_s160_mem] testLoadFun')
        testLoadFun(bundlelist, assetlist, ct.getType(UnityEngine.Sprite))
        local timer = FrameTimer.New(function()
            ct.log('abel_w17_load_A_unload_force_s160_mem','[abel_w17_load_A_unload_force_s160_mem] TestUnLoadFun_force')
            TestUnLoadFun_force(bundlelist)
            bundlelist ={}
            collectgarbage("collect")
        end, 90, 0)
        timer:Start()
    end, 10, 0)
    timer0:Start()
end)

UnitTest.Exec("abel_w17_load_AS_unload_No_force_s160_mem", "abel_w17_load_AS_unload_No_force_s160_mem",  function ()
    local bundlelist ={}        --存放bundle的表
    local assetlist ={}     --存放asset的表
    -- 非unloadAllLoadedObjects 方式卸载测试
    local TestUnLoadFun_No_Force = function(reslist )
        ct.log('abel_w17_load_AS_unload_No_force_s160_mem','[TestUnLoadFun_No_Force] #reslist = '..#reslist)
        for k,v in pairs(reslist ) do
            UnityEngine.AssetBundle.Unload(v,false)
            v = nil
        end
        for k,v in pairs(assetlist) do
            UnityEngine.Resources.UnloadAsset(v)
            GameObject.DestroyImmediate(v, true)
            v = nil
        end
        assetlist = nil
    end

    local timer0 = FrameTimer.New(function()
        collectgarbage("collect")
        ct.log('abel_w17_load_AS_unload_No_force_s160_mem','[abel_w17_load_AS_unload_No_force_s160_mem] testLoadFun')
        testLoadFun(bundlelist, assetlist)
        local timer = FrameTimer.New(function()
            ct.log('abel_w17_load_AS_unload_No_force_s160_mem','[abel_w17_load_AS_unload_No_force_s160_mem] TestUnLoadFun_No_Force')
            TestUnLoadFun_No_Force(bundlelist)
            bundlelist ={}
            collectgarbage("collect")
        end, 90, 0)
        timer:Start()
    end, 10, 0)
    timer0:Start()

    --测试结果
    --如果 unloadAllLoadedObjects 为true，那么 bundle 和 asset 都可以卸载掉
    --如果 unloadAllLoadedObjects 为false，那么 bundle 可以卸载，但是加载到内存的 asset 不能被清理掉
    --那么究竟是哪儿还在引用这些 asset ？
    --[[
    原因找到：
        原来是因为 panelMgr:LoadPrefab_A(ResPathList[i], ptype, nil,function(self, obj ,ab)
        ptype 为 Sprite ,传入这个类型，实际上相当于先 load 了 asset ，然后创建了引用该资源的 Sprite
        也就是说，  GameObject.DestroyImmediate(v, true) 实际上只销毁了 Sprite ，并没有销毁 asset
    --]]
end)

--同步方式加载、卸载的内存测试, 运行时不会使用这种方式加载，但是，这个测试可以用来明确加载不同尺寸的贴图的速度
--[[
    需要提供自定义的加载接口，要满足：
    1、 符合我们项目资源和包的命名约定
            1、 bundle名字为：
                1、 相对路径（相对 view 目录，开头没有'/'）中'/'转为'_'
                2、 扩展名为' .unity3d'
            2、 资源名文件名，不带路径和扩展名
    2、 加载bundle
    3、加载对应资源
    * 注意
        * 2、3步需要扩展一个单独的接口， 类似 panelMgr:LoadPrefab_S
        * 这个测试需要比对尺寸128和160的加载时间
--]]
UnitTest.Exec("abel_w17_load_S_s160_n1000_time", "abel_w17_load_S_s160_n1000_time",  function ()
    local assetlist ={}     --存放asset的表
    --异步加载测试
    local testLoadFun_S = function(reslist,type)
        ct.log('abel_w17_load_S_s160_n1000_time','[testLoadFun_S] #reslist = '..#reslist)
        for i = 1, testcount do
            --注意这里返回的值包括两个数据： asset, bundle
            reslist[#reslist+1] = resMgr:LoadRes_S(ResPathListS[i], type)
        end
    end

    --尺寸128的测试

    --尺寸160的测试
    --加载 sprite
    collectgarbage("collect")
    local t1 = UnitTest.PerformanceTest("abel_w17_load_S_s160_n1000_time","[Sprite同步加载的时间测试]", function()
        testLoadFun_S(assetlist,ct.getType(UnityEngine.Sprite))
    end)
    ct.log('abel_w17_load_S_s160_n1000_time','1000个160大小的Sprite同步加载的时间 = '..t1)

    --卸载
    for k,v in pairs(assetlist ) do
        UnityEngine.AssetBundle.Unload(v._bunldle,true)
        v = nil
    end
    assetlist = {}
    collectgarbage("collect")

    --加载 texture
    local t2 = UnitTest.PerformanceTest("abel_w17_load_S_s160_n1000_time","[Texture同步加载的时间测试]", function()
        testLoadFun_S(assetlist, nil)
    end)
    ct.log('abel_w17_load_S_s160_n1000_time','1000个160大小的Texture同步加载的时间 = '..t2)
    collectgarbage("collect")

    --[[
    测试结果
    pc
        [abel_w17_load_S_s160_n1000_time]1000个160大小的Sprite同步加载的时间 = 20.255
        [abel_w17_load_S_s160_n1000_time]1000个160大小的Texture同步加载的时间 = 19.454
        *  性能差别可以忽略不计
        *  pc 上每帧加载 33.33 / 20.255 = 1.65
    设备
        [abel_w17_load_S_s160_n1000_time]1000个160大小的Sprite同步加载的时间 = 4.293647
        [abel_w17_load_S_s160_n1000_time]1000个160大小的Texture同步加载的时间 = 2.265139
        *  性能差别比较明显，近1倍， 不过一般情况下，滑动滚动条时，加载3屏，一屏10个算，那么一次加载10个，那么加载时间为
        *  设备上每帧加载  33.33 / 5.95 = 5.60
    --]]
end)

--同步下周30张Icon
UnitTest.Exec("abel_w17_load_S_s160_n30_time", "abel_w17_load_S_s160_n30_time",  function ()
    local testcount = 30
    local assetlist ={}     --存放asset的表
    --异步加载测试
    local testLoadFun_S = function(reslist,type)
        ct.log('abel_w17_load_S_s160_n30_time','[testLoadFun_S] #reslist = '..#reslist)
        for i = 1, testcount do
            --注意这里返回的值包括两个数据： asset, bundle
            reslist[#reslist+1] = resMgr:LoadRes_S(ResPathListS[i], type)
        end
    end

    --尺寸128的测试

    --尺寸160的测试
    --加载 sprite
    collectgarbage("collect")
    local t1 = UnitTest.PerformanceTest("abel_w17_load_S_s160_n30_time","[Sprite同步加载的时间测试]", function()
        testLoadFun_S(assetlist,ct.getType(UnityEngine.Sprite))
    end)
    ct.log('abel_w17_load_S_s160_n30_time','30个160大小的Sprite同步加载的时间 = '..t1)

    --卸载
    for k,v in pairs(assetlist ) do
        UnityEngine.AssetBundle.Unload(v._bunldle,true)
        v = nil
    end
    assetlist = {}
    collectgarbage("collect")

    --加载 texture
    local t2 = UnitTest.PerformanceTest("abel_w17_load_S_s160_n30_time","[Texture同步加载的时间测试]", function()
        testLoadFun_S(assetlist, nil)
    end)
    ct.log('abel_w17_load_S_s160_n30_time','30个160大小的Texture同步加载的时间 = '..t2)
    collectgarbage("collect")

    --[[
    测试结果
    pc
        ......
    设备
        [abel_w17_load_S_s160_n30_time]30个160大小的Sprite同步加载的时间 = 0.227158
        [abel_w17_load_S_s160_n30_time]30个160大小的Texture同步加载的时间 = 0.119937
        *  性能差别比较明显，1倍
        *  按一帧 0.03333 秒算， 同步加载 30 个 Sprite 要  0.227158/0.03333 = 6.8 , 将近7帧
        *  异步会比这个快得多
    --]]
end)

--异步加载1000个160 icon 时间测试
UnitTest.Exec("abel_w17_load_A_s160_n1000_time", "abel_w17_load_A_s160_n1000_time",  function ()
    --尺寸160的测试
    local aTester = AsyncSequenceTester:new()

    --初始化测试数据
    aTester.testcount = 1000
    aTester.loadCount = 0
    aTester.bundlelist = {}
    aTester.assertlist = {}
    aTester.startTime = 0
    aTester.ResPathList = ResPathList
    aTester.curPos = 1
    aTester.testSquence = {}

    --异步加载测试,带回调
    local testLoadFunA = function(type, testData, cb)
        for i = 1, testData.testcount do
            panelMgr:LoadPrefab_A(testData.ResPathList[i], type, testData,cb)
        end
    end

    --加载成功后的回调
    local callback = function (testData, obj , ab)
        testData.bundlelist[#testData.bundlelist +1] = ab
        testData.assertlist[#testData.assertlist] = obj
        testData.loadCount = testData.loadCount + 1
        if testData.loadCount >= testData.testcount then
            local costTime = os.clock() - testData.startTime
            ct.log('abel_w17_load_A_s160_n1000_time',testData:getCurSeq().msg ..costTime)

            --卸载

            local pos = #testData.bundlelist
            while pos > 0 do
                if testData.bundlelist[pos] ~= nil then
                    resMgr:UnloadAssetBundle(testData.bundlelist[pos].name, true)
                    --UnityEngine.AssetBundle.Unload(testData.bundlelist[pos],true)
                    table.remove(testData.bundlelist, pos)
                    pos = pos -1
                end
            end

            --testData:Nextfun()
            --collectgarbage("collect")
            --testData:excute()

            local timer = FrameTimer.New(function()
                testData:Nextfun()
                collectgarbage("collect")
                testData:excute()
            end, 90,0)
            timer:Start()
        end
    end

    aTester.testSquence[1] = { fun = testLoadFunA, type = nil, cb = callback, msg = '1000个160大小的 Texture 异步加载的时间 ='}
    aTester.testSquence[2] = { fun = testLoadFunA, type = ct.getType(UnityEngine.Sprite), cb = callback, msg = '1000个160大小的 Sprite 异步加载的时间 = '}

    --开始执行异步测试序列
    collectgarbage("collect")
    aTester:excute()
    --尺寸128的测试
    --[[
    测试结果
    pc
        [abel_w17_load_A_s160_n1000_time]1000个160大小的 Texture 异步加载的时间 =2.2260000000001
        [abel_w17_load_A_s160_n1000_time]1000个160大小的 Sprite 异步加载的时间 = 2.3319999999999
        *  性能差别比不大, 平均每帧可以加载 33.33/2.332 = 14.29 个
    设备
        [abel_w17_load_A_s160_n1000_time]1000个160大小的 Texture 异步加载的时间 =6.757779
        [abel_w17_load_A_s160_n1000_time]1000个160大小的 Sprite 异步加载的时间 = 6.006067
        *  设备上 Sprite 比 Texture 加载的时间还短
            * 这个结论与同步加载的结论一致？
        * 平均每帧可以加载 33.33/6.006067 = 5.555 个（texture 33.33/6.757779 = 4.932 个 ）
        * 比对同步加载
            [abel_w17_load_S_s160_n1000_time]1000个160大小的Texture同步加载的时间 = 2.265139
            [abel_w17_load_S_s160_n1000_time]1000个160大小的Sprite同步加载的时间 = 4.293647
            * Sprite异步加载总的耗时与同步加载差不多；texture 同步加载时间会少不少
            * 同步加载期间会导致程序卡顿
    --]]
end)

--测试 Instantiate 及对应 destory 的性能开销
UnitTest.Exec("abel_w17_Instantiate_destory_s160_n1000", "abel_w17_Instantiate_destory_s160_n1000",  function ()
    --local resTexture = resMgr:LoadRes_S(ResPathListS[1], LuaHelper.GetType("UnityEngine.Texture2D"))
    --local resTexture = resMgr:LoadRes_S(ResPathListS[1], LuaHelper.GetType("UnityEngine_Texture2DWrap"))
    local tp = ct.getType(UnityEngine.Texture2D)
    local tp1 = ct.getType(UnityEngine.Sprite)

    local resTexture = resMgr:LoadRes_S(ResPathListS[1], ct.getType(UnityEngine.Texture2D))
    --[[
    --这里设置贴图资源为 Readable ,否则 Instantiate 会失败，提示为 Instantiating a non-readable texture is not allowed!
    --参考 https://www.cnblogs.com/weigx/p/7300586.html
    --]]
    --resTexture._asset:Apply(true,true)
    local resSprite = resMgr:LoadRes_S(ResPathListS[1], ct.getType(UnityEngine.Sprite))
    local insList_texture = {}
    local insList_sprite = {}

    --实例化1000张Sprite
    local textureIns = UnitTest.PerformanceTest("abel_w17_Instantiate_destory_s160_n1000","[1000 张 Sprite Instantiate 的时间]", function()
        for i = 1, testcount do
            insList_sprite[#insList_sprite+1] = UnityEngine.GameObject.Instantiate(resSprite._asset);
        end
    end)

    --销毁1000张Sprete的实例
    local textureIns = UnitTest.PerformanceTest("abel_w17_Instantiate_destory_s160_n1000","[1000 张 Sprite 销毁 的时间]", function()
        for i, v in pairs(insList_sprite) do
            GameObject.DestroyImmediate(v, true)
        end
        insList_sprite = {}
    end)

    --[[
    测试结果
    [abel_w17_Instantiate_destory_s160_n1000][1000 张 Sprite Instantiate 的时间]        执行时间:     0.014999999999873  一帧 Instantiate 2.22 个
        * 这个数据还只是简单数据的实例化，复杂数据可能会更耗时，所以 Instantiate 一定要慎用
    [abel_w17_Instantiate_destory_s160_n1000][1000 张 Sprite 销毁 的时间]               执行时间:     0.0029999999997017 一帧销毁 11.11 个
    --]]
end)

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



UnitTest.Exec("abel_w17_load_s128_n1000_S_IoTime", "abel_w17_load_s128_n1000_S_IoTime",  function ()

    --load IO执行时间
    local bundlelist = {}
    local assetlist = {}
    collectgarbage("collect")
    UnitTest.PerformanceTest("abel_w17_load_s128_n1000_S_IoTime","[同步加载1000个尺寸为128的执行时间]", function()
        testLoadFun(bundlelist,assetlist)
    end)
    --[[
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
    --]]
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
            local go = UnityEngine.GameObject.Instantiate(resLoad)
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