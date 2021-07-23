extends Node

var settings : Dictionary = {
	"video" : {"fullscreen" : false, "borderless" : false, "resolution" : Vector2(0,0), "vsync" : false, "quality_index" : 1},
	"audio" : {"master" : 100, "music" : 100, "sound" : 100}
}
var video_qualities = ["low", "high", "ultra"]

func _ready():
	pass

func load_default_settings():
	#todo
	pass

