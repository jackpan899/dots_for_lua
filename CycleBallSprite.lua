

local CycleBallSprite = class("CycleBallSprite", 
	function()
		local sprite = CCSprite:create(getPathByName("Images/ball.png"))
		if sprite ~= nil then
			CycleBallSprite:init(sprite)
		end
		print("CycleBallSprite 1111111111111111")
		return sprite
	end)

CycleBallSprite.canRo = false
CycleBallSprite.angle = 0

function CycleBallSprite:init(sprite)
    if (sprite) then
        canRo = false
		angle = 0
        sprite:setScale(0.5)
    end
end

function CycleBallSprite:startCycleMove(cp ,angle)
    canRo  = true
    angle = angle
end

return CycleBallSprite