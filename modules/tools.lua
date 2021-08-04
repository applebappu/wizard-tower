Entity = require "classes.Entity"
resources = require "modules.resources"

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
			mobs[i].position.x = math.random(2,37)
			mobs[i].position.y = math.random(2,19)
		end
		for i = 1, #mobs do
			mobs[i]:Spawn()
		end
	end,

	ElementalSpawn = function()
		local threshold1 = 20
		local threshold2 = 100
		local current_map = resources.current_map

		if current_map.elemental_balance.fire > threshold1 then
			tools.MakeEntities(mob_db.fire_slime, 1)
		elseif current_map.elemental_balance.fire > threshold2 then
		end

		if current_map.elemental_balance.earth > threshold1 then
			tools.MakeEntities(mob_db.kobold, 1)
		elseif current_map.elemental_balance.earth > threshold2 then
		end

		if current_map.elemental_balance.water > threshold1 then
			tools.MakeEntities(mob_db.water_slime, 1)
		elseif current_map.elemental_balance.water > threshold2 then
		end
 
		if current_map.elemental_balance.wood > threshold1 then
			tools.MakeEntities(mob_db.wood_slime, 1)
		elseif current_map.elemental_balance.wood > threshold2 then
		end
		
		if current_map.elemental_balance.metal > threshold1 then
			tools.MakeEntities(mob_db.metal_slime, 1)
		elseif current_map.elemental_balance.metal > threshold2 then
		end

		current_map:PrintElements()
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
		resources.current_map = m
	end,

	TowerLevelInit = function()
		for i = 1, resources.tower_height do
			resources.world_spawn_memory[i] = {}
			resources.world_map_memory[i] = {}
		end
	end
}

return tools
