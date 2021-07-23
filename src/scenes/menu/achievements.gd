extends Panel

onready var achievementTextureRect = preload("res://src/scenes/menu/achievement.tscn")

func _ready():
	pass

func _reload_achievements():
	print("reloading achievements")
	$LoadingLabel.show()
	$StatsLabel.hide()
	var loop_index = 1
	#clean up
	for node in $GridContainer.get_children():
		node.queue_free()
	for achievement in GlobalAchievements.achievements.keys():
		loop_index += 1
		var achievement_image = achievementTextureRect.instance()
		achievement_image.name = achievement
		achievement_image.texture = GlobalAchievements.achievements[achievement]["image"]
		achievement_image.hint_tooltip = GlobalAchievements.achievements[achievement]["description"] + "\nOwned: Yes" if GlobalAchievements.is_owned(achievement) else GlobalAchievements.achievements[achievement]["description"] + "\nOwned: No"
		achievement_image.rect_position.x = 64 * loop_index
		
		if not GlobalAchievements.is_owned(achievement):
			achievement_image.modulate = Color8(92, 92, 92)
		
		$GridContainer.call_deferred("add_child", achievement_image)
		
	$StatsLabel.text = "Achievements owned: " + str(GlobalAchievements.achievements_owned.size()) + "/" + str(GlobalAchievements.achievements.size())
	$LoadingLabel.hide()
	$StatsLabel.show()

func _on_Exit_pressed():
	hide()
