WoWQuest = {
                _ID = 0;
                _Index = 0;
				--title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID, startEvent, displayQuestID 
				Title = "";
				Level = 0;
				Tag = 0;
				SuggestedGroup = 0;
				IsComplete = nil;
				IsDaily = nil;
				StartEvent = nil; -- 0 or 1
				IsLegendary = nil;
				IsTrivial = nil;
				IsValid = false;
				
           }

--[[ 'STATICS' ]]--
           
-- (static) Returns the index of the quest by QuestID
function WoWQuest.Count()
    WowLuaDoString("numEntries, numQuests = GetNumQuestLogEntries()")
    return tonumber(WowGetLuaValue("numQuests"))
end

-- (static) Returns the number of quests in he quest log
function WoWQuest.GetIndexByQuestID(QuestID)
    WowLuaDoString("index = GetQuestLogIndexByID("..QuestID..")")
    return tonumber(WowGetLuaValue("index"))
end

-- (static) Set the Quest as Active to complete a quest
function WoWQuest.SetActive(Index)
    WoWLog(">WoWQuest.SetActiveQuestID("..Index..")",4);
    WowLuaDoString("SelectQuestLogEntry("..Index..")")
end

--[[ 'PUBLICS' ]]--

function WoWQuest:ToString()
    return "WoWQuest";
end

function WoWQuest:new (obj)
    WoWLog(">Create new Quest Object",4);
    obj = obj or {} -- create object if user does not provide one
    setmetatable(obj,self)
    self.__index = self
    obj:Init()
    return obj;
end

function WoWQuest:ID(id)
	if id then self._ID = id return id end
	return self._ID
end

function WoWQuest:Index(index)
	if index then self._Index = index return index end
	return self._Index
end

function WoWQuest:Init()
    WoWLog(">WoWQuest:Init("..self:ID()..")",4);
	self:Index(self:__GetIndex())
    WoWQuest.SetActive(self:Index());
    WowLuaDoString("title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily, questID, startEvent, displayQuestID = GetQuestLogTitle("..self:Index()..")")
	
	self.Title      = tostring(WowGetLuaValue("title"));
	self.Level      = tonumber(WowGetLuaValue("level"));
	self.Tag        = tostring(WowGetLuaValue("questTag") or "Normal");
	self.IsComplete = tonumber(WowGetLuaValue("isComplete")) or 0;
	self.IsDaily    = tonumber(WowGetLuaValue("isDaily")) or 0;
	self.StartEvent = tonumber(WowGetLuaValue("startEvent")) or 0;
end

function WoWQuest:Foo()
	_Log("Foo - Start")
	WowLuaDoString([[
					function GOSSIP_SHOW()
						DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (GOSSPI)")
					end
					function QUEST_DETAIL()
						DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (DETAIL)")
					end
					function QUEST_PROGRESS()
						DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (PROGRESS)")
					end
					function QUEST_COMPLETE()
						DEFAULT_CHAT_FRAME:AddMessage("-=TEST=- (COMPLETE)")
					end
	
					questFrame = CreateFrame("Frame", "SOCD_EVENT_FRAME", UIParent);
					questFrame:SetScript("OnEvent", function(self,event) 
														DEFAULT_CHAT_FRAME:AddMessage("-=TEST=-"..event)
														event()
													end
										);
					
					questFrame:RegisterEvent("GOSSIP_SHOW")
					questFrame:RegisterEvent("QUEST_DETAIL")
					questFrame:RegisterEvent("QUEST_PROGRESS")
					questFrame:RegisterEvent("QUEST_COMPLETE")
					
					]])
	_Log(tostring(WowGetLuaValue("questFrame")))
	_Log("Foo - End")
end

function WoWQuest:Abandon()
	self:__Test()
	WoWLog(">WoWQuest:Abandon("..self:Index()..")",4);
	WowLuaDoString("SetAbandonQuest("..self:Index()..")")
	WowLuaDoString("AbandonQuest()")
end

function WoWQuest:DoNotTrack()
	self:__Test()
	WoWLog(">WoWQuest:DoNotTrack("..self:Index()..")",4);
	WowLuaDoString("RemoveQuestWatch("..self:Index()..")")
end

function WoWQuest:Track()
	self:__Test()
	WoWLog(">WoWQuest:Track("..self:Index()..")",4);
	WowLuaDoString("AddQuestWatch("..self:Index()..")")
end

function WoWQuest:IsTracked()
	self:__Test()
	WoWLog(">WoWQuest:IsTracked("..self:Index()..")",4);
	WowLuaDoString("tracked = IsQuestWatched("..self:Index()..")")
	_Log(WowGetLuaValue("tracked"))
	result = tonumber(WowGetLuaValue("tracked")) or 0
	if result == 1 then return true else return false end
end


--[[ 'INTERNAL' ]]--
-- Returns the number of quests in he quest log
function WoWQuest:__GetIndex()
    WowLuaDoString("index = GetQuestLogIndexByID("..self:ID()..")")
    return tonumber(WowGetLuaValue("index"))
end

-- Returns the number of quests in he quest log
function WoWQuest:__IsValid()
	WowLuaDoString("numEntries, numQuests = GetNumQuestLogEntries()");
	WowLuaDoString("index = GetQuestLogIndexByID("..self:ID()..")");
	idx = tonumber(WowGetLuaValue("index")) or 0
	cnt = tonumber(WowGetLuaValue("numEntries")) or 0
	if idx > cnt then return false else return true end
end

function WoWQuest:__Test()
	if not self:__IsValid() then error("Quest Object does not exists!") end
end


