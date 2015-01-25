
module("DotGameScene", package.seeall)

local l_DotGameScene = nil

function Scene()
	if l_DotGameScene == nil then
		l_DotGameScene = CCScene:create()
		--l_DotGameScene:registerScriptHandler(DotGameScene_onEnterOrExit)
		local backGroundLayer = CCLayerColor:create(ccc4(100, 100, 100, 255))
		backGroundLayer:setAnchorPoint(ccp(0, 0))
		
		l_DotGameScene:addChild(backGroundLayer)
		print("DotGameScene:Scene()")
		
		l_DotGameScene:registerScriptHandler(DotGameScene.onNodeEvent)
	end
	
	return l_DotGameScene
end


function onNodeEvent(event)
	 print("DotGameScene onNodeEvent eventname=".. tostring(event) )
	if "enter" == event then
		onEnter()
	elseif "exit" == event then
		print("DotGameScene_onEnterOrExit:exit")
	elseif "enterTransitionFinish" == event then
		onEnterTransitionFinish()
	--elseif "cleanup" == event then
	end
end

function onEnterTransitionFinish()
	local size = CCDirector:sharedDirector():getWinSize()
		
	print("DotGameScene:onEnterTransitionFinish")
--[[
	l_Menu_playnow = ZyButton:new("Images/play_now.png",nil,nil,nil,"ºÚÌå",SCALEX(15));
	l_Menu_playnow:addto(l_DotGameScene,2)
	l_Menu_playnow:setTag(1)
	l_Menu_playnow:setAnchorPoint(PT(0.5,0.5))
	l_Menu_playnow:setPosition(PT(layer:getContentSize().width - closeBtn:getContentSize().width,layer:getContentSize().height - closeBtn:getContentSize().height-SY(3)))
	l_Menu_playnow:registerScriptHandler(playingNowBtnClicked)
	l_Menu_playnow:setVisible(true)
]]

	local arrayOfItems = CCArray:create()
	local playnow = tolua.cast(CCMenuItemImage:create("Images/play_now.png","Images/play_now.png"),"CCMenuItem")
	playnow:registerScriptTapHandler(playingNowBtnClicked)
	arrayOfItems:addObject(playnow)
print("DotGameScene_onEnterOrExit:enter playnow = ",playnow)
	local multiplayer = tolua.cast(CCMenuItemImage:create("Images/multiple_player.png","Images/multiple_player.png"),"CCMenuItem")
	multiplayer:registerScriptTapHandler(multiplePlayerBtnClicked)
	arrayOfItems:addObject(multiplayer)
	print("DotGameScene_onEnterOrExit:enter multiplayer = ",multiplayer)
	local highscore = tolua.cast(CCMenuItemImage:create("Images/high_score.png","Images/high_score.png"),"CCMenuItem")
	highscore:registerScriptTapHandler(highScoreBtnClicked)
	arrayOfItems:addObject(highscore)
	print("DotGameScene_onEnterOrExit:enter highscore = ",highscore)
	local settings = tolua.cast(CCMenuItemImage:create("Images/settings.png","Images/settings.png"),"CCMenuItem")
	settings:registerScriptTapHandler(settingsBtnClicked)
	arrayOfItems:addObject(settings)
	print("DotGameScene_onEnterOrExit:enter settings = ",settings)
	local aboutus = tolua.cast(CCMenuItemImage:create("Images/about_us.png","Images/about_us.png"),"CCMenuItem")
	aboutus:registerScriptTapHandler(aboutusBtnClicked)
	arrayOfItems:addObject(aboutus)
	print("DotGameScene_onEnterOrExit:enter aboutus = ",aboutus)
	local menu = CCMenu:createWithArray(arrayOfItems)
	menu:alignItemsVerticallyWithPadding(10)
	menu:setPosition(ccp(size.width/2,size.height/2))
	print("DotGameScene_onEnterOrExit:enter menu =",menu)
	l_DotGameScene:addChild(menu,2)
end

function playingNowBtnClicked()

	print("playingNowBtnClicked btn clicked 111")
	require("DotPlayingScene")
	local playingScene =  DotPlayingScene:Scene() --DotPlayingScene_create()--
    
    CCDirector:sharedDirector():replaceScene(CCTransitionMoveInR:create(0.2 ,playingScene))
	
	print("playingNowBtnClicked btn clicked 222")
end

function multiplePlayerBtnClicked()
	print("multiplePlayerBtnClicked btn clicked")
	--local playingScene = MutablePlayerScene:node()
   -- CCDirector:sharedDirector():replaceScene(CCTransitionMoveInR:create(0.2 ,playingScene))
end

function highScoreBtnClicked()
	print("highScoreBtnClicked btn clicked")
	--local playingScene = TopScoreLayer:scene()
    
    --CCDirector:sharedDirector():replaceScene(CCTransitionMoveInR:create(0.2 ,playingScene))
end

function settingsBtnClicked()
	print("settingsBtnClicked btn clicked")
end

function aboutusBtnClicked()
	print("aboutusBtnClicked btn clicked")
end

function startGame()
	l_DotGameScene:removeAllChildren()

end