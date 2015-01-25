
require("MutableLayer")
require("MatchHudLayer")
require("MatchPlayingHudLayer")
require("DataHandle")


local backLayer = nil -- MutableLayer *
local m_hudLayer = nil -- MatchHudLayer * 
local m_playingHudLayer = nil  --     MatchPlayingHudLayer *
local m_core = nil --     DataHandle *
--local m_delta = 0 -- CGFloat
local m_timeCounter = 0 --   CGFloat 
local m_point = 0 --    NSInteger 
local m_sendDelta = 0 --    CGFloat 

local g_updateFunc1 = nil
local MutablePlayerScene = class("MutablePlayerScene", function()
	local node = CCScene:create()
		if node ~= nil then
			MutablePlayerScene:init(node)
		end
		
		local function onNodeEvent(event)
			print("MutablePlayerScene onNodeEvent eventname=".. tostring(event) )
            if "enter" == event then
                self:onEnter()
            elseif "exit" == event then
                self:onExit()
            end
        end
		
        node:registerScriptHandler(onNodeEvent)
		
		print("MutablePlayerScene:new()")
	return node
end)



function MutablePlayerScene:init(scene)
    if (scene) then
        
        backLayer = MutableLayer:new()
        scene:addChild(backLayer,0,1)
        
        m_hudLayer= MatchHudLayer:new()
        scene:addChild(m_hudLayer)
        
        m_core = DataHandle:new()
        scene:addChild(m_core)
        
        m_playingHudLayer = MatchPlayingHudLayer:new()
        scene:addChild(m_playingHudLayer)
        
        m_sendDelta = 2.0
    end
end

function MutablePlayerScene:onEnterTransitionDidFinish()
    getSuperMethod(self, "onEnterTransitionDidFinish")(self) --???????????
    backLayer:startAnimation()
end


function MutablePlayerScene:startGame(oppname,point)
    
    m_hudLayer:setVisible(false)
    backLayer:setVisible(false)
    
    m_core:startAnimtionDisplay()
    m_core:startPlaying()
    
    m_playingHudLayer:startAnimation(oppname)
    
    m_timeCounter = 60.0;
    self scheduleUpdate];
	if g_updateFunc1 ~= nil then
		g_scheduler:unscheduleScriptEntry(g_updateFunc1)
		g_updateFunc1 = nil
	end
	g_updateFunc1 = g_scheduler:scheduleScriptFunc(self:update,1,false)

end


function MutablePlayerScene:update(delta)

	m_timeCounter = m_timeCounter - 1
	m_playingHudLayer:resetTimeString(m_timeCounter)
	if (m_timeCounter<=0) then
		self:gameOver()
	end
end

function MutablePlayerScene:playingScoreAdd(score)
    m_point = m_point + score
    if (m_playingHudLayer) then
        m_playingHudLayer:sendMessage(score)
        m_playingHudLayer:resetPoint(m_point)
    end
end

function MutablePlayerScene:gameOver()
    if g_updateFunc1 ~= nil then
		g_scheduler:unscheduleScriptEntry(g_updateFunc1)
		g_updateFunc1 = nil
	end
    m_core:moveOut()
    m_playingHudLayer:gameOver(m_point)
end


function MutablePlayerScene:playerUsedToolDisappear(type)
    if (type ~= tooltime) then
		m_core:allDrawNodeBeSelected(type == toolDisappearAll)
    end
end

return MutablePlayerScene