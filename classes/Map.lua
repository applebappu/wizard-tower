Entity = require "classes.Entity"

bresenham = require "modules.bresenham"
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
			memory = {}
		}
		setmetatable(m, Map)
		return m
	end,

	RandomMap = function(self)
		local noise_map = {}
		local up_stairs = {
			x = math.random(2,37),
			y = math.random(2,19)
		}
		local down_stairs = {
			x = math.random(2,37),
			y = math.random(2,19)
		}
		
		for i = 1, self.board_size.x do
			noise_map[i] = {}
			self.map_table[i] = {}
			for j = 1, self.board_size.y do
				noise_map[i][j] = math.floor(10 * ( love.math.noise( i + math.random(1,9), j + math.random(1,9) ) ) ) + 1
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
				if mob_db.Player:LineOfSight(i, j) and mob_db.Player:DistToPoint(i, j) <= mob_db.Player.sight_dist then
					if self.map_table[i][j] == "." then
						love.graphics.setColor(200/255, 200/255, 200/255)
					elseif self.map_table[i][j] == "4" then
						love.graphics.setColor(0/255, 150/255, 0/255)
					elseif self.map_table[i][j] == "~" then
						love.graphics.setColor(0/255, 0/255, 150/255)
					elseif self.map_table[i][j] == "6" then
						love.graphics.setColor(255/255, 120/255, 0/255)
					else
						love.graphics.setColor(255/255,255/255,255/255,255/255)
					end
					love.graphics.print(self.map_table[i][j], i * self.tile_size, j * self.tile_size)
					self.memory[i][j] = self.map_table[i][j]
				end
			end
		end
	end,

	MemoryInit = function(self)
		for i = 1, self.board_size.x do
			self.memory[i] = {}
			for j = 1, self.board_size.y do
				self.memory[i][j] = {}
			end
		end		
	end,

	DrawMapMemory = function(self)
		love.graphics.setColor(100/255,100/255,100/255,255/255)
		for i = 1, self.board_size.x do
			for j = 1, self.board_size.y do
				love.graphics.print(self.memory[i][j], i * self.tile_size, j * self.tile_size)
			end
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
		love.graphics.print("HP: "..mob_db.Player.hp_current.."/"..mob_db.Player.hp_max, m.tile_size, m.tile_size * 22)
	end,

	PrintElements = function(self)
		for k, v in pairs(self.elemental_balance) do
			print(k, v)
		end
	end,
	
	-- f e wa wd m a	
	TileElements = function(self)
		for i = 1, #self.map_table  do
			for j = 1, #self.map_table[i] do
				local tile = self.map_table[i][j]
				if tile == "#" then 
					self:InfuseElements(0, 0.1, 0, 0, 0, 0)
				elseif tile == "." then
					self:InfuseElements(0, 0, 0, 0, 0, 0.1)
				elseif tile == "~" then
					self:InfuseElements(0, 0, 0.1, 0, 0, 0)
				elseif tile == "4" then
					self:InfuseElements(0, 0, 0, 0.1, 0, 0)
				elseif tile == "6" then
					self:InfuseElements(0.1, 0, 0, 0, 0, 0)
				elseif tile == "^" then
					self:InfuseElements(0, 0, 0, 0, 0.1, 0)
				end
			end
		end
	end
}

Map.__index = Map

return Map
