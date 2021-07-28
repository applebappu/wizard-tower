Entity = require "classes.Entity"

local item_db = {
--	fire_glyph = Entity.New("fire glyph", math.random(10,15), math.random(10,15), "*", 1, "fire", 10),
--	earth_glyph = Entity.New("earth glyph", math.random(10,15), math.random(10,15), "*", 1, "earth", 10),
--	water_glyph = Entity.New("water glyph", math.random(10,15), math.random(10,15), "*", 1, "water", 10),
--	wood_glyph = Entity.New("wood glyph", math.random(10,15), math.random(10,15), "*", 1, "wood", 10),
--	metal_glyph = Entity.New("metal glyph", math.random(10,15), math.random(10,15), "*", 1, "metal", 10),
--	air_glyph = Entity.New("air glyph", math.random(10,15), math.random(10,15), "*", 1, "air", 10)
}

for k,v in pairs(item_db) do
	v.entity_type = "item"
	v.myTurn = true
end

--item_db.fire_glyph.elemental_balance.fire = 10
--item_db.earth_glyph.elemental_balance.earth = 10
--item_db.water_glyph.elemental_balance.water = 10
--item_db.wood_glyph.elemental_balance.wood = 10
--item_db.metal_glyph.elemental_balance.metal = 10
--item_db.air_glyph.elemental_balance.air = 10

return item_db
