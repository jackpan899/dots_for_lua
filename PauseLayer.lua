module("PauseLayer", package.seeall)

local PauseLayer = class("PauseLayer", function()
	--local size = CCDirector:sharedDirector():getWinSize()
	local layer = CCLayerColor:create(ccc4(198, 203, 206, 255))
		print("PauseLayer:new()")
	return layer
end)
PauseLayer.__index = PauseLayer 
PauseLayer.m_resume = nil
PauseLayer.m_restart = nil
PauseLayer.m_exittomain = nil

function PauseLayer:init()
    if (self) then
        
        self:setAnchorPoint(ccp(0, 0))
        self:setPosition(ccp(0, 0))
		local arrayOfItems = CCArray:create()
		
		m_resume = tolua.cast(CCMenuItemImage:create("Images/resume.png","Images/resume_unselect.png"),"CCMenuItem")
		m_resume:registerScriptTapHandler(self:resumeDotGame)
		arrayOfItems:addObject(m_resume)
    
		m_restart = tolua.cast(CCMenuItemImage:create("Images/restart.png","Images/restart_unselect.png"),"CCMenuItem")
		m_restart:registerScriptTapHandler(self:restartDotGame)
		arrayOfItems:addObject(m_restart)
		
		m_exittomain = tolua.cast(CCMenuItemImage:create("Images/exit.png","Images/exit_unselect.png"),"CCMenuItem")
		m_exittomain:registerScriptTapHandler(self:exitToMainScnen)
		arrayOfItems:addObject(m_exittomain)
		
		local menu = CCMenu:createWithArray(arrayOfItems)
		--menu:alignItemsVerticallyWithPadding(10)
		
		menu:setAnchorPoint(ccp(0, 0))
		menu:setPosition(ccp(0,0))
       
		self:addChild(menu)
		self:setVisible(false)
    end
end


function PauseLayer:startAnimationDiaplay()
    
    self:setVisible(true)
    local s = CCDirector:sharedDirector():getWinSize()
    
    m_resume:setPosition(ccp(s.width, s.height/2+50))
    m_restart:setPosition(ccp(s.width, s.height/2))
    m_exittomain:setPosition(ccp(s.width, s.height/2-50))
    
	local moveTo11 = CCMoveTo:create(0.2,ccp(s.width/2-15, s.height/2+50))
	local moveTo12 = CCMoveTo:create(0.2,ccp(s.width/2, s.height/2+50))
    local sequence1 = CCSequence:createWithTwoActions(moveTo11, moveTo12)
	m_resume:runAction(sequence1)
	
    local moveTo21 = CCMoveTo:create(0.2,ccp(s.width/2-35, s.height/2))
	local moveTo22 = CCMoveTo:create(0.2,ccp(s.width/2, s.height/2))
    local sequence2 = CCSequence:createWithTwoActions(moveTo21, moveTo22)
    m_restart:runAction(sequence2)
	
	local moveTo31 = CCMoveTo:create(0.2,ccp(s.width/2-45, s.height/2-50))
	local moveTo32 = CCMoveTo:create(0.2,ccp(s.width/2, s.height/2-50))
    local sequence3 = CCSequence:createWithTwoActions(moveTo31, moveTo32)
    m_exittomain:runAction(sequence3)
end



function PauseLayer:resumeDotGame()
    
end

function PauseLayer:restartDotGame()
    
end

function PauseLayer:exitToMainScnen()
	require("DotGameScene")
    local scene = DotGameScene.Scene()
    CCDirector:sharedDirector():replaceScene(CCTransitionProgressOutIn:create(0.2,scene))
end

--return PauseLayer

function Create()
	local layer = PauseLayer:new()
	layer:init()
	return layer
end