

--===========================================================================


function printTableData(tb)
	print(" printTableData ------------begin------ ")
	print(" tb size =",tostring(#tb))
	for key,value in pairs (tb) do
		if (key ~= nil and value ~= nil ) then
			if type(value) == "table" then
				local tbTmp = value
				print(" key =",tostring(key))
				print(" table in tb")
				printTableData(tbTmp)
			else
				print(string.format(" key =%s,value =%s",tostring(key),tostring(value)))
			end
		end
	end
	print(" printTableData ------------end------ ")
end

function timeToString(secTime)
	if secTime < 0 then
		secTime = 0
	end
	
	local text = ""
	if secTime > 0 then
		if math.floor(secTime/3600) ~= 0 then
			text = tostring(math.floor(secTime/3600))..":" --小时
		end
		if math.floor((secTime%3600)/60) ~= 0 then
			text = text..tostring(math.floor((secTime%3600)/60))..":" --分钟
		end
		text = text..tostring(math.floor((secTime%3600)%60))
	end
	return text
end

function GetTableSize(tb)
  local n = 0
  if tb == nil then return n end
  for _, value in pairs (tb) do
      if value ~= nil then
          n = n + 1
      end
  end
  return n
end


--字符串strDes
function hasPrefix(strDes,tag)
	if strDes == nil or tag == nil or strDes == "" or tag == "" then
		return false
	end
	local i,j = string.find(strDes,tag)
	if(i == 1 and j == string.len(tag) ) then
		return true
	end
	
	return false
end


function hasSuffix(strDes,tag)
	if strDes == nil or tag == nil or strDes == "" or tag == "" then
		return false
	end

	local i,j = string.find(strDes,tag)
	if(i == string.len(strDes) - string.len(tag) + 1 and j == string.len(strDes) ) then
		return true
	end

	return false
end

function getRandom(maxNum,minNum)
    --math.randomseed(tostring(os.time()):reverse():sub(1, 6))
	if minNum == nil then
		minNum = 1
		if maxNum == 1 then
			minNum = 0
		end
	end
	return math.random(minNum,maxNum )- 1
end


----------------------------- 宏定义 -----------------------------------
ccBLACK = ccc3(0,0,0)
ccWHITE = ccc3(255,255,255)
ccYELLOW = ccc3(255,255,0)
ccBLUE = ccc3(0,0,255)
ccGREEN = ccc3(0,255,0)
ccRED = ccc3(255,0,0)
ccMAGENTA = ccc3(255,0,255)
ccPINK = ccc3(228,56,214)      -- 粉色
ccORANGE = ccc3(206, 79, 2)   -- 橘红色
ccGRAY = ccc3(166,166,166)

---自定义颜色
ccC1=ccc3(45,245,250)
ccRED1= ccc3(86,26,0)


--物品品质的五个颜色
ccGRAY2=ccc3(51,37,24)
ccGREEN2 = ccc3(101,249,8)
ccBLUE2 = ccc3(0,0,255)
ccMAGENTA2 = ccc3(148,1,139)
ccYELLOW2=ccc3(230,138,63)

--武魂颜色
ccYELLOW4 = ccc3(255,204,0)
ccYELLOW3 = ccc3(255,102,0)
ccBLUE3 = ccc3(0,255,255)
ccMAGENTA3 = ccc3(102,51,204)

function PT(x,y)
    return CCPoint(x,y)
end
function Half_Float(x)
    return x*0.5
end

function SZ(width, height)
    return CCSize(width, height)
end 

function SCALEX(x)
    return CCDirector:sharedDirector():getWinSize().width/480*x
end

function SCALEY(y)
    return CCDirector:sharedDirector():getWinSize().height /320*y
end

function  setScaleXY(frame,scaleX,scaleY)
	if scaleX~=nil then
		frame:setScaleX(scaleX/frame:getContentSizeW())
	end
	if scaleY~=nil then
		frame:setScaleX(scaleY/frame:getContentSizeH())
	end
end


------获取资源的路径---------------------
function getPathByName(fileName)
	return fileName
    --[[if fileName then
		fileName = "resource/" .. fileName
        return fileName
    else
        return nil
    end]]
end

function loadCocostudioUI(jsonFileName)
	return GUIReader:shareReader():widgetFromJsonFile(getPathByName(jsonFileName))
end

-- createTextField(createCharacter_UILayer,"name_TextField",onTextFieldEvent,"请点击输入账号")
function createTextField(touchGroupRootNode,tagName,functionEvent,strPlaceHolder)
	return createTextFieldByJsonTagName(touchGroupRootNode,tagName,functionEvent,false,"微软雅黑",24,strPlaceHolder,12,300,40)
end

function createPasswordTextField(touchGroupRootNode,tagName,functionEvent,strPlaceHolder)
	return createTextFieldByJsonTagName(touchGroupRootNode,tagName,functionEvent,true,"微软雅黑",24,strPlaceHolder,12,300,40)
end

function createTextFieldByJsonTagName(touchGroupRootNode,tagName,functionEvent,isPassWord,textFontName,textSize,strPlaceHolder,iMaxLength,touchSizeW,touchSizeH)
	if touchGroupRootNode == nil then
		return
	end
	local uiTextField = tolua.cast(touchGroupRootNode:getWidgetByName(tagName),"TextField")
	LogPrint("createTextFieldByJsonTagName,uiTextField=",uiTextField)
	uiTextField:setTouchEnabled(true)
	uiTextField:setFontName(textFontName)
	uiTextField:setFontSize(textSize)
	uiTextField:setPlaceHolder(strPlaceHolder)
	uiTextField:setMaxLengthEnabled(true)
	uiTextField:setMaxLength(iMaxLength)
	uiTextField:setPasswordEnabled(isPassWord)
	uiTextField:setPasswordStyleText("*")
	--uiTextField:ignoreContentAdaptWithSize(false)
	uiTextField:setTouchSize(CCSize(touchSizeW,touchSizeH))
	uiTextField:setTouchAreaEnabled(true)
	uiTextField:setTextHorizontalAlignment(kCCTextAlignmentCenter)
	uiTextField:setTextVerticalAlignment(kCCVerticalTextAlignmentCenter)
	uiTextField:addEventListenerTextField(functionEvent)

	return uiTextField
end

function initCocostudioUIEvent(equipRootWnd,wndName,wndClassType,callBackFunc)
	local  wnd = UIHelper:seekWidgetByName(equipRootWnd,wndName)
	if wnd ~= nil and callBackFunc ~= nil then
		wnd:setTouchEnabled(true)
		wnd:addTouchEventListener(
			function(sender,eventType)
				if eventType == TOUCH_EVENT_ENDED then
					callBackFunc(sender)			
				end
			end
		)
		
	end
	local wndClass = nil
	if wnd ~= nil then
		wndClass = tolua.cast(wnd,wndClassType)
	end
	return wndClass
end

function Split(szFullString, szSeparator)
    local nFindStartIndex = 1
    local nSplitIndex = 1
    local nSplitArray = {}
    while true do
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
        if not nFindLastIndex then
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
            break
        end
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)
        nSplitIndex = nSplitIndex + 1
    end
    return nSplitArray
end


--时间与金币间的关系
function timeToMoney(sec)
     local money = 0
     if sec <= 60 then
        money = 1
     else
        money = math.ceil(sec/60)		
	 end	
     return money
end

function hasOneOf(src, dst)
    for i=1,string.len(dst) do
        CCLOG("lonsharn, char=%s", string.sub(dst, i, i))
        local char = string.sub(dst, i, i)
        if char == "." then
            char = "%."
            CCLOG("lonsharn, find .")
        end

        local j,_ = string.find(src, char)
        if j and j >= 1 then
            return true
        end
    end

    CCLOG("lonsharn, resutlt=false")
    return false
end
