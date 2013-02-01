-- Loading Classes
WoWDebug = 4;--0 nichts / 1 info / 2 warning / 3 Error / 4 debug
dofile("wowipc.lua");
dofile("wowobject.lua");
dofile("wowunit.lua");




function WoWLog(Message, loglevel)
	if loglevel == WoWDebug then _Log(Message) end
end

function WoWFoo()

	questManager = WoWQuestManager:new();
	
	
	--_Log(questManager:ToString())


	--_Log("QuestCount: "..WoWQuest.Count())
	--_Log("GetIndexByQuestID: "..WoWQuest.GetIndexByQuestID(31821))
	
	--quest = WoWQuest:new({_ID = 31109})--culling the swarm
	--quest:Foo()
	--quest:Track()
	--if quest:IsTracked() then _Log("True") else _Log("False") end
	--quest:DoNotTrack()
		
	--quest:Abandon();
	--quest = WoWQuest:new({_ID = 31481})
	--quest = WoWQuest:new({_ID = 31821})
	
	--_Log(quest.Title)
	
	
	--[[
	me = WoWObject:new({Address=750517304})
	_Log(me.ToString())
	_Log(me.Address)
	]]--
	--[[
	me2 = WoWUnit:new()
	_Log(me2.ToString())
	_Log(me2.Address)
	]]--
end


local status, err = pcall(WoWFoo);
if not status then
	if err == nil then
		err = "<nil>";
	end
	_Log("LUA error encountered:");
	_Log(err);
	_Log("aborting script");
end


--[[
dofile("unit.lua");
dofile("player");
dofile("target");
dofile("groupMember");
dofile("item");
dofile("quest");
dofile("faction");
dofile("group");
dofile("movement");
dofile("pet");
dofile("spell");
dofile("skill");
dofile("totem");
dofile("map");
]]--