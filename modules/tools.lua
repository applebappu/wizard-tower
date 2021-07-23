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
	end
}

return tools
