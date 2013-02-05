--[[
Written by Murdoka

The Eventmanager is written to attach events (async or synchron).

Asynchron Events are small Lua Scripts that will be compiled and run in context of WoW
Synchron Events need EventManager.DoEvents() in loops to get fired due to missing threading in lua


=============================================
Operating mode:

The EventManager creates a Frame under the context of WoW.
Start the EventManager via EventManager.Run().
To Disable Async Events use EventManager.ShutDown()
To allow that Sync Events are fired use EventManager.DoEvents()

In this example i use CHAT_CHANNEL_MSG to abort the Script. 
If 'exit' is found on any Channel the Script will abbort.

To get this to work:

1. Define the Eventhandler:
----------------------------
		function OnCHAT_MSG_CHANNEL()
			--EventManager.AddSyncEventAction(eventname,callbackfunction)
			--eventname: the exact WoW event name
			--the function reference that should be called after the event occured
			EventManager.AddSyncEventAction("CHAT_MSG_CHANNEL",exit_cmd_callBack)
		end

		
2. Define the Event Callback function:
--------------------------------------
		--Every Event have up to 13 arguments. You can use it in your function signature
		--for CHAT_MSG_CHANNEL it can looks like: (arg13 is missing here because its not used)
		function exit_cmd_callBack(message,author,language,channel,target,flag,arg6,arg7,arg8,arg9,arg10,arg11,sender)
			_Log(sender)
			if message and message == "exit" then
				ExitExample = 0
			end
		end


3. Register Your Events to the EventManager:
--------------------------------------------
		-- Function that will be called if the EventManager is initiated
		function AddOn_ExitCommand()
			OnCHAT_MSG_CHANNEL()
		end

		--EventManager.RegisterAddOns(function_reference)
		--function_reference: Function reference to a function that will register all your Events
		--in this examle its only one OnCHAT_MSG_CHANNEL() event that is registered to this AddOn
		EventManager.RegisterAddOns(AddOn_ExitCommand)

Access EventParameter in Async Call :
-------------------------------------
for Example see QUEST_ACCEPTED Event

		--eventArgs will be added to FunctionContext after the Event is fired
		-- using:  local arg0,arg1,arg2=eventArgs
		function OnQUEST_ACCEPTED()
			local func = [[
							if eventArgs then
								local QuestIndex=eventArgs
								AddQuestWatch(QuestIndex)
							end
						]]
			EventManager.AddAsyncEventAction("QUEST_ACCEPTED",func)
		end

]]--


ExitExample = 1
dofile("Eventmanager.lua");
dofile("event_chat_msg_channel.lua");
dofile("event_quest_autoaccept.lua");
dofile("event_autojoin_raid.lua");


-- Run EventManager (Main Loop)
EventManager.Run()
while ExitExample == 1 do
	Sleep(1000)
	EventManager.DoEvents()
end
EventManager.ShutDown()
_Log("Exit Script.")