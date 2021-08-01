Entity = require "classes.Entity"
resources = require "modules.resources"

local tools = {
	setFont = function()
		font = love.graphics.newFont("courier.ttf", 20)
		love.graphics.setFont(font)
	end,
	
	setRandomSeed = function()
	        math.randomseed(os.time() - (os.clock() * 1000))
	end,

	DiceRoll = function(number, sides)
		total = {}
		for i = 1, number do
			roll = math.random(1,sides)
			table.insert(total, roll)
		end
	end,
	
	PrintSpawn = function() 
		for k,v in pairs(spawn_table) do
			print(k)
			for i,j in pairs(v) do
				print(j)
			end
		end
	end,

	-- copy a table, including its functions (for randomly spawning new stuff)
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

	-- clone a function while preserving upvalues (for randomly spawning new stuff)
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

	EquipmentQuery = function()
		love.graphics.setColor(255,255,255)
		love.graphics.print("Equip which glyph?", m.tile_size, 20 * m.tile_size)
	end,

	UnequipQuery = function()
		love.graphics.setColor(255,255,255)
		love.graphics.print("Unequip which glyph?", m.tile_size, 20 * m.tile_size)
	end,

	DropQuery = function()
		love.graphics.setColor(255,255,255)
		love.graphics.print("Drop which glyph?", m.tile_size, 20 * m.tile_size)
	end,

	DrawMobs = function()
		for k,v in pairs(resources.spawn_table) do
			if v.element == "fire" then
				love.graphics.setColor(255,0,0)
			elseif v.element == "water" then
				love.graphics.setColor(0,0,255)
			elseif v.element == "wood" then
				love.graphics.setColor(200,200,40)
			elseif v.element == "metal" then
				love.graphics.setColor(200,200,200)
			elseif v.element == "earth" then
				love.graphics.setColor(0,255,0)
			elseif v.element == "air" then
				love.graphics.setColor(0,255,255)
			end
 
			if mob_db.Player:DistToEntity(v) <= mob_db.Player.sight_dist then
				love.graphics.print(v.char, v.position.x * m.tile_size, v.position.y * m.tile_size)
			end
		end
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
		local threshold1 = 5
		local threshold2 = 10

		if m.elemental_balance.fire > threshold1 then
			tools.MakeEntities(mob_db.fire_slime, m.elemental_balance.fire)
		elseif m.elemental_balance.fire > threshold2 then
			tools.MakeEntities(item_db.fire_glyph, m.elemental_balance.fire - threshold2)
		end

		if m.elemental_balance.earth > threshold1 then
			tools.MakeEntities(mob_db.earth_slime, m.elemental_balance.earth)
		elseif m.elemental_balance.earth > threshold2 then
			tools.MakeEntities(item_db.earth_glyph, m.elemental_balance.earth - threshold2)
		end

		if m.elemental_balance.water > threshold1 then
			tools.MakeEntities(mob_db.water_slime, m.elemental_balance.water)
		elseif m.elemental_balance.water > threshold2 then
			tools.MakeEntities(item_db.water_glyph, m.elemental_balance.water - threshold2)
		end
 
		if m.elemental_balance.wood > threshold1 then
			tools.MakeEntities(mob_db.wood_slime, m.elemental_balance.wood)
		elseif m.elemental_balance.wood > threshold2 then
			tools.MakeEntities(item_db.wood_glyph, m.elemental_balance.wood - threshold2)
		end
		
		if m.elemental_balance.metal > threshold1 then
			tools.MakeEntities(mob_db.metal_slime, m.elemental_balance.metal)
		elseif m.elemental_balance.metal > threshold2 then
			tools.MakeEntities(item_db.metal_glyph, m.elemental_balance.metal - threshold2)
		end

		if m.elemental_balance.air > threshold1 then
			tools.MakeEntities(mob_db.air_slime, m.elemental_balance.air)
		elseif m.elemental_balance.air > threshold2 then
			tools.MakeEntities(item_db.air_glyph, m.elemental_balance.air - threshold2)
		end

		m:PrintElements()
	end
}

return tools
