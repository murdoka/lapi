--[[
===================================================================================
Author: Orionshock
Date: $Date
Revision: $Revision$
Notes:
	A Small Addon made to simply Pick Dailys Up, and Turn them in.
	not based on any framework, uses all internal code. it does however have a Twin Brother addon called DailyFu
Additional Credits:
	Facktotum, for providing the Netherwing Daily quests.
===================================================================================
Distibuted under the "Do What The Fuck You Want To Public License" (http://sam.zoy.org/wtfpl/)
-----
     DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar
  14 rue de Plaisance, 75014 Paris, France
 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO.

  /* This program is free software. It comes without any warranty, to
 the extent permitted by applicable law. You can redistribute it
 and/or modify it under the terms of the Do What The Fuck You Want
 To Public License, Version 2, as published by Sam Hocevar. See
 http://sam.zoy.org/wtfpl/COPYING for more details. */
===================================================================================
]]--
SOCD_ENABLE_DEBUG = true
SOCD_ENABLE_LOGING = true
local d_table = SOCD_DEBUG_TABLE or {}

-- if #SOCD_DEBUG_TABLE > 100 then
	-- SOCD_DEBUG_TABLE = {}
-- end

local function DEBUG(message, event)
	if SOCD_ENABLE_DEBUG == false then
		return 
	elseif SOCD_ENABLE_DEBUG == true then
		DEFAULT_CHAT_FRAME:AddMessage("SOCD_DEBUG: "..message)
	end
	if ENABLE_LOGING then
		timeIndex = GetTime()
		d_table[timeIndex] = {event, message}
	end
end
DEBUG("DEBUG ENABLED, THIS IS VERY SPAMMY", "Init")


SOCD = {}
local mod = SOCD

local npcs = {
   ["Skyguard Khatie"] = true,              	--BEM
   ["Sky Sergeant Vanderlip"] = true,       	--BEM
   ["Chu'a'lor"] = true,                    	--BEM
   ["Kronk"] = true,                        	--BEM
   ["Sky Sergeant Doryn"] = true,           	--SKET
   ["Skyguard Prisoner"] = true,            	--SKET
   ["Chief Overseer Mudlump"] = true,			--NETH
   ["Overlord Mor'ghor"] = true,				--NETH
   ["The Dragonmaw Foreman"] = true,			--NETH
   ["The Mistress of the Mines"] = true,		--NETH
   ["Yarzill the Merc"] = true,					--NETH
   }

local quests = {
    ["The Relic's Emanation"] = true,      							--BEM
    ["Wrangle More Aether Rays!"] = true,   						--BEM
    ["Bomb Them Again!"] = true,            						--BEM
    ["Banish More Demons"] = true,          						--BEM
	["Fires Over Skettis"] = true,          						--SKET
	["The Booterang: A Cure For The Common Worthless Peon"] = true, --NETH
	["Disrupting the Twilight Portal"] = true,						--NETH
	["Dragons are the Least of Our Problems"] = true, 				--NETH
	["Picking Up The Pieces..."] = true,							--NETH
	["The Not-So-Friendly Skies..."] = true,						--NETH
	["A Slow Death"] = true,
    }

local SpecialQuests = {
	["Escape from Skettis"] = true			--Escort Quest, SKET
}

function mod:GOSSIP_SHOW()
    DEBUG("GossipShow", "GossipShow")
	local npc = mod.CheckNPC() or "None"
	local quest, qs = mod.OpenCheck()
	local extra, es = mod.eOpenCheck()
	if (not quest and not qs) and extra then 
		quest = extra
		qs = es 
	end
	if qs == nil then return end
	DEBUG("GossipShow: "..npc..". Quest: "..quest..". Status = "..qs, "GossipShow")
	
    if npc and quest then
		if qs == "Avail" then
			DEBUG("GossipShow~Picking up Quest: "..quest..". From: "..npc,"GossipShow")
			SelectGossipAvailableQuest(1)
        elseif qs == "Active" then
            DEBUG("GossipShow~Turning in Quest: "..quest..". From: "..npc, "GossipShow")
			SelectGossipActiveQuest(1)
        end
    end

end

function mod:QUEST_DETAIL()
	DEBUG("QuestDetail", "QuestDetail")
	local npc = mod.CheckNPC() or "None"
	local quest = mod.TitleCheck()
	local extra = mod.eTitleCheck()
	if not quest then quest = extra end

    if npc and quest then        
        DEBUG("QuestDetail~Accepting Quest: "..quest..". From: "..npc, "QuestDetail")
		AcceptQuest()
    end
end

function mod:QUEST_PROGRESS()
    DEBUG("QuestProgress", "QuestProgress")
	local npc = mod.CheckNPC() or "None"
	local quest = mod.TitleCheck()
	local extra = mod.eTitleCheck()
	if not quest then quest = extra end
	
	if npc and quest then
		DEBUG("QuestProgress~Gossip for turning In Quest: "..quest..". For: "..npc, "QuestProgress")
		CompleteQuest()
    end
end

function mod:QUEST_COMPLETE()
    DEBUG("QuestComplete", "QuestComplete")
	local npc = mod.CheckNPC() or "None"
	local quest = mod.TitleCheck()
	local extra = mod.eTitleCheck()
	if not quest then quest = extra end
	
	if npc and quest then
        if extra then  --handle escort quest seperatly
			DEBUG("QuestProgress~Found Escort Quest Turn In from: "..npc, "QuestComplete")
            if (DailyFu and DailyFu.db.char.options.escort) then --wonder if we have DailyFu Installed
				DEBUG("QuestProgress~DailyFu Installed & Option is set", "QuestComplete")
                if (DailyFu.db.char.options.escort == nil) or (DailyFu.db.char.options.escort == 3) then -- if it's installed, check for the None Option and return
					DEBUG("QuestProgress~DailyFu Installed & Option is nil or None, Doing Nothing", "QuestProgress")
					return
                elseif (DailyFu.db.char.options.escort == 1) or (DailyFu.db.char.options.escort == 2) then --Veryify that it's one or 2 else API shits brick
					DEBUG("QuestProgress~DailyFu Installed & Option is set, Getting Option: "..DailyFu.db.char.options.escort, "QuestComplete")
					GetQuestReward(DailyFu.db.char.options.escort)
                end
            elseif (not DailyFu) or (DailyFu.db.char.options.escort == nil) then
				DEBUG("QuestProgress: DailyFu not installed or option is not set. Ending here, no option Selected", "QuestComplete")
				return
			end
        else
			DEBUG("QuestProgress~Getting Gold from Daily Quest: "..quest..". NPC: "..npc, "QuestProgress")
            GetQuestReward(0)
		end
		if DailyFu then --check dailyFu again
			DEBUG("QuestProgress~DailyFu Installed & Sending Quest Completion", "QuestProgress")
			DailyFu:AddQuestToCompleted(quest) -- add quest.
		end
    end
end

--~ Check the F'n NPC
function mod.CheckNPC()
    local target = UnitName("target")
    if npcs[target] then
		DEBUG("NPC Query, Found: "..target, "NPC-Query")
		return target
    end
end

--~ Check the F'n Quest
	mod.OpenCheck = function()
		if quests[select(1, GetGossipAvailableQuests()) ] then
			DEBUG("CheckQuest.GossipShow~Avail: "..select(1, GetGossipAvailableQuests()), "Quest-OpenCheck-Avail")
			return select(1, GetGossipAvailableQuests() ), "Avail"
		elseif quests[select(1, GetGossipActiveQuests() )] then
			DEBUG("CheckQuest.GossipShow~Active: "..select(1, GetGossipActiveQuests()), "Quest-OpenCheck-Active")
			return select(1, GetGossipActiveQuests() ), "Active"
		else
			return
		end	
	end
	mod.TitleCheck = function()
		if quests[GetTitleText()] then
			DEBUG("CheckQuest.TitleCheck~Active: "..GetTitleText(), "Quest-TitleCheck")
			return GetTitleText()
		else
			return
		end
	end
local ExtraQuestCheck = {}
	mod.eOpenCheck = function()
		if SpecialQuests[select(1, GetGossipAvailableQuests()) ] then
			DEBUG("E.QuestCheck.GossipShow~Avail: "..select(1, GetGossipAvailableQuests()), "E.Quest-OpenCheck-Avail")
			return select(1, GetGossipAvailableQuests() ), "Avail"
		elseif SpecialQuests[select(1, GetGossipActiveQuests() )] then
			DEBUG("E.QuestCheck.GossipShow~Avail: "..select(1, GetGossipActiveQuests()), "E.Quest-OpenCheck-Active")
			return select(1, GetGossipActiveQuests() ), "Active"
		else
			return
		end	
	end 
	mod.eTitleCheck = function()
		if SpecialQuests[GetTitleText()] then
			DEBUG("E.CheckQuest.TitleCheck~Active: "..GetTitleText(), "E.Quest-TitleCheck")
			return GetTitleText()
		else
			return
		end
	end	

--Event Handler, this is perfect.
mod.eventFrame = CreateFrame("Frame", "SOCD_EVENT_FRAME", UIParent)
mod.eventFrame:SetScript("OnEvent", function(self, event)
        if mod[event] then
			DEBUG("EventHandlerInvoked: "..event, "EventHandler")
			mod[event]()
		end
    end)

mod.eventFrame:RegisterEvent("GOSSIP_SHOW")
mod.eventFrame:RegisterEvent("QUEST_DETAIL")
mod.eventFrame:RegisterEvent("QUEST_PROGRESS")
mod.eventFrame:RegisterEvent("QUEST_COMPLETE")