extends StaticBody2D

func _ready():
	pass

func _process(delta):
	pass


func _on_Area2D_body_entered(body):
	if $SpikeCooldown.is_stopped() and body.is_in_group("Player"):
		body.damage(25)
		$ASP.play()
		$SpikeCooldown.start()


func _on_SpikeCooldown_timeout():
	$SpikeCooldown.stop()
