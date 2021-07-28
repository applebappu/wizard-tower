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

	EquipmentQuery = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Equip which item?", m.tile_size, 20 * m.tile_size)
	end,

	UnequipQuery = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Unequip which item?", m.tile_size, 20 * m.tile_size)
	end,

	DropQuery = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Drop which item?", m.tile_size, 20 * m.tile_size)
	end
}
return tools
