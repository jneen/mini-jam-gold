extends RigidBody2D

func _on_Coininteractzone_body_entered(body):
	if body.is_in_group("Player"):
		if body.coin_in != self:
			body.coin_in = self

func _on_Coininteractzone_body_exited(body):
	if body.is_in_group("Player"):
		if body.coin_in == self:
			body.coin_in = null
