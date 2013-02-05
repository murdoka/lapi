--[[
http://www.wowwiki.com/Events_A-Z_%28Full_List%29
CHAT_MSG_CHANNEL"
Fired when the client receives a channel message.
arg1    chat message 
arg2    author 
arg3    language 
arg4    channel name with number ex: "1. General - Stormwind City" 
		zone is always current zone even if not the same as the channel name 
arg5    target 
		second player name when two users are passed for a CHANNEL_NOTICE_USER (E.G. x kicked y) 
arg6    AFK/DND/GM "CHAT_FLAG_"..arg6 flags 
arg7    zone ID used for generic system channels (1 for General, 2 for Trade, 22 for LocalDefense, 23 for WorldDefense and 26 for LFG) 
		not used for custom channels or if you joined an Out-Of-Zone channel ex: "General - Stormwind City" 
arg8    channel number 
arg9    channel name without number (this is _sometimes_ in lowercase) 
		zone is always current zone even if not the same as the channel name 
arg11    Chat lineID used for reporting the chat message. 
arg12    Sender GUID 
]]--
function exit_cmd_callBack(message,author,language,channel,target,flag,arg6,arg7,arg8,arg9,arg10,arg11,sender)
	_Log(sender)
	if message and message == "exit" then
		ExitExample = 0
	end
end

function OnCHAT_MSG_CHANNEL()
	EventManager.AddSyncEventAction("CHAT_MSG_CHANNEL",exit_cmd_callBack)
end

-- Function that will be called if the EventManager is initiated
function AddOn_ExitCommand()
	OnCHAT_MSG_CHANNEL()
end

EventManager.RegisterAddOns(AddOn_ExitCommand)