local item_db = {}

Entity = require "classes.Entity"
tools = require "modules.tools"

-- GLYPHS --
item_db.glyph = tools.CopyTable(Entity)
item_db.glyph.name = "glyph"
item_db.glyph.char = "%"
item_db.glyph.is_equipment = true
item_db.glyph.is_edible = true
item_db.glyph.nourishment = 0

item_db.fire_glyph = tools.CopyTable(item_db.glyph)
item_db.fire_glyph.element = "fire"
item_db.fire_glyph.elemental_balance.fire = 10
item_db.fire_glyph.name = "fire glyph"

item_db.earth_glyph = tools.CopyTable(item_db.glyph)
item_db.earth_glyph.element = "earth"
item_db.earth_glyph.elemental_balance.earth = 10
item_db.earth_glyph.name = "earth glyph"

item_db.water_glyph = tools.CopyTable(item_db.glyph)
item_db.water_glyph.element = "water"
item_db.water_glyph.elemental_balance.water = 10
item_db.water_glyph.name = "water glyph"

item_db.wood_glyph = tools.CopyTable(item_db.glyph)
item_db.wood_glyph.element = "wood"
item_db.wood_glyph.elemental_balance.wood = 10
item_db.wood_glyph.name = "wood glyph"

item_db.metal_glyph = tools.CopyTable(item_db.glyph)
item_db.metal_glyph.element = "metal"
item_db.metal_glyph.elemental_balance.metal = 10
item_db.metal_glyph.name = "metal glyph"

item_db.air_glyph = tools.CopyTable(item_db.glyph)
item_db.air_glyph.element = "air"
item_db.air_glyph.elemental_balance.air = 10
item_db.air_glyph.name = "air glyph"

-- FOOD --
item_db.food = tools.CopyTable(Entity)
item_db.food.char = "%"
item_db.food.element = "earth"
item_db.food.elemental_balance.earth = 10
item_db.food.is_edible = true

item_db.cheeseburger = tools.CopyTable(item_db.food)
item_db.cheeseburger.name = "cheeseburger"
item_db.cheeseburger.nourishment = 20

-- WEAPONS --
item_db.weapon = tools.CopyTable(Entity)
item_db.weapon.char = "/"
item_db.weapon.is_equipment = true

item_db.rapier = tools.CopyTable(item_db.weapon)
item_db.rapier.name = "rapier"
item_db.rapier.attack = 2
item_db.rapier.defense = 1
item_db.rapier.attack_speed = 1.1
item_db.rapier.element = "metal"
item_db.rapier.elemental_balance.metal = 20

item_db.staff = tools.CopyTable(item_db.weapon)
item_db.staff.name = "staff"
item_db.staff.attack = 1
item_db.staff.defense = 2
item_db.staff.attack_speed = 0.9
item_db.staff.element = "wood"
item_db.staff.elemental_balance.wood = 20

-- ARMOR --
item_db.armor = tools.CopyTable(Entity)
item_db.armor.char = "&"
item_db.armor.element = "earth"
item_db.armor.elemental_balance.earth = 20
item_db.armor.is_equipment = true

item_db.fancy_hat = tools.CopyTable(item_db.weapon)
item_db.fancy_hat.name = "fancy hat"
item_db.fancy_hat.defense = 1

for k,v in pairs(item_db) do
	v.entity_type = "item"
	v.myTurn = true
end

return item_db
