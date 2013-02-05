--[[
http://www.wowwiki.com/Events_A-Z_%28Full_List%29
"GOSSIP_SHOW"
Fired when you talk to an npc 
]]--
function OnGOSSIP_SHOW()
	local func = [[
					-- Accept Available Gossip Quests
					for i=1, GetNumGossipAvailableQuests() do
						SelectGossipAvailableQuest(i)
					end
				]]
	EventManager.AddAsyncEventAction("GOSSIP_SHOW",func)
end

--[[
QUEST_DETAIL
Fired when the player is given a more detailed view of his quest. 
]]--
function OnQUEST_DETAIL()
	local func = [[
					AcceptQuest()
				]]
	EventManager.AddAsyncEventAction("QUEST_DETAIL",func)	
end

--[[
QUEST_PROGRESS
Fired when a player is talking to an NPC about the status of a quest and has not yet clicked the complete button. 
]]--
function OnQUEST_PROGRESS()
	local func = [[
					CompleteQuest()
				]]
	EventManager.AddAsyncEventAction("QUEST_PROGRESS",func)
end

--[[
QUEST_COMPLETE
Fired after the player hits the "Continue" button in the quest-information page, before the "Complete Quest" button.
In other words it fires when you are given the option to complete a quest, but just before you actually complete the quest (as stated above). 
]]--
function OnQUEST_COMPLETE()
	local func = [[
					GetQuestReward(0)
				]]
	EventManager.AddAsyncEventAction("QUEST_COMPLETE",func)
end

--[[
QUEST_ACCEPTED
This event fires whenever the player accepts a quest.
arg1 
    Quest log index. You may pass this to GetQuestLogTitle() for information about the accepted quest. 
]]--
-- In Async Methods you can access Event Parameter via eventArgs
function OnQUEST_ACCEPTED()
	local func = [[
					if eventArgs then
						local QuestIndex=eventArgs
						AddQuestWatch(QuestIndex)
					end
				]]
	EventManager.AddAsyncEventAction("QUEST_ACCEPTED",func)
end


-- Function that will be called if the EventManager is initiated
-- contain all Events for this AddOn
function AddOn_AcceptAnyQuest()
	OnGOSSIP_SHOW()
	OnQUEST_DETAIL()
	OnQUEST_PROGRESS()
	OnQUEST_COMPLETE()
	OnQUEST_ACCEPTED()
end

EventManager.RegisterAddOns(AddOn_AcceptAnyQuest)
