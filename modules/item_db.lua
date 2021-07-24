Entity = require "classes.Entity"

local item_db = {
	sword = Entity.New("sword", math.random(2,5), math.random(3,6), "/", "metal", 1)
}

for k,v in pairs(item_db) do
	v.entity_type = "item"
	v.myTurn = true
end

item_db.sword.equip_type = "weapon"

return item_db
