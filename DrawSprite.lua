
module("DrawSprite",package.seeall)

require("config")
local caleActiontag = 100


local DrawSprite = class("DrawSprite", function()
    local node = CCNode:create()
    return node
end)

DrawSprite.__index = DrawSprite   -- 用于访问

DrawSprite.m_x = 0
DrawSprite.m_y = 0
DrawSprite.m_w = 0
DrawSprite.m_h = 0
DrawSprite.m_dropCount = 0
DrawSprite.m_disappear = false --是否消失
DrawSprite.m_hasSelected = false --可否被选择

DrawSprite.m_color = nil --ccColor4F

DrawSprite.m_drawNode = nil -- CCDrawNode * 画当前颜色的圆点
DrawSprite.m_selectNode = nil -- CCDrawNode * 用于被选中时播放动画   


-- override CCNode::setVisible (重写setVisible需将基类的setVisible指针保存起来，如:_setVisibleFunc)
function DrawSprite:setVisible(visible)
    getSuperMethod(self, "setVisible")(self, visible) --调用父类方法并传递参数
    print("override setVisible method")
    -- to do something.(当显示时可以添加动画，隐藏时可以删除动画)
end


function DrawSprite:init() --此函数不算是重写，因为并不是调用的基类的指针。
    if self then
        self:calcColor()
    end
end



function DrawSprite:calcPos(x,y)
	print(string.format("DrawSprite:calcPos,x=%f,y=%f,m_w=%f,m_h=%f",tonumber(x),tonumber(y),m_w,m_h))
    local width = self:getAnchorPoint().x * m_w + x * m_w;
    local height = self:getAnchorPoint().y * m_h + y * m_h;
	print(string.format("DrawSprite:calcPos self:getAnchorPoint() x=%f,y=%f,width=%f,height=%f",self:getAnchorPoint().x,self:getAnchorPoint().y,width,height))
    return ccp(width, height)
end


function DrawSprite:calcColor()
    local colortype = getRandom(TOTAL_TYPE)
	print("DrawSprite:calcColor colortype =",colortype)
    if (colortype == 0) then
        m_color = ccc4fBlue
    elseif (colortype == 1) then
        m_color = ccc4fGreen
    elseif (colortype == 2) then
        m_color = ccc4fRed
    elseif (colortype == 3) then
        m_color = ccc4fPurple
    elseif (colortype == 4) then
        m_color = ccc4fOrange
    else
        m_color = ccc4fPurple
    end
end


function DrawSprite:spawnAtX(x,y,w,h)
	
	print(string.format("DrawSprite:spawnAtX,x=%f,y=%f,w=%f,h=%f",x,y,w,h))
	
    m_hasSelected = true
    m_disappear = false
    m_x = x
    m_y = y
    
    m_w = w*2
    m_h = h*2
  
    self:calcColor()
    
    local size = CCDirector:sharedDirector():getWinSize()
    local wd = self:getAnchorPoint().x * m_w + x * m_w
	print(string.format("DrawSprite:spawnAtX,wd=%f,m_w=%f,size.width=%f,size.height=%f",wd,m_w,size.width,size.height))
    m_drawNode = CCDrawNode:create()
    m_drawNode:setPosition(ccp(wd, size.height))
    m_drawNode:setContentSize(CCSizeMake(DRAWSPRITE_RADIUES, DRAWSPRITE_RADIUES))
    self:addChild(m_drawNode)
    m_drawNode:drawDot(ccp(0, 0) ,DRAWSPRITE_RADIUES ,m_color)
    
    m_selectNode = CCDrawNode:create()
    m_drawNode:addChild(m_selectNode)
    
    local col = ccc4f(m_color.r, m_color.g, m_color.b, 255*0.75)
    
    m_selectNode:drawDot(ccp(0, 0) ,DRAWSPRITE_RADIUES ,col)
    m_selectNode:setVisible(false)
end

function DrawSprite:respawn()
    
    m_disappear = false
    m_drawNode:stopAllActions()
    m_drawNode:clear()
    m_drawNode:setScale(1.0)
    
    m_selectNode:clear()
    m_selectNode:setScale(1.0)
    
    self:calcColor()
    
	local size = CCDirector:sharedDirector():getWinSize()
    local wd = self:getAnchorPoint().x * m_w + m_x * m_w -- +addWidth
    
    m_drawNode:setPosition(ccp(wd, size.height))
    m_drawNode:drawDot(self:getPosition() ,DRAWSPRITE_RADIUES ,m_color)
    
    local col = ccc4f(m_color.r, m_color.g, m_color.b, 255*0.75)
    m_selectNode:drawDot(ccp(0, 0) ,DRAWSPRITE_RADIUES ,col)
    self:respawnDropdown()
end


