--
-- Collect memory reference info.
--
-- @filename  MemoryReferenceInfo.lua
-- @author    WangYaoqi
-- @date      2016-02-03

-- The global config of the mri.
local cConfig = 
{
    m_bAllMemoryRefFileAddTime = false,
    m_bSingleMemoryRefFileAddTime = false,
    m_bComparedMemoryRefFileAddTime = false
}

-- Get the format string of date time.
local function FormatDateTimeNow()
	local cDateTime = os.date("*t")
	local strDateTime = string.format("%04d%02d%02d-%02d%02d%02d", tostring(cDateTime.year), tostring(cDateTime.month), tostring(cDateTime.day),
		tostring(cDateTime.hour), tostring(cDateTime.min), tostring(cDateTime.sec))
	return strDateTime
end

-- Get the string result without overrided __tostring.
local function GetOriginalToStringResult(cObject)
	if not cObject then
		return ""
	end

	local cMt = getmetatable(cObject)
	if not cMt then
		return tostring(cObject)
	end

	-- Check tostring override.
	local strName = ""
	local cToString = rawget(cMt, "__tostring")
	if cToString then
		rawset(cMt, "__tostring", nil)
		strName = tostring(cObject)
		rawset(cMt, "__tostring", cToString)
	else
		strName = tostring(cObject)
	end

	return strName
end

-- Create a container to collect the mem ref info results.
local function CreateObjectReferenceInfoContainer()
	-- Create new container.
	local cContainer = {}

	-- Contain [table/function] - [reference count] info.
	local cObjectReferenceCount = {}
	setmetatable(cObjectReferenceCount, {__mode = "k"})

	-- Contain [table/function] - [name] info.
	local cObjectAddressToName = {}
	setmetatable(cObjectAddressToName, {__mode = "k"})

	-- Set members.
	cContainer.m_cObjectReferenceCount = cObjectReferenceCount
	cContainer.m_cObjectAddressToName = cObjectAddressToName

	-- For stack info.
	cContainer.m_nStackLevel = -1
	cContainer.m_strShortSrc = "None"
	cContainer.m_nCurrentLine = -1

	return cContainer
end

-- Create a container to collect the mem ref info results from a dumped file.
-- strFilePath - The file path.
local function CreateObjectReferenceInfoContainerFromFile(strFilePath)
	-- Create a empty container.
	local cContainer = CreateObjectReferenceInfoContainer()
	cContainer.m_strShortSrc = strFilePath

	-- Cache ref info.
	local cRefInfo = cContainer.m_cObjectReferenceCount
	local cNameInfo = cContainer.m_cObjectAddressToName

	-- Read each line from file.
	local cFile = assert(io.open(strFilePath, "rb"))
	for strLine in cFile:lines() do
		local strHeader = string.sub(strLine, 1, 2)
		if "--" ~= strHeader then
			local _, _, strAddr, strName, strRefCount= string.find(strLine, "(.+)\t(.*)\t(%d+)")
			if strAddr then
				cRefInfo[strAddr] = strRefCount
				cNameInfo[strAddr] = strName
			end
		end
	end

    -- Close and clear file handler.
    io.close(cFile)
    cFile = nil

	return cContainer
end

-- Create a container to collect the mem ref info results from a dumped file.
-- strObjectName - The object name you need to collect info.
-- cObject - The object you need to collect info.
local function CreateSingleObjectReferenceInfoContainer(strObjectName, cObject)
	-- Create new container.
	local cContainer = {}

	-- Contain [address] - [true] info.
	local cObjectExistTag = {}
	setmetatable(cObjectExistTag, {__mode = "k"})

	-- Contain [name] - [true] info.
	local cObjectAliasName = {}

	-- Contain [access] - [true] info.
	local cObjectAccessTag = {}
	setmetatable(cObjectAccessTag, {__mode = "k"})

	-- Set members.
	cContainer.m_cObjectExistTag = cObjectExistTag
	cContainer.m_cObjectAliasName = cObjectAliasName
	cContainer.m_cObjectAccessTag = cObjectAccessTag

	-- For stack info.
	cContainer.m_nStackLevel = -1
	cContainer.m_strShortSrc = "None"
	cContainer.m_nCurrentLine = -1

	-- Init with object values.
	cContainer.m_strObjectName = strObjectName
	cContainer.m_strAddressName = (("string" == type(cObject)) and ("\"" .. tostring(cObject) .. "\"")) or GetOriginalToStringResult(cObject)
	cContainer.m_cObjectExistTag[cObject] = true

	return cContainer
end

