require("config")


--问题：如果lua继承的C++类，本身也继承自另一个基类。并且都重写了一个共同的函数，
--      则调用此函数的指针的时候是否返回正确？

--[[
--============================================================================
--继承CCLayer示例
local MyLayer = class("MyLayer", function()
    return CCLayer:create()
end)
-- override CCLayer::setVisible
function MyLayer:setVisible(visible)
    -- invoke CCLayer::setVisible
    getSuperMethod(self, "setVisible")(self, visible)
    -- to do something.
end
--============================================================================

--============================================================================
--继承CCSprite示例
--自定义类继承sprite，前提是这个sprite必须先绑定好c++中的sprite
MyCustom = class("MyCustom",function(filename)  --通过返回一个sprite实现继承CCSprite类，
    return CCSprite:create(filename)           --这里的function就是下面的MyCustom.new
end)

MyCustom.__index = MyCustom     --索引访问
MyCustom.aaa = 0    --定义属性及对应值

function MyCustom:create(filename , aaa)    
    local mySpr = MyCustom.new(filename)    --这里使用的是''."，不是":"
    self.aaa = aaa  --设置属性值
    return mySpr
end

-- 实现重写父类方法
function MyCustom:setVisible(visible)
    getSuperMethod(self, "setVisible")(self, visible) --调用父类方法并传递参数
    print("override setVisible method")
end
--============================================================================
]]

local m_x = 0
local m_y = 0
local m_color = nil

local CCDrawSprite = class("CCDrawSprite", function()
    local node = CCDrawNode:create()
    return node
end)

-- override CCNode::setVisible (重写setVisible需将基类的setVisible指针保存起来，如:_setVisibleFunc)
function CCDrawSprite:setVisible(visible)
    getSuperMethod(self, "setVisible")(self, visible) --调用父类方法并传递参数
    print("override setVisible method")
    -- to do something.(当显示时可以添加动画，隐藏时可以删除动画)
end

function CCDrawSprite:init() --此函数不算是重写，因为并不是调用的基类的指针。
    if self then
        self:setAnchorPoint(ccp(0.5, 0.5))
        self:setPosition(ccp(0, 0))
        calcColor()
    end
end

function CCDrawSprite:calcPos(x,y)
    local width = self:getAnchorPoint().x * m_w + x * m_w;
    local height = self:getAnchorPoint().y * m_h + y * m_h;
    return ccp(width, height)
end

function CCDrawSprite:calcColor()
    local colortype = getRandom(TOTAL_TYPE)
    if (colortype == 0) then
        m_color = ccc4fBlue
    elseif (colortype == 1) then
        m_color = ccc4fGreen
    elseif (colortype == 2) then
        m_color = ccc4fOrange
    elseif (colortype == 3) then
        m_color = ccc4fPurple
    elseif (colortype == 4) then
        m_color = ccc4fRed
    else
        m_color = ccc4fRed
    end
end

function CCDrawSprite:spawnAtX(x,y,w,h)
    m_disappear = true
    m_x = x
    m_y = y
    m_w = w
    m_h = h
    
    self:setContentSize(CCSizeMake(DRAWSPRITE_RADIUES, DRAWSPRITE_RADIUES))
    
    self:drawDot(self:getPosition(),DRAWSPRITE_RADIUES,m_color)
end

function CCDrawSprite:spawnDropdown()
	local size = CCDirector:sharedDirector():getWinSize()
    local wd = self:getAnchorPoint().x * m_w + m_x * m_w
    self:setPosition(ccp(wd, size.height))
    local pos = calcPos(m_x ,m_y)
    
	local delayTime = CCDelayTime:create(m_y*SPAWN_DROPDOWN_TIME/5) 
	local funcall= CCCallFunc:create(
		function()
			print("2222")
			m_disappear = false
			self:setVisible( true)
		end) 
	local moveto = CCMoveTo:create(SPAWN_DROPDOWN_TIME,pos)
	local jump = CCJumpTo:create(SPAWN_JUMP_TIME,pos ,30 ,3)
	
	local seq1 = CCSequence:createWithTwoActions(delayTime, moveto)
	local seq2 = CCSequence:createWithTwoActions(jump, funcall)
    local sequence = CCSequence:createWithTwoActions(seq1, seq2)
	self:runAction(sequence)
	
end

function CCDrawSprite:resetPropertyA(x ,y) 
    m_x = x
    m_y = y
end

function CCDrawSprite:resetDropdown()
    m_disappear = true
    local pos = calcPos(m_x ,m_y)
	local moveto = CCMoveTo:create(RESET_DROPDOWN_TIME,pos)
	local jump = CCJumpTo:create(RESET_JUMP_TIME,pos ,15 ,RESET_JUMP_TIMES)
	local funcall= CCCallFunc:create(
		function()
			print("333")
			m_disappear = false
		end) 
	local seq1 = CCSequence:createWithTwoActions(moveto, jump)
    local sequence = CCSequence:createWithTwoActions(seq1, funcall)
	self:runAction(sequence)
end

function CCDrawSprite:positionInContent(pos)
    return  self:boundingBox():containsPoint(pos)
end

function CCDrawSprite:selectedType(colorType)
    
    if (m_disappear or not ccc4FEqual(colorType, m_color)) then
        return false
    end
    
    self:setScale(1.0)
    local scaleBy = CCScaleBy:create(0.2 ,2.0)
    local sequence = CCSequence:createWithTwoActions(scaleBy, scaleBy:reverse())
    self:runAction(sequence)
    
    return true
end

function CCDrawSprite:disappear(bCallf)
    
    local scaleBy = CCScaleBy:create(0.1 ,1.5)
    local scaleBy2 = CCScaleBy:create(0.2 ,0)
    local sequence = CCSequence:createWithTwoActions(scaleBy, scaleBy2)
    
    self:runAction(sequence)
end

function CCDrawSprite:randpos()
    local pos = ccp(getRandom(320), getRandom(480))
    self:setPosition(pos)
    CCLOG("%f,%f",pos.x,pos.y)
end

return CCDrawSprite