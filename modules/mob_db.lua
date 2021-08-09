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

mob_db.water_slime = tools.CopyTable(mob_db.slime)
mob_db.water_slime.element = "water"
mob_db.water_slime.elemental_balance.water = 10

mob_db.metal_slime = tools.CopyTable(mob_db.slime)
mob_db.metal_slime.element = "metal"
mob_db.metal_slime.elemental_balance.metal = 10

-- GOBLINS --
mob_db.goblin = tools.CopyTable(Entity)
mob_db.goblin.name = "goblin"
mob_db.goblin.char = "g"
mob_db.goblin.element = "fire"
mob_db.goblin.elemental_balance.fire = 10
mob_db.goblin.lumpiness = 0

-- KOBOLDS --
mob_db.kobold = tools.CopyTable(Entity)
mob_db.kobold.name = "kobold"
mob_db.kobold.char = "k"
mob_db.kobold.element = "earth"
mob_db.kobold.elemental_balance.earth = 10
mob_db.kobold.lumpiness = 0

-- FAIRIES --
mob_db.fairy = tools.CopyTable(Entity)
mob_db.fairy.name = "fairy"
mob_db.fairy.char = "f"
mob_db.fairy.element = "wood"
mob_db.fairy.elemental_balance.wood = 10
mob_db.fairy.lumpiness = 0

-- ROBOTS --
mob_db.robot = tools.CopyTable(Entity)
mob_db.robot.name = "robot"
mob_db.robot.char = "r"
mob_db.robot.element = "metal"
mob_db.robot.elemental_balance.metal = 10
mob_db.robot.lumpiness = 0

for k,v in pairs(mob_db) do
	v.entity_type = "mob"
end

mob_db.Player.entity_type = "Player"

return mob_db
