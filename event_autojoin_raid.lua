--LFG_PROPOSAL_SHOW
--[[
LFG_PROPOSAL_SHOW	Fired when a dungeon group was found and the dialog to accept or decline it appears 
]]--

function OnLFG_PROPOSAL_SHOW()
	local func = [[
					LFDDungeonReadyDialogEnterDungeonButton:Click()
				]]
	EventManager.AddAsyncEventAction("LFG_PROPOSAL_SHOW",func)
end

-- Function that will be called if the EventManager is initiated
function AddOn_AutoJoinLFR()
	OnLFG_PROPOSAL_SHOW()
end

EventManager.RegisterAddOns(AddOn_AutoJoinLFR)