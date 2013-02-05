EventManager = {}

EventManager.DeSerializeSperator = ";^;"
EventManager.DeSerializeSperatorPattern = "([^;\^;]+)";
EventActionTable = {}
EventManager.AddOns = {}

function EventManager.RegisterAddOns(RegisterCallPtr)
	table.insert(EventManager.AddOns,RegisterCallPtr)
end

function EventManager.RegisterEventCalls()
	for _, funcPtr in ipairs(EventManager.AddOns) do
		if funcPtr then 
			funcPtr() 
		end
	end
end

function EventManager.AddAsyncEventAction(event,func)
	if not event then _Log("AddAsyncEventAction missing 'event'") return end
	if not func  then _Log("AddAsyncEventAction missing 'func'")  return end
	WowLuaDoString("EventManager_RegisterEvent('"..event.."')")
	WowLuaDoString('EventManager.AddAsyncEventAction("'..event..'",[['..func..']])')
end

function EventManager.AddSyncEventAction(event, func_ptr)
	WowLuaDoString("EventManager_RegisterEvent('"..event.."')")
	EventActionTable[event] = func_ptr
end

function EventManager.ShutDown()
	WowLuaDoString([[
							if EventManager ~= nil then
								if EventManager.frame ~= nil then
									CxDEBUG("Unregister All Events")
									EventManager.frame:UnregisterAllEvents()
								end
							end
							
							CxDEBUG("Shutdown")
					]])
end

function EventManager.Init()
	_Log("\n\nWaiting for Eventmanager.Init() ...\n")
	WowLuaDoString([[
							EventManager_InitDone = 0
							
							function CxDEBUG(message)
								DEFAULT_CHAT_FRAME:AddMessage("EventManager>> : "..message)
							end	
	
							CxDEBUG("")
							CxDEBUG("")
							CxDEBUG("<< EventManager V.0.1>>")
							CxDEBUG("=======================")
		
							-- Avoid double fireing
							if EventManager ~= nil then
								if EventManager.frame ~= nil then
									CxDEBUG("Unregister All Events")
									EventManager.frame:UnregisterAllEvents()
								end
							end
							
							CxDEBUG("Init EventManager")
							EventManager = nil -- Renew init frame
							EventManager = {}
							EventManager.InitDone = 0
							EventManager.EventMethods = {}
							
							EventManager_LastEventPointer = 0
							EventManager.EventBuffer = {}
							function EventManager.AddEvent(event,...)
								local arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13 = ...
								if not arg0 then arg0 = "" end
								if not arg1 then arg1 = "" end
								if not arg2 then arg2 = "" end
								if not arg3 then arg3 = "" end
								if not arg4 then arg4 = "" end
								if not arg5 then arg5 = "" end
								if not arg6 then arg6 = "" end
								if not arg7 then arg7 = "" end
								if not arg8 then arg8 = "" end
								if not arg9 then arg9 = "" end
								if not arg10 then arg10 = "" end
								if not arg11 then arg11 = "" end
								if not arg12 then arg12 = "" end
								if not arg13 then arg13 = "" end
								local seperator = "]]..EventManager.DeSerializeSperator..[["
								local serialize = string.format("%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",event,seperator,arg0,seperator,arg1,seperator,arg2,seperator,arg3,seperator,arg4,seperator,arg5,seperator,arg6,seperator,arg7,seperator,arg8,seperator,arg9,seperator,arg10,seperator,arg11,seperator,arg12,seperator,arg13)
								EventManager_LastEventPointer = EventManager_LastEventPointer + 1
								table.insert(EventManager.EventBuffer,EventManager_LastEventPointer,serialize)
							end

							function EventManager_SerializeEventData(number)
								if EventManager.EventBuffer[number] then
									return EventManager.EventBuffer[number]
								else
									return nil
								end
							end


							function EventManager.AddAsyncEventAction(event,func)
								if not event then return end
								if not func  then return end
								CxDEBUG("Register callback for: "..event.." ... ")
								if not EventManager.EventMethods[event] then EventManager.EventMethods[event] = {} end
								local compiledFunc = EventManager.__CompileMethod(func)
								if not compiledFunc then return end
								table.insert(EventManager.EventMethods[event],compiledFunc)
								CxDEBUG("Register callback for: "..event.." Complete! ")
							end
							
							function EventManager.__CompileMethod(func)
								CxDEBUG("      +---->Compile ... ")
								local f,error = loadstring(func,"Eventmanager LoadString")
								if not f then
									CxDEBUG("      +---->Compile FAILED!")
									CxDEBUG("Error: "..error)
									return nil
								end
								CxDEBUG("      +---->Compile complete ")
								return f
							end
							
							function EventManager.__CallBack(event,...)
								if not EventManager.EventMethods[event] then return end -- if no Callbacks a registered exit
								local e = EventManager.EventMethods[event]
								for i,f in ipairs(e) do 
									local newenv = {} 						-- new environment
									setmetatable(newenv, {__index = _G})	-- copy current Environment
									newenv.eventArgs = ...					-- expose arguments
									setfenv(f, newenv)
									f() -- execution
								end
							end

							
							-- Create Frame
							EventManager.frame, EventManager.events = CreateFrame("Frame","EventManager",UIParent), {};

							-- Generic EventHandler
							function EventManager.GenericEventCall(event,...)
								EventManager.AddEvent(event,...)
								EventManager.__CallBack(event,...)
							end
							
							-- Manage EventHandler
							EventManager.frame:SetScript("OnEvent", 	function(self, event, ...)
																			CxDEBUG("Incoming Event: "..event)
																			--EventManager.events[event](self, ...); 
																			EventManager.GenericEventCall(event,...)
																		end);
							
							-- Register Events
							function EventManager_RegisterEvent(event)
								if not event then 
									CxDEBUG("Unrecognized eventname")
									return 
								end
								CxDEBUG("Register event: "..event)
								EventManager.frame:RegisterEvent(event);
							end
							
							-- Unregister All Events
							function EventManager_UnregisterAllEvents()
								EventManager.frame:UnregisterAllEvents()
							end
							
							-- Unregister Event from frame
							function EventManager_UnregisterEvent(event)
								if not event then return end
								EventManager.frame:UnregisterEvent(event)
							end							

							CxDEBUG("EventManager running...")
							EventManager_InitDone = 1
					]])
	local j = 1
	local result = 0
	for j=1,5 do
		Sleep(500)
		result = tonumber(WowGetLuaValue("EventManager_InitDone")) or 0
		if result == 1 then break end
		_Log("Waiting for Init() ... Try: "..j)
	end

	if result == 1 then 
		_Log("EventManager running...")
		return true
	else
		_Log("EventManager could not loaded.")
		return false
	end
