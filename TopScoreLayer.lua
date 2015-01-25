module("TopScoreLayer", package.seeall)

require("TableLayer")
require("DataController")
require("DotPlayingScene")

local TopScoreLayer = class("TopScoreLayer", 
	function()
		local layer = CCLayerColor:create(ccc4(100, 100, 100, 255))
			
			print("TopScoreLayer:new()")
		return layer
	end)

TopScoreLayer.__index = TopScoreLayer   -- 用于访问
TopScoreLayer.radiues = nil          -- CGFloat
TopScoreLayer.centerPos = nil        -- CGPoint
TopScoreLayer.m_started = nil        -- BOOL   
TopScoreLayer.m_angle = nil          -- CGFloat
TopScoreLayer.m_timeCtrl = nil       -- CGFloat 
TopScoreLayer.m_r = nil              -- CGFloat  
TopScoreLayer.m_imageButtonResponseType = false
TopScoreLayer.m_canTriggerAction = false


function TopScoreLayer:init()
    if (self) then
        local s = CCDirector:sharedDirector():getWinSize()
        
        self:setAnchorPoint(ccp(0, 0))
        m_logoLabel = CCLabelTTF:create("FUCK SHIT","Arial",32)
        m_logoLabel:setColor(ccc3(0, 0, 0))
        m_logoLabel:setPosition(ccp(s.width/2, s.height - 50))
        self:addChild(m_logoLabel)
        
        local thisRound = CCSprite:create("Images/thisRoundScore.png")
        thisRound:setPosition(ccp(60, s.height-130))
        self:addChild(thisRound)
        m_thisRound = CCLabelTTF:create("","Arial" ,18)
        m_thisRound:setColor(ccc3(0, 0, 0))
        m_thisRound:setPosition(ccp(40, 10)
        thisRound:addChild(m_thisRound)
       
        local highScore = CCSprite:create("Images/HighScore.png")
        highScore:setPosition(ccp(s.width/2, s.height-130))
        self:addChild(highScore)
        m_highScore = CCLabelTTF:create("","Arial",18)
        m_highScore:setColor(ccc3(0, 0, 0))
        m_highScore:setPosition(ccp(40, 10))
        highScore:addChild(m_highScore)
        
        local goldSprite = CCSprite:create("Images/gold.png")
        goldSprite:setPosition(ccp(s.width-60, s.height-130))
        self:addChild(goldSprite)
        m_goldlabel = CCLabelTTF:create("","Arial",18)
        m_goldlabel:setColor(ccc3(0, 0, 0))
        m_goldlabel:setPosition(ccp(40, 10))
        goldSprite:addChild(m_goldlabel)
        
        
        local timerSprite = CCSprite:create("Images/timerb.png")
        timerSprite:setAnchorPoint(ccp(0, 0))
        timerSprite:setPosition(ccp(20, s.height - 200))
        self:addChild(timerSprite)
        m_expProgress = CCProgressTimer:create(CCSprite:create("Images/timer.png"))
        m_expProgress:setAnchorPoint(ccp(0,0))
        m_expProgress:setType(kCCProgressTimerTypeBar)
        m_expProgress:setMidpoint(ccp(0, 0))
        m_expProgress:setBarChangeRate(ccp(1,0))
        m_expProgress:setPosition(ccp(3.5, 4.0))
        timerSprite:addChild(m_expProgress)
        m_expProgress:setPercentage(60)
        
        
        m_levelLabel = CCLabelTTF:create("level:","Arial",18)
        m_levelLabel:setAnchorPoint(ccp(0, 0.5))
        m_levelLabel:setColor(ccc3(0, 0, 0))
        m_levelLabel:setPosition(ccp(5, 20))
        timerSprite:addChild(m_levelLabel)
        
        m_tableLayer =  TableLayer:Create()
        m_tableLayer:setPosition(ccp(60, s.height/6))
        self:addChild(m_tableLayer)
        
        
		m_imageItem = tolua.cast(CCMenuItem:create(),"CCMenuItem")
		m_imageItem:registerScriptTapHandler(self:imageItemPressed)
		m_imageItem:setPosition(ccp(0, -s.height/2+30))
        local menu = CCMenu:createWithItem(m_imageItem)
        self:addChild(menu)
        self:setVisible(false)
        self:setTouchMode(kCCTouchesOneByOne)
        self:setTouchEnabled(false)
		
		--self:startAnimationDisplay()
    end
end

function TopScoreLayer:startAnimationDisplay(score)
    
    self:m_imageButtonResponseType = true
    
    self:setVisible(true)
    
	local s = CCDirector:sharedDirector():getWinSize()
    self:stopAllActions()
    self:setPosition(ccp(s.width, 0 ))
    
    
	local moveto = CCMoveTo:create(0.2,ccp(0, 0))
	local funcall= CCCallFunc:create(
		function()
			self:loadAnimation(score,DataController:getSharedDataController():readPlayerDefaultProperty())
		end)
    local sequence = CCSequence:createWithTwoActions(moveto, funcall)
	self:runAction(sequence)
	
    local texture = CCTextureCache:sharedTextureCache():addImage("Images/TopPlayingNow.png")
    
    local frame = CCSpriteFrame:createWithTexture(texture ,CCRectMake(0, 0, texture:getContentSize().width, texture:getContentSize().height))
    m_imageItem:setNormalSpriteFrame(frame)
    
    self:setTouchEnabled(true)
end


function TopScoreLayer:startAnimationDisplay()
    self:m_imageButtonResponseType = false
    self:setVisible(true)
    self:loadAnimation(0,DataController:getSharedDataController():readPlayerDefaultProperty())
    
	local texture = CCTextureCache:sharedTextureCache():addImage("Images/TopExit.png")
    local frame = CCSpriteFrame:createWithTexture(texture ,CCRectMake(0, 0, texture:getContentSize().width, texture:getContentSize().height))
    m_imageItem:setNormalSpriteFrame(frame)
    
    self:setTouchEnabled(true)
end

function TopScoreLayer:imageItemPressed()
    if (self:m_imageButtonResponseType) then
        local playingScene = DotPlayingScene:scene()
        CCDirector:sharedDirector():replaceScene(CCTransitionMoveInR:create(0.2 ,playingScene))
    else
        CCDirector:sharedDirector():popScene()
    end
end


function TopScoreLayer:loadAnimation(score ,array)
    
    local level = 1
    local gold = 1
    local exp = 0
    local high = DataController:getSharedDataController():getHighScore()
    
    if (array) then
        local l = tolua.cast(array:objectAtIndex(0),"CCString")  -- NSNumber *
        local g = tolua.cast(array:objectAtIndex(1),"CCString")  -- NSNumber *
        local e = tolua.cast(array:objectAtIndex(2),"CCString")  -- NSNumber *
        
        level = l.intValue()
        gold = g.intValue()
        exp = e.intValue()
    end
    
    m_levelLabel:setString("level:"..level)
    m_goldlabel:setString(tostring(gold))
    m_thisRound:setString(tostring(score))
    
    m_highScore:setString(tostring(high))
    
    if (m_imageButtonResponseType) then
        m_thisRound:setString(tostring(score))
    else
        m_thisRound:setString("--")
    end
    
    m_tableLayer:loadLoaclLayer(1)
end

function TopScoreLayer:ccTouchBegan(touch,event)
    
    if (not self.visible) then
        return false
    end
    --[[
    local touchLocation = touch:locationInView: touch view])
	touchLocation = CCDirector sharedDirector] convertToGL: touchLocation)
    
    m_touchStartLocation = self convertToNodeSpace:touchLocation)
    ]]
    self.m_canTriggerAction = true
    
    return true
