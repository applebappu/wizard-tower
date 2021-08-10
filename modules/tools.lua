Entity = require "classes.Entity"

local tools = {
	CopyTable = function(table)
		local new_table = {}

		for k, v in pairs(table) do
			if type(v) == 'function' then
				new_table[k] = tools.CloneFunction(v)
			elseif type(v) == 'table' then
				local sub_table = {}
				for i,j in pairs(v) do
					sub_table[i] = j
				end
				new_table[k] = sub_table
			else
				new_table[k] = v
			end
		end

		setmetatable(new_table, table)
		new_table.__index = table

		return new_table
	end,

	CloneFunction = function(f)
		local dumped = string.dump(f)
		local cloned = loadstring(dumped)
		local i = 1

		while true do
			local name = debug.getupvalue(f, i)
			if not name then
				break
			end
			debug.upvaluejoin(cloned, i, f, i)
			i = i + 1
		end
		return cloned
	end,

	MakeEntities = function(target, iterations)
		local mobs = {}
		
		for i = 1, iterations do
			mobs[i] = tools.CopyTable(target)

			math.randomseed(os.time() - (os.clock() * 1000))
			mobs[i].position.x = math.random(3,36)
			mobs[i].position.y = math.random(3,18)
		end
		for i = 1, #mobs do
			print("spawning "..mobs[i].name)
			mobs[i]:Spawn()
		end
	end,

	ElementalSpawn = function(entity_type, threshold, number_to_make)
		local elem = current_map.elemental_balance

		if entity_type == "mob" then
			if elem.fire >= threshold then
				tools.MakeEntities(mob_db.goblin, number_to_make)
			elseif elem.earth >= threshold then
				tools.MakeEntities(mob_db.kobold, number_to_make)
			elseif elem.water >= threshold then
				tools.MakeEntities(mob_db.water_slime, number_to_make)
			elseif elem.wood >= threshold then
				tools.MakeEntities(mob_db.fairy, number_to_make)
			elseif elem.metal >= threshold then
				tools.MakeEntities(mob_db.robot, number_to_make)
			end
		elseif entity_type == "item" then
			if elem.fire >= threshold then
				tools.MakeEntities(item_db.fire_glyph, number_to_make)
			elseif elem.earth >= threshold then
				tools.MakeEntities(item_db.cheeseburger, number_to_make)
			elseif elem.water >= threshold then
				tools.MakeEntities(item_db.water_glyph, number_to_make)
			elseif elem.wood >= threshold then
				tools.MakeEntities(item_db.wood_glyph, number_to_make)
			elseif elem.metal >= threshold then
				tools.MakeEntities(item_db.rapier, number_to_make)
			end
		end
	end,

	NewLevel = function()
		local m = Map.New()
		local dice = math.random(1,3)
		if dice == 1 then
			m:RandomMap("cave")
		elseif dice == 2 then
			m:RandomMap("forest")
		elseif dice == 3 then
			m:RandomMap("volcano")
		end
		m:MemoryInit()
		current_map = m
	end,

	TimerTick = function()
		spawn_timer = spawn_timer + 1
		element_timer = element_timer + 1
		global_timer = global_timer + 1	
	end,

	DrawEntities = function(entity_types)
		for k,v in pairs(spawn_table) do
			if mob_db.Player:DistToEntity(v) <= mob_db.Player.sight_dist and mob_db.Player:LineOfSight(v.position.x, v.position.y) and v.entity_type == entity_types then
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("fill", v.position.x * current_map.tile_size, v.position.y * current_map.tile_size, current_map.tile_size, current_map.tile_size)
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
				love.graphics.print(v.char, v.position.x * current_map.tile_size, v.position.y * current_map.tile_size)
			end
		end
	end
}

return tools
