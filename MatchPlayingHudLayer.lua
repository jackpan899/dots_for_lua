

require("NetWorkHandle")


local MatchPlayingHudLayer = class("MatchPlayingHudLayer", function()
	
	local layer = CCLayer:create()
		if layer ~= nil then
			MatchPlayingHudLayer:init(layer)
			layer:registerScriptHandler(MatchPlayingHudLayer:onExit)
		end
		
		print("MatchPlayingHudLayer:new()")
	return layer
end)

MatchPlayingHudLayer.m_downStateLayer = nil
MatchPlayingHudLayer.selfName = nil --CCLabelTTF * 
MatchPlayingHudLayer.pointLabel = nil -- CCLabelTTF * 
MatchPlayingHudLayer.timeLabel = nil  -- CCLabelTTF *
MatchPlayingHudLayer.oppNameLabel = nil -- CCLabelTTF * 
MatchPlayingHudLayer.oppPoints = nil -- CCLabelTTF * 

function MatchPlayingHudLayer:init(layer)

    if (layer) then
        layer:setAnchorPoint(CCPointZero)
        require("DownStateLayer")
        m_downStateLayer = DownStateLayer:new()
        layer:addChild(m_downStateLayer)
        layer:setVisible(false)
        
        local size = CCDirector:sharedDirector():getWinSize()
        
        selfName = CCLabelTTF:create("Name:You" ,"Arial" ,12)
        selfName:setColor(ccc3(0, 0, 0)];
        selfName:setPosition(ccp(40, s.height - 50)];
        layer:addChild(selfName)
        pointLabel = CCLabelTTF:create("Score:0","Arial",12)
        pointLabel:setColor(ccc3(0, 0,0))
        pointLabel:setPosition((ccp(150, s.height - 50))
        layer:addChild(pointLabel)
        timeLabel = CCLabelTTF:create("Time:60","Arial",12)
        timeLabel:setColor(ccc3(0, 0,0))
        timeLabel:setPosition((ccp(250, s.height - 50))
        layer:addChild(timeLabel)
        
        oppNameLabel = CCLabelTTF:create("OppName:","Arial",12)
        oppNameLabel:setColor(ccc3(0, 0,0))
        oppNameLabel:setPosition((ccp(40, s.height - 90))
        layer:addChild(oppNameLabel)
        oppPoints = CCLabelTTF:create("OppPoint:0","Arial",12)
        oppPoints:setColor(ccc3(0, 0,0))
        oppPoints:setPosition((ccp(150, s.height - 90))
        layer:addChild(oppPoints)
    end
end

function MatchPlayingHudLayer:startAnimation(oppname)
    self:setVisible(true)
    m_downStateLayer:startAnimationDisplay()
    if (oppNameLabel) then
        oppNameLabel:setString("OppName:".. oppname)
    end
end

function MatchPlayingHudLayer:playerUseSkill(skillTpye)
    if (self:getParent()) then
		require("MutablePlayerScene")
        local sc = tolua.cast(self:getParent(),"MutablePlayerScene")
        if (sc) {
            sc:playerUsedToolDisappear(skillTpye)
        end
    end
end

function MatchPlayingHudLayer:resetPoint(point)
    
    if (pointLabel) then
        [pointLabel setString:[NSString stringWithFormat:@"Point:%d",point]];
    end
end

function MatchPlayingHudLayer:resetTimeString(times)

    if (timeLabel) then
        timeLabel:setString("Time:"..t)
    end
end


function MatchPlayingHudLayer:sendMessage(point)
    NetWorkHandle:getSharedNetWork():sendCurrentPoint(self ,point)
end

function MatchPlayingHudLayer:reveiveMessage(infoDic ,errorMsg) --NSDictionary*)infoDic Error:(NSDictionary*) errorMsg
   
end

function MatchPlayingHudLayer:gameOverMssage(infoDic ,errorMsg)--NSDictionary*)infoDic Error:(NSDictionary*) errorMsg
end

function MatchPlayingHudLayer:gameOver(point)
    NetWorkHandle:getSharedNetWork():sendGameOver(self ,0)
end

function MatchPlayingHudLayer:onExit()
    NetWorkHandle:getSharedNetWork():cancellationSendPoint()
    NetWorkHandle:getSharedNetWork():cancellationGameOver()
end

return MatchPlayingHudLayer