Entity = require "classes.Entity"

local item_db = {
	sword = Entity.New("sword", 1, 1, "/", "metal", 1),
	hat = Entity.New("hat", 1, 1, "/", "metal", 1),
	mace = Entity.New("mace", 1, 1, "/", "metal", 1)
}

for k,v in pairs(item_db) do
	v.entity_type = "item"
	v.myTurn = true
end

item_db.sword.equip_type = "weapon"
item_db.sword.speed = 0

item_db.hat.equip_type = "hat"
item_db.hat.attack = 0
item_db.hat.defense = 1
item_db.hat.speed = 0

item_db.mace.equip_type = "weapon"
item_db.mace.attack = 2
item_db.mace.speed = -2

return item_db
