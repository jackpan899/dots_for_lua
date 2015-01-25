
module("DotHudController", package.seeall)

local DotHudController = class("DotHudController", function()
	local node = CCNode:create()
		print("DotHudController:new()")
	return node
end)

DotHudController.__index = DotHudController   -- 用于访问

DotHudController.m_upstateLayer = nil  -- UpStateLayer *
DotHudController.m_downStateLayer = nil -- DownStateLayer * 
DotHudController.m_pauseLayer = nil -- PauseLayer * 
DotHudController.m_topScoreLayer = nil -- TopScoreLayer *  
DotHudController.m_pause = false   

function DotHudController:init()
    print("DotHudController init 111")
	if (self) then
        require("DownStateLayer")
        m_downStateLayer    = DownStateLayer:Create()
		require("UpStateLayer")
        m_upstateLayer      = UpStateLayer:Create()
		require("PauseLayer")
        m_pauseLayer        = PauseLayer:Create()
		require("TopScoreLayer")
        m_topScoreLayer     = TopScoreLayer:Create()
        
        self:addChild(m_downStateLayer,2)
        self:addChild(m_upstateLayer,2)
        self:addChild(m_pauseLayer,1)
        self:addChild(m_topScoreLayer)
		
		
		local function onNodeEvent(event)
			print("DotHudController onNodeEvent eventname=".. tostring(event) )
            if "enter" == event then
                self:onEnter()
            elseif "exit" == event then
                self:onExit()
            end
        end
		print("DotHudController create 111")
        self:registerScriptHandler(onNodeEvent)
		
		
		print("DotHudController init 222")
    end
end

function DotHudController:onEnter()
    m_upstateLayer:startAnimationDisplay()
    m_downStateLayer:startAnimationDisplay()
end

function DotHudController:startGame()
    if (self:getParent()) then
        local dps = tolua.cast(self:getParent(),"DotPlayingScene")
        dps:startDotGame()
    end
end

function DotHudController:gamePause()
    if (m_pause) then
        if (self:getParent()) then
            m_pauseLayer:setVisible(false)
            
			local playing = tolua.cast(self:getParent(),"DotPlayingScene")
            playing:resumeGame()
            m_pause = false
        end
    else
        if (self:getParent()) then
            m_pauseLayer:startAnimationDiaplay()
			local playing = tolua.cast(self:getParent(),"DotPlayingScene")
            playing:pauseGame()
            m_pause = true
        end
    end
end

function DotHudController:currentGameOver(score)
    m_downStateLayer:setVisible(false)
    m_upstateLayer:setVisible(false)
    m_pauseLayer:setVisible(false)
    m_topScoreLayer:startAnimationDisplay(score)
end


function DotHudController:resetTimeString(time_string)
    m_upstateLayer:resetTimeString(time_string)
end

function DotHudController:resetScoreString(time_string)
    m_upstateLayer:resetScoreString(time_string)
end


function DotHudController:playerUseSkill(skillTpye)
    if (self:getParent()) then
		local playing = tolua.cast(self:getParent(),"DotPlayingScene")
        if (playing) then
            playing:playerUsedToolDisappear(skillTpye)
        end
    end
end

--return DotHudController

function Create()
	print("DotHudController create 1")
	local node = DotHudController:new()
	print("DotHudController create 2")
	node:init()
	print("DotHudController create 3")
	return node
	
end
