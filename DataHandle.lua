
module("DataHandle",package.seeall)

require("config")
require("DrawSprite")
require("DotPlayingScene")

local DataHandle = class("DataHandle", function()
    local layer = CCLayerColor:create(ccc4(255, 255, 255, 255)) --ccc4(230, 230, 230, 255)
	if layer ~= nil then
		print("DataHandle class 1111=")
		--init(layer)
	end
    return layer
end)

DataHandle.__index = DataHandle   -- 用于访问

DataHandle.m_drawSpriteArray = nil  -- NSMutableArray *
DataHandle.m_currentDrawColor = nil --   ccColor4F m_currentDrawColor;
DataHandle.m_stackArray = nil --    NSMutableArray * m_stackArray;
DataHandle.m_movePos = nil -- CGPoint m_movePos;
DataHandle.m_drawLine = false   
DataHandle.m_objectHasContina = false
DataHandle.m_removeAllSameColor = false    
DataHandle.m_toolsDisappear = false
DataHandle.m_toolsDisappearType = false    
DataHandle.m_canPlaying = false


function DataHandle:init()
	print("DataHandle init layer=",self)
    if (self) then
       
	   m_drawSpriteArray = CCArray:create()
	   print("TOTALY =",TOTALY)
	   print("DRAWSPRITE_WIDTH =",DRAWSPRITE_WIDTH)
	   print("DRAWSPRITE_HEIGH =",DRAWSPRITE_HEIGH)
	   
        for y = 0,TOTALY  do
            for  x = 0,TOTALX do
                print("x =",x)
				print("y =",y)
                local drawS = DrawSprite:Create()
                
                drawS:spawnAtX(x,y,DRAWSPRITE_WIDTH,DRAWSPRITE_HEIGH)
                
                m_drawSpriteArray:addObject(drawS)
                
                self:addChild(drawS ,1)
            end
        end
	
        m_stackArray = CCArray:create()
        
		local function onTouchEvent(eventType, args)
			if eventType == "began" then
				return onTouchesBegan(args)
			elseif eventType == "moved" then
				onTouchesMoved(args)
			elseif eventType == "ended" then
				onTouchesEnded(args)
			elseif eventType == "cancelled" then
				onTouchesCancelled(args)
			end
		end
		
		local function onNodeEvent(event)
			 print("DataHandle onNodeEvent eventname=".. tostring(event) )
			if "enter" == event then
				
			elseif "exit" == event then
				
				print("DataHandle_onNodeEvent:exit")
				onExit()
			elseif "enterTransitionFinish" == event then
			--elseif "cleanup" == event then
			end
		end
		
		self:setTouchMode(kCCTouchesOneByOne) -- kCCTouchesAllAtOnce
		self:registerScriptTouchHandler(onTouchEvent,true)
		self:registerScriptHandler(onNodeEvent)
    end
    self:setVisible(true)
    self:loadEffectSounds()
    
end

function DataHandle:loadEffectSounds()
	for i=1,13 do
		SimpleAudioEngine:sharedEngine():preloadEffect("Sounds/" ..tostring(i) ..".aif")
    end
end


function DataHandle:getCurrentSelectSprite(pos)
    if (m_drawSpriteArray) then
        for i=0,m_drawSpriteArray:count() do
			local item = m_drawSpriteArray:objectAtIndex(i)
            if (item and item:positionInContent(pos)) then
                return item
            end
        end
    end
    
    return nil
end

function DataHandle:onTouchesCancelled(args)
	print("DataHandle:onTouchesCancelled 111")
end

function DataHandle:onTouchesBegan(localPoint)
    print("DataHandle:onTouchesBegan 111")
    if m_toolsDisappear then
        toolDisappearSelected(localPoint)
        return false
    end
    
    m_movePos = localPoint
    m_objectHasContina = false
    m_removeAllSameColor = false
    
    if (m_stackArray:count() >0) then
        for i=0,m_stackArray:count() do
			local node = m_stackArray:objectAtIndex(i)
            if node  then
                node:unselected()
            end
        end
        m_stackArray:removeAllObjects()
    end
    
    local ds = getCurrentSelectSprite(localPoint)
    
    if (ds and ds:selectedType()) then
        
        m_stackArray:addObject(ds)
        playingSound(m_stackArray:count())
        m_currentDrawColor = ds.m_color
        m_drawLine = true
        return true
    end
    return false
end

