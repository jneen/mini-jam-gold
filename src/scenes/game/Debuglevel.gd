extends Node2D

func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_F3:
		$"../World".save_raw_level_to_file($"../World/TileMap", "user://level",$"../World")
