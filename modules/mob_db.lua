local mob_db = {}

Entity = require "classes.Entity"
tools = require "modules.tools"

-- PLAYER --
mob_db.Player = tools.CopyTable(Entity)
mob_db.Player.name = "Player"
mob_db.Player.element = "fire"
mob_db.Player.hp_max = 10
mob_db.Player.hp_current = 10

-- SLIMES --
mob_db.slime = tools.CopyTable(Entity)
mob_db.slime.name = "slime"
mob_db.slime.char = "s"

mob_db.fire_slime = tools.CopyTable(mob_db.slime)
mob_db.fire_slime.element = "fire"
mob_db.fire_slime.elemental_balance.fire = 5

mob_db.water_slime = tools.CopyTable(mob_db.slime)
mob_db.water_slime.element = "water"
mob_db.water_slime.elemental_balance.water = 5

mob_db.wood_slime = tools.CopyTable(mob_db.slime)
mob_db.wood_slime.element = "wood"
mob_db.wood_slime.elemental_balance.wood = 5

mob_db.metal_slime = tools.CopyTable(mob_db.slime)
mob_db.metal_slime.element = "metal"
mob_db.metal_slime.elemental_balance.metal = 5

-- KOBOLDS --
mob_db.kobold = tools.CopyTable(Entity)
mob_db.kobold.name = "kobold"
mob_db.kobold.char = "k"
mob_db.kobold.element = "earth"
mob_db.kobold.elemental_balance.earth = 10

for k,v in pairs(mob_db) do
	v.entity_type = "mob"
end

mob_db.Player.entity_type = "Player"

return mob_db
