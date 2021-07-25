extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var loop_index = 0
	
	for levelindex in Levels.levels.keys():
		var level = loop_index
		var button_image = preload("res://src/scenes/menu/levelbutton.tscn").instance()
		button_image.name = str(level)
		var st = StreamTexture.new()
		print(Levels.levels[level]["icon_resource"])
		print(Levels.levels[level]["icon_resource"].resource_path)
		st.load_path = Levels.levels[level]["icon_resource"].resource_path
		button_image.call_deferred("set", "texture_normal", st)
		
		button_image.connect("clicked", self, "level_button_clicked")
		
		$GridContainer.add_child(button_image)
		loop_index += 1

func level_button_clicked(instance):
	var level_dic = Levels.levels[int(instance.name)]
	$Panel/Label.text = "Level " + instance.name + "\nName: " + level_dic["name"] + "\nAuthor " + "" + "\nDescription: " + ""
