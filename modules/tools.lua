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

	ElementalSpawn = function()
		local threshold1 = 10
		local threshold2 = 20

		if current_map.elemental_balance.fire > threshold1 then
			tools.MakeEntities(mob_db.goblin, 1)
		elseif current_map.elemental_balance.fire > threshold2 then
			
		end

		if current_map.elemental_balance.earth > threshold1 then
			tools.MakeEntities(mob_db.kobold, 1)
		elseif current_map.elemental_balance.earth > threshold2 then
			tools.MakeEntities(item_db.cheeseburger, 1)
		end

		if current_map.elemental_balance.water > threshold1 then
			tools.MakeEntities(mob_db.water_slime, 1)
		elseif current_map.elemental_balance.water > threshold2 then
		end
 
		if current_map.elemental_balance.wood > threshold1 then
			tools.MakeEntities(mob_db.fairy, 1)
		elseif current_map.elemental_balance.wood > threshold2 then
		end
		
		if current_map.elemental_balance.metal > threshold1 then
			tools.MakeEntities(mob_db.robot, 1)
		elseif current_map.elemental_balance.metal > threshold2 then
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
	end
}

return tools
