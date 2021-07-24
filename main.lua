Entity = require "classes.Entity"
Map = require "classes.Map"
Vector2 = require "classes.Vector2"

item_db = require "modules.item_db"
map_pieces = require "modules.map_pieces"
mob_db = require "modules.mob_db"
resources = require "modules.resources"
time = require "modules.time"
tools = require "modules.tools"

tools.setFont()
tools.setRandomSeed()

m = Map.New(38,20,10,10,10,10,10,10)
m:RandomMap() 

mob_db.Player:Spawn()
mob_db.Player.entity_type = "Player"

mob_db.fire_slime:Spawn()
mob_db.earth_slime:Spawn()

item_db.sword:Spawn()

function love.keyreleased(k)
	if k == "escape" then
		love.event.quit()
	end

	if k == "kp5" then -- wait
		mob_db.Player:Move(0, 0)
	elseif k == "kp4" then -- move west
		mob_db.Player:Move(-1, 0)
	elseif k == "kp6" then -- move east
		mob_db.Player:Move(1, 0)
	elseif k == "kp8" then -- move north
		mob_db.Player:Move(0, -1)
	elseif k == "kp2" then -- move south
		mob_db.Player:Move(0, 1)
	elseif k == "kp1" then -- move SW
		mob_db.Player:Move(-1, 1)
	elseif k == "kp7" then -- move NW
		mob_db.Player:Move(-1, -1)
	elseif k == "kp9" then -- move NE
		mob_db.Player:Move(1, -1)
	elseif k == "kp3" then -- move SE
		mob_db.Player:Move(1, 1)
	end

	if k == "g" then
		-- pick up item at current position
		mob_db.Player:Pickup()
	elseif k == "i" then
		-- view inventory
	end
end

function love.draw()
	m:DrawMap()
	m:DrawItems()
	m:DrawMobs()
	m:DrawGUI()
end

function love.update(dt)
	if item_db.sword.myTurn then
		item_db.sword:Move(0,0)
	end

	for k,v in pairs(resources.spawn_table) do
		if v.myTurn and v.entity_type == "mob" then
			v:Wander()
		end
	end

	time.incrementTurns()
end