function DataHandle:onTouchesMoved(localPoint)
    print("DataHandle:onTouchesMoved 111")
    m_movePos = localPoint
    
    local ds = getCurrentSelectSprite(localPoint)
    
    if (ds and ccc4FEqual(m_currentDrawColor, ds.m_color)) then
        
        if (ds == m_stackArray:lastObject()) then
            return
        end
        if m_stackArray:count() >=2 and
            ds == m_stackArray:objectAtIndex(m_stackArray:count()-2) then --退一格
            
            local tds = tolua.cast(m_stackArray:lastObject(),"DrawSprite")
            tds:unselected()
            if (m_objectHasContina) then
                m_removeAllSameColor = false
                m_objectHasContina = false
            end
            m_stackArray:removeLastObject()
            ds:selectedType()
            self:playingSound(m_stackArray:count()) --//play sounds
            return
        end
        
        if ( not m_objectHasContina and m_stackArray:containsObject(ds)) then
            
            local tds = tolua.cast(m_stackArray:lastObject(),"DrawSprite")
            local absValue = abs(ds.m_x - tds.m_x) + abs(ds.m_y - tds.m_y)
            ds:unselected()
            if (absValue == 1 and ds:selectedType()) then                
                m_objectHasContina = true
                m_removeAllSameColor = true
                
                m_stackArray:addObject(ds)
                self:playingSound(m_stackArray:count()) --//play sounds
            end
        end
        
        if (m_objectHasContina and m_stackArray:containsObject(ds)) then
            return
        end
        
        m_objectHasContina = false
        local tds = tolua.cast(m_stackArray:lastObject(),"DrawSprite")
        local absValue = abs(ds.m_x - tds.m_x) + abs(ds.m_y - tds.m_y)
        
        if (absValue == 1 and ds:selectedType()) then
            m_stackArray:addObject(ds)--//play sounds
            self:playingSound(m_stackArray:count())
        end
    end
end

function DataHandle:onTouchesEnded(args)
    print("DataHandle:onTouchesEnded 111")
	m_drawLine = false
    
    local disappearCount = 0
    
    if (m_stackArray:count()>=2) then
        if (m_removeAllSameColor) then
            self:disappearAllSameColorDotsWithSelected()
        else
            for i=0,m_stackArray:count()-1 do
				local node = tolua.cast(m_stackArray:objectAtIndex(i),"DrawSprite")
                if (node) then
                    if (i == m_stackArray:count()-1) then
                        node:disappear(true)
                    end
                    node:disappear(false)
                    disappearCount = disappearCount + 1
                end
            end
        end
    else
        for i=0,m_stackArray:count()-1 do
			local node = tolua.cast(m_stackArray:objectAtIndex(i),"DrawSprite")
			if (node) then
				node:unselected()
			end
		end
    end
    m_stackArray:removeAllObjects()
    
    if (self:getParent()) then
        self:getParent():playingScoreAdd(disappearCount)
    end
end

function DataHandle:disappearAllSameColorDotsWithSelected()
    local count = 0
    local dis = true
    for i=0,m_drawSpriteArray:count()-1 do
		local node = tolua.cast(m_drawSpriteArray:objectAtIndex(i),"DrawSprite")
        if (node and ccc4FEqual(m_currentDrawColor, node.m_color)) then
            if (dis) then
                node:disappear(true)
                dis = false
            end
            node:disappear(false)
            count = count + 1
        end
    end
    return count
end

function DataHandle:draw()
    getSuperMethod(self, "draw")(self)
    
    if (m_drawLine and m_canPlaying) then
        
        glLineWidth(10)
    
        local c4b = ccc4BFromccc4F(m_currentDrawColor)
        ccDrawColor4B(c4b.r, c4b.g, c4b.b, c4b.a)
        
        if (m_stackArray:count()>=2) then
			local ds = tolua.cast(m_stackArray:objectAtIndex(0),"DrawSprite")
            local pos = ds:getDrawNodePosition()
            for c=1,m_stackArray:count()-1 do
                ds  = tolua.cast(m_stackArray:objectAtIndex(c),"DrawSprite")
                local pos1 = ds:getDrawNodePosition()
                ccDrawLine(pos, pos1)
                pos = pos1
            end
        end
		local ds = tolua.cast(m_stackArray:lastObject(),"DrawSprite")
        local pos = ds:getDrawNodePosition()
        ccDrawLine(pos, m_movePos)
    end
end

