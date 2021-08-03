local time = {
	IncrementTurns = function()
		for k,v in pairs(resources.spawn_table) do
			if v.myTurn == false then
				v.turn_timer = v.turn_timer - 1
			end
			for k, v in pairs(resources.spawn_table) do
				if v.turn_timer <= 0 then
					v.turn_timer = 0
					v.myTurn = true
					break
				end
			end
		end
	end,

	Spawner = function()
		while resources.spawn_timer > 20 do
			tools.ElementalSpawn()
			resources.spawn_timer = resources.spawn_timer - 1
		end
	end,

	ElementalSeepage = function()
		while resources.element_timer > 5 do
			m:TileElements()
			resources.element_timer = resources.element_timer - 5
		end
	end,

	TimerTick = function()
		resources.spawn_timer = resources.spawn_timer + 1
		resources.element_timer = resources.element_timer + 1
	end
}

return time
