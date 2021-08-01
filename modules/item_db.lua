local item_db = {}

Entity = require "classes.Entity"
tools = require "modules.tools"

-- GLYPHS --
item_db.glyph = tools.CopyTable(Entity)
item_db.glyph.char = "%"

item_db.fire_glyph = tools.CopyTable(item_db.glyph)
item_db.fire_glyph.element = "fire"
item_db.fire_glyph.elemental_balance.fire = 10

item_db.earth_glyph = tools.CopyTable(item_db.glyph)
item_db.earth_glyph.element = "earth"
item_db.earth_glyph.elemental_balance.earth = 10

item_db.water_glyph = tools.CopyTable(item_db.glyph)
item_db.water_glyph.element = "water"
item_db.water_glyph.elemental_balance.water = 10

item_db.wood_glyph = tools.CopyTable(item_db.glyph)
item_db.wood_glyph.element = "wood"
item_db.wood_glyph.elemental_balance.wood = 10

item_db.metal_glyph = tools.CopyTable(item_db.glyph)
item_db.metal_glyph.element = "metal"
item_db.metal_glyph.elemental_balance.metal = 10

item_db.air_glyph = tools.CopyTable(item_db.glyph)
item_db.air_glyph.element = "air"
item_db.air_glyph.elemental_balance.air = 10

for k,v in pairs(item_db) do
	v.entity_type = "item"
	v.myTurn = true
end

return item_db
