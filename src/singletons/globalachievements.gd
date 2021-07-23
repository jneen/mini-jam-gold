extends Node

var achievements = {
	"youplayed" : {"description" : "you managed to download the game.\ncongrats.", "image" : preload("res://assets/achievements/youplayed.png")}
}

var achievements_owned = []

func _ready():
	pass # Replace with function body.

func is_owned(achievement_name : String):
	return achievements_owned.has(achievement_name)
