
module("DataController",package.seeall)


--public:
WORLD_TOPLIST = "worldtoplist"
LOCAL_TOPLIST = "localtoplist"

PLAYER_PROPERTY = "playerdefaultProperty"

NAME_KEY = "name"
SCORE_KEY = "score"


local m_filePath = ""
local m_dataDic = nil


local _sharedDataController = nil
function getSharedDataController()
    if (_sharedDataController == nil) then
        _sharedDataController = init()
    end
    return _sharedDataController
end

function init()
    m_dataDic  = CCDictionary:create()
    m_filePath = ""  --文件需要存储的位置
end


function readLoaclScoreTopList()

    reloadData()

    if m_dataDic:count() <= 0 then
        return nil
    end

    local array = tolua.cast(m_dataDic:objectForKey(LOCAL_TOPLIST),"CCArray")

    if (array) then
        return array
    end
    return nil
end

function readWorldScpreTopList()

    reloadData()

    if (m_dataDic == nil) then
        return nil
    end

    local world = tolua.cast(m_dataDic:objectForKey(WORLD_TOPLIST),"CCArray")

    if (world) then
        return world
    end
    return nil
end

function readPlayerDefaultProperty()
    reloadData()

    if (m_dataDic == nil) then
        return nil
--        [array initWithObjects:[NSNumber numberWithInteger:1],[NSNumber numberWithInteger:1], nil]
    end


    local array= tolua.cast(m_dataDic:objectForKey(PLAYER_PROPERTY),"CCArray")
    if (array == nil) then
		array = CCArray:create()
		array:addObject(CCString:create("1"))
        array:addObject(CCString:create("1"))
		array:addObject(CCString:create("1"))
    end
    return array
end

function getHighScore()
	local iScore = 0
    local sco = readLoaclScoreTopList()
    if (sco == nil) then
        return 0
    end
    local numberStr = tolua.cast(sco:objectAtIndex(0),"CCString")
    return numberStr:intValue()
end

function savePlayerDefauleProperty(ilevel,igold,exp)
    local array = CCArray:create()
	array:addObject(CCString:create(tostring(ilevel)))
	array:addObject(CCString:create(tostring(igold)))
	array:addObject(CCString:create(tostring(exp)))
	
    saveDataIntoFile(readLoaclScoreTopList(),readWorldScpreTopList(),array)
end

function savePlayerTemplateData(iscore) 
	local scoreArray = readLoaclScoreTopList()
	local saveScoreArray = nil 
	if (scoreArray) then
        saveScoreArray = CCArray:createWithArray(scoreArray)
    else
        saveScoreArray = CCArray:create()
    end
	
    saveScoreArray:addObject(CCString:create(tostring(iscore)))
   -- saveScoreArray:sortUsingFunction(Compare context:nil];

    local flag = false

    if (saveScoreArray:count()>7) then

        if (iscore == (tolua.cast(saveScoreArray:lastObject(),"CCString")):intValue() then
            flag = true
        end
        saveScoreArray:removeLastObject()
    end

    if (flag == false) then
        saveDataIntoFile(saveScoreArray,readWorldScpreTopList() ,readPlayerDefaultProperty())
    end
end



function saveDataIntoFile(localArray ,worldDic ,proArray)
    local dic = CCDictionary:create()
	dic:setObject(localArray,LOCAL_TOPLIST)
	dic:setObject(worldDic,WORLD_TOPLIST)
	dic:setObject(proArray,PLAYER_PROPERTY)
	
	--保存文件
   -- [NSKeyedArchiver archiveRootObject:dic toFile:m_filePath];
end

--读文件
function reloadData()
--[[
    if (m_dataDic) then
        m_dataDic:removeAllObjects()
    end

    if (!NSFileManager defaultManager] fileExistsAtPath:m_filePath]){
        m_dataDic = nil;
        return;
    }

    m_dataDic = [NSKeyedUnarchiver unarchiveObjectWithFile:m_filePath];

    if (m_dataDic) {
        [m_dataDic retain];
    }
	]]
end
