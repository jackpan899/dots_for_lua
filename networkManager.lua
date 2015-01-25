
--==================以下定义各种消息发送及返回处理===========================
-------------------------------------------------------------------------------
--发送消息统一接口
function sendNetMessage(actionId,protobufData)
	local datatemp = ""
	if protobufData ~= nil then
		datatemp = protobufData:SerializeToString()
	end
	print("datatemp=",datatemp)
	print("actionId",tostring(actionId))
	print("datatemp",tostring(datatemp))
	
	ScutDataLogic.CNetWriter:getInstance():writeString("ActionId",tostring(actionId))
    ScutDataLogic.CNetWriter:getInstance():writeString("uidex", tostring(getCurrentUserID()))
	ScutDataLogic.CNetWriter:getInstance():writeString("cidex", tostring(getCurrentCharIDInGame()))
	ScutDataLogic.CNetWriter:getInstance():writeString("Data",datatemp )
	
	ZyExecRequest(rootScene, nil,false)

end
-------------------------------------------------------------------------------
function sendNetMessageExt(actionId,Userid,protobufData)
	local datatemp = protobufData:SerializeToString()
	print("sendNetMessageExt actionId",tostring(actionId))
	print("sendNetMessageExt Userid",tostring(Userid))
	ScutDataLogic.CNetWriter:getInstance():writeString("ActionId",tostring(actionId))
	ScutDataLogic.CNetWriter:getInstance():writeString("Userid",tostring(Userid) )
    ScutDataLogic.CNetWriter:getInstance():writeString("Data",datatemp )
	
	ZyExecRequest(rootScene, nil,false)

end


--消息返回统一接口
function netCallback(pZyScene, lpExternalData, isTcp)
	
	print("netCallback actionId =",actionId)
	print("netCallback pZyScene =",pZyScene)
	print("netCallback lpExternalData =",lpExternalData)
	print("netCallback isTcp =",isTcp)
	
    local actionId = ZyReader:getActionID()
	local restult = ZyReader:getResult()
	print("netCallback restult =",restult)
	print("netCallback actionId =",actionId)
	
	if restult == 0 then --网络消息返回正常
		if 101 == actionId then -- register 
			registerMsgCallback()
		end
	end
end


--=====账号注册=====================================================
function sendRegisterMsg(user_name,password)
	
	CCLOG("sendRegisterMsg, user_name="..tostring(user_name))
	CCLOG("sendRegisterMsg, password="..tostring(password))
	
	local registerMsg = msg_pb.register()
	registerMsg.name = user_name
	registerMsg.pwd = password
	local datatemp = registerMsg:SerializeToString()
	sendNetMessage(101,registerMsg)
end

--=====账号注册消息返回=====================================================
function registerMsgCallback()
	closeLoadingUI()
	local str = ZyReader:readString()
	local registerMsgBack = msg_pb.register_rep() 
	registerMsgBack:ParseFromString(str)
	print(" registerMsgBack.ret",registerMsgBack.ret)
	print(" registerMsgBack.userid",registerMsgBack.userid)
	if registerMsgBack.ret == 1 then --注册成功
		registerSuccess(registerMsgBack.userid)
	elseif registerMsgBack.ret == 2 then --用户名已存在
		registerFail(registerMsgBack.ret)
	end
end

