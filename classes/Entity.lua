resources = require "modules.resources"

Entity = {
	New = function(name, x, y, char, hp, elem, elem_amt)
		local self = {
			name = name,
			position = {
				x = x,
				y = y
			},
			char = char,
			hp_current = hp,
			hp_max = hp,
			turn_timer = 0,
			myTurn = false,
			inventory = {},
			equipment = {},
			element = elem,
			elem_amt = elem_amt,
			attack = 1,
			defense = 0,
			speed = 10,
			sight_dist = 10,
			entity_type = nil,
			equip_type = nil
		}
		setmetatable(self, Entity)
		return self
	end,

	Spawn = function(self)
		table.insert(resources.spawn_table, self)
	end,

	Die = function(self)
		for k, v in pairs(resources.spawn_table) do
			if v == self then
				table.remove(resources.spawn_table, k)
				resources.souls = resources.souls + 1

				local a = self.elem_amt

				if self.element == "fire" then m:InfuseElements(a,0,0,0,0,0)
				elseif self.element == "water" then m:InfuseElements(0,0,a,0,0,0)
				elseif self.element == "wood" then m:InfuseElements(0,0,0,a,0,0)
				elseif self.element == "metal" then m:InfuseElements(0,0,0,0,a,0)
				elseif self.element == "earth" then m:InfuseElements(0,a,0,0,0,0)
				elseif self.element == "air" then m:InfuseElements(0,0,0,0,0,a)
				end
				
				for k,v in pairs(m.elemental_balance) do
					print(k,v)
				end

				for k,v in pairs(self.inventory) do
					Drop("all")
				end
			end
		end
	end,

	Heal = function(self, amount)
		self.hp_current = self.hp_current + amount
		if self.hp_current > self.hp_max then
			self.hp_current = self.hp_max
		end
	end,

	Harm = function(self, amount)
		self.hp_current = self.hp_current - amount
		if self.hp_current <= 0 then
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
		local test_value = false
		
		for k, v in pairs(resources.spawn_table) do
			if test_x == v.position.x and test_y == v.position.y and v ~= self then
				if v.entity_type == "mob" then
					print("canMove says Bump!")
					self:Bump(v)
					return test_value
				end
			end
		end
		
		if test_x < 1 or test_x > m.board_size.x then 
			return test_value
		end

		if m.map_table[test_x][test_y] == "." then
			test_value = true
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
		else
			table.insert(self.inventory, target)
			target:Die()
			print(target.name.." picked up by "..self.name)
		end

		self.turn_timer = self.turn_timer + (resources.one_turn / self.speed)
		self.myTurn = false
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
	end,

	Equip = function(self, item_num)
		local item = self.inventory[item_num]
		table.remove(self.inventory, item_num)
		table.insert(self.equipment, item)

		for k, v in pairs(self.equipment) do
			self.attack = self.attack + v.attack
			self.defense = self.defense + v.defense
			self.speed = self.speed + v.speed
		end
	end,

	Bump = function(self, target)
		target:Harm(self.attack)
		print(target.name .. "'s HP is now "..target.hp_current)
	end,

	DrawInventory = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Inventory:", m.tile_size, m.tile_size)
		for k,v in ipairs(self.inventory) do
			love.graphics.print(k.." - ", m.tile_size, (k + 1) * m.tile_size)
			love.graphics.print(self.inventory[k].name, 4 * m.tile_size, (k + 1) * m.tile_size)
		end
	end,

	DrawEquipment = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Equipment:", 20 * m.tile_size, m.tile_size)
		for k,v in ipairs(self.equipment) do
			love.graphics.print(k.." - ", 20 * m.tile_size, (k + 1) * m.tile_size)
			love.graphics.print(self.equipment[k].name, 24 * m.tile_size, (k + 1) * m.tile_size)
		end
	end,
	
	EquipmentQuery = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Equip which item?", m.tile_size, 20 * m.tile_size)
	end,

	DropQuery = function(self)
		love.graphics.setColor(255,255,255)
		love.graphics.print("Drop which item?", m.tile_size, 20 * m.tile_size)
	end,

	Rest = function(self)
		self.turn_timer = self.turn_timer + (resources.one_turn)
		self.myTurn = false
		print(self.name.." rests")
	end
}

Entity.__index = Entity

return Entity
