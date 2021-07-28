Entity = require "classes.Entity"
Map = require "classes.Map"
Vector2 = require "classes.Vector2"

item_db = require "modules.item_db"
map_pieces = require "modules.map_pieces"
mob_db = require "modules.mob_db"
resources = require "modules.resources"
time = require "modules.time"
tools = require "modules.tools"

tools.setFont()
tools.setRandomSeed()

m = Map.New(38,20,10,10,10,10,10,10)
m:RandomMap() 

mob_db.Player:Spawn()
mob_db.Player.entity_type = "Player"

fire_slime1 = tools.CopyTable(mob_db.fire_slime)

for k,v in pairs(fire_slime1) do
	print(k, v)
	if type(v) == "table" then
		for i,j in pairs(v) do
			print(i, j)
		end
	end
end

function love.keyreleased(k)
	if k == "escape" then
		if resources.query_substate ~= nil then
			resources.query_substate = nil
		elseif resources.game_state == "inventory" then
			resources.game_state = "main"
		else
			love.event.quit()
		end
	end

	if resources.game_state == "main" then
		if k == "kp5" then 
			mob_db.Player:Move(0, 0)
		elseif k == "kp4" then 
			mob_db.Player:Move(-1, 0)
		elseif k == "kp6" then 
			mob_db.Player:Move(1, 0)
		elseif k == "kp8" then 
			mob_db.Player:Move(0, -1)
		elseif k == "kp2" then 
			mob_db.Player:Move(0, 1)
		elseif k == "kp1" then 
			mob_db.Player:Move(-1, 1)
		elseif k == "kp7" then 
			mob_db.Player:Move(-1, -1)
		elseif k == "kp9" then 
			mob_db.Player:Move(1, -1)
		elseif k == "kp3" then 
			mob_db.Player:Move(1, 1)
		end
	
		if k == "g" then
			mob_db.Player:Pickup()
		elseif k == "i" then
			resources.game_state = "inventory"
		end
	end

	if resources.game_state == "inventory" then
		if k == "e" and resources.query_substate == nil then
			resources.query_substate = "equip"
		elseif k == "u" and resources.query_substate == nil then
			resources.query_substate = "unequip"
		elseif k == "d" and resources.query_substate == nil then
			resources.query_substate = "drop"
		end
	end
	
	-- this code here is for equipping and unequipping and it's a hot mess
	if resources.game_state == "inventory" and resources.query_substate == "equip" then
		local b = mob_db.Player
		if k == "1" then
			local a = 1
			b:Equip(b.inventory[a])
		elseif k == "2" then
			local a = 2
			b:Equip(b.inventory[a])
		elseif k == "3" then
			local a = 3
			b:Equip(b.inventory[a])
		end

	elseif resources.game_state == "inventory" and resources.query_substate == "unequip" then
		local b = mob_db.Player
		if k == "1" then
			local a = 1
			b:Unequip(b.equipment[a])
		elseif k == "2" then
			local a = 2
			b:Unequip(b.equipment[a])
		elseif k == "3" then
			local a = 3
			b:Unequip(b.equipment[a])
		end
	end
end

function love.draw()
	if resources.game_state == "main" then
		m:DrawMap()
		m:DrawItems()
		m:DrawMobs()
		m:DrawGUI()
	elseif resources.game_state == "inventory" then
		mob_db.Player:DrawInventory()
		mob_db.Player:DrawEquipment()
		if resources.query_substate == "equip" then
			tools.EquipmentQuery()
		elseif resources.query_substate == "drop" then
			tools.DropQuery()
		elseif resources.query_substate == "unequip" then
			tools.UnequipQuery()
		end
	end
end

function love.update(dt)
	for k,v in pairs(resources.spawn_table) do
		if v.myTurn and v.entity_type == "mob" then
			v:Wander()
		elseif v.myTurn and v.entity_type == "item" then
			v:Rest()
		end
	end

	time.incrementTurns()
end
