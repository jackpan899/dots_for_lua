
module("UpStateLayer", package.seeall)

local UpStateLayer = class("UpStateLayer", function()
	local size = CCDirector:sharedDirector():getWinSize()
	local layer = CCLayerColor:create(ccc4(198, 203, 206, 255),s.width,60)
		
		print("UpStateLayer:new()")
	return layer
end)

UpStateLayer.__index = UpStateLayer   -- 用于访问

UpStateLayer.m_scoreItem = nil 
UpStateLayer.m_timeItem = nil 

function UpStateLayer:init()
    print("UpStateLayer init 111")
	if (self) then
        local s = CCDirector:sharedDirector():getWinSize()
        --layer:setAnchorPoint(ccp(0, 0))
        --layer:setPosition(ccp(0, 0))
		local arrayOfItems = CCArray:create()
		
		m_scoreItem = tolua.cast(CCMenuItemImage:create("Images/scorebutton.png","Images/score_unselect.png"),"CCMenuItem")
		m_scoreItem:registerScriptTapHandler(self:menuBePressed)
		arrayOfItems:addObject(m_scoreItem)
    
		m_timeItem = tolua.cast(CCMenuItemImage:create("Images/timebutton.png","Images/time_unselect.png"),"CCMenuItem")
		m_timeItem:registerScriptTapHandler(self:menuBePressed)
		arrayOfItems:addObject(m_timeItem)
		
		m_scoreItem:setAnchorPoint(ccp(0, 0))
		m_scoreItem:setPosition(ccp(0,0))
		
		m_timeItem:setAnchorPoint(ccp(1, 0))
		m_scoreItem:setPosition(ccp(s.width,0))
		
		local menu = CCMenu:createWithArray(arrayOfItems)
		--menu:setAnchorPoint(ccp(0, 0))
		menu:setPosition(ccp(0,2))
       
		layer:addChild(menu)
		
		m_labelScore = CCLabelTTF:create("0" ,"Arial" ,18)
        m_labelTime  = CCLabelTTF:create("60" ,"Arial" ,18)
        
		m_labelScore:setAnchorPoint(ccp(0, 0.5))
		m_labelScore:setPosition(ccp(m_scoreItem:getContentSize().width/2+10,m_scoreItem:getContentSize().height/2))
		m_labelScore:setColor(ccc3(0, 0, 0))
       
	    m_labelTime:setAnchorPoint(ccp(0, 0.5))
		m_labelTime:setPosition(ccp(m_timeItem:getContentSize().width/2+10,m_timeItem:getContentSize().height/2))
		m_labelTime:setColor(ccc3(0, 0, 0))
        
        m_timeItem:addChild(m_labelTime ,11)
        m_scoreItem:addChild(m_labelScore ,11)
		
		layer:setVisible(false)
    end
end

function UpStateLayer:startAnimationDisplay()
    
    local s = CCDirector:sharedDirector():getWinSize()
    self:setVisible(true)
    
    self:setAnchorPoint(ccp(0, 0))
    self:setPosition(ccp(0, s.height))
    
	local moveto1 = CCMoveTo:create(0.2,ccp(0, s.height-60))
	local moveto2 = CCMoveTo:create(0.2,ccp(0, s.height-43))
	local funcall= CCCallFunc:create(
		function()
			if (self:getParent()) then
				require("DotHudController")
				local dhc = toua.cast(self:getParent(),"DotHudController")
				dhc:startGame()
			end
		end) 
	local seq1 = CCSequence:createWithTwoActions(moveto1, moveto2)
    local sequence = CCSequence:createWithTwoActions(seq1, funcall)
	self:runAction(sequence)
end

function UpStateLayer:resetScoreString(stringScore)
    m_labelScore:setString(stringScore)
end

function UpStateLayer:resetTimeString(stringTime)
    m_labelTime:setString(stringTime)
end

function UpStateLayer:menuBePressed()
    if (self:getParent()) then
		require("DotHudController")
        local dhc = toua.cast(self:getParent(),"DotHudController")
        dhc:gamePause()
    end
end

--return UpStateLayer
function Create()
	local layer = UpStateLayer:new()
	layer:init()
	return layer
end