extends VBoxContainer

onready var masterSlider = $MasterSlider
onready var masterText = $MasterAudio
onready var musicSlider = $MusicSlider
onready var musicText = $MusicAudio
onready var soundSlider = $SoundSlider
onready var soundText = $SoundAudio

func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), masterSlider.value)
	GlobalSettings.settings["audio"]["master"] = masterSlider.value / 100
	masterText.text = "Master Volume (" + str(masterSlider.value) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), musicSlider.value)
	GlobalSettings.settings["audio"]["music"] = musicSlider.value / 100
	musicText.text = "Music Volume (" + str(musicSlider.value) + "%)"
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), soundSlider.value)
	GlobalSettings.settings["audio"]["sound"] = soundSlider.value / 100
	soundText.text = "Sound Volume (" + str(soundSlider.value) + "%)"

