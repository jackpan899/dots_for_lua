
require("NetWorkHandle")
require("WebRegisterController")
require("MutablePlayerScene")


local hasResponse = false

local MatchHudLayer = class("MatchHudLayer", function()
    local layer = CCLayer:create()
	if layer ~= nil then
		MatchHudLayer:init(layer)
	end
	print("MatchHudLayer:new()")
    return layer
end)

function MatchHudLayer:init(layer)
    if (layer) then
        layer:setAnchorPoint(CCPointZero)
        hasResponse = false
    end
end


function MatchHudLayer:startMatch()
    if (hasResponse) then
        return
    end
    hasResponse = true
end

function MatchHudLayer:exitMatch()
	
end



function MatchHudLayer:reveiveMessage(dic ,errorMsgDic)
    --NSLog(@"dic:%@",dic);NSLog(@"error:%@",error);
    
end


function MatchHudLayer:alertView(alertView ,buttonIndex)
    
    hasResponse = false
    
    if (alertView:getTag() == 1) then
        if (buttonIndex == 1) then
--            [self stargGame];
        end
    end
    if (alertView:getTag() == 2) then
        if (buttonIndex == 1) then
            self:registerNow()
        end
    end
end

function MatchHudLayer:stargGame(oppname ,oppPoint)
    if self:getParent() then
        --NSLog(@"start game!");
        local mps = tolua.cast(self:getParent(),"MutablePlayerScene")
        mps:startGame(oppname,oppPoint)
    end
end

function MatchHudLayer:registerNow()
    --WebRegisterController * viewController = WebRegisterController alloc]init]autorelease];
    --AppController *app = (AppController*) UIApplication sharedApplication] delegate];
    --app navController] pushViewController:viewController animated:YES];
end

return MatchHudLayer