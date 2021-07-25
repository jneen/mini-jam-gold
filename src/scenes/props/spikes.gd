extends StaticBody2D

func _on_Area2D_body_entered(body):
	print('_on_Area2D_body_entered: ', body)
	if $SpikeCooldown.is_stopped() and body.is_in_group('Player'):
		body.damage(25)
		$SpikeCooldown.start()


func _on_SpikeCooldown_timeout():
	$SpikeCooldown.stop()
