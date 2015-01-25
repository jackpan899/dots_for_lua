-- notice: tabel 获取长度，getn及#只能针对连续索引的table



touchX = 0 
touchY = 0
screenScaleX = 1
screenScaleY = 1

isSoundOn = true
isMusicOn = true

rootScene = nil
layerHelloWorld = nil
layerRoot = nil
pWinSize = nil

touchFrame = 0
frameCountAll = 0
touchCount = 0
touchID = 0

function scene()
    if  rootScene then
        return rootScene
    end

    local scene = ScutScene:new()
    rootScene = scene.root
    scene:registerCallback(rootSceneNetCallback)
	scene:registerNetErrorFunc(rootSceneNetWorkErrorCallback)
    layerHelloWorld = CCLayer:create()
	layerHelloWorld:setAnchorPoint(0,0)
    rootScene:addChild(layerHelloWorld,1)
    pWinSize = CCDirector:sharedDirector():getWinSize()
	
	layerRoot = CCLayer:create()
    layerHelloWorld:addChild(layerRoot ,1)
    layerRoot:setAnchorPoint(0,0)
	
	--[[
    if (pWinSize.width / pWinSize.height) > (1100 / 740) then
        rootScene:setScaleY(0.90)
    end
	]]
    
    CCDirector:sharedDirector():runWithScene( rootScene)
    layerRoot:scheduleUpdateWithPriorityLua(tick, 1)
	
	initHelloWorldLayerTouchesEvent()

    --SimpleAudioEngine:sharedEngine():setBackgroundMusicVolume(0.75)
	--playSound(fadeMusicSound)
    --playMusic(fadeMusicURL)
	
    return rootScene
end



function rootSceneNetCallback(pZyScene, lpExternalData, isTcp)
    netCallback(pZyScene, lpExternalData,true)
end


function rootSceneNetWorkErrorCallback()
	print("网络中断  rootSceneNetWorkErrorCallback")
	--connectSuspend()
end

function init()
   
--[[
    local button2 = ZyButton:new("button/button_1011.png", "button/button_1012.png",nil,IDS_SUBMIT)
    button2:setPosition(PT(pWinSize.width/2 - button2:getContentSize().width/2 ,SCALEY(10)));
    button2:addto(rootScene,0)
    button2:registerScriptTapHandler(submit);
	]]

end



