local resources = {
	spawn_table = {},
	current_map = {},
	elements = {
		fire = {},
		wood = {},
		earth = {},
		water = {},
		metal = {},
		air = {}
	},
    
	souls = 0,

	one_turn = 100,
	global_timer = 0,

	game_state = "main",
	query_substate = nil
}

return resources
