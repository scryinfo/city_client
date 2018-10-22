---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by cyz_scry.
--- DateTime: 2018/10/19 11:07
---
require('Common/functions')

local lfs = lfs
local file_exists = file_exists
local class = require 'Framework/class'
local AutoRequire = class("AutoRequire")
local WindowsEditor = UnityEngine.Application.isEditor

local instance = nil

function AutoRequire:getInstance()
    return instance
end

function AutoRequire:initialize()
    self.requirePaths = {} --这个用以Android打包时，导出到 AndroidRequire.lua
end

function AutoRequire:init(dir)
    instance.OriginalPath = dir
    print("instance.OriginalPath", instance.OriginalPath)
end

function AutoRequire:getTag()
    return self._tag
end

function AutoRequire:getRequirePath()
    return self._require_path
end

function AutoRequire:addPath(path)
    if WindowsEditor then
        self.requirePaths[#self.requirePaths +1] = path
    end
end

function AutoRequire:require(path, data)
    local loadpath = self.OriginalPath..'/'..path
    log("abel_w9_autoRequire","AutoRequire:require: loadpath = ".. loadpath)
    assert(lfs.symlinkattributes(loadpath), "Error AutoRequire path not find "..loadpath)
    self._tag = data
    self._require_path = path

    local initfile = loadpath..'/'.."init.lua"
    if file_exists(initfile) then
        local loadf = path..'/'.."init"
        require(loadf)
        self:addPath(loadf)
    end

    for file in lfs.dir(loadpath) do
        if file ~= "." and file ~= ".." and file ~= "init.lua" and file ~= "loadend.lua" then
            local f = loadpath ..'/'..file
            local attr = lfs.attributes(f)
            if attr ~= nil then
                local filename = string.gsub(file, ".lua$", "")
                if attr.mode == "file" and file ~= filename then
                    local loadf = path..'/'..filename
                    require(loadf)
                    self:addPath(loadf)
                end
            end
        end
    end

    local initfile = loadpath..'/'.."loadend.lua"
    if file_exists(initfile) then
        local loadf = path..'/'.."loadend"
        require(loadf)
        self:addPath(loadf)
    end

    self._tag = nil
    self._require_path = nil
end

if instance == nil then
    instance = AutoRequire:new()
    instance:init(CityLuaUtil.getAssetsPath()..'/Lua')
    package.path = package.path .. ';'..CityLuaUtil.getAssetsPath()..'/Lua'
end

return AutoRequire