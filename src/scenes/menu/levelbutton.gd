extends TextureButton

signal clicked

func _on_LevelButton_pressed():
	emit_signal("clicked", self)
