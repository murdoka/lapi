WoWQuestManager = {}

--[[ 'STATICS' ]]--
           

--[[ 'PUBLICS' ]]--

function WoWQuestManager:ToString()
    return "WoWQuestManager";
end

function WoWQuestManager:new(obj)
    obj = obj or {} -- create object if user does not provide one
    setmetatable(obj,self)
    self.__index = self
	obj:Init()
    return obj;
end

function WoWQuestManager:Init()
	WoWLog(">WoWQuestManager:Init()",4);
	WowLuaDoString([[
						DEFAULT_CHAT_FRAME:AddMessage("")
						DEFAULT_CHAT_FRAME:AddMessage("")
						DEFAULT_CHAT_FRAME:AddMessage("<< CxEventFrame V.0.1>>")
						DEFAULT_CHAT_FRAME:AddMessage("=======================")
	
						function CxDEBUG(message)
							DEFAULT_CHAT_FRAME:AddMessage("CxEventFrame>> : "..message)
						end
						
						
						if CxQuestManager ~= nil then
							if CxQuestManager.eventFrame ~= nil then
								CxDEBUG("Unregister All Events")
								CxQuestManager.eventFrame:UnregisterAllEvents()
							end
						end
						
						
						CxQuestManager = nil -- for debug purpose
						
						
						if CxQuestManager ~= nil then
							CxDEBUG("CxQuestManager Already exists. Skipping Init")
						else
							CxDEBUG("Init CxQuestManager")
							
							
							CxQuestManager = {}
							
							CxQuestManager.Init = 1
							CxQuestManager.CxAllowedQuests = {}
							
							function CxQuestManager:GOSSIP_SHOW()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (GOSSIP_SHOW)")
								CxDEBUG(UnitName("target"))

								-- Accept Available Gossip Quests
								--for i=1, GetNumGossipAvailableQuests() do
								--	SelectGossipAvailableQuest(i)
								--end
								
								--call_func_ptr()
								
								
								
							end
							function CxQuestManager:QUEST_DETAIL()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_DETAIL)")
								CxDEBUG("QuestID : "..GetQuestID())
								AcceptQuest()
							end
							function CxQuestManager:QUEST_PROGRESS()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_PROGRESS)")
								CompleteQuest()
							end
							function CxQuestManager:QUEST_COMPLETE()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_COMPLETE)")
								GetQuestReward(0)
							end
							function CxQuestManager:GOSSIP_CONFIRM()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (GOSSIP_CONFIRM)")
							end
							function CxQuestManager:QUEST_ACCEPT_CONFIRM()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_ACCEPT_CONFIRM)")
							end
							function CxQuestManager:QUEST_AUTOCOMPLETE()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_AUTOCOMPLETE)")
							end
							function CxQuestManager:QUEST_FINISHED(arg)
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_FINISHED)")
							end
							function CxQuestManager:QUEST_GREETING()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_GREETING)")
							end
							function CxQuestManager:QUEST_ITEM_UPDATE()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_ITEM_UPDATE)")
							end
							function CxQuestManager:QUEST_WATCH_UPDATE()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_WATCH_UPDATE)")
							end
							function CxQuestManager:QUEST_POI_UPDATE()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_POI_UPDATE)")
							end							
							function CxQuestManager:UNIT_QUEST_LOG_CHANGED(UnitID)
								if UnitID ~= "player" then return end -- Skip Updates the does not belongs to me
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (UNIT_QUEST_LOG_CHANGED)")
							end
							function CxQuestManager:QUEST_QUERY_COMPLETE()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_QUERY_COMPLETE)")
							end							
							function CxQuestManager:QUEST_ACCEPTED(QuestIndex)
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (QUEST_ACCEPTED) QuestIndex: "..QuestIndex)
								AddQuestWatch(QuestIndex)
							end											
							
							function CxQuestManager:CINEMATIC_START()
								DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (CINEMATIC_START)")
							end								
							
							CxQuestManager.eventFrame = CreateFrame("Frame", "CxeventFrame", UIParent);
							CxQuestManager.eventFrame:SetScript("OnEvent", function(self,event,...) 
																				arg = ...
																				-- Call with Argument
																				if event == "UNIT_QUEST_LOG_CHANGED" then
																					CxQuestManager:UNIT_QUEST_LOG_CHANGED(arg)
																					return
																				end
																				
																				if event == "QUEST_ACCEPTED" then
																					CxQuestManager:QUEST_ACCEPTED(arg)
																					return
																				end
																				
																				if arg then
																					DEFAULT_CHAT_FRAME:AddMessage(arg)
																				end
																				
																				if CxQuestManager[event] then
																					CxQuestManager[event]()
																				else
																					CxDEBUG("Registered Event function count not called: "..event)
																				end
																			end	);

							CxQuestManager.eventFrame:RegisterEvent("GOSSIP_SHOW")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_DETAIL")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_PROGRESS")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_COMPLETE")
							CxQuestManager.eventFrame:RegisterEvent("GOSSIP_CONFIRM")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_ACCEPT_CONFIRM")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_AUTOCOMPLETE")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_FINISHED")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_GREETING")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_ITEM_UPDATE")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_WATCH_UPDATE")
							CxQuestManager.eventFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_POI_UPDATE")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_QUERY_COMPLETE")
							CxQuestManager.eventFrame:RegisterEvent("QUEST_ACCEPTED")
							
							-- Additional Events --
							CxQuestManager.eventFrame:RegisterEvent("CINEMATIC_START")
						end
					]])
end