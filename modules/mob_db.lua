Entity = require "classes.Entity"

local mob_db = {
	Player = Entity.New("Player", math.random(2,37), math.random(2,19), "@", 10, "air", 10),
	earth_slime = Entity.New("earth slime", math.random(2,37), math.random(2,19), "s", 1, "earth", 1),
	fire_slime = Entity.New("fire slime", math.random(2,37), math.random(2,19), "s", 1, "fire", 1)
}

for k,v in pairs(mob_db) do
	v.entity_type = "mob"
end

return mob_db
