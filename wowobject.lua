WoWObject = {}

function WoWObject:new (obj)
	obj = obj or {} -- create object if user does not provide one
	setmetatable(obj,self)
	self.__index = self
	return obj;
end

function WoWObject:ToString()
	_Log("WoWObject");
end