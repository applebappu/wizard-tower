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
tower_height = 1

souls = 0

one_turn = 10

spawn_timer = 0
spawn_tick = 5
element_timer = 0
element_tick = 5
global_timer = 0

game_state = "main"
query_substate = nil

cursor = {
	position = {
		x = 1,
		y = 1
	},
	blink_timer = 0.25,
	visible = false 
}

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

function love.keyreleased(k)
	if k == "escape" then
		if query_substate ~= nil then
			query_substate = nil
		elseif game_state ~= "main" and game_state ~= "game over" then
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
			mob_db.Player:Meditate()
		elseif k == "b" then
			game_state = "spellbook"
		end
		
		-- changing levels
		if k == "." and current_map.map_table[mob_db.Player.position.x][mob_db.Player.position.y] == ">" then
			-- store level in memory
			world_map_memory[tower_level] = current_map
			world_spawn_memory[tower_level] = spawn_table
			
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
			-- store level in memory
			world_map_memory[tower_level] = current_map
			world_spawn_memory[tower_level] = spawn_table
			-- go up a level
			tower_level = tower_level + 1
			-- if we're at the top,
			if tower_level > tower_height then
				-- make the top taller and make a new level
				tower_height = tower_height + 1
				tools.NewLevel()
			else
				-- restore whatever was at the level before
				current_map = world_map_memory[tower_level] 
				spawn_table = world_spawn_memory[tower_level]
			end

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
		if query_substate == nil then
			cursor.visible = false
			if k == "e" then
				query_substate = "equip"
			elseif k == "u" then
				query_substate = "unequip"
			elseif k == "d" then
				query_substate = "drop"
			elseif k == "c" then
				query_substate = "consume"
			end
		else
			cursor.visible = true
			local a = mob_db.Player
			if k == "enter" then
				if query_substate == "equip" then
			
				elseif query_substate == "unequip" then

				elseif query_substate == "drop" then

				elseif query_substate == "consume" then
				
				end
			elseif k == "kp2" then
				cursor.position.y = cursor.position.y + current_map.tile_size
			elseif k == "kp8" then
				cursor.position.y = cursor.position.y - current_map.tile_size
			elseif k == "kp4" then

			elseif k == "kp6" then

			end
		end
	end
end

function love.draw()
	if game_state == "main" then
		-- draw map memory --
		love.graphics.setColor(100/255,100/255,100/255,255/255)
		for i = 1, current_map.board_size.x do
			for j = 1, current_map.board_size.y do
				love.graphics.print(current_map.memory[i][j], i * current_map.tile_size, j * current_map.tile_size)
			end
		end

		-- draw map --
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

		-- draw entities -- 
		tools.DrawEntities("item")
		tools.DrawEntities("mob")
		tools.DrawEntities("Player")

		-- draw GUI --
		local ts = current_map.tile_size

		-- HP
		local hp_ratio = mob_db.Player.hp_current / mob_db.Player.hp_max
		if hp_ratio >= 0.9 then
			love.graphics.setColor(0/255,255/255,0/255) 
		elseif hp_ratio >= 0.5 then
			love.graphics.setColor(255/255,255/255,0/255)
		elseif hp_ratio >= 0.2 then
			love.graphics.setColor(255/255,165/255,0/255)
		elseif hp_ratio >= 0 then
			love.graphics.setColor(255/255,0/255,0/255)
		end
		love.graphics.print("Health: "..mob_db.Player.hp_current.."/"..mob_db.Player.hp_max, ts, ts * 22)
		
		-- elements
		love.graphics.setColor(255/255,255/255,255/255)
		love.graphics.print("Fire: "..mob_db.Player.elemental_balance.fire.."/"..mob_db.Player.elemental_max.fire, ts, ts * 23)
		love.graphics.print("Earth: "..mob_db.Player.elemental_balance.earth.."/"..mob_db.Player.elemental_max.earth, ts, ts * 24)
		love.graphics.print("Wood: "..mob_db.Player.elemental_balance.wood.."/"..mob_db.Player.elemental_max.wood, ts, ts * 25)
		love.graphics.print("Water: "..mob_db.Player.elemental_balance.water.."/"..mob_db.Player.elemental_max.water, ts, ts * 26)
		love.graphics.print("Metal: "..mob_db.Player.elemental_balance.metal.."/"..mob_db.Player.elemental_max.metal, ts, ts * 27)
		love.graphics.print("Air: "..mob_db.Player.elemental_balance.air.."/"..mob_db.Player.elemental_max.air, ts, ts * 28)

		-- stats
		love.graphics.print("Strength: "..mob_db.Player.strength, ts * 12, ts * 22)
		love.graphics.print("Toughness: "..mob_db.Player.toughness, ts * 12, ts * 23)
		love.graphics.print("Concentration: "..mob_db.Player.concentration, ts * 12, ts * 24)
		love.graphics.print("Mobility: "..mob_db.Player.concentration, ts * 12, ts * 25)
		love.graphics.print("Mind: "..mob_db.Player.concentration, ts * 12, ts * 26)

		-- tower level and misc (satiety, stam, etc)
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
		-- inventory and equipment --
		love.graphics.setColor(255,255,255)
		love.graphics.print("Inventory:", current_map.tile_size, current_map.tile_size)
		for k,v in ipairs(mob_db.Player.inventory) do
			love.graphics.print(k.." - ", current_map.tile_size, (k + 1) * current_map.tile_size)
			love.graphics.print(mod_db.Player.inventory[k].name, 4 * current_map.tile_size, (k + 1) * current_map.tile_size)
		end

		love.graphics.print("Equipment:", 20 * current_map.tile_size, current_map.tile_size)
		for k,v in ipairs(mob_db.Player.equipment) do
			love.graphics.print(k.." - ", 20 * current_map.tile_size, (k + 1) * current_map.tile_size)
			love.graphics.print(mob_db.Player.equipment[k].name, 24 * current_map.tile_size, (k + 1) * current_map.tile_size)
		end

		-- query substates --
		if query_substate == "equip" then
			love.graphics.print("Equip which item?", current_map.tile_size, 20 * current_map.tile_size)
		elseif query_substate == "unequip" then
			love.graphics.print("Unequip which item?", current_map.tile_size, 20 * current_map.tile_size)
		elseif query_substate == "drop" then
			love.graphics.print("Drop which item?", current_map.tile_size, 20 * current_map.tile_size)
		elseif query_substate == "consume" then
			love.graphics.print("Consume which item?", current_map.tile_size, 20 * current_map.tile_size)
		end

		-- cursor code --
		if cursor.visible then
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("fill", 100, current_map.tile_size, cursor.position.x, cursor.position.y)
		end

	elseif game_state == "game over" then
		love.graphics.setColor(255/255,0/255,0/255)
		love.graphics.print("YOU DIED", 350, 200)
	end