function DataHandle:disappearEnd()
    
    local dropArray = CCArray:create()
    
    for  i = 0, m_drawSpriteArray:count()-1 do
        local ds = tolua.cast(m_drawSpriteArray:objectAtIndex(i),"DrawSprite")
        self:calcDropDown(ds,dropArray)
    end
    
    for  i = 0, dropArray:count()-1 do
        local ds = tolua.cast(dropArray:objectAtIndex(i),"DrawSprite")
        ds:resetDropdown()
    end
    
    for  i = 0, m_drawSpriteArray:count()-1 do
        local ds = tolua.cast(m_drawSpriteArray:objectAtIndex(i),"DrawSprite")
        if (ds.m_disappear) then
            ds:respawn()
        end
    end
end

function DataHandle:calcDropDown(drawSprite, resultArray)
    
    if (not drawSprite) then
        return
    end
    
    while (true) do
        local x = drawSprite.m_x;
        local y = drawSprite.m_y;
        
        local index = y*TOTALY + x;
        local nIndex = (y-1) * TOTALY +x;
        
        if (nIndex<0) then
            break;
        end
		
        local nDS = tolua.cast(m_drawSpriteArray:objectAtIndex(nIndex),"DrawSprite")
        if (nDS and nDS.m_disappear) then
            local nX = nDS.m_x
            local nY = nDS.m_y
            
            nDS:resetPropertyA(x ,y)
            drawSprite:resetPropertyA(nX,nY)
            
            m_drawSpriteArray:exchangeObjectAtIndex(index,nIndex)
            
            if (not resultArray:containsObject(drawSprite) and not drawSprite.m_disappear) then
                resultArray:addObject(drawSprite)
            end
        end
        if(nDS and not nDS.m_disappear)then
            break
        end
    end
end


function DataHandle:toolDisappearSelected(localPos)
    local ds = tolua.cast(self:getCurrentSelectSprite(localPos),"DrawSprite")
    local count = 0
    
    if (ds) then
        
        self:cancelAllDrawNodeBeSelected()
        
        if (m_toolsDisappearType) then
            
            m_currentDrawColor = ds.m_color
            count = self:disappearAllSameColorDotsWithSelected()
        else
            ds:disappear(true)
            count = 1
        end
        m_toolsDisappear = false
        
        
        
        if (self:getParent()) then
            
            local playing = tolua.cast(self:getParent(),"DotPlayingScene")
            if (playing) then
                playing:playingScoreAdd(count)
            end
        end
    end
    
end


function DataHandle:allDrawNodeBeSelected(disappearType)
    
    if (m_toolsDisappear) then
        return false
    end
    
    m_toolsDisappearType = disappearType
    m_toolsDisappear = true
    
    for i=0, m_drawSpriteArray:count()-1 do
        local ds = tolua.cast(m_drawSpriteArray:objectAtIndex(i),"DrawSprite")
        if (ds) then
            ds:KeepSelected()
        end
    end
    
    return true
end


function DataHandle:cancelAllDrawNodeBeSelected()
    
    for i=0, m_drawSpriteArray:count()-1 do
        local ds = tolua.cast(m_drawSpriteArray:objectAtIndex(i),"DrawSprite")
        if (ds) then
            ds:unKeepSelected()
        end
    end
end



function DataHandle:startAnimtionDisplay()
    self:setVisible( true)
    if (m_drawSpriteArray) then
        
		for i=0, m_drawSpriteArray:count()-1 do
            local node = tolua.cast(m_drawSpriteArray:objectAtIndex(i),"DrawSprite")
            if (node) then
                node:spawnDropdown()
            end
        end
    end
end


function DataHandle:startPlaying()
    
    m_toolsDisappear = false
    m_canPlaying = true
    
    self:setTouchMode(kCCTouchesOneByOne)
    self:setTouchEnabled(true)
end

function DataHandle:moveOut()
    m_canPlaying = false
    self:setVisible(false)
end

function DataHandle:moveIn()
    m_canPlaying = true
    self:setVisible(true)
end


function DataHandle:playingSound(count)
    
    if (count>13) then
        count = 13
    end
    
    local soundName = "Sounds/" .. count .. ".aif"
    SimpleAudioEngine:sharedEngine():playEffect(soundName)
end


--[[
function DataHandle:dealloc()
    [super dealloc];
end
]]

function DataHandle:onExit()
	m_stackArray:removeLastObject()
	m_stackArray = nil
    m_drawSpriteArray:removeLastObject()
	m_drawSpriteArray = nil
end
--return DataHandle

function Create()
	local layer = DataHandle:new()
	layer:init()
	return layer
end