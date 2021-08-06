bresenham = require "modules.bresenham"

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
	turn_counter = 1,

	inventory = {},
	equipment = {},

	attack = 1,
	defense = 0,
	move_speed = 10,

	strength = 1,
	exercise_strength = 0,
	toughness = 1,
	exercise_toughness = 0,
	concentration = 1,
	exercise_concentration = 0,
	mobility = 1,
	exercise_mobility = 0,
	mind = 1,
	exercise_mind = 0,
	
	spark_chance = 0,

	entity_type = nil,

	element = "air",
	elemental_balance = {
		fire = 0,
		earth = 0,
		water = 0,
		wood = 0,
		metal = 0,
		air = 0
	},
	elemental_max = {
		fire = 10,
		earth = 10,
		water = 10,
		wood = 10,
		metal = 10,
		air = 10
	},

	can_see = true,
	sight_dist = 5,
	stealthiness = 1,

	can_smell = true,
	smell_dist = 5,
	stinkiness = 1,

	can_hear = true,
	hear_dist = 5,
	loudness = 1,

	satiety = 100,
	nourishment = 10,
	is_food = true,
	metabolic_rate = 1,
	
	stamina = 100,
	lumpiness = 0.2,

	Spawn = function(self)
		table.insert(spawn_table, self)
		
		local s = self.elemental_balance
		local f = s.fire
		local e = s.earth
		local wa = s.water
		local wd = s.wood
		local me = s.metal
		local a = s.air

		current_map:InfuseElements(-f,-e,-wa,-wd,-me,-a)
		
		if current_map.map_table[self.position.x][self.position.y] == "#" then
			current_map.map_table[self.position.x][self.position.y] = "."
		end
	end,

	Die = function(self)
		for k, v in pairs(spawn_table) do
			if v == self then
				table.remove(spawn_table, k)
				souls = souls + 1

				local a = self.elemental_balance
				current_map:InfuseElements(a.fire, a.earth, a.water, a.wood, a.metal, a.air)

				for k,v in pairs(current_map.elemental_balance) do
					print(k,v)
				end

				for k,v in pairs(self.inventory) do
					self:Drop("all")
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
		
		for k, v in pairs(spawn_table) do
			if test_x == v.position.x and test_y == v.position.y and v ~= self then
				if v.entity_type == "mob" then
					print("canMove says Bump!")
					self:Bump(v)
					return test_value
				end
			end
		end
		
		if test_x < 1 or test_x > current_map.board_size.x then 
			return test_value
		end
		
		local test = current_map.map_table[test_x][test_y]
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

			self.turn_timer = self.turn_timer + (one_turn / self.move_speed)
			self.turn_counter = self.turn_counter + 1
			self.myTurn = false

			self.satiety = self.satiety - (0.1 * self.metabolic_rate)

			if self.name == "Player" then 
				tools.TimerTick()
			end
			print("move complete for "..self.name)
		elseif self.myTurn then
			
		end
	end,

	MakeNoise = function(self, amount)

	end,

	Wander = function(self)
		local r1 = math.random(-1, 1)
		local r2 = math.random(-1, 1)
		self:Move(r1, r2)
	end,

	Pickup = function(self)
		local target = nil
		for k,v in pairs(spawn_table) do
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

		self.turn_timer = self.turn_timer + (one_turn / self.move_speed)
		self.myTurn = false
		tools.TimerTick()
	end,

	Drop = function(self, target)
		if target == "all" then
			for k,v in pairs(self.inventory) do
				table.remove(self.inventory, k)
				target.position = {
					x = self.position.x,
					y = self.position.y
				}
				v:Spawn()
			end
		else
			for k, v in pairs(self.inventory) do
				if v == target then
					table.remove(self.inventory, k)
					target.position = {
						x = self.position.x,
						y = self.position.y
					}
					target:Spawn()
				end
			end
		end
		query_substate = nil
		tools.TimerTick()
		print(self.name.." dropped "..target.name)
	end,

	Equip = function(self, item)
		print("Equip beginning")
		if #self.equipment < 6 then
 			for k,v in pairs(self.inventory) do
				if v == item then
					print("Equipping "..v.name)
					table.insert(self.equipment, v)
					table.remove(self.inventory, k)
					print("Equip is adding stats")
					print("pre-equip stats: "..self.attack..", "..self.defense..", "..self.move_speed)
					self.attack = self.attack + v.attack
					self.defense = self.defense + v.defense
					self.move_speed = self.speed + v.speed
					print("post-equip: "..self.attack..", "..self.defense..", "..self.move_speed)
				end
			end
			query_substate = nil
			print("Equip ended")
		else
			print("equipment full")
		end
	end,

	Unequip = function(self, item)
		print("Unequip beginning")
		for k,v in pairs(self.equipment) do
			if v == item then
				print("Unequipping "..v.name)
				table.insert(self.inventory, v)
				table.remove(self.equipment, k)
				print("Unequip is subtracting stats")
				print("pre-unequip stats: "..self.attack..", "..self.defense..", "..self.move_speed)
				self.attack = self.attack - v.attack
				self.defense = self.defense - v.defense
				self.move_speed = self.speed - v.speed
				print("post-unequip: "..self.attack..", "..self.defense..", "..self.move_speed)
			end
		end
		query_substate = nil
		print("Unequip ended")
	end,

	Bump = function(self, target)
		target:ChangeHP(-self.attack)
		print(target.name .. "'s HP is now "..target.hp_current)
		self.turn_timer = self.turn_timer + (one_turn / self.move_speed)
		self.myTurn = false
		self.turn_counter = self.turn_counter + 1
		tools.TimerTick()
	end,

	DrawInventory = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Inventory:", current_map.tile_size, current_map.tile_size)
		for k,v in ipairs(self.inventory) do
			love.graphics.print(k.." - ", current_map.tile_size, (k + 1) * current_map.tile_size)
			love.graphics.print(self.inventory[k].name, 4 * current_map.tile_size, (k + 1) * current_map.tile_size)
		end
	end,

	DrawEquipment = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Equipment:", 20 * current_map.tile_size, current_map.tile_size)
		for k,v in ipairs(self.equipment) do
			love.graphics.print(k.." - ", 20 * current_map.tile_size, (k + 1) * current_map.tile_size)
			love.graphics.print(self.equipment[k].name, 24 * current_map.tile_size, (k + 1) * current_map.tile_size)
		end
	end,
	
	Rest = function(self)
		self.turn_timer = self.turn_timer + (one_turn)
		self.myTurn = false
		self.stamina = self.stamina + 10
		self.satiety = self.satiety - 1
		self.turn_counter = self.turn_counter + 1
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
	end,

	Eat = function(self, target, eat_type)
		if eat_type == "world" then
			target:Die()
		elseif eat_type == "inventory" then
			for k,v in pairs(self.inventory) do
				if v == target then
					table.remove(self.inventory, k)
				end
			end
			query_substate = nil
		end
		self.satiety = self.satiety + target.nourishment
		print(self.name.." eats "..target.name)
	end,

	GetClosestEntity = function(self)
		local distances = {}
		local shortest_distance = nil
		local closest_entity = {}

		for i = 1, #spawn_table do
			distances[i] = self:DistToEntity(spawn_table[i])
		end

		shortest_distance = math.min(distances)
		
		for i = 1, #spawn_table do
			if self:DistToEntity(spawn_table[i]) == shortest_distance then
				closest_entity = spawn_table[i]
				return closest_entity
			end
		end
	end,

	GetDirectionToEntity = function(self, target)
		
	end,

	DropEmitter = function(self, emitter_type)

	end,

	SeekFood = function(self, target)
		
	end
}

Entity.__index = Entity

return Entity
