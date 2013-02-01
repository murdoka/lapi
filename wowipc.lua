-- Inter-Process-Communication


function WoWIPC.DoEvents()
	
end

WoWIPC.__eventTable = {}
function WoWIPC.RegisterEvent(eventName,ptr)
	if not WoWIPC.__eventTable[eventName] then WoWIPC.__eventTable[eventName] = {} end
	if not WoWIPC.__eventTable[eventName][ptr] then WoWIPC.__eventTable[eventName][ptr] = true end
end

function WoWIPC.UnregisterAllEvents(eventName)
	if WoWIPC.__eventTable[eventName] then WoWIPC.__eventTable[eventName] = nil end
end