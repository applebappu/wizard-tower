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
	spawn_timer = 0,
	element_timer = 0,

	game_state = "main",
	query_substate = nil
}

return resources
