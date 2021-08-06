-- requires
bresenham = require "modules.bresenham"
item_db = require "modules.item_db"
map_pieces = require "modules.map_pieces"
mob_db = require "modules.mob_db"
tools = require "modules.tools"

Entity = require "classes.Entity"
Map = require "classes.Map"

font = love.graphics.newFont("courier.ttf", 20)
love.graphics.setFont(font)

-- globals
spawn_table = {}
world_spawn_memory = {}
world_spawn_memory[1] = {}

current_map = {}
tower_level = 1
world_map_memory = {}
world_map_memory[1] = {}
tower_height = 10

souls = 0

one_turn = 100

spawn_timer = 0
element_timer = 0
global_timer = 0

game_state = "main"
query_substate = nil

-- init
math.randomseed(os.time() - (os.clock() * 1000))

tools.NewLevel()

mob_db.Player:Spawn()
for i = 1, current_map.board_size.x do
	for j = 1, current_map.board_size.y do
		if current_map.map_table[i][j] == ">" then
			mob_db.Player.position.x = i
			mob_db.Player.position.y = j
		end
	end				
end

item_db.cheeseburger:Spawn()

function love.keyreleased(k)
	if k == "escape" then
		if query_substate ~= nil then
			query_substate = nil
		elseif game_state ~= "main" then
			game_state = "main"
		else
			love.event.quit()
		end
	end

	if game_state == "main" then
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
			game_state = "inventory"
		elseif k == "m" then
			-- meditate
		elseif k == "b" then
			-- spellbook
		end
		
		-- changing levels
		if k == "." and current_map.map_table[mob_db.Player.position.x][mob_db.Player.position.y] == ">" then
			if tower_level == 1 then
				print("leaving the tower")
				love.event.quit()
			else
				tower_level = tower_level - 1
				current_map = world_map_memory[tower_level]
				spawn_table = world_spawn_memory[tower_level]
				mob_db.Player.turn_counter = mob_db.Player.turn_counter + 1
				for i = 1, current_map.board_size.x do
					for j = 1, current_map.board_size.y do
						if current_map.map_table[i][j] == "<" then
							mob_db.Player.position.x = i
							mob_db.Player.position.y = j
						end
					end				
				end
			end
		elseif k == "," and current_map.map_table[mob_db.Player.position.x][mob_db.Player.position.y] == "<" then
			world_map_memory[tower_level] = current_map
			world_spawn_memory[tower_level] = spawn_table
			tower_level = tower_level + 1
			tools.NewLevel()
			mob_db.Player.turn_counter = mob_db.Player.turn_counter + 1
			for i = 1, current_map.board_size.x do
				for j = 1, current_map.board_size.y do
					if current_map.map_table[i][j] == ">" then
						mob_db.Player.position.x = i
						mob_db.Player.position.y = j
					end
				end				
			end
		end
	end

	if game_state == "inventory" then
		if k == "e" and query_substate == nil then
			query_substate = "equip"
		elseif k == "u" and query_substate == nil then
			query_substate = "unequip"
		elseif k == "d" and query_substate == nil then
			query_substate = "drop"
		elseif k == "c" and query_substate == nil then
			query_substate = "consume"
		end
	end
	
	if game_state == "inventory" and query_substate == "equip" then
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

	elseif game_state == "inventory" and query_substate == "unequip" then
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
			b:Unequip(b.equipment[a])
		elseif k == "5" then
			local a = 5
			b:Unequip(b.equipment[a])
		elseif k == "6" then
			local a = 6
			b:Unequip(b.equipment[a])
		end
	elseif game_state == "inventory" and query_substate == "drop" then
		local b = mob_db.Player
		if k == "1" then
			local a = 1
			b:Drop(b.inventory[a])
		elseif k == "2" then
			local a = 2
			b:Drop(b.inventory[a])
		elseif k == "3" then
			local a = 3
			b:Drop(b.inventory[a])
		elseif k == "4" then
			local a = 4
			b:Drop(b.inventory[a])
		elseif k == "5" then
			local a = 5
			b:Drop(b.inventory[a])
		elseif k == "6" then
			local a = 6
			b:Drop(b.inventory[a])
		end
	elseif game_state == "inventory" and query_substate == "consume" then
		local b = mob_db.Player
		if k == "1" then
			local a = 1
			b:Eat(b.inventory[a], "inventory")
		elseif k == "2" then
			local a = 2
			b:Eat(b.inventory[a], "inventory")
		elseif k == "3" then
			local a = 3
			b:Eat(b.inventory[a], "inventory")
		elseif k == "4" then
			local a = 4
			b:Eat(b.inventory[a], "inventory")
		elseif k == "5" then
			local a = 5	
			b:Eat(b.inventory[a], "inventory")
		elseif k == "6" then
			local a = 6	
			b:Eat(b.inventory[a], "inventory")
		end
	end
end

