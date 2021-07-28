Entity = require "classes.Entity"
tools = require "modules.tools"

local mob_db = {
	Player = tools.CopyTable(Entity),
	air_slime = tools.CopyTable(Entity) 
}

for k,v in pairs(mob_db) do
	v.entity_type = "mob"
end

return mob_db
