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

	game_state = "main",
	query_substate = nil
}

return resources
