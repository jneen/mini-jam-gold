extends Node

var example_world = {
	Vector2(0,0) : {"tile_id" : 1, "tile_flags" : {"flip_x" : false, "flip_y" : false}, "flags" : []},
	Vector2(1,0) : {"tile_id" : 1, "tile_flags" : {"flip_x" : false, "flip_y" : false}, "flags" : []},
	Vector2(1,1) : {"tile_id" : 1, "tile_flags" : {"flip_x" : false, "flip_y" : false}, "flags" : []},
}

func get_level_dictionary(tilemap : TileMap):
	var level_dictionary = {}
	
	for tile in tilemap.get_used_cells():
		var cellid = tilemap.get_cellv(tile)
		level_dictionary[tile] = {"tile_id" : cellid, "tile_flags" : {"flip_x" : tilemap.is_cell_x_flipped(tile.x, tile.y), "flip_y" : tilemap.is_cell_y_flipped(tile.x, tile.y)}, "flags" : []}
	
	return level_dictionary

func make_entities_dictionary(world):
	var entities_dictionary = {}
	var entities = world.get_node("Entities")
	
	# Saving any kind of entity lol
	for entity_type in entities.get_children():
		if entities.get_node(entity_type.name).get_child_count() >= 1:
			for entity in entities.get_children():
				print("[Saving] Entities/" + entity_type.name + " - Saving " + entity_type.name + " id (" + entity.name + ")")
				
				entities_dictionary[entity.name] = {"entity_name": entity_type.name, "entity_position" : entity.position, "entity_flags" : entity.retrieve_save_flags()}
				print("[Saving] Entities/" + str(entities_dictionary[entity.name]))
	
	return entities_dictionary

func load_entities(world, entities_dictionary, reset_before_loading : bool):
	if reset_before_loading == true:
		for entity_type in world.get_node("Entities").get_children():
			for node in world.get_node("Entities").get_node(entity_type.name).get_children():
				node.queue_free()
	
	var entities = world.get_node("Entities")
	for entity_index in entities_dictionary:
		var obj_dic = entities_dictionary.get(entity_index)
		entities.summon_entity(obj_dic["entity_name"], obj_dic["entity_position"], obj_dic["entity_flags"])


func load_level(level_dictionary : Dictionary, level_position : Vector2, tilemap : TileMap):
	for key in level_dictionary.keys():
		var position = key
		var tile_information = level_dictionary.get(key)
		tilemap.set_cellv(Vector2(level_position.x + position.x, level_position.y + position.y), tile_information["tile_flags"]["flip_x"], tile_information["tile_flags"]["flip_y"])
	
	print("level loaded")

func save_raw_level_to_file(tilemap, path, world):
	var file = File.new()
	file.open(path + ".dug", File.WRITE)
	file.store_line(to_json(var2str(get_level_dictionary(tilemap))))
	file.close()
	file.open(path + ".ent", File.WRITE)
	file.store_line(to_json(var2str(make_entities_dictionary(world))))
	file.close()
	
	print("level saved")

func save_level_to_file(level_dictionary : Dictionary, path, world):
	var file = File.new()
	file.open(path + ".dug", File.WRITE)
	file.store_line(to_json(var2str(level_dictionary)))
	file.close()
	file.open(path + ".ent", File.WRITE)
	file.store_line(to_json(var2str(make_entities_dictionary(world))))
	file.close()
	
	print("level saved")

func load_level_from_file(path, level_position : Vector2, tilemap : TileMap, world):
	var file = File.new()
	file.open(path + ".dug", File.READ)
	var text = file.get_as_text()
	var level_dictionary = {}
	level_dictionary = parse_json(text)
	level_dictionary = str2var(level_dictionary)
	file.close()
	
	file.open(path + ".ent", File.READ)
	var entities_dictionary = {}
	entities_dictionary = parse_json(file.get_as_text())
	if entities_dictionary is String:
		entities_dictionary = str2var(entities_dictionary)
	file.close()
	
	load_level(level_dictionary, level_position, tilemap)
	load_entities(world, entities_dictionary, true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
