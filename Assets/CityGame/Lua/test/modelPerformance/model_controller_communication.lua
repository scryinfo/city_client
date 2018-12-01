---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/12/1 10:21
---
UnitTest.TestBlockStart()---------------------------------------------------------
--定义一个model基类
local ModelBase = class('ModelBase')
local ControllerBase = class('ControllerBase')

function ModelBase:initialize(name)
    self.name = name
end

function ControllerBase:initialize(name, newInsId)
    self.name = name
    self.insId = newInsId
end

--model类{
Model_1 = class('Model_1',ModelBase)
function Model_1:testfun(arg_int1, arg_int2)
    ct.log("wk16_abel_controller_model", "[Model_1:testfun] invoked!")
    return #self.name+arg_int1+arg_int2
end

Model_2 = class('Model_2',ModelBase)
function Model_2:testfun(arg_str)
    ct.log("wk16_abel_controller_model", "[Model_2:testfun] invoked!")
    return self.name..arg_str
end
--model类}

--model管理器类{
ModelManager = class('ModelManager')
local modelList = {}
function ModelManager:initialize()
    modelList = {}
end
function ModelManager:addModel(model)
    modelList[#modelList+1] = model
end
function ModelManager.modelRpc(insId, modelMethord, callback,...)
    if md ~= nil then
        local md = modelList[insId]
        assert(md, 'model not exist which instance id = ',insId)
        assert(md[modelMethord], 'Methord: '..modelMethord..' not exist,model instance id = '..insId)
        local ret = md[modelMethord](md,...)
        if callback ~= nil then
            callback(ret)
        end
    end
end

--全局方法
function ct.model_rpc(insId, modelMethord, callback, ...)
    ModelManager.modelRpc(insId, modelMethord, callback,...)
end
--model管理器类}

--controller类{
Crtl_1 = class('Crtl_1',ControllerBase)
function Crtl_1:initialize(name, newInsId)
    ControllerBase.initialize(self, name,newInsId)
end
function Crtl_1:reqDatafun(arg_int1, arg_int2)
    ct.model_rpc(self.insId, 'testfun',function (retvalue)
        ct.log('wk16_abel_controller_model', '[Crtl_1:reqDatafun] return: '..retvalue)
    end,  arg_int1,arg_int2)
end

Crtl_2 = class('Crtl_2',ControllerBase)
function Crtl_2:initialize(name, newInsId)
    ControllerBase.initialize(self, name,newInsId)
end
function Crtl_2:reqDatafun(arg_str)
    ct.model_rpc(self.insId, 'testfun',function (retvalue)
        ct.log('wk16_abel_controller_model', '[Crtl_2:reqDatafun] return: '..retvalue)
    end, arg_str)
end
--controller类}


UnitTest.Exec("wk16_abel_controller_model", "test_wk16_abel_controller_model",  function ()
    --数据准备{
    local ModelManager = ModelManager
    ModelManager.initialize()
    local test_count = 100
    for i = 1, test_count do
        ModelManager.addModel(nil,Model_1:new('Model_1'..i))
    end
    for i = test_count, test_count *2 do
        ModelManager.addModel(nil,Model_2:new('Model_2'..i))
    end

    local pCrtl_1 = Crtl_1:new('Crtl_1_ins', ct.getIntPart(test_count*0.5) )
    local pCrtl_2 = Crtl_2:new('Crtl_1_ins',ct.getIntPart(test_count*1.5))
    --数据准备}
    --测试{
    pCrtl_1:reqDatafun(1,2)
    pCrtl_2:reqDatafun('hello')

    --不存在的方法
    ct.model_rpc(pCrtl_2.insId, 'testfun1',function (retvalue)
        ct.log('wk16_abel_controller_model', '[Crtl_2:reqDatafun] return: '..retvalue)
    end, 'hello')

    ModelManager.modelRpc(ctr2_IdCache,'testfun', 1,2,function()

    end)

    --测试}
end)

UnitTest.TestBlockEnd()-----------------------------------------------------------