end

function love.update(dt)
	-- basic "AI"
	for k,v in pairs(spawn_table) do
		-- if it's your turn and you're a mob entity,
		if v.myTurn and v.entity_type == "mob" then 
			-- make sure they're not too lumpy to move
			if math.random(0,1) >= v.lumpiness then
				for t = 1, #spawn_table do
					-- can you see an entity that isn't you?
					if spawn_table[t] ~= v and v:LineOfSight(spawn_table[t].position.x, spawn_table[t].position.y) then
						-- are you standing on it (i.e. an item)?
						if v:DistToEntity(spawn_table[t]) == 0 then
							-- is it food?
							-- if not, are you something with hands?
								-- are you holding something else already?
									-- if not, equip it
						else 
							-- go towards the entity
							local step = v:GetDirectionToEntity(spawn_table[t])
							v:Move(step.x, step.y)
							print(v.name.." saw "..spawn_table[t].name.." and moved towards them")
						end
					else
						v:Wander()
						print(v.name.." is wandering")
					end
				end
			else
				v:Rest()
				print(v.name.." is resting")
			end
		-- if it's your turn and you're an item entity,
		elseif v.myTurn and v.entity_type == "item" then
			-- just chill
			v:Rest()
			print(v.name.." is resting because it is an item")
		end
	end

	-- increment turns
	for i = 1, #spawn_table do
		local v = spawn_table[i]
		if v.myTurn == false then
			v.turn_timer = v.turn_timer - 1
		end
		for i = 1, #spawn_table do
			local v = spawn_table[i]
			if v.turn_timer <= 0 then
				v.turn_timer = 0
				v.myTurn = true
				break
			end
		end
	end

	-- changes over time
	if spawn_timer >= spawn_tick then
		
		tools.ElementalSpawn("item", 50, 1)
		tools.ElementalSpawn("mob", 20, 1)

		local p = mob_db.Player
		local dice = math.random(0,100)
		if dice < p.exercise_strength then
			p.attack = p.attack - p.strength
			p.strength = p.strength + 1
			p.exercise_strength = 0
			print("Player strength up")
			p.attack = p.attack + p.strength
		end
		if dice < p.exercise_toughness then
			p.defense = p.defense - p.toughness
			p.toughness = p.toughness + 1
			p.exercise_toughness = 0
			print("Player toughness up")
			p.defense = p.defense + p.toughness
		end
		if dice < p.exercise_concentration then
			p.concentration = p.concentration + 1
			p.exercise_concentration = 0
		end
		if dice < p.exercise_mobility then
			p.mobility = p.mobility + 1
			p.exercise_mobility = 0
		end
		if dice < p.exercise_mind then
			p.mind = p.mind + 1
			p.exercise_mind = 0
		end

		spawn_timer = 0
	end

	if element_timer >= element_tick then
		current_map:TileElements()
		mob_db.Player:ElementalMetabolismTick()

		element_timer = 0
	end
end
