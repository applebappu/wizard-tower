Entity = require "classes.Entity"

bresenham = require "modules.bresenham"
resources = require "modules.resources"
map_pieces = require "modules.map_pieces"

Map = {
	New = function()
		local m = {
			board_size = {
				x = 38,
				y = 20
			},
			tile_size = 20,
			map_tileset = nil,
			elemental_balance = {
				fire = 0,
				earth = 0,
				water = 0,
				wood = 0,
				metal = 0,
				air = 0
			},
			map_table = {},
			memory = {}
		}
		setmetatable(m, Map)
		return m
	end,

	RandomMap = function(self, map_type)
		local noise_map = {}
		local up_stairs = {
			x = math.random(2,37),
			y = math.random(2,19)
		}
		local down_stairs = {
			x = math.random(2,37),
			y = math.random(2,19)
		}
		
		local t = nil
		if map_type == "forest" then
			t = map_pieces.forest_tiles
			self.map_tileset = "forest"
		elseif map_type == "volcano" then
			t = map_pieces.volcano_tiles
			self.map_tileset = "volcano"
		elseif map_type == "cave" then
			t = map_pieces.cave_tiles
			self.map_tileset = "cave"
		end	

		for i = 1, self.board_size.x do
			noise_map[i] = {}
			self.map_table[i] = {}
			for j = 1, self.board_size.y do
				noise_map[i][j] = math.floor(10 * ( love.math.noise( i + math.random(1,9), j + math.random(1,9) ) ) ) + 1
				self.map_table[i][j] = t[noise_map[i][j]]

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
					local tile = self.map_table[i][j]
					local tileset = self.map_tileset
					
					if tile  == "4" then
						love.graphics.setColor(0/255, 150/255, 0/255)
					elseif tile == "~" then
						love.graphics.setColor(0/255, 0/255, 150/255)
					elseif tile == "6" then
						love.graphics.setColor(255/255, 180/255, 0/255)
					elseif tile == "^" then
						love.graphics.setColor(100/255, 125/255, 150/255)
					elseif tile == "<" or tile == ">" then
						love.graphics.setColor(255/255, 255/255, 255/255)
					else
						if tileset == "forest" and tile == "#" then
							love.graphics.setColor(0/255,255/255,255/255,125/255)
						elseif tileset == "forest" and tile == "." then
							love.graphics.setColor(0/255, 200/255, 100/255)
						elseif tileset == "volcano" and tile == "#" then
							love.graphics.setColor(200/255, 100/255, 0/255)
						elseif tileset == "volcano" and tile == "." then
							love.graphics.setColor(150/255, 75/255, 0/255)
						elseif tileset == "cave" and tile == "#" then
							love.graphics.setColor(255/255, 255/255, 255/255)
						elseif tileset == "cave" and tile == "." then
							love.graphics.setColor(200/255, 200/255, 200/255)
						end
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
					self:InfuseElements(0, 0.005, 0, 0, 0, 0)
				elseif tile == "." then
					self:InfuseElements(0, 0, 0, 0, 0, 0.005)
				elseif tile == "~" then
					self:InfuseElements(0, 0, 0.01, 0, 0, 0)
				elseif tile == "4" then
					self:InfuseElements(0, 0, 0, 0.01, 0, 0)
				elseif tile == "6" then
					self:InfuseElements(0.01, 0, 0, 0, 0, 0)
				elseif tile == "^" then
					self:InfuseElements(0, 0, 0, 0, 0.01, 0)
				end
			end
		end
		resources.current_map:PrintElements()	
	end
}

Map.__index = Map

return Map
