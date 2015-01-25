
module("NetWorkHandle", package.seeall)


local selfMd5Address = nil
local startMatchDel = nil
local sendPointDel = nil
local sendGameOverDel = nil

local _sharedNewWork = nil


local function init()
    --selfMd5Address =  -- [[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier] retain];
    
end

function getSharedNetWork()
    if ( not _sharedNewWork) then
        _sharedNewWork = NetWorkHandle:init()
    end
    return _sharedNewWork
end

function startMatchOppoent(startMatchDelegate)
	-- startMatchDel = 
end

function cancellationMatchOppoent()
    startMatchDel = nil
end

-(void) sendCurrentPoint:(id) sendDelegate point:(NSInteger) point{
    --[[
	sendPointDel = sendDelegate;
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"NULL",selfMd5Address,point]
    ASIHTTPRequest * sendPoint = [ASIHTTPRequest requestWithURL:url];
    [sendPoint setRequestMethod:@"GET"];
    [sendPoint setTimeOutSeconds:30.0];
    [sendPoint setCompletionBlock:^{
        NSError * error;
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:sendPoint.responseData options:NSJSONReadingMutableLeaves error:&error];
        if (sendPointDel) {
            [sendPointDel reveiveMessage:dic Error:nil];
        }
        
    }];
    
    [sendPoint setFailedBlock:^{
        if (sendPointDel) {
            [sendPointDel reveiveMessage:nil Error:sendPoint.error.userInfo];;
        }
    }];
    [sendPoint startAsynchronous];
	]]
end

function cancellationSendPoint()
    sendPointDel = nil
end

-(void) sendGameOver:(id) gameOver point:(NSInteger)point{
    
    sendGameOverDel = gameOver;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"NULL",selfMd5Address]];
    ASIHTTPRequest * gameOverR = [ASIHTTPRequest requestWithURL:url];
    [gameOverR setRequestMethod:@"GET"];
    [gameOverR setTimeOutSeconds:30.0];
    
    [gameOverR setCompletionBlock:^{
        
        NSError * error;
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:gameOverR.responseData options:NSJSONReadingMutableLeaves error:&error];
        
        if (sendPointDel) {
//            MatchHudLayer * hud = (MatchHudLayer*)startMatchDel;
//            [hud reveiveMessage:dic Error:nil];
            [sendGameOverDel gameOverMssage:dic Error:nil];
        }
        
    }];
    
    [gameOverR setFailedBlock:^{
        if (sendPointDel) {
//            MatchHudLayer * hud = (MatchHudLayer*)startMatchDel;
            [sendGameOverDel gameOverMssage:nil Error:gameOverR.error.userInfo];
        }
    }];
    [gameOverR startAsynchronous];
}
-(void) cancellationGameOver{
    
}


- (void)dealloc
{
    [selfMd5Address release];
    [super dealloc];
}

@end
