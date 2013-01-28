function object(base, init)
   local obj = {}
   
   if not init and type(base) == 'function' then
      init = base
      base = nil
   elseif type(base) == 'table' then
      for i,v in pairs(base) do
         obj[i] = v
      end
      obj._base = base
   end
   
   
   obj.__index = obj

   local mt = {}
   mt.__call = function(object_tbl, ...)

   local obj = {}
   
   setmetatable(obj,obj)
   if init then
      init(obj,...)
   else 
      if base and base.init then
      base.init(obj, ...)
      end
   end
   return obj
   end
   obj.init = init
   obj.is_a = function(self, klass)
      local m = getmetatable(self)
      while m do 
         if m == klass then return true end
         m = m._base
      end
      return false
   end
   setmetatable(obj, mt)
   return obj
end