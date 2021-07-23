extends VBoxContainer

onready var masterSlider = $MasterSlider
onready var masterText = $MasterAudio
onready var musicSlider = $MusicSlider
onready var musicText = $MusicAudio
onready var soundSlider = $SoundSlider
onready var soundText = $SoundAudio

func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), masterSlider.value)
	GlobalSettings.settings["audio"]["master"] = masterSlider.value
	masterText.text = "Master Volume (" + str(masterSlider.value) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicSlider.value)
	GlobalSettings.settings["audio"]["music"] = musicSlider.value
	musicText.text = "Music Volume (" + str(musicSlider.value) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), soundSlider.value)
	GlobalSettings.settings["audio"]["sound"] = soundSlider.value
	soundText.text = "Sound Volume (" + str(soundSlider.value) + "%)"