function love.draw()
	if game_state == "main" then
		-- draw map memory
		love.graphics.setColor(100/255,100/255,100/255,255/255)
		for i = 1, current_map.board_size.x do
			for j = 1, current_map.board_size.y do
				love.graphics.print(current_map.memory[i][j], i * current_map.tile_size, j * current_map.tile_size)
			end
		end

		-- draw map
		for i = 1, current_map.board_size.x do
			for j = 1, current_map.board_size.y do
				if mob_db.Player:LineOfSight(i, j) and mob_db.Player:DistToPoint(i, j) <= mob_db.Player.sight_dist then
					local tile = current_map.map_table[i][j]
					local tileset = current_map.map_tileset
					
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
					love.graphics.print(current_map.map_table[i][j], i * current_map.tile_size, j * current_map.tile_size)
					current_map.memory[i][j] = current_map.map_table[i][j]
				end
			end
		end

		-- draw entities 
		for k,v in pairs(spawn_table) do
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
				love.graphics.print(v.char, v.position.x * current_map.tile_size, v.position.y * current_map.tile_size)
			end
		end

		-- draw GUI
		local ts = current_map.tile_size
		love.graphics.setColor(255,255,255)
		love.graphics.print("Health: "..mob_db.Player.hp_current.."/"..mob_db.Player.hp_max, ts, ts * 22)
		love.graphics.print("Fire: "..mob_db.Player.elemental_balance.fire.."/"..mob_db.Player.elemental_max.fire, ts, ts * 23)
		love.graphics.print("Earth: "..mob_db.Player.elemental_balance.earth.."/"..mob_db.Player.elemental_max.earth, ts, ts * 24)
		love.graphics.print("Wood: "..mob_db.Player.elemental_balance.wood.."/"..mob_db.Player.elemental_max.wood, ts, ts * 25)
		love.graphics.print("Water: "..mob_db.Player.elemental_balance.water.."/"..mob_db.Player.elemental_max.water, ts, ts * 26)
		love.graphics.print("Metal: "..mob_db.Player.elemental_balance.metal.."/"..mob_db.Player.elemental_max.metal, ts, ts * 27)
		love.graphics.print("Air: "..mob_db.Player.elemental_balance.air.."/"..mob_db.Player.elemental_max.air, ts, ts * 28)

		love.graphics.print("Strength: "..mob_db.Player.strength, ts * 12, ts * 22)
		love.graphics.print("Toughness: "..mob_db.Player.toughness, ts * 12, ts * 23)
		love.graphics.print("Concentration: "..mob_db.Player.concentration, ts * 12, ts * 24)
		love.graphics.print("Mobility: "..mob_db.Player.concentration, ts * 12, ts * 25)
		love.graphics.print("Mind: "..mob_db.Player.concentration, ts * 12, ts * 26)

		love.graphics.print("Tower Level: "..tower_level, ts * 24, ts * 22)
		if mob_db.Player.satiety == 125 then
			love.graphics.print("Satiety: Stuffed!", ts * 24, ts * 23)
		elseif mob_db.Player.satiety >= 100 then
			love.graphics.print("Satiety: Full", ts * 24, ts * 23)
		elseif mob_db.Player.satiety >= 75 then
			love.graphics.print("Satiety: Good", ts * 24, ts * 23)
		elseif mob_db.Player.satiety >= 50 then
			love.graphics.print("Satiety: Hungry", ts * 24, ts * 23)
		elseif mob_db.Player.satiety >= 25 then
			love.graphics.print("Satiety: Hungry!", ts * 24, ts * 23)
		elseif mob_db.Player.satiety == 0 then
			love.graphics.print("Satiety: Starving!", ts * 24, ts * 23)
		end

		if mob_db.Player.stamina == 100 then
			love.graphics.print("Stamina: Full", ts * 24, ts * 24)
		elseif mob_db.Player.satiety >= 75 then
			love.graphics.print("Stamina: Good", ts * 24, ts * 24)
		elseif mob_db.Player.satiety >= 50 then
			love.graphics.print("Stamina: Tired", ts * 24, ts * 24)
		elseif mob_db.Player.satiety >= 25 then
			love.graphics.print("Stamina: Tired!", ts * 24, ts * 24)
		elseif mob_db.Player.satiety == 0 then
			love.graphics.print("Stamina: Exhausted!", ts * 24, ts * 24)
		end

	elseif game_state == "inventory" then
		love.graphics.setColor(255,255,255)
		mob_db.Player:DrawInventory()
		mob_db.Player:DrawEquipment()

		if query_substate == "equip" then
			love.graphics.print("Equip which item?", current_map.tile_size, 20 * current_map.tile_size)
		elseif query_substate == "unequip" then
			love.graphics.print("Unequip which item?", current_map.tile_size, 20 * current_map.tile_size)
		elseif query_substate == "drop" then
			love.graphics.print("Drop which item?", current_map.tile_size, 20 * current_map.tile_size)
		elseif query_substate == "consume" then
			love.graphics.print("Consume which item?", current_map.tile_size, 20 * current_map.tile_size)
		end
	end
end

function love.update(dt)
	-- basic "AI"
	for k,v in pairs(spawn_table) do
		if v.myTurn and v.entity_type == "mob" then
			if math.random(0,1) >= v.lumpiness then
				v:Wander()
			else
				v:Rest()
			end
		elseif v.myTurn and v.entity_type == "item" then
			v:Rest()
		end
	end

	-- increment turns
	for k,v in pairs(spawn_table) do
		if v.myTurn == false then
			v.turn_timer = v.turn_timer - 1
		end
		for k, v in pairs(spawn_table) do
			if v.turn_timer <= 0 then
				v.turn_timer = 0
				v.myTurn = true
				if v.name == "Player" then
				end
				break
			end
		end
	end

	-- changes over time
	while spawn_timer > 20 do
		tools.ElementalSpawn()
		spawn_timer = spawn_timer - 20
	end

	while element_timer > 5 do
		current_map:TileElements()
		element_timer = element_timer - 5
	end

	-- stat increases
	local x = global_timer / 100
	if x == 1 then
		local p = mob_db.Player
		local dice = math.random(0,100)
		if dice < p.exercise_strength then
			p.strength = p.strength + 1
		end
		if dice < p.exercise_toughness then
			p.toughness = p.toughness + 1
		end
		if dice < p.exercise_concentration then
			p.concentration = p.concentration + 1
		end
		if dice < p.exercise_mobility then
			p.mobility = p.mobility + 1
		end
		if dice < p.exercise_mind then
			p.mind = p.mind + 1
		end
	end
end
