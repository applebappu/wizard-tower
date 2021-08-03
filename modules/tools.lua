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
		local threshold1 = 10
		local threshold2 = 100

		if m.elemental_balance.fire > threshold1 then
			tools.MakeEntities(mob_db.fire_slime, m.elemental_balance.fire / mob_db.fire_slime.elemental_balance.fire)
		elseif m.elemental_balance.fire > threshold2 then
		end

		if m.elemental_balance.earth > threshold1 then
			tools.MakeEntities(mob_db.kobold, m.elemental_balance.earth / mob_db.kobold.elemental_balance.earth)
		elseif m.elemental_balance.earth > threshold2 then
		end

		if m.elemental_balance.water > threshold1 then
			tools.MakeEntities(mob_db.water_slime, m.elemental_balance.water / mob_db.water_slime.elemental_balance.water)
		elseif m.elemental_balance.water > threshold2 then
		end
 
		if m.elemental_balance.wood > threshold1 then
			tools.MakeEntities(mob_db.wood_slime, m.elemental_balance.wood / mob_db.wood_slime.elemental_balance.wood)
		elseif m.elemental_balance.wood > threshold2 then
		end
		
		if m.elemental_balance.metal > threshold1 then
			tools.MakeEntities(mob_db.metal_slime, m.elemental_balance.metal / mob_db.metal_slime.elemental_balance.metal)
		elseif m.elemental_balance.metal > threshold2 then
		end

		m:PrintElements()
	end
}

return tools
