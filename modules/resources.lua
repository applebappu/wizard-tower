local resources = {
	spawn_table = {},
	world_spawn_memory = {},
	
	current_map = {},
	tower_level = 1,
	world_map_memory = {},
	tower_height = 10,

	souls = 0,

	one_turn = 100,
	spawn_timer = 0,
	element_timer = 0,

	game_state = "main",
	query_substate = nil
}

return resources
