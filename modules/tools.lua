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
			mobs[i].position.x = math.random(3,36)
			mobs[i].position.y = math.random(3,18)
		end
		for i = 1, #mobs do
			mobs[i]:Spawn()
		end
	end,

	ElementalSpawn = function(entity_type)
		local mob_threshold = 20
		local item_threshold = 20

		if current_map.elemental_balance.fire > mob_threshold and entity_type == "mob"then
			tools.MakeEntities(mob_db.goblin, 1)
		elseif current_map.elemental_balance.fire > item_threshold and entity_type == "item" then
			tools.MakeEntities(item_db.fire_glyph, 1)
		end

		if current_map.elemental_balance.earth > mob_threshold and entity_type == "mob"then
			tools.MakeEntities(mob_db.kobold, 1)
		elseif current_map.elemental_balance.earth > item_threshold and entity_type == "item" then
			tools.MakeEntities(item_db.cheeseburger, 1)
		end

		if current_map.elemental_balance.water > mob_threshold and entity_type == "mob" then
			tools.MakeEntities(mob_db.water_slime, 1)
		elseif current_map.elemental_balance.water > item_threshold and entity_type == "item" then
			tools.MakeEntities(item_db.water_glyph, 1)
		end
 
		if current_map.elemental_balance.wood > mob_threshold and entity_type == "mob"then
			tools.MakeEntities(mob_db.fairy, 1)
		elseif current_map.elemental_balance.wood > item_threshold and entity_type == "item" then
			tools.MakeEntities(item_db.wood_glyph, 1)
		end
		
		if current_map.elemental_balance.metal > mob_threshold and entity_type == "mob"then
			tools.MakeEntities(mob_db.robot, 1)
		elseif current_map.elemental_balance.metal > item_threshold and entity_type == "item" then
			tools.MakeEntities(item_db.rapier, 1)
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