function DrawSprite:spawnDropdown()	
	m_dropCount = 0
    self:stopAllActions()
    local pos = calcPos(m_x ,m_y)
    
	local delayTime = CCDelayTime:create(m_y*SPAWN_DROPDOWN_TIME/5) 
	local moveto = CCMoveTo:create(SPAWN_DROPDOWN_TIME/2,pos)
	local jump = CCJumpTo:create(SPAWN_JUMP_TIME,pos ,30 ,1)
	local funcall= CCCallFunc:create(
		function()
			print("2222")
			m_hasSelected = false
			self:setVisible( true)
		end)
	
	local seq1 = CCSequence:createWithTwoActions(delayTime, moveto)
	local seq2 = CCSequence:createWithTwoActions(jump, funcall)
    local sequence = CCSequence:createWithTwoActions(seq1, seq2)
	self:runAction(sequence)
end

function DrawSprite:respawnDropdown()
    m_dropCount = 0
    self:stopAllActions()
    local pos = calcPos(m_x ,m_y)
    
    local moveto = CCMoveTo:create(SPAWN_DROPDOWN_TIME/3,pos)
	local jump = CCJumpTo:create(SPAWN_JUMP_TIME/3*2,pos ,20 ,1)
	local funcall= CCCallFunc:create(
		function()
			print("333")
			m_hasSelected = false
			self:setVisible( true)
		end) 
	local seq1 = CCSequence:createWithTwoActions(moveto, jump)
    local sequence = CCSequence:createWithTwoActions(seq1, funcall)
	self:runAction(sequence)
end


function DrawSprite:resetPropertyA(x ,y) 
    if (y < m_y) then
        m_dropCount = m_dropCount + 1
    end
	m_x = x
    m_y = y
end


function DrawSprite:resetDropdown()
    m_hasSelected = true
    local pos = calcPos(m_x ,m_y)
	local moveto = CCMoveTo:create(RESET_DROPDOWN_TIME,pos)
	local jump = CCJumpTo:create(RESET_JUMP_TIME/3,pos ,15 ,1)
	local funcall = CCCallFunc:create(
		function()
			print("333")
			m_hasSelected = false
		end) 
	local seq1 = CCSequence:createWithTwoActions(moveto, jump)
    local sequence = CCSequence:createWithTwoActions(seq1, funcall)
	self:runAction(sequence)
	 m_dropCount = 0
end



function DrawSprite:positionInContent(pos)
	local orgx = m_drawNode:getPosition().x - DRAWSPRITE_WIDTH
    local orgy = m_drawNode:getPosition().y - DRAWSPRITE_HEIGH
	local rect = CCRectMake(orgx, orgy, DRAWSPRITE_WIDTH*2, DRAWSPRITE_HEIGH*2)
    return rect:containsPoint(pos)
end



function DrawSprite:selectedType()
    m_hasSelected = true
    m_selectNode:stopAllActions()
    m_selectNode:setScale(1.0)
    m_selectNode:setVisible(true)
    
	local scaleBy = CCScaleBy:create(0.1 ,2.0)
    local funcall = CCCallFunc:create(
		function()
			m_selectNode:setVisible(false)
		end) 
	local seq1 = CCSequence:createWithTwoActions(scaleBy, scaleBy:reverse());
	local seq2 = CCSequence:createWithTwoActions(seq1, funcall);
    (tolua.cast(seq2,"CCNode")):setTag(caleActiontag);
    m_selectNode:runAction(seq2)
    
    return true
end


function DrawSprite:disappear(bCallf)
    
    local scaleBy = CCScaleBy:create(0.1 ,1.5)
    local scaleBy2 = CCScaleBy:create(0.2 ,0)
	local seq1 = CCSequence:createWithTwoActions(scaleBy, scaleBy2)
	local sequence = seq1
	
	
	if bCallf then
		local funcall = CCCallFunc:create(
			function()
				 if self:getParent() then
					local data = tolua.cast(self.parent,"DataHandle")
					data:disappearEnd()
				end
			end)	
		sequence = CCSequence:createWithTwoActions(seq1, funcall)
	end
    m_disappear = true
    m_drawNode:runAction(sequence)
end

function DrawSprite:unselected()
    m_hasSelected = false
end

function DrawSprite:getDrawNodePosition()
    return m_drawNode:getPosition()
end


function DrawSprite:KeepSelected()
    m_hasSelected = true
    m_selectNode:stopAllActions()
    m_selectNode:setVisible(true)
    local scaleBy = CCScaleBy:create(0.1 ,1.7)
    m_selectNode:runAction(scaleBy)
end

function DrawSprite:unKeepSelected()
    
    m_hasSelected = false
    m_selectNode:stopAllActions()
    local scaleTo = CCScaleTo:create(0.1 ,1.0)
    
	local funcall = CCCallFunc:create(
		function()
			m_selectNode:setVisible(false)
		end)
   
    local seq = CCSequence:createWithTwoActions(scaleTo, funcall);
    (tolua.cast(seq,"CCNode")):setTag(caleActiontag);
    m_selectNode:runAction(seq)
end

--return DrawSprite

function Create()
	local node = DrawSprite:new()
	node:setAnchorPoint(ccp(0.5, 0.5))
	node:setPosition(ccp(0, 0))
	node:init()
	return node
end