end

function TopScoreLayer:ccTouchMoved(touch,event)
    
    if (not self.m_canTriggerAction) then
        return
    end
    --[[
    CGPoint touchLocation = touch locationInView: touch view])
	touchLocation = CCDirector sharedDirector] convertToGL: touchLocation)
    
    CGPoint localPos = self convertToNodeSpace:touchLocation)
    
    CGFloat distance = ccpDistance(localPos, m_touchStartLocation);
    ]]
	local distance = 0
    if (distance>=20) then
        self.m_canTriggerAction = false
        
        if (m_touchStartLocation.x < localPos.x) then
            m_tableLayer:leftPageMove(200)
        else
            m_tableLayer:rightPageMove(200)
        end
    end
end

--function TopScoreLayer:ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event{
--    NSLog(@"toch cancelnot ");
--end

function TopScoreLayer:ccTouchEnded(touch,event)

    if (self.m_canTriggerAction) then
        return
    end
    --[[
    local touchLocation = touch locationInView: touch view])
	touchLocation = CCDirector sharedDirector] convertToGL: touchLocation)
    
    local localPos = self:convertToNodeSpace(touchLocation)
    
    local distance = ccpDistance(localPos, m_touchStartLocation)
    ]]
	local distance = 0
    if (distance>=5) then
        self.m_canTriggerAction = false
        
        if (m_touchStartLocation.x < localPos.x) then
            m_tableLayer:leftPageMove(200)
        else
            m_tableLayer:rightPageMove(200)
        end
    end

end

function TopScoreLayer:onExit()
    self:setTouchEnabled(false)
end

--return TopScoreLayer

function Create()
	local layer = TopScoreLayer:new()
	layer:init()
	return layer
end