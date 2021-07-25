extends RigidBody2D

var held : bool = false

func _on_Coininteractzone_body_entered(body):
	if body.is_in_group("Player"):
		print("CARRIED RN")
		held = true
		hide()

func get_collision():
	return $CollisionShape2D
