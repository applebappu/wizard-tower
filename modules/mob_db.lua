Entity = require "classes.Entity"
tools = require "modules.tools"

local mob_db = {
	Player = tools.CopyTable(Entity),
	
	slime = tools.CopyTable(Entity) 
}

for k,v in pairs(mob_db) do
	v.entity_type = "mob"
end

mob_db.Player.name = "Player"
mob_db.Player.char = "@"
	
return mob_db
