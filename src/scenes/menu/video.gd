extends Panel

onready var fullscreenButton = $"Video Settings/Fullscreen"
onready var borderlessScreenButton = $"Video Settings/Borderless"
onready var resolutionList = $"Video Settings/ResolutionLabel/ResolutionList"
onready var applyResolution = $"Video Settings/ResolutionLabel/ApplyResolution"
onready var vsyncButton = $"Video Settings/Vsync"
onready var qualityButton = $"Video Settings/Quality"

func _ready():
	_reload_settings()

func _reload_settings():
	print("reloading settings")
	fullscreenButton.text = "Fullscreen: ON" if GlobalSettings.settings["video"]["fullscreen"] else "Fullscreen: OFF"
	borderlessScreenButton.text = "Borderless: ON" if GlobalSettings.settings["video"]["borderless"] else "Borderless: OFF"
	vsyncButton.text = "V-Sync: ON" if GlobalSettings.settings["video"]["vsync"] else "V-Sync: OFF"
	qualityButton.text = "Quality: " + GlobalSettings.video_qualities[GlobalSettings.settings["video"]["quality_index"]].capitalize()

func _on_Exit_pressed():
	hide()

func _on_Fullscreen_pressed():
	GlobalSettings.settings["video"]["fullscreen"] = !GlobalSettings.settings["video"]["fullscreen"]
	OS.window_fullscreen = GlobalSettings.settings["video"]["fullscreen"]
	fullscreenButton.text = "Fullscreen: ON" if GlobalSettings.settings["video"]["fullscreen"] else "Fullscreen: OFF"

func _on_Borderless_pressed():
	GlobalSettings.settings["video"]["borderless"] = !GlobalSettings.settings["video"]["borderless"]
	OS.window_borderless = GlobalSettings.settings["video"]["borderless"]
	borderlessScreenButton.text = "Borderless: ON" if GlobalSettings.settings["video"]["borderless"] else "Borderless: OFF"

func _on_ApplyResolution_pressed():
	if resolutionList.text != "Native":
		var resolution = resolutionList.text.split('×', false)
		var resolutionVector = Vector2(resolution[0], resolution[1])
		GlobalSettings.settings["video"]["resolution"] = resolutionVector
		OS.window_size = resolutionVector
	else:
		OS.window_size = OS.get_screen_size(OS.current_screen)

func _on_Vsync_pressed():
	GlobalSettings.settings["video"]["vsync"] = !GlobalSettings.settings["video"]["vsync"]
	OS.vsync_enabled = GlobalSettings.settings["video"]["vsync"]
	vsyncButton.text = "V-Sync: ON" if GlobalSettings.settings["video"]["vsync"] else "V-Sync: OFF"

func _on_Quality_button_up():
	if GlobalSettings.settings["video"]["quality_index"] == 2:
		GlobalSettings.settings["video"]["quality_index"] = 0
	else:
		GlobalSettings.settings["video"]["quality_index"] += 1
	
	qualityButton.text = "Quality: " + GlobalSettings.video_qualities[GlobalSettings.settings["video"]["quality_index"]].capitalize()