end

function EventManager.Deserialize(data)
	local result = {}
	local i = 0
	for match in string.gfind(data,EventManager.DeSerializeSperatorPattern) do
		i = i + 1
		result[i] = match
	end
	return unpack(result)
end



EventManager.LastEventPointer = 0
EventManager.ptr = 1
function EventManager.DoEvents()
		local sdata = ""
		EventManager.ptr = tonumber(WowGetLuaValue("EventManager_LastEventPointer")) or 1
		if EventManager.LastEventPointer < EventManager.ptr then
			for i=EventManager.LastEventPointer+1,EventManager.ptr do
				WowLuaDoString("serializeData = EventManager_SerializeEventData("..i..")")
				sdata = tostring(WowGetLuaValue("serializeData"))
				if sdata then 
					local event,arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13 = "","","","","","","","","","","","","","",""
					event,arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13 = EventManager.Deserialize(sdata)
					if EventActionTable[event] then -- event registered?
						EventActionTable[event](arg0,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13) -- Execute
					end
				end
			end
			EventManager.LastEventPointer = EventManager.ptr
		end	
end

function EventManager.Polling(sleep)
	if not sleep then sleep = 1000 end
	while 1 == 1 do
		Sleep(sleep)
		EventManager.DoEvents()
	end
end


function EventManager.__Launchner()
	if EventManager.Init() then
		EventManager.RegisterEventCalls()
	end
end

function EventManager.Run()
	local status, err = pcall(EventManager.__Launchner);
	if not status then
		if err == nil then
			err = "<nil>";
		end
		_Log("LUA error encountered:");
		_Log(err);
		_Log("aborting script");
	end		
end