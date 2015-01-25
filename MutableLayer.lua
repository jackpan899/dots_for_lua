
require("CycleBallSprite")
	
local MutableLayer = class("MutableLayer", 
	function()
		
		local layer = CCLayerColor:create(ccc4(0, 0, 0, 255))
			if layer ~= nil then
				MutableLayer:init(layer)
			end
			print("MutableLayer:new()")
		return layer
	end)

MutableLayer.radiues = nil          -- CGFloat
MutableLayer.centerPos = nil        -- CGPoint
MutableLayer.m_started = nil        -- BOOL   
MutableLayer.m_angle = nil          -- CGFloat
MutableLayer.m_timeCtrl = nil       -- CGFloat 
MutableLayer.m_r = nil              -- CGFloat  

function MutableLayer:init(layer)
    if (layer) then
		local size = CCDirector:sharedDirector():getWinSize()
        layer:setAnchorPoint(ccp(0, 0))
        for i = 1,16 do
            local sprite = CycleBallSprite:new()
            layer:addChild(sprite)
            sprite:setVisible(false)
        end
        radiues = 40
        centerPos = ccp(self:getContentSize().width/2, self:getContentSize().height/2)
        m_started = false
        m_angle = 1.0f
        m_timeCtrl = 5.0
        m_r = 0
    end
end

function MutableLayer:startAnimation()
    
    local lPos = ccp(centerPos.x-radiues, centerPos.y)
    local rPos = ccp(centerPos.x+radiues, centerPos.y)
    
	local childs = self:getChildren()
    for i=1,8  do
        local cs = tolua.cast(childs:objectAtIndex(i-1),"CycleBallSprite")
        if (cs) then
            cs:setVisible(true)
            cs:setPosition(ccp(-radiues, lPos.y))
			local delayTime = CCDelayTime:create((i-1)*0.38) 
			local moveto = CCMoveTo:create(1.0,lPos)
			local funcall= CCCallFunc:create(
				function()
					cs:startCycleMove(centerPos ,180)
				end)
			
			local seq1 = CCSequence:createWithTwoActions(delayTime, moveto)
			local sequence = CCSequence:createWithTwoActions(seq1, funcall)
			cs:runAction(sequence)	
        end
    end
    for i=1,8  do
        local cs = tolua.cast(childs:objectAtIndex(i-1+8),"CycleBallSprite")
        if (cs) then
            cs:setVisible(true)
            cs:setPosition(ccp(self:getContentSize().width+radiues, rPos.y))
			local delayTime = CCDelayTime:create((i-1)*0.38) 
			local moveto = CCMoveTo:create(1.0,rPos)
			local funcall= CCCallFunc:create(
				function()
					cs:startCycleMove(centerPos ,0)
				end)
			
			local seq1 = CCSequence:createWithTwoActions(delayTime, moveto)
			local sequence = CCSequence:createWithTwoActions(seq1, funcall)
			cs:runAction(sequence)	
        end
    end
	self:scheduleUpdateWithPriorityLua(update, 1)
	self:scheduleUpdateWithPriorityLua(controller, 1)
end

function MutableLayer:controller(delta)
    if (not m_started) then
        m_timeCtrl = 0
        return
    end
    m_timeCtrl = m_timeCtrl + delta
    if (m_timeCtrl>5.0) then
        m_angle = (getRandom(10) + 21)/10
        local x = getRandom(2)
        x = x - 1
        x = (x==0) and 1 or x
        m_angle = m_angle * x
        m_r = x
        m_timeCtrl = 0
    end
    radiues = radiues + m_r/10
    if (radiues<40.0) then
        radiues = 40.0
    end
    if (radiues>80.0) then
        radiues = 80.0
    end
end

function MutableLayer:update(delta)
	local childs = self:getChildren()
    for i=1, i<16 do
		
        local cs = tolua.cast(childs:objectAtIndex(i-1),"CycleBallSprite")
        if (cs) then
            if (cs.canRo) then
                if ( not m_started) then
                    m_started = true
                end
                cs.angle = cs.angle + m_angle
                cs:setPosition(ccp( centerPos.x + math.cos(cs.angle/180 * math.pi)*radiues,
                                    centerPos.y + math.sin(cs.angle/ 180 * math.pi)*radiues))
            end
        end
    end
end

return MutableLayer
