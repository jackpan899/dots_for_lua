
module("DownStateLayer", package.seeall)


--require("DotHudController")

local DownStateLayer = class("DownStateLayer", function()
	local size = CCDirector:sharedDirector():getWinSize()
	local layer = CCLayerColor:create(ccc4(198, 203, 206, 255),size.width,60)
	print("DownStateLayer:new()")
	return layer
end)

DownStateLayer.__index = DownStateLayer   -- 用于访问

--DownStateLayer.m_upstateLayer = nil  -- UpStateLayer *
--DownStateLayer.m_downStateLayer = nil -- DownStateLayer * 
--DownStateLayer.m_pauseLayer = nil -- PauseLayer * 
--DownStateLayer.m_topScoreLayer = nil -- TopScoreLayer *  
--DownStateLayer.m_pause = false   


function DownStateLayer:init()
	print("DownStateLayer init 111")
    if (self) then
        self:setAnchorPoint(ccp(0, 0))
		
		local arrayOfItems = CCArray:create()
		local skillOne = tolua.cast(CCMenuItemImage:create("Images/skillbutton.png","Images/skillButton_unselect.png"),"CCMenuItem")
		skillOne:registerScriptTapHandler(self:skillOnePressed)
		arrayOfItems:addObject(skillOne)
    
		local skillTwo = tolua.cast(CCMenuItemImage:create("Images/skillbutton.png","Images/skillButton_unselect.png"),"CCMenuItem")
		skillTwo:registerScriptTapHandler(self:skillTwoPressed)
		arrayOfItems:addObject(skillTwo)
		
		local skillThree = tolua.cast(CCMenuItemImage:create("Images/skillbutton.png","Images/skillButton_unselect.png"),"CCMenuItem")
		skillThree:registerScriptTapHandler(self:skillThreePressed)
		arrayOfItems:addObject(skillThree)
		
		local size = CCDirector:sharedDirector():getWinSize()
		local menu = CCMenu:createWithArray(arrayOfItems)
		--menu:alignItemsVerticallyWithPadding(10)
		menu:setPosition(ccp(0,17))
		
		skillOne:setAnchorPoint(ccp(0, 0))
		skillOne:setPosition(ccp(0, 0))
		
        skillTwo:setAnchorPoint(ccp(0.5, 0))
		skillTwo:setPosition(ccp(size.width/2, 0))
		
        skillThree:setAnchorPoint(ccp(1, 0))
        skillThree:setPosition(ccp(size.width, 0))
		
		self:addChild(menu)
		self:setVisible(false)
		
    end
end

function DownStateLayer:startAnimationDisplay()
    
    self:setAnchorPoint(ccp(0, 0))
    self:setPosition(ccp(0, -60))
    
    self:setVisible(true)
	local moveTo1 = CCMoveTo:create(0.2,ccp(0, 0))
	local moveTo2 = CCMoveTo:create(0.2,ccp(0, -17))
	
    local sequence = CCSequence:createWithTwoActions(moveTo1, moveTo2)
	self:runAction(sequence)
    
end


function DownStateLayer:skillOnePressed()
    
    if (self:getParent()) then
        local dhc = tolua.cast(self:getParent(),"DotHudController")
        dhc:playerUseSkill(tooltime)
    end
end

function DownStateLayer:skillTwoPressed{
    if (self:getParent()) then
		local dhc = tolua.cast(self:getParent(),"DotHudController")
        dhc:playerUseSkill(toolDisappearOne)
    end
end

function DownStateLayer:skillThreePressed{
    if (self:getParent()) then
        local dhc = tolua.cast(self:getParent(),"DotHudController")
        dhc:playerUseSkill(toolDisappearAll)
    end
end

--return DownStateLayer


function Create()
	local layer = DownStateLayer:new()
	layer:init()
	return layer
	
end