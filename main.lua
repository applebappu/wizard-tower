bresenham = require "modules.bresenham"
item_db = require "modules.item_db"
map_pieces = require "modules.map_pieces"
mob_db = require "modules.mob_db"
resources = require "modules.resources"
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

item_db.cheeseburger:Spawn()

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
		elseif k == "m" then
			-- meditate
		elseif k == "b" then
			-- spellbook
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
		-- draw map memory
		love.graphics.setColor(100/255,100/255,100/255,255/255)
		for i = 1, resources.current_map.board_size.x do
			for j = 1, resources.current_map.board_size.y do
				love.graphics.print(resources.current_map.memory[i][j], i * resources.current_map.tile_size, j * resources.current_map.tile_size)
			end
		end

		-- draw map
		for i = 1, resources.current_map.board_size.x do
			for j = 1, resources.current_map.board_size.y do
				if mob_db.Player:LineOfSight(i, j) and mob_db.Player:DistToPoint(i, j) <= mob_db.Player.sight_dist then
					local tile = resources.current_map.map_table[i][j]
					local tileset = resources.current_map.map_tileset
					
					if tile  == "4" then
						love.graphics.setColor(0/255, 150/255, 0/255)
					elseif tile == "~" then
						love.graphics.setColor(0/255, 0/255, 150/255)
					elseif tile == "6" then
						love.graphics.setColor(255/255, 180/255, 0/255)
					elseif tile == "^" then
						love.graphics.setColor(100/255, 125/255, 150/255)
					elseif tile == "<" or tile == ">" then
						love.graphics.setColor(255/255, 255/255, 255/255)
					else
						if tileset == "forest" and tile == "#" then
							love.graphics.setColor(0/255,255/255,255/255,125/255)
						elseif tileset == "forest" and tile == "." then
							love.graphics.setColor(0/255, 200/255, 100/255)
						elseif tileset == "volcano" and tile == "#" then
							love.graphics.setColor(200/255, 100/255, 0/255)
						elseif tileset == "volcano" and tile == "." then
							love.graphics.setColor(150/255, 75/255, 0/255)
						elseif tileset == "cave" and tile == "#" then
							love.graphics.setColor(255/255, 255/255, 255/255)
						elseif tileset == "cave" and tile == "." then
							love.graphics.setColor(200/255, 200/255, 200/255)
						end
					end
					love.graphics.print(resources.current_map.map_table[i][j], i * resources.current_map.tile_size, j * resources.current_map.tile_size)
					resources.current_map.memory[i][j] = resources.current_map.map_table[i][j]
				end
			end
		end

		-- draw entities 
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

		-- draw GUI
		local ts = resources.current_map.tile_size
		love.graphics.setColor(255,255,255)
		love.graphics.print("HP: "..mob_db.Player.hp_current.."/"..mob_db.Player.hp_max, ts, ts * 22)
		love.graphics.print("Fire: "..mob_db.Player.elemental_balance.fire.."/"..mob_db.Player.elemental_max.fire, ts, ts * 23)
		love.graphics.print("Earth: "..mob_db.Player.elemental_balance.earth.."/"..mob_db.Player.elemental_max.earth, ts, ts * 24)
		love.graphics.print("Wood: "..mob_db.Player.elemental_balance.wood.."/"..mob_db.Player.elemental_max.wood, ts, ts * 25)
		love.graphics.print("Water: "..mob_db.Player.elemental_balance.water.."/"..mob_db.Player.elemental_max.water, ts, ts * 26)
		love.graphics.print("Metal: "..mob_db.Player.elemental_balance.metal.."/"..mob_db.Player.elemental_max.metal, ts, ts * 27)
		love.graphics.print("Air: "..mob_db.Player.elemental_balance.air.."/"..mob_db.Player.elemental_max.air, ts, ts * 28)

		love.graphics.print("Satiety: "..mob_db.Player.satiety.."/100", ts * 10, ts * 22)

		love.graphics.print("Tower Level: "..resources.tower_level, resources.current_map.tile_size * 23, resources.current_map.tile_size * 22)

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
	-- increment turns
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

	for k,v in pairs(resources.spawn_table) do
		if v.myTurn == false then
			v.turn_timer = v.turn_timer - 1
		end
		for k, v in pairs(resources.spawn_table) do
			if v.turn_timer <= 0 then
				v.turn_timer = 0
				v.myTurn = true
				break
			end
		end
	end

	-- changes over time
	while resources.spawn_timer > 20 do
		tools.ElementalSpawn()
		resources.spawn_timer = resources.spawn_timer - 20
	end
	while resources.element_timer > 5 do
		resources.current_map:TileElements()
		resources.element_timer = resources.element_timer - 5
	end

end
