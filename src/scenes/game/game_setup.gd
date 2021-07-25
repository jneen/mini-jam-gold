extends Node2D

var level_to_load : String = ""

func find_levelid_by_name(name : String):
	for level_id in Levels.levels.keys():
		if Levels.levels[level_id]["name"] == name:
			return true

func _process(_delta):
	if level_to_load != "":
		var lvl_id = find_levelid_by_name(level_to_load)
		$World.load_level(Levels.levels[lvl_id]["level_resource"][0], Vector2(0,0), $World/TileMap)
		$World.load_entities($World, Levels.levels[lvl_id]["level_resource"][1], true)
		$Players/Player.position = Levels.levels[lvl_id]["spawn_pos"]
		
		level_to_load = ""

