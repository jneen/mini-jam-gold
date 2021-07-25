extends RigidBody2D

var held : bool = false
var original_gravity_scale = 0

func _on_Coininteractzone_body_entered(body):
	if not $GrabCooldownTimer.is_stopped(): return
	if body.is_in_group("Player") and Input.is_action_pressed('interact'):
		body.carry(self)

func disable_physics():
	print('disable_physics')
	$CollisionShape2D.set_deferred('disabled', true)
	original_gravity_scale = self.gravity_scale
	self.gravity_scale = 0

func enable_physics():
	print('enable_physics')
	$CollisionShape2D.set_deferred('disabled', false)
	self.gravity_scale = original_gravity_scale
