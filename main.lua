Entity = require "classes.Entity"
Map = require "classes.Map"
Vector2 = require "classes.Vector2"

map_pieces = require "modules.map_pieces"
resources = require "modules.resources"
time = require "modules.time"
tools = require "modules.tools"

tools.setFont()
tools.setRandomSeed()

m = Map.New(38,20,0,0,0,0,0,0)
m:RandomMap() 

Player = Entity.New("Player",5,5,"@",10,"fire",1)
Player:Spawn()

slime = Entity.New("slime",math.random(1,38),math.random(1,20),"s",2,"air",2)
slime:Spawn()

slime2 = Entity.New("slime2",math.random(1,38),math.random(1,20),"s",2,"earth",2)
slime2:Spawn()

function love.keyreleased(k)
	if k == "escape" then
		love.event.quit()
	end

	if k == "kp5" then -- wait
		Player:Move(0, 0)
	elseif k == "kp4" then -- move west
		Player:Move(-1, 0)
	elseif k == "kp6" then -- move east
		Player:Move(1, 0)
	elseif k == "kp8" then -- move north
		Player:Move(0, -1)
	elseif k == "kp2" then -- move south
		Player:Move(0, 1)
	elseif k == "kp1" then -- move SW
		Player:Move(-1, 1)
	elseif k == "kp7" then -- move NW
		Player:Move(-1, -1)
	elseif k == "kp9" then -- move NE
		Player:Move(1, -1)
	elseif k == "kp3" then -- move SE
		Player:Move(1, 1)
	end
end

function love.draw()
	m:DrawMap()
	m:DrawMobs()	
	m:DrawGUI()
end

function love.update(dt)
	for k,v in pairs(resources.spawn_table) do
		if v.myTurn and v.name ~= "Player" then
			v:Wander()
		end
	end

	time.incrementTurns()
end