-- Collect memory reference info from a root table or function.
-- strName - The root object name that start to search, default is "_G" if leave this to nil.
-- cObject - The root object that start to search, default is _G if leave this to nil.
-- cDumpInfoContainer - The container of the dump result info.
local function CollectObjectReferenceInMemory(strName, cObject, cDumpInfoContainer)
	if not cObject then
		return
	end

	if not strName then
		strName = ""
	end

	-- Check container.
	if (not cDumpInfoContainer) then
		cDumpInfoContainer = CreateObjectReferenceInfoContainer()
	end

	-- Check stack.
	if cDumpInfoContainer.m_nStackLevel > 0 then
		local cStackInfo = debug.getinfo(cDumpInfoContainer.m_nStackLevel, "Sl")
		if cStackInfo then
			cDumpInfoContainer.m_strShortSrc = cStackInfo.short_src
			cDumpInfoContainer.m_nCurrentLine = cStackInfo.currentline
		end

		cDumpInfoContainer.m_nStackLevel = -1
	end

	-- Get ref and name info.
	local cRefInfoContainer = cDumpInfoContainer.m_cObjectReferenceCount
	local cNameInfoContainer = cDumpInfoContainer.m_cObjectAddressToName
	
	local strType = type(cObject)
	if "table" == strType then
		-- Check table with class name.
		if rawget(cObject, "__cname") then
			if "string" == type(cObject.__cname) then
				strName = strName .. "[class:" .. cObject.__cname .. "]"
			end
		elseif rawget(cObject, "class") then
			if "string" == type(cObject.class) then
				strName = strName .. "[class:" .. cObject.class .. "]"
			end
		elseif rawget(cObject, "_className") then
			if "string" == type(cObject._className) then
				strName = strName .. "[class:" .. cObject._className .. "]"
			end
		end

		-- Check if table is _G.
		if cObject == _G then
			strName = strName .. "[_G]"
		end

		-- Get metatable.
		local bWeakK = false
		local bWeakV = false
		local cMt = getmetatable(cObject)
		if cMt then
			-- Check mode.
			local strMode = rawget(cMt, "__mode")
			if strMode then
				if "k" == strMode then
					bWeakK = true
				elseif "v" == strMode then
					bWeakV = true
				elseif "kv" == strMode then
					bWeakK = true
					bWeakV = true
				end
			end
		end

		-- Add reference and name.
		cRefInfoContainer[cObject] = (cRefInfoContainer[cObject] and (cRefInfoContainer[cObject] + 1)) or 1
		if cNameInfoContainer[cObject] then
			return
		end

		-- Set name.
		cNameInfoContainer[cObject] = strName

		-- Dump table key and value.
		for k, v in pairs(cObject) do
			-- Check key type.
			local strKeyType = type(k)
			if "table" == strKeyType then
				if not bWeakK then
					CollectObjectReferenceInMemory(strName .. ".[table:key.table]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			elseif "function" == strKeyType then
				if not bWeakK then
					CollectObjectReferenceInMemory(strName .. ".[table:key.function]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			elseif "thread" == strKeyType then
				if not bWeakK then
					CollectObjectReferenceInMemory(strName .. ".[table:key.thread]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			elseif "userdata" == strKeyType then
				if not bWeakK then
					CollectObjectReferenceInMemory(strName .. ".[table:key.userdata]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			else
				CollectObjectReferenceInMemory(strName .. "." .. k, v, cDumpInfoContainer)
			end
		end

		-- Dump metatable.
		if cMt then
			CollectObjectReferenceInMemory(strName ..".[metatable]", cMt, cDumpInfoContainer)
		end
	elseif "function" == strType then
		-- Get function info.
		local cDInfo = debug.getinfo(cObject, "Su")

		-- Write this info.
		cRefInfoContainer[cObject] = (cRefInfoContainer[cObject] and (cRefInfoContainer[cObject] + 1)) or 1
		if cNameInfoContainer[cObject] then
			return
		end

		-- Set name.
		cNameInfoContainer[cObject] = strName .. "[line:" .. tostring(cDInfo.linedefined) .. "@file:" .. cDInfo.short_src .. "]"

		-- Get upvalues.
		local nUpsNum = cDInfo.nups
		for i = 1, nUpsNum do
			local strUpName, cUpValue = debug.getupvalue(cObject, i)
			local strUpValueType = type(cUpValue)
			--print(strUpName, cUpValue)
			if "table" == strUpValueType then
				CollectObjectReferenceInMemory(strName .. ".[ups:table:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			elseif "function" == strUpValueType then
				CollectObjectReferenceInMemory(strName .. ".[ups:function:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			elseif "thread" == strUpValueType then
				CollectObjectReferenceInMemory(strName .. ".[ups:thread:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			elseif "userdata" == strUpValueType then
				CollectObjectReferenceInMemory(strName .. ".[ups:userdata:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			end
		end

		-- Dump environment table.
		local getfenv = debug.getfenv
		if getfenv then
			local cEnv = getfenv(cObject)
			if cEnv then
				CollectObjectReferenceInMemory(strName ..".[function:environment]", cEnv, cDumpInfoContainer)
			end
		end
	elseif "thread" == strType then
		-- Add reference and name.
		cRefInfoContainer[cObject] = (cRefInfoContainer[cObject] and (cRefInfoContainer[cObject] + 1)) or 1
		if cNameInfoContainer[cObject] then
			return
		end

		-- Set name.
		cNameInfoContainer[cObject] = strName

		-- Dump environment table.
		local getfenv = debug.getfenv
		if getfenv then
			local cEnv = getfenv(cObject)
			if cEnv then
				CollectObjectReferenceInMemory(strName ..".[thread:environment]", cEnv, cDumpInfoContainer)
			end
		end

		-- Dump metatable.
		local cMt = getmetatable(cObject)
		if cMt then
			CollectObjectReferenceInMemory(strName ..".[thread:metatable]", cMt, cDumpInfoContainer)
		end
	elseif "userdata" == strType then
		-- Add reference and name.
		cRefInfoContainer[cObject] = (cRefInfoContainer[cObject] and (cRefInfoContainer[cObject] + 1)) or 1
		if cNameInfoContainer[cObject] then
			return
		end

		-- Set name.
		cNameInfoContainer[cObject] = strName

		-- Dump environment table.
		local getfenv = debug.getfenv
		if getfenv then
			local cEnv = getfenv(cObject)
			if cEnv then
				CollectObjectReferenceInMemory(strName ..".[userdata:environment]", cEnv, cDumpInfoContainer)
			end
		end

		-- Dump metatable.
		local cMt = getmetatable(cObject)
		if cMt then
			CollectObjectReferenceInMemory(strName ..".[userdata:metatable]", cMt, cDumpInfoContainer)
		end
    elseif "string" == strType then
        -- Add reference and name.
        cRefInfoContainer[cObject] = (cRefInfoContainer[cObject] and (cRefInfoContainer[cObject] + 1)) or 1
        if cNameInfoContainer[cObject] then
            return
        end

        -- Set name.
        cNameInfoContainer[cObject] = strName .. "[" .. strType .. "]"
	else
		-- For "number" and "boolean". (If you want to dump them, uncomment the followed lines.)

		-- -- Add reference and name.
		-- cRefInfoContainer[cObject] = (cRefInfoContainer[cObject] and (cRefInfoContainer[cObject] + 1)) or 1
		-- if cNameInfoContainer[cObject] then
		-- 	return
		-- end

		-- -- Set name.
		-- cNameInfoContainer[cObject] = strName .. "[" .. strType .. ":" .. tostring(cObject) .. "]"
	end
end

-- Collect memory reference info of a single object from a root table or function.
-- strName - The root object name that start to search, can not be nil.
-- cObject - The root object that start to search, can not be nil.
-- cDumpInfoContainer - The container of the dump result info.
local function CollectSingleObjectReferenceInMemory(strName, cObject, cDumpInfoContainer)
	if not cObject then
		return
	end

	if not strName then
		strName = ""
	end

	-- Check container.
	if (not cDumpInfoContainer) then
		cDumpInfoContainer = CreateObjectReferenceInfoContainer()
	end

	-- Check stack.
	if cDumpInfoContainer.m_nStackLevel > 0 then
		local cStackInfo = debug.getinfo(cDumpInfoContainer.m_nStackLevel, "Sl")
		if cStackInfo then
			cDumpInfoContainer.m_strShortSrc = cStackInfo.short_src
			cDumpInfoContainer.m_nCurrentLine = cStackInfo.currentline
		end

		cDumpInfoContainer.m_nStackLevel = -1
	end

	local cExistTag = cDumpInfoContainer.m_cObjectExistTag
	local cNameAllAlias = cDumpInfoContainer.m_cObjectAliasName
	local cAccessTag = cDumpInfoContainer.m_cObjectAccessTag
	
	local strType = type(cObject)
	if "table" == strType then
		-- Check table with class name.
		if rawget(cObject, "__cname") then
			if "string" == type(cObject.__cname) then
				strName = strName .. "[class:" .. cObject.__cname .. "]"
			end
		elseif rawget(cObject, "class") then
			if "string" == type(cObject.class) then
				strName = strName .. "[class:" .. cObject.class .. "]"
			end
		elseif rawget(cObject, "_className") then
			if "string" == type(cObject._className) then
				strName = strName .. "[class:" .. cObject._className .. "]"
			end
		end

		-- Check if table is _G.
		if cObject == _G then
			strName = strName .. "[_G]"
		end

		-- Get metatable.
		local bWeakK = false
		local bWeakV = false
		local cMt = getmetatable(cObject)
		if cMt then
			-- Check mode.
			local strMode = rawget(cMt, "__mode")
			if strMode then
				if "k" == strMode then
					bWeakK = true
				elseif "v" == strMode then
					bWeakV = true
				elseif "kv" == strMode then
					bWeakK = true
					bWeakV = true
				end
			end
		end

		-- Check if the specified object.
		if cExistTag[cObject] and (not cNameAllAlias[strName]) then
			cNameAllAlias[strName] = true
		end

		-- Add reference and name.
		if cAccessTag[cObject] then
			return
		end

		-- Get this name.
		cAccessTag[cObject] = true

		-- Dump table key and value.
		for k, v in pairs(cObject) do
			-- Check key type.
			local strKeyType = type(k)
			if "table" == strKeyType then
				if not bWeakK then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:key.table]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			elseif "function" == strKeyType then
				if not bWeakK then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:key.function]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			elseif "thread" == strKeyType then
				if not bWeakK then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:key.thread]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			elseif "userdata" == strKeyType then
				if not bWeakK then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:key.userdata]", k, cDumpInfoContainer)
				end

				if not bWeakV then
					CollectSingleObjectReferenceInMemory(strName .. ".[table:value]", v, cDumpInfoContainer)
				end
			else
				CollectSingleObjectReferenceInMemory(strName .. "." .. k, v, cDumpInfoContainer)
			end
		end

		-- Dump metatable.
		if cMt then
			CollectSingleObjectReferenceInMemory(strName ..".[metatable]", cMt, cDumpInfoContainer)
		end
	elseif "function" == strType then
		-- Get function info.
		local cDInfo = debug.getinfo(cObject, "Su")
		local cCombinedName = strName .. "[line:" .. tostring(cDInfo.linedefined) .. "@file:" .. cDInfo.short_src .. "]"

		-- Check if the specified object.
		if cExistTag[cObject] and (not cNameAllAlias[cCombinedName]) then
			cNameAllAlias[cCombinedName] = true
		end

		-- Write this info.
		if cAccessTag[cObject] then
			return
		end

		-- Set name.
		cAccessTag[cObject] = true

		-- Get upvalues.
		local nUpsNum = cDInfo.nups
		for i = 1, nUpsNum do
			local strUpName, cUpValue = debug.getupvalue(cObject, i)
			local strUpValueType = type(cUpValue)
			--print(strUpName, cUpValue)
			if "table" == strUpValueType then
				CollectSingleObjectReferenceInMemory(strName .. ".[ups:table:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			elseif "function" == strUpValueType then
				CollectSingleObjectReferenceInMemory(strName .. ".[ups:function:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			elseif "thread" == strUpValueType then
				CollectSingleObjectReferenceInMemory(strName .. ".[ups:thread:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			elseif "userdata" == strUpValueType then
				CollectSingleObjectReferenceInMemory(strName .. ".[ups:userdata:" .. strUpName .. "]", cUpValue, cDumpInfoContainer)
			end
		end

		-- Dump environment table.
		local getfenv = debug.getfenv
		if getfenv then
			local cEnv = getfenv(cObject)
			if cEnv then
				CollectSingleObjectReferenceInMemory(strName ..".[function:environment]", cEnv, cDumpInfoContainer)
			end
		end
	elseif "thread" == strType then
		-- Check if the specified object.
		if cExistTag[cObject] and (not cNameAllAlias[strName]) then
			cNameAllAlias[strName] = true
		end

		-- Add reference and name.
		if cAccessTag[cObject] then
			return
		end

		-- Get this name.
		cAccessTag[cObject] = true

		-- Dump environment table.
		local getfenv = debug.getfenv
		if getfenv then
			local cEnv = getfenv(cObject)
			if cEnv then
				CollectSingleObjectReferenceInMemory(strName ..".[thread:environment]", cEnv, cDumpInfoContainer)
			end
		end

		-- Dump metatable.
		local cMt = getmetatable(cObject)
		if cMt then
			CollectSingleObjectReferenceInMemory(strName ..".[thread:metatable]", cMt, cDumpInfoContainer)
		end
	elseif "userdata" == strType then
		-- Check if the specified object.
		if cExistTag[cObject] and (not cNameAllAlias[strName]) then
			cNameAllAlias[strName] = true
		end

		-- Add reference and name.
		if cAccessTag[cObject] then
			return
		end

		-- Get this name.
		cAccessTag[cObject] = true

		-- Dump environment table.
		local getfenv = debug.getfenv
		if getfenv then
			local cEnv = getfenv(cObject)
			if cEnv then
				CollectSingleObjectReferenceInMemory(strName ..".[userdata:environment]", cEnv, cDumpInfoContainer)
			end
		end

		-- Dump metatable.
		local cMt = getmetatable(cObject)
		if cMt then
			CollectSingleObjectReferenceInMemory(strName ..".[userdata:metatable]", cMt, cDumpInfoContainer)
		end
    elseif "string" == strType then
        -- Check if the specified object.
        if cExistTag[cObject] and (not cNameAllAlias[strName]) then
            cNameAllAlias[strName] = true
        end

        -- Add reference and name.
        if cAccessTag[cObject] then
            return
        end

        -- Get this name.
        cAccessTag[cObject] = true
    else
        -- For "number" and "boolean" type, they are not object type, skip.
	end
end

-- The base method to dump a mem ref info result into a file.
-- strSavePath - The save path of the file to store the result, must be a directory path, If nil or "" then the result will output to console as print does.
-- strExtraFileName - If you want to add extra info append to the end of the result file, give a string, nothing will do if set to nil or "".
-- nMaxRescords - How many rescords of the results in limit to save in the file or output to the console, -1 will give all the result.
-- strRootObjectName - The header info to show the root object name, can be nil.
-- cRootObject - The header info to show the root object address, can be nil.
-- cDumpInfoResultsBase - The base dumped mem info result, nil means no compare and only output cDumpInfoResults, otherwise to compare with cDumpInfoResults.
-- cDumpInfoResults - The compared dumped mem info result, dump itself only if cDumpInfoResultsBase is nil, otherwise dump compared results with cDumpInfoResultsBase.
local function OutputMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, strRootObjectName, cRootObject, cDumpInfoResultsBase, cDumpInfoResults)
	-- Check results.
	if not cDumpInfoResults then
		return
	end

	-- Get time format string.
	local strDateTime = FormatDateTimeNow()

	-- Collect memory info.
	local cRefInfoBase = (cDumpInfoResultsBase and cDumpInfoResultsBase.m_cObjectReferenceCount) or nil
	local cNameInfoBase = (cDumpInfoResultsBase and cDumpInfoResultsBase.m_cObjectAddressToName) or nil
	local cRefInfo = cDumpInfoResults.m_cObjectReferenceCount
	local cNameInfo = cDumpInfoResults.m_cObjectAddressToName
	
	-- Create a cache result to sort by ref count.
	local cRes = {}
	local nIdx = 0
	for k in pairs(cRefInfo) do
		nIdx = nIdx + 1
		cRes[nIdx] = k
	end

	-- Sort result.
	table.sort(cRes, function (l, r)
		return cRefInfo[l] > cRefInfo[r]
	end)

	-- Save result to file.
	local bOutputFile = strSavePath and (string.len(strSavePath) > 0)
	local cOutputHandle = nil
	local cOutputEntry = print
	
	if bOutputFile then
		-- Check save path affix.
		local strAffix = string.sub(strSavePath, -1)
		if ("/" ~= strAffix) and ("\\" ~= strAffix) then
			strSavePath = strSavePath .. "/"
		end

		-- Combine file name.
		--local strFileName = strSavePath .. "LuaMemRefInfo-All"
		local strFileName = strSavePath
		if (not strExtraFileName) or (0 == string.len(strExtraFileName)) then
            if cDumpInfoResultsBase then
                if cConfig.m_bComparedMemoryRefFileAddTime then
                    strFileName = strFileName .. "[" .. strDateTime .. "].txt"
                else
                    strFileName = strFileName .. ".txt"
                end
            else
                if cConfig.m_bAllMemoryRefFileAddTime then
                    strFileName = strFileName .. "[" .. strDateTime .. "].txt"
                else
                    strFileName = strFileName .. ".txt"
                end
            end
		else
            if cDumpInfoResultsBase then
                if cConfig.m_bComparedMemoryRefFileAddTime then
                    strFileName = strFileName .. strDateTime .. strExtraFileName .. ".txt"
                else
                    strFileName = strFileName .. strExtraFileName .. ".txt"
                end
            else
                if cConfig.m_bAllMemoryRefFileAddTime then
                    strFileName = strFileName .. strDateTime .. strExtraFileName .. ".txt"
                else
                    strFileName = strFileName ..strExtraFileName .. ".txt"
                end
            end
		end

		local cFile = assert(io.open(strFileName, "w"))
		cOutputHandle = cFile
		cOutputEntry = cFile.write
	end

	local cOutputer = function (strContent)
		if cOutputHandle then
			cOutputEntry(cOutputHandle, strContent)
		else
			cOutputEntry(strContent)
		end
	end

	-- Write table header.
	if cDumpInfoResultsBase then
		cOutputer("--------------------------------------------------------\n")
		cOutputer("-- This is compared memory information.\n")

		cOutputer("--------------------------------------------------------\n")
		cOutputer("-- Collect base memory reference at line:" .. tostring(cDumpInfoResultsBase.m_nCurrentLine) .. "@file:" .. cDumpInfoResultsBase.m_strShortSrc .. "\n")
		cOutputer("-- Collect compared memory reference at line:" .. tostring(cDumpInfoResults.m_nCurrentLine) .. "@file:" .. cDumpInfoResults.m_strShortSrc .. "\n")
	else
		cOutputer("--------------------------------------------------------\n")
		cOutputer("-- Collect memory reference at line:" .. tostring(cDumpInfoResults.m_nCurrentLine) .. "@file:" .. cDumpInfoResults.m_strShortSrc .. "\n")
	end

	cOutputer("--------------------------------------------------------\n")
	cOutputer("-- [Table/Function/String Address/Name]\t[Reference Path]\t[Reference Count]\n")
	cOutputer("--------------------------------------------------------\n")

	if strRootObjectName and cRootObject then
        if "string" == type(cRootObject) then
            cOutputer("-- From Root Object: \"" .. tostring(cRootObject) .. "\" (" .. strRootObjectName .. ")\n")
        else
            cOutputer("-- From Root Object: " .. GetOriginalToStringResult(cRootObject) .. " (" .. strRootObjectName .. ")\n")
        end
	end

	-- Save each info.
	for i, v in ipairs(cRes) do
		if (not cDumpInfoResultsBase) or (not cRefInfoBase[v]) then
			if (nMaxRescords > 0) then
				if (i <= nMaxRescords) then
                    if "string" == type(v) then
                        local strOrgString = tostring(v)
                        local nPattenBegin, nPattenEnd = string.find(strOrgString, "string: \".*\"")
                        if ((not cDumpInfoResultsBase) and ((nil == nPattenBegin) or (nil == nPattenEnd))) then
                            local strRepString = string.gsub(strOrgString, "([\n\r])", "\\n")
                            cOutputer("string: \"" .. strRepString .. "\"\t" .. cNameInfo[v] .. "\t" .. tostring(cRefInfo[v]) .. "\n")
                        else
                            cOutputer(tostring(v) .. "\t" .. cNameInfo[v] .. "\t" .. tostring(cRefInfo[v]) .. "\n")
                        end
                    else
                        cOutputer(GetOriginalToStringResult(v) .. "\t" .. cNameInfo[v] .. "\t" .. tostring(cRefInfo[v]) .. "\n")
                    end
				end
			else
                if "string" == type(v) then
                    local strOrgString = tostring(v)
                    local nPattenBegin, nPattenEnd = string.find(strOrgString, "string: \".*\"")
                    if ((not cDumpInfoResultsBase) and ((nil == nPattenBegin) or (nil == nPattenEnd))) then
                        local strRepString = string.gsub(strOrgString, "([\n\r])", "\\n")
                        cOutputer("string: \"" .. strRepString .. "\"\t" .. cNameInfo[v] .. "\t" .. tostring(cRefInfo[v]) .. "\n")
                    else
                        cOutputer(tostring(v) .. "\t" .. cNameInfo[v] .. "\t" .. tostring(cRefInfo[v]) .. "\n")
                    end
				else
                    cOutputer(GetOriginalToStringResult(v) .. "\t" .. cNameInfo[v] .. "\t" .. tostring(cRefInfo[v]) .. "\n")
                end
			end
		end
	end

	if bOutputFile then
		io.close(cOutputHandle)
        cOutputHandle = nil
	end
end

-- The base method to dump a mem ref info result of a single object into a file.
-- strSavePath - The save path of the file to store the result, must be a directory path, If nil or "" then the result will output to console as print does.
-- strExtraFileName - If you want to add extra info append to the end of the result file, give a string, nothing will do if set to nil or "".
-- nMaxRescords - How many rescords of the results in limit to save in the file or output to the console, -1 will give all the result.
-- cDumpInfoResults - The dumped results.
local function OutputMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, cDumpInfoResults)
	-- Check results.
	if not cDumpInfoResults then
		return
	end

	-- Get time format string.
	local strDateTime = FormatDateTimeNow()

	-- Collect memory info.
	local cObjectAliasName = cDumpInfoResults.m_cObjectAliasName

	-- Save result to file.
	local bOutputFile = strSavePath and (string.len(strSavePath) > 0)
	local cOutputHandle = nil
	local cOutputEntry = print
	
	if bOutputFile then
		-- Check save path affix.
		local strAffix = string.sub(strSavePath, -1)
		if ("/" ~= strAffix) and ("\\" ~= strAffix) then
			strSavePath = strSavePath .. "/"
		end

		-- Combine file name.
		local strFileName = strSavePath .. "LuaMemRefInfo-Single"
		if (not strExtraFileName) or (0 == string.len(strExtraFileName)) then
            if cConfig.m_bSingleMemoryRefFileAddTime then
                strFileName = strFileName .. "[" .. strDateTime .. "].txt"
            else
                strFileName = strFileName .. ".txt"
            end
		else
            if cConfig.m_bSingleMemoryRefFileAddTime then
                strFileName = strFileName .. "[" .. strDateTime .. "]-[" .. strExtraFileName .. "].txt"
            else
                strFileName = strFileName .. "[" .. strExtraFileName .. "].txt"
            end
		end

		local cFile = assert(io.open(strFileName, "w"))
		cOutputHandle = cFile
		cOutputEntry = cFile.write
	end

	local cOutputer = function (strContent)
		if cOutputHandle then
			cOutputEntry(cOutputHandle, strContent)
		else
			cOutputEntry(strContent)
		end
	end

	-- Write table header.
	cOutputer("--------------------------------------------------------\n")
	cOutputer("-- Collect single object memory reference at line:" .. tostring(cDumpInfoResults.m_nCurrentLine) .. "@file:" .. cDumpInfoResults.m_strShortSrc .. "\n")
	cOutputer("--------------------------------------------------------\n")

	-- Calculate reference count.
	local nCount = 0
	for k in pairs(cObjectAliasName) do
		nCount = nCount + 1
	end

	-- Output reference count.
	cOutputer("-- For Object: " .. cDumpInfoResults.m_strAddressName .. " (" .. cDumpInfoResults.m_strObjectName .. "), have " .. tostring(nCount) .. " reference in total.\n")
	cOutputer("--------------------------------------------------------\n")

	-- Save each info.
	for k in pairs(cObjectAliasName) do
		if (nMaxRescords > 0) then
			if (i <= nMaxRescords) then
				cOutputer(k .. "\n")
			end
		else
			cOutputer(k .. "\n")
		end
	end

	if bOutputFile then
		io.close(cOutputHandle)
        cOutputHandle = nil
	end
end

-- Fileter an existing result file and output it.
-- strFilePath - The existing result file.
-- strFilter - The filter string.
-- bIncludeFilter - Include(true) or exclude(false) the filter.
-- bOutputFile - Output to file(true) or console(false).
local function OutputFilteredResult(strFilePath, strFilter, bIncludeFilter, bOutputFile)
	if (not strFilePath) or (0 == string.len(strFilePath)) then
		print("You need to specify a file path.")
		return
	end

	if (not strFilter) or (0 == string.len(strFilter)) then
		print("You need to specify a filter string.")
		return
	end

	-- Read file.
	local cFilteredResult = {}
    local cReadFile = assert(io.open(strFilePath, "rb"))
	for strLine in cReadFile:lines() do
		local nBegin, nEnd = string.find(strLine, strFilter)
		if nBegin and nEnd then
			if bIncludeFilter then
                nBegin, nEnd = string.find(strLine, "[\r\n]")
                if nBegin and nEnd  and (string.len(strLine) == nEnd) then
                    table.insert(cFilteredResult, string.sub(strLine, 1, nBegin - 1))
                else
				    table.insert(cFilteredResult, strLine)
                end
			end
		else
			if not bIncludeFilter then
                nBegin, nEnd = string.find(strLine, "[\r\n]")
                if nBegin and nEnd and (string.len(strLine) == nEnd) then
                    table.insert(cFilteredResult, string.sub(strLine, 1, nBegin - 1))
                else
				    table.insert(cFilteredResult, strLine)
                end
			end
		end
	end

    -- Close and clear read file handle.
    io.close(cReadFile)
    cReadFile = nil

	-- Write filtered result.
	local cOutputHandle = nil
	local cOutputEntry = print

	if bOutputFile then
		-- Combine file name.
		local _, _, strResFileName = string.find(strFilePath, "(.*)%.txt")
		strResFileName = strResFileName .. "-Filter-" .. ((bIncludeFilter and "I") or "E") .. "-[" .. strFilter .. "].txt"

		local cFile = assert(io.open(strResFileName, "w"))
		cOutputHandle = cFile
		cOutputEntry = cFile.write
	end

	local cOutputer = function (strContent)
		if cOutputHandle then
			cOutputEntry(cOutputHandle, strContent)
		else
			cOutputEntry(strContent)
		end
	end

	-- Output result.
	for i, v in ipairs(cFilteredResult) do
		cOutputer(v .. "\n")
	end

	if bOutputFile then
		io.close(cOutputHandle)
        cOutputHandle = nil
	end
end

-- Dump memory reference at current time.
-- strSavePath - The save path of the file to store the result, must be a directory path, If nil or "" then the result will output to console as print does.
-- strExtraFileName - If you want to add extra info append to the end of the result file, give a string, nothing will do if set to nil or "".
-- nMaxRescords - How many rescords of the results in limit to save in the file or output to the console, -1 will give all the result.
-- strRootObjectName - The root object name that start to search, default is "_G" if leave this to nil.
-- cRootObject - The root object that start to search, default is _G if leave this to nil.
local function DumpMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, strRootObjectName, cRootObject)
	-- Get time format string.
	local strDateTime = FormatDateTimeNow()

	-- Check root object.
	if cRootObject then
		if (not strRootObjectName) or (0 == string.len(strRootObjectName)) then
			strRootObjectName = tostring(cRootObject)
		end
	else
		cRootObject = debug.getregistry()
		strRootObjectName = "registry"
	end

	-- Create container.
	local cDumpInfoContainer = CreateObjectReferenceInfoContainer()
	local cStackInfo = debug.getinfo(2, "Sl")
	if cStackInfo then
		cDumpInfoContainer.m_strShortSrc = cStackInfo.short_src
		cDumpInfoContainer.m_nCurrentLine = cStackInfo.currentline
	end

	-- Collect memory info.
	CollectObjectReferenceInMemory(strRootObjectName, cRootObject, cDumpInfoContainer)
	
	-- Dump the result.
	OutputMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, strRootObjectName, cRootObject, nil, cDumpInfoContainer)
end

-- Dump compared memory reference results generated by DumpMemorySnapshot.
-- strSavePath - The save path of the file to store the result, must be a directory path, If nil or "" then the result will output to console as print does.
-- strExtraFileName - If you want to add extra info append to the end of the result file, give a string, nothing will do if set to nil or "".
-- nMaxRescords - How many rescords of the results in limit to save in the file or output to the console, -1 will give all the result.
-- cResultBefore - The base dumped results.
-- cResultAfter - The compared dumped results.
local function DumpMemorySnapshotCompared(strSavePath, strExtraFileName, nMaxRescords, cResultBefore, cResultAfter)
	-- Dump the result.
	OutputMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, nil, nil, cResultBefore, cResultAfter)
end

-- Dump compared memory reference file results generated by DumpMemorySnapshot.
-- strSavePath - The save path of the file to store the result, must be a directory path, If nil or "" then the result will output to console as print does.
-- strExtraFileName - If you want to add extra info append to the end of the result file, give a string, nothing will do if set to nil or "".
-- nMaxRescords - How many rescords of the results in limit to save in the file or output to the console, -1 will give all the result.
-- strResultFilePathBefore - The base dumped results file.
-- strResultFilePathAfter - The compared dumped results file.
local function DumpMemorySnapshotComparedFile(strSavePath, strExtraFileName, nMaxRescords, strResultFilePathBefore, strResultFilePathAfter)
	-- Read results from file.
	local cResultBefore = CreateObjectReferenceInfoContainerFromFile(strSavePath..strResultFilePathBefore)
	local cResultAfter = CreateObjectReferenceInfoContainerFromFile(strSavePath..strResultFilePathAfter)

	-- Dump the result.
	OutputMemorySnapshot(strSavePath, strExtraFileName, nMaxRescords, nil, nil, cResultBefore, cResultAfter)
end

-- Dump memory reference of a single object at current time.
-- strSavePath - The save path of the file to store the result, must be a directory path, If nil or "" then the result will output to console as print does.
-- strExtraFileName - If you want to add extra info append to the end of the result file, give a string, nothing will do if set to nil or "".
-- nMaxRescords - How many rescords of the results in limit to save in the file or output to the console, -1 will give all the result.
-- strObjectName - The object name reference you want to dump.
-- cObject - The object reference you want to dump.
local function DumpMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, strObjectName, cObject)
	-- Check object.
	if not cObject then
		return
	end

	if (not strObjectName) or (0 == string.len(strObjectName)) then
		strObjectName = GetOriginalToStringResult(cObject)
	end

	-- Get time format string.
	local strDateTime = FormatDateTimeNow()

	-- Create container.
	local cDumpInfoContainer = CreateSingleObjectReferenceInfoContainer(strObjectName, cObject)
	local cStackInfo = debug.getinfo(2, "Sl")
	if cStackInfo then
		cDumpInfoContainer.m_strShortSrc = cStackInfo.short_src
		cDumpInfoContainer.m_nCurrentLine = cStackInfo.currentline
	end

	-- Collect memory info.
	CollectSingleObjectReferenceInMemory("registry", debug.getregistry(), cDumpInfoContainer)
	
	-- Dump the result.
	OutputMemorySnapshotSingleObject(strSavePath, strExtraFileName, nMaxRescords, cDumpInfoContainer)
end

-- Return methods.
MemoryRefInfo = { m_cConfig = nil, m_cMethods = {}, m_cHelpers = {}, m_cBases = {}}

MemoryRefInfo.m_cConfig = cConfig

MemoryRefInfo.m_cMethods.DumpMemorySnapshot = DumpMemorySnapshot
MemoryRefInfo.m_cMethods.DumpMemorySnapshotCompared = DumpMemorySnapshotCompared
MemoryRefInfo.m_cMethods.DumpMemorySnapshotComparedFile = DumpMemorySnapshotComparedFile
MemoryRefInfo.m_cMethods.DumpMemorySnapshotSingleObject = DumpMemorySnapshotSingleObject

MemoryRefInfo.m_cHelpers.FormatDateTimeNow = FormatDateTimeNow
MemoryRefInfo.m_cHelpers.GetOriginalToStringResult = GetOriginalToStringResult

MemoryRefInfo.m_cBases.CreateObjectReferenceInfoContainer = CreateObjectReferenceInfoContainer
MemoryRefInfo.m_cBases.CreateObjectReferenceInfoContainerFromFile = CreateObjectReferenceInfoContainerFromFile
MemoryRefInfo.m_cBases.CreateSingleObjectReferenceInfoContainer = CreateSingleObjectReferenceInfoContainer
MemoryRefInfo.m_cBases.CollectObjectReferenceInMemory = CollectObjectReferenceInMemory
MemoryRefInfo.m_cBases.CollectSingleObjectReferenceInMemory = CollectSingleObjectReferenceInMemory
MemoryRefInfo.m_cBases.OutputMemorySnapshot = OutputMemorySnapshot
MemoryRefInfo.m_cBases.OutputMemorySnapshotSingleObject = OutputMemorySnapshotSingleObject
MemoryRefInfo.m_cBases.OutputFilteredResult = OutputFilteredResult

--return MemoryRefInfo


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

