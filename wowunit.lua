WoWUnit = WoWObject:new()

function WoWUnit:new (obj)
	obj = obj or {} -- create object if user does not provide one
	setmetatable(obj,self)
	self.__index = self
	return obj;
end

function WoWUnit:ToString()
	_Log("WoWUnit");
end