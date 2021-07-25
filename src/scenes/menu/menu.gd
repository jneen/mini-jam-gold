extends Control

onready var OptionsPanel = $OptionsPanel
onready var AchievementsPanel = $Achievements
onready var CreditsPanel = $CreditsPanel

func _on_Singleplayer_pressed():
	get_tree().change_scene_to(preload("res://src/scenes/game/game.tscn"))

func _on_Multiplayer_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(preload("res://src/scenes/menu/lobby.tscn"))

func _on_Achievements_pressed():
	AchievementsPanel.show()
	AchievementsPanel._reload_achievements()

func _on_Options_pressed():
	OptionsPanel.show()
	OptionsPanel._reload_settings()

func _on_Credits_pressed():
	CreditsPanel.show()

func _on_Quit_pressed():
	# TODO: save
	get_tree().quit()
