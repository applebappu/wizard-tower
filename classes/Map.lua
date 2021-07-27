Entity = require "classes.Entity"
resources = require "modules.resources"
map_pieces = require "modules.map_pieces"

Map = {
	New = function(x, y, f, e, wa, wd, m, a)
		local m = {
			board_size = {
				x = x,
				y = y
			},
			tile_size = 20,
			elemental_balance = {
				fire = f,
				earth = e,
				water = wa,
				wood = wd,
				metal = m,
				air = a
			},
			map_table = {},
		}
		setmetatable(m, Map)
		return m
	end,

	RandomMap = function(self)
		local noise_map = {}
		local up_stairs = {
			x = math.random(2,36),
			y = math.random(2,18)
		}
		local down_stairs = {
			x = math.random(2,36),
			y = math.random(2,18)
		}
		
		for i = 1, self.board_size.x do
			noise_map[i] = {}
			self.map_table[i] = {}
			for j = 1, self.board_size.y do
				noise_map[i][j] = math.floor(10 * ( love.math.noise( i + math.random(), j + math.random() ) ) ) + 1
				self.map_table[i][j] = map_pieces.tiles[noise_map[i][j]]

				if i == 1 or j == 1 then
					self.map_table[i][j] = "#"
				end

				if i == self.board_size.x or j == self.board_size.y then
					self.map_table[i][j] = "#"
				end

				if i == up_stairs.x and j == up_stairs.y then
					self.map_table[i][j] = "<"
				end

				if i == down_stairs.x and j == down_stairs.y then
					self.map_table[i][j] = ">"
				end
			end
		end
	end,

	InfuseElements = function(self, f, e, wa, wd, m, a)
		local s = self.elemental_balance
		s.fire = s.fire + f
		s.earth = s.earth + e
		s.water = s.water + wa
		s.wood = s.wood + wd
		s.metal = s.metal + m
		s.air = s.air + a
	end,

	DrawMap = function(self)
		for i = 1, self.board_size.x do
			for j = 1, self.board_size.y do
				love.graphics.print(self.map_table[i][j], i * self.tile_size, j * self.tile_size)
			end
		end
	end,

	DrawMobs = function(self)
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
			love.graphics.print(v.char, v.position.x * m.tile_size, v.position.y * m.tile_size)
		end
	end,

	DrawItems = function(self)
		for k,v in pairs(resources.spawn_table) do
			if v.entity_type == "item" then
				love.graphics.setColor(150,150,150)
				love.graphics.print(v.char, v.position.x * m.tile_size, v.position.y * m.tile_size)
			end
		end
	end,

	DrawGUI = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("HP: "..mob_db.Player.hp_current.."/"..mob_db.Player.hp_max, m.tile_size, (m.board_size.y + 2) * m.tile_size)
	end,

	PrintElements = function(self)
		for k, v in pairs(self.elemental_balance) do
			print(k, v)
		end
	end,
	
	-- Creative Cycle -- f e wa wd m a
	WoodFeedsFire = function(self)
		local s = self.elemental_balance
		local f = s.fire
		local w = s.wood
		local a = s.air
		local counter = 0

		while w > 0 do
			w = w - 1
			f = f + 1
			a = a + 1
			counter = counter + 1
		end
		
		self:InfuseElements(f, 0, 0, -counter, 0, a)
	end,

	FireCreatesAshes = function(self)
		local s = self.elemental_balance
		local f = s.fire
		local e = s.earth
		local counter = 0

		while f > 0 do
			f = f - 1
			e = e + 1
			counter = counter + 1
		end

		self:InfuseElements(-counter, e, 0, 0, 0, 0)
	end,

	EarthGivesMetal = function(self)
		local s = self.elemental_balance
		local e = s.earth
		local m = s.metal
		local counter = 0

		while e > 0 do
			e = e - 1
			m = m + 1
			counter = counter + 1
		end

		self:InfuseElements(0, -counter, 0, 0, m, 0)
	end,

	MetalGivesWater = function(self)
		local s = self.elemental_balance
		local m = s.metal
		local w = s.water
		local counter = 0

		while m > 0 do
			m = m - 1
			w = w + 1
			counter = counter + 1
		end

		self:InfuseElements(0, 0, w, 0, -counter, 0)
	end,

	WaterNourishesWood = function(self)
		local s = self.elemental_balance
		local wa = s.water
		local wd = s.wood
		local counter = 0

		while wa > 0 do
			wa = wa - 1
			wd = wd + 1
			counter = counter + 1
		end

		self:InfuseElements(0, 0, -counter, wd, 0, 0)
	end,
	-- CC End --

	-- Destructive Cycle -- f e wa wd m a
	WaterDousesFire = function(self)
		local s = self.elemental_balance
		local w = s.water
		local f = s.fire
		local a = s.air
		local counter = 0
		
		while f > 0 and w > 0 do
			f = f - 1
			w = w - 1
			a = a + 1
			counter = counter + 1
		end

		self:InfuseElements(-counter, 0, 0, 0, 0, a)
	end,

	FireMeltsMetal = function(self)
		local s = self.elemental_balance
		local m = s.metal
		local f = s.fire
		local counter = 0
		
		while m > 0 and f > 0 do
			m = m - 1
			f = f - 1
			counter = counter + 1
		end
		
		self:InfuseElements(-counter, 0, 0, 0, -counter, 0)
	end,

	MetalChopsWood = function(self)
		local s = self.elemental_balance
		local m = s.metal
		local w = s.wood
		local counter = 0
		
		while w > 0 and m > 0 do
			w = w - 1
			m = m - 1
			counter = counter + 1
		end
		
		self:InfuseElements(0, 0, 0, -counter, -counter, 0)
	end,

	WoodPiercesEarth = function(self)
		local s = self.elemental_balance
		local w = s.wood
		local e = s.earth
		local counter = 0
		
		while e > 0 and w > 0 do
			e = e - 1
			w = w - 1
			counter = counter + 1
		end
		
		self:InfuseElements(0, -counter, 0, -counter, 0, 0)
	end,

	EarthMakesMud = function(self)
		local s = self.elemental_balance
		local e = s.earth
		local w = s.water
		local counter = 0
		
		while e > 0 and w > 0 do
			e = e - 1
			w = w - 1
			counter = counter + 1
		end
		
		self:InfuseElements(0, -counter, -counter, 0, 0, 0)
	end
	-- DC End --
}

Map.__index = Map

return Map
