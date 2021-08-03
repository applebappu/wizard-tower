bresenham = require "modules.bresenham"
resources = require "modules.resources"
time = require "modules.time"

Entity = {
	name = "no name",
	position = {
		x = math.random(2,37),
		y = math.random(2,19)
	},
	char = "@",
	hp_current = 1,
	hp_max = 1,
	turn_timer = 0,
	myTurn = false,
	inventory = {},
	equipment = {},
	element = "air",
	attack = 1,
	defense = 0,
	speed = 10,
	sight_dist = 5,
	entity_type = nil,
	elemental_balance = {
		fire = 0,
		earth = 0,
		water = 0,
		wood = 0,
		metal = 0,
		air = 0
	},

	Spawn = function(self)
		table.insert(resources.spawn_table, self)
		
		local s = self.elemental_balance
		local f = s.fire
		local e = s.earth
		local wa = s.water
		local wd = s.wood
		local me = s.metal
		local a = s.air

		resources.current_map:InfuseElements(-f,-e,-wa,-wd,-me,-a)
		
		resources.current_map.map_table[self.position.x][self.position.y] = "."
	end,

	Die = function(self)
		for k, v in pairs(resources.spawn_table) do
			if v == self then
				table.remove(resources.spawn_table, k)
				resources.souls = resources.souls + 1

				local a = self.elemental_balance
				resources.current_map:InfuseElements(a.fire, a.earth, a.water, a.wood, a.metal, a.air)

				for k,v in pairs(resources.current_map.elemental_balance) do
					print(k,v)
				end

				for k,v in pairs(self.inventory) do
					Drop("all")
				end
			end
		end
	end,

	ChangeHP = function(self, amount)
		self.hp_current = self.hp_current + amount
		if self.hp_current > self.hp_max then
			self.hp_current = self.hp_max
		elseif self.hp_current <= 0 then
			self:Die()
		end
	end,

	DistToPoint = function(self, target_x, target_y)
		local a = {
			x = self.position.x,
			y = self.position.y
		}
		local b = {
			x = target_x,
			y = target_y
		}
		local c = math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
		return c
	end,

	DistToEntity = function(self, target)
		local a = {
			x = self.position.x,
			y = self.position.y
		}
		local b = {
			x = target.position.x,
			y = target.position.y
		}
		local c = math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
		return c
	end,

	canMove = function(self, dx, dy)
		local test_x = self.position.x + dx
		local test_y = self.position.y + dy
		local test_value = true
		
		for k, v in pairs(resources.spawn_table) do
			if test_x == v.position.x and test_y == v.position.y and v ~= self then
				if v.entity_type == "mob" then
					print("canMove says Bump!")
					self:Bump(v)
					return test_value
				end
			end
		end
		
		if test_x < 1 or test_x > resources.current_map.board_size.x then 
			return test_value
		end
		
		local test = resources.current_map.map_table[test_x][test_y]
		if test == "#" then
			test_value = false
		end

		return test_value
	end,

	Move = function(self, dx, dy)
		local t = self:canMove(dx, dy)
		if t and self.myTurn then
			self.position.x = self.position.x + dx
			self.position.y = self.position.y + dy

			self.turn_timer = self.turn_timer + (resources.one_turn / self.speed)
			self.myTurn = false

			time.TimerTick()
			print("move complete for "..self.name)
		elseif self.myTurn then
			
		end
	end,

	Wander = function(self)
		local r1 = math.random(-1, 1)
		local r2 = math.random(-1, 1)
		self:Move(r1, r2)
	end,

	Pickup = function(self)
		local target = nil
		for k,v in pairs(resources.spawn_table) do
			if v.position.x == self.position.x and v.position.y == self.position.y then
				if v ~= self then
					target = v
				end
			end
		end

		if target == nil then
			print("nothing here to pick up")
		elseif #self.inventory < 6 then
			table.insert(self.inventory, target)
			target:Die()
			print(target.name.." picked up by "..self.name)
		else
			print(self.name.." inventory full")
		end

		self.turn_timer = self.turn_timer + (resources.one_turn / self.speed)
		self.myTurn = false
		time.TimerTick()
	end,

	Drop = function(self, target)
		if target == "all" then
			for k,v in pairs(self.inventory) do
				table.remove(v, k)
				target.position = {
					x = self.position.x,
					y = self.position.y
				}
				v:Spawn()
			end
		else
			for k, v in pairs(self.inventory) do
				if v == target then
					table.remove(target, k)
					target.position = {
						x = self.position.x,
						y = self.position.y
					}
					target:Spawn()
				end
			end
		end
		time.TimerTick()
	end,

	Equip = function(self, item)
		print("Equip beginning")
		for k,v in pairs(self.inventory) do
			if v == item then
				print("Equipping "..v.name)
				table.insert(self.equipment, v)
				table.remove(self.inventory, k)
				print("Equip is adding stats")
				print("pre-equip stats: "..self.attack..", "..self.defense..", "..self.speed)
				self.attack = self.attack + v.attack
				self.defense = self.defense + v.defense
				self.speed = self.speed + v.speed
				print("post-equip: "..self.attack..", "..self.defense..", "..self.speed)
			end
		end
		resources.query_substate = nil
		print("Equip ended")
	end,

	Unequip = function(self, item)
		print("Unequip beginning")
		for k,v in pairs(self.equipment) do
			if v == item then
				print("Unequipping "..v.name)
				table.insert(self.inventory, v)
				table.remove(self.equipment, k)
				print("Unequip is subtracting stats")
				print("pre-unequip stats: "..self.attack..", "..self.defense..", "..self.speed)
				self.attack = self.attack - v.attack
				self.defense = self.defense - v.defense
				self.speed = self.speed - v.speed
				print("post-unequip: "..self.attack..", "..self.defense..", "..self.speed)
			end
		end
		resources.query_substate = nil
		print("Unequip ended")
	end,

	Bump = function(self, target)
		target:ChangeHP(-self.attack)
		print(target.name .. "'s HP is now "..target.hp_current)
		self.turn_timer = self.turn_timer + (resources.one_turn / self.speed)
		self.myTurn = false
		time.TimerTick()
	end,

	DrawInventory = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Inventory:", resources.current_map.tile_size, current_map.tile_size)
		for k,v in ipairs(self.inventory) do
			love.graphics.print(k.." - ", resources.current_map.tile_size, (k + 1) * resources.current_map.tile_size)
			love.graphics.print(self.inventory[k].name, 4 * resources.current_map.tile_size, (k + 1) * resources.current_map.tile_size)
		end
	end,

	DrawEquipment = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Equipment:", 20 * resources.current_map.tile_size, resources.current_map.tile_size)
		for k,v in ipairs(self.equipment) do
			love.graphics.print(k.." - ", 20 * resources.current_map.tile_size, (k + 1) * resources.current_map.tile_size)
			love.graphics.print(self.equipment[k].name, 24 * resources.current_map.tile_size, (k + 1) * resources.current_map.tile_size)
		end
	end,
	
	Rest = function(self)
		self.turn_timer = self.turn_timer + (resources.one_turn)
		self.myTurn = false
		print(self.name.." rests")
	end,

	ChangeElements = function(self, f, e, wa, wd, m, a)
		local s = self.elemental_balance

		s.fire = s.fire + f
		s.earth = s.earth + e
		s.water = s.water + wa
		s.wood = s.wood + wd
		s.metal = s.metal + m
		s.air = s.air + a
	end,

	LineOfSight = function(self, x, y)
		local los_table = bresenham.line(self.position.x, self.position.y, x, y)
		local onemore = false

		for i = 1, #los_table do
			if onemore then
				onemore = false
				return false
			else
				if los_table[i] == "#" then
					onemore = true
				end
			end
		end
		
		return true
	end
}

Entity.__index = Entity

return Entity
