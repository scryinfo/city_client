--Allen
--基础工具类（单例）
BaseTools = {}

--Table的深拷贝
function BaseTools.TableCopy(obj)
    local InTable = {};
    local function Func(obj)
        if type(obj) ~= "table" then   --判断表中是否有表
            return obj;
        end
        local NewTable = {};  --定义一个新表
        InTable[obj] = NewTable;  --若表中有表，则先把表给InTable，再用NewTable去接收内嵌的表
        for k,v in pairs(obj) do  --把旧表的key和Value赋给新表
            NewTable[Func(k)] = Func(v);
        end
        return setmetatable(NewTable, getmetatable(obj))--赋值元表
    end
    return Func(obj) --若表中有表，则把内嵌的表也复制了
end
