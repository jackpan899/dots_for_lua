
module("DotPlayingScene", package.seeall)



local g_updateFunc = nil


local DotPlayingLayer = class("DotPlayingLayer", function()
	local layer = CCLayer:create()
	layer:setAnchorPoint(ccp(0, 0))
    return layer
end)

DotPlayingLayer.__index = DotPlayingLayer   -- 用于访问

DotPlayingLayer.m_timeCounter =  0  -- NSInteger
DotPlayingLayer.m_iScore =  0  -- NSInteger
DotPlayingLayer.m_pause =  false  -- BOOL
DotPlayingLayer.m_data =  nil  -- DataHandle
DotPlayingLayer.m_hudController =  nil  -- DotHudController

function DotPlayingLayer:init()
    if (self) then
		print("DotPlayingLayer init 1111=")
		require("DataHandle")
        m_data = DataHandle:Create()
		print("DotPlayingLayer init 2222=",m_data)
        self:addChild(m_data)
		print("DotPlayingLayer init 22=")
		
		require("DotHudController")
        self.m_hudController = DotHudController:Create()
		print("DotPlayingLayer init 3333=",self.m_hudController)
        self:addChild(self.m_hudController)
		print("DotPlayingLayer init 4444=")
    end
end

function DotPlayingLayer:startDotGame()
	if m_data ~= nil then
		m_data:startAnimtionDisplay()
		m_data:startPlaying()
	end
    self:startTimerCounter()
end

function DotPlayingLayer:playingScoreAdd(score)

    m_iScore = m_iScore + score
    m_hudController:resetScoreString(tostring(m_iScore))
end


function DotPlayingLayer:startTimerCounter()
    m_pause = false
    m_timeCounter = 60

	if g_updateFunc ~= nil then
		g_scheduler:unscheduleScriptEntry(g_updateFunc)
		g_updateFunc = nil
	end
	g_updateFunc = g_scheduler:scheduleScriptFunc("tick",1,false)

end

function DotPlayingLayer:tick()

    if m_pause then
        return
    end

    m_timeCounter = m_timeCounter - 1
	m_hudController:resetTimeString(tostring(m_timeCounter))
    if (m_timeCounter <= 0) then -- gameover
		m_data:moveOut()
		--m_hudController:gamePause()
        m_hudController:currentGameOver(m_iScore)

        if g_updateFunc ~= nil then
			g_scheduler:unscheduleScriptEntry(g_updateFunc)
			g_updateFunc = nil
		end
    end

end



function DotPlayingLayer:pauseGame()
    m_pause = true
    m_data:moveOut()
end

function DotPlayingLayer:resumeGame()
    m_pause = false
    m_data:moveIn()
end

function DotPlayingLayer:playerUsedToolDisappear(ePlayerToolType)

    if (ePlayerToolType ~= tooltime) then
		m_data:allDrawNodeBeSelected(ePlayerToolType == toolDisappearAll)
	end
end

local l_DotPlayingScene = nil

--此函数有调用DotPlayingLayer:new() ，故需放在DotPlayingLayer的构造函数之后
function Scene()
	if l_DotPlayingScene == nil then
		l_DotPlayingScene = CCScene:create()
		local layer = DotPlayingLayer:new()
		layer:init()
		l_DotPlayingScene:addChild(layer)
		print("DotPlayingScene_create 111")
	end
	return l_DotPlayingScene
end
