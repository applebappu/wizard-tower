bresenham = require "modules.bresenham"
item_db = require "modules.item_db"
map_pieces = require "modules.map_pieces"
mob_db = require "modules.mob_db"
resources = require "modules.resources"
time = require "modules.time"
tools = require "modules.tools"

Entity = require "classes.Entity"
Map = require "classes.Map"

font = love.graphics.newFont("courier.ttf", 20)
love.graphics.setFont(font)

math.randomseed(os.time() - (os.clock() * 1000))

tools.TowerLevelInit()
tools.NewLevel()

mob_db.Player.position.x = math.random(2,37)
mob_db.Player.position.y = math.random(2,19)
mob_db.Player:Spawn()

function love.keyreleased(k)
	if k == "escape" then
		if resources.query_substate ~= nil then
			resources.query_substate = nil
		elseif resources.game_state ~= "main" then
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

		if k == "." and resources.current_map.map_table[mob_db.Player.position.x][mob_db.Player.position.y] == ">" then
			if resources.tower_level == 1 then
				print("leaving the tower")
				love.event.quit()
			else
				resources.tower_level = resources.tower_level - 1
				resources.current_map = resources.world_map_memory[resources.tower_level]
				resources.spawn_table = resources.world_spawn_memory[resources.tower_level]	
			end
		elseif k == "," and resources.current_map.map_table[mob_db.Player.position.x][mob_db.Player.position.y] == "<" then
			resources.world_map_memory[resources.tower_level] = resources.current_map
			resources.world_spawn_memory[resources.tower_level] = resources.spawn_table
			resources.tower_level = resources.tower_level + 1
			tools.NewLevel()
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
		elseif k == "4" then
			local a = 4
			b:Equip(b.inventory[a])
		elseif k == "5" then
			local a = 5
			b:Equip(b.inventory[a])
		elseif k == "6" then
			local a = 6
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
		elseif k == "4" then
			local a = 4
			b:Unequip(b.inventory[a])
		elseif k == "5" then
			local a = 5
			b:Unequip(b.inventory[a])
		elseif k == "6" then
			local a = 6
			b:Unequip(b.inventory[a])
		end
	end
end

function love.draw()
	if resources.game_state == "main" then
		resources.current_map:DrawMapMemory()
		resources.current_map:DrawMap()
		resources.current_map:DrawItems()

		for k,v in pairs(resources.spawn_table) do
			if v.element == "fire" then
				love.graphics.setColor(255/255,0/255,0/255)
			elseif v.element == "water" then
				love.graphics.setColor(0/255,100/255,255/255)
			elseif v.element == "wood" then
				love.graphics.setColor(0/255,255/255,100/255)
			elseif v.element == "metal" then
				love.graphics.setColor(201/255,247/255,238/255)
			elseif v.element == "earth" then
				love.graphics.setColor(165/255,42/255,42/255)
			elseif v.element == "air" then
				love.graphics.setColor(100/255,255/255,255/255)
			end
 
			if mob_db.Player:DistToEntity(v) <= mob_db.Player.sight_dist and mob_db.Player:LineOfSight(v.position.x, v.position.y) then
				love.graphics.print(v.char, v.position.x * resources.current_map.tile_size, v.position.y * resources.current_map.tile_size)
			end
		end

		love.graphics.setColor(255,255,255)
		love.graphics.print("HP: "..mob_db.Player.hp_current.."/"..mob_db.Player.hp_max, resources.current_map.tile_size, resources.current_map.tile_size * 22)

	elseif resources.game_state == "inventory" then
		love.graphics.setColor(255,255,255)
		mob_db.Player:DrawInventory()
		mob_db.Player:DrawEquipment()

		if resources.query_substate == "equip" then
			love.graphics.print("Equip which item?", resources.current_map.tile_size, 20 * resources.current_map.tile_size)
		elseif resources.query_substate == "unequip" then
			love.graphics.print("Unequip which item?", resources.current_map.tile_size, 20 * resources.current_map.tile_size)
		elseif resources.query_substate == "drop" then
			love.graphics.print("Drop which item?", resources.current_map.tile_size, 20 * resources.current_map.tile_size)
		end
	end
end

function love.update(dt)
	for k,v in pairs(resources.spawn_table) do
		if v.myTurn and v.entity_type == "mob" then
			if math.random(0,1) >= 0.25 then
				v:Wander()
			else
				v:Rest()
			end
		elseif v.myTurn and v.entity_type == "item" then
			v:Rest()
		end
	end

	time.IncrementTurns()
	time.Spawner()
	time.ElementalSeepage()
end
