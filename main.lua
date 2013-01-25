-- Loading Classes
dofile("wowobject.lua");
dofile("wowunit.lua");


function WoWFoo()
	me = WoWObject:new({Address=750517304})
	_Log(me.ToString())
	_Log(me.Address)
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