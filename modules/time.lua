local time = {
	incrementTurns = function()
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

	spawner = function()
		while resources.global_timer > 20 do
			tools.ElementalSpawn()
			resources.global_timer = resources.global_timer - 1
		end
	end
}

return time
