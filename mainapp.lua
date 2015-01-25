------------------------------------------------------------------
-- mainapp.lua
-- Author     : LZW
-- Version    : 1.0.0.0
-- Date       : 2014-1-20
-- Description:
------------------------------------------------------------------


local strModuleName = "mainapp"
CCLuaLog("Module ".. strModuleName.. " loaded.")
strModuleName = nil
g_scheduler = nil

function PushReceiverCallback(pScutScene, lpExternalData)
    testScene.netCallback(pScutScene, lpExternalData, true)
end

local function ScutMain()
    ------------------------------------------------------------------
    -- ↓↓ 初始化环境变量 开始 ↓↓
    ------------------------------------------------------------------

    local strRootDir = ScutDataLogic.CFileHelper:getPath("lua");
    local strTmpPkgPath = package.path;

    local strSubDirs =
    {

        "lib",


        -- 在此添加新的目录
    };

    -- 逐个添加子文件夹
    for key, value in ipairs(strSubDirs) do
        local strOld = strTmpPkgPath;
        if(1 == key) then
            strTmpPkgPath = string.format("%s/%s/?.lua%s", strRootDir, value, strOld);
        else
            strTmpPkgPath = string.format("%s/%s/?.lua;%s", strRootDir, value, strOld);
        end
        strOld = nil;
    end

    package.path = string.format("%s/?.lua;%s", strRootDir, strTmpPkgPath);
    strTmpPkgPath = nil;

    ------------------------------------------------------------------
    -- ↑↑ 初始化环境变量 结束 ↑↑
    ------------------------------------------------------------------

    -- require必须在环境变量初始化之后，避免文件找不到的情况发生
    require("lib.lib")
    require("lib.ScutScene")
    require("lib.FrameManager")
	require("lib.extern")
	require("game_utlity")
    g_frame_mgr = FrameManager:new()
    g_frame_mgr:init()
	g_scheduler = CCDirector:sharedDirector():getScheduler()
	
	require("HelloWorldLayer")
    function OnHandleData(pScene, nTag, nNetRet, pData)
        pScene = tolua.cast(pScene, "CCScene")
        g_scenes[pScene]:execCallback(nTag, nNetRet, pData)
    end

    math.randomseed(os.time());
    __NETWORK__=true
    ------------------------------------------------------------------
    -- ↓↓ 协议解析函数注册 开始 ↓↓
    ------------------------------------------------------------------

    function processCommonData(lpScene)
		return true;
    end

    function netDecodeEnd(pScutScene, nTag)

    end

    --注册服务器push回调
   ScutExt:getInstance():RegisterSocketPushHandler("PushReceiverCallback")
   ScutScene:registerNetDecodeEnd("netDecodeEnd");
    ------------------------------------------------------------------
    -- ↑↑ 协议解析函数注册 结束 ↑↑
    ------------------------------------------------------------------

end



function tracebackex()  
	local ret = ""  
	local level = 2  
	ret = ret .. "stack traceback:\n"  
	while true do  
	   --get stack info  
	   local info = debug.getinfo(level, "Sln")  
	   if not info then break end  
	   if info.what == "C" then                -- C function  
		ret = ret .. tostring(level) .. "\tC function\n"  
	   else           -- Lua function  
		ret = ret .. string.format("\t[%s]:%d in function `%s`\n", info.source, info.currentline, info.name or "")  
	   end  
	   --get local vars  
	   local i = 1  
	   while true do  
		local name, value = debug.getlocal(level, i)  
		if not name then break end  
		ret = ret .. "\t\t" .. name .. " =\t" .. tostringex(value, 3) .. "\n"  
		i = i + 1  
	   end    
	   level = level + 1  
	end  
	return ret  
end  
  
function tostringex(v, len)  
	if len == nil then len = 0 end  
	local pre = string.rep('\t', len)  
	local ret = ""  
	if type(v) == "table" then  
	   if len > 5 then return "\t{ ... }" end  
	   local t = ""  
	   for k, v1 in pairs(v) do  
		t = t .. "\n\t" .. pre .. tostring(k) .. ":"  
		t = t .. tostringex(v1, len + 1)  
	   end  
	   if t == "" then  
		ret = ret .. pre .. "{ }\t(" .. tostring(v) .. ")"  
	   else  
		if len > 0 then  
		 ret = ret .. "\t(" .. tostring(v) .. ")\n"  
		end  
		ret = ret .. pre .. "{" .. t .. "\n" .. pre .. "}"  
	   end  
	else  
	   ret = ret .. pre .. tostring(v) .. "\t(" .. type(v) .. ")"  
	end  
	return ret  
end  

function __G__TRACKBACK__(msg)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(msg) .. "\n")
    --print(debug.traceback())
	print(tracebackex())
    print("----------------------------------------")
end


local function main()
    ScutMain()

    scene() --HelloWorldLayer全局函数
end

xpcall(main, __G__TRACKBACK__)