function getTouchesTable(args)
    local touchesArray = {}
    if args~= nil and type(args) == "table" then
        for i=1,#args, 3 do
            local touch = {}
            touch["x"] = tonumber(args[i])
            touch["y"] = tonumber(args[i+1]) 
            touch["ID"] = tonumber(args[i+2]) 
            touchesArray[#touchesArray+1] = touch
        end
        return touchesArray		
    end
    return nil
end

function onTouchesBegan(args)
    if layerHelloWorld == nil then
        return
    end
    local touchesArray = getTouchesTable(args)
    if touchesArray == nil then
        return
    end

    for i=1,#touchesArray do
        local touch = touchesArray[i]
        touch.y = touch.y - layerRoot:getPositionY()
        touchFrame = frameCountAll+1
        touchX = touch.x/screenScaleX
        touchY = touch.y/screenScaleY
       -- print("onTouchesBegan:x="..touch.x)
        touchCount = touchCount + 1		

    end
end

function onTouchesMoved(args)
    if layerHelloWorld ~= nil then
        local touchesArray = getTouchesTable(args)
        if touchesArray == nil then
            return
        end

        for i=1,#touchesArray do
            local touch = touchesArray[i]
            touch.y = touch.y  - layerRoot:getPositionY()
            local x=touch.x/screenScaleX
            local y = touch.y / screenScaleY
            
            
        end
    end
end

function onTouchesEnded(args)
    if layerHelloWorld ~= nil then
        local touchesArray = getTouchesTable(args)
        if touchesArray == nil then
            return
        end

        for i=1,#touchesArray do
            local touch = touchesArray[i]
            local x =  layerRoot:getPositionX()
            local y =  layerRoot:getPositionY()
            touch.y = touch.y - y
            releaseFrame = frameCountAll + 1
            touchCount = touchCount - 1
            for p=0, 2 do
                if(touchID[p] == tonumber(touch.ID)) then
                    if(p==1 or p==2) then
                        touchID[1] , touchID[2] = 0, 0
                    end
                    touchID[p] = 0
                    
                end
            end
        end
    end
end

function onTouchesCancelled(args)
    if layerHelloWorld ~= nil then
        print("HelloWorldLayer onTouchesCancelled ")
        touchX = 0
        touchY = 0
    end
end

function onBackClicked()
	CCDirector:sharedDirector():popScene()
end

function onEnter()
    if layerHelloWorld ~= nil then
        print("HelloWorldLayer onEnter ")
        layerHelloWorld:setTouchEnabled(true)
		layerHelloWorld:setKeypadEnabled(true)
		layerHelloWorld:setAccelerometerEnabled(true) --启用重力感应
        print("layerHelloWorld set setTouchEnabled --- 2")
    end
end

function onExit()
    if layerHelloWorld ~= nil then
        print("HelloWorldLayer  onExit ")
		
        layerHelloWorld:setTouchEnabled(false)
		layerHelloWorld:setKeypadEnabled(false)
		layerHelloWorld:setAccelerometerEnabled(false)
        print("layerHelloWorld onExit set setTouchEnabled --- 2")
		
		SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
    end
end


function initHelloWorldLayerTouchesEvent()
    if layerHelloWorld ~= nil then
        local function onTouchEvent(eventType, args)
            if eventType == "began" then
                return onTouchesBegan(args)
            elseif eventType == "moved" then
                onTouchesMoved(args)
            elseif eventType == "ended" then
                onTouchesEnded(args)
            elseif eventType == "cancelled" then
                onTouchesCancelled(args)
            end
        end
		
		local function OnKeypadEvent(event)
			 if "backClicked" == event then
                onBackClicked()
            elseif "menuClicked" == event then
            end
		end
		
		local function onAccelerateEvent(x, y, z, timestamp)
            if x == -11111 then
                pressKeyvalue = y
            else
                pressKeyvalue = 0
            end
        end
		
        local function onNodeEvent(event)
            print("HelloWorldLayer onNodeEvent eventname=".. tostring(event) )
            if "enter" == event then
                onEnter()
            elseif "exit" == event then
                onExit()
			--elseif "enterTransitionFinish" == event then
			--elseif "cleanup" == event then
            end
        end
		
        layerHelloWorld:setTouchMode(kCCTouchesOneByOne) -- kCCTouchesAllAtOnce
        layerHelloWorld:registerScriptTouchHandler(onTouchEvent,true)
        layerHelloWorld:registerScriptHandler(onNodeEvent)
		layerHelloWorld:registerScriptKeypadHandler(OnKeypadEvent)
        layerHelloWorld:registerScriptAccelerateHandler(onAccelerateEvent)
    end
end 


--读取本地保存的游戏记录
function loadRecord()
    local shareObject = CCUserDefault:sharedUserDefault()
    isSoundOn = shareObject:getBoolForKey("isSoundOn")
    isMusicOn = shareObject:getBoolForKey("isMusicOn")
   
end

function saveRecord()
    local shareObject = CCUserDefault:sharedUserDefault()
    shareObject:setBoolForKey("isSoundOn",isSoundOn )
    shareObject:setBoolForKey("isMusicOn",isMusicOn )
   
    shareObject:flush()
end


function playSound(url)
    if(isSoundOn) then
		SimpleAudioEngine:sharedEngine():playEffect(getPathByName(url))
    end
end

function playMusic(url)
    if(isMusicOn) then
        SimpleAudioEngine:sharedEngine():playBackgroundMusic(getPathByName(url),true)
		--SimpleAudioEngine:sharedEngine():playBackgroundMusic("blank.mp3",true)
    end
	--SimpleAudioEngine:sharedEngine():stopBackgroundMusic()
end



function tick(dt)
    frameCountAll = frameCountAll + 1
    print("tick frameCountAll= ",frameCountAll)
	if frameCountAll == 1 then
		--[[
		local size = CCDirector:sharedDirector():getWinSize()	
        local mainScale = CCDirector:sharedDirector():getContentScaleFactor()
		print( "width = ",size.width)
		print( "height = ",size.height)
		print( "mainScale = ",mainScale)
        local scaleX = size.width * mainScale/1100
        local scaleY = size.height * mainScale/740
        screenScaleX = size.width/1100
        screenScaleY = size.height/740
		
        screenRatio = size.width/size.height
		print( "screenScaleX = ",screenScaleX)
		print( "screenScaleY = ",screenScaleY)
		print( "screenRatio = ",screenRatio)
        if (screenRatio > 1.5) then -- //iphone5
            layerRoot:setPosition(0,-size.height / 17.3 * mainScale)
            scaleY = scaleY * 1.117
            screenScaleY = screenScaleY * 1.117
        end
		print( "scaleY = ",scaleY)
		print( "screenScaleY = ",screenScaleY)
        layerRoot:setScaleX(scaleX)
        layerRoot:setScaleY(scaleY)
		]]
	elseif frameCountAll == 10 then
		require("DotGameScene")
		CCDirector:sharedDirector():replaceScene(CCTransitionFade:create(1.0,DotGameScene.Scene()))
	end
end