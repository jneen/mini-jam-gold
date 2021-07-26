extends RigidBody2D

var held : bool = false
var original_gravity_scale = 0

export (bool) var is_crown

var cooldown = false

func _on_Coininteractzone_body_entered(body):
	print('cooldown: ', cooldown, $GrabCooldownTimer.time_left)
	if cooldown: return
	if not body.is_in_group("Player"): return
	if not Input.is_action_pressed("interact"): return
	if body.held_item: return
	body.carry(self)

func disable_physics():
	$CollisionShape2D.set_deferred('disabled', true)
	original_gravity_scale = self.gravity_scale
	self.gravity_scale = 0

func enable_physics():
	$GrabCooldownTimer.start()
	cooldown = true
	$CollisionShape2D.set_deferred('disabled', false)
	self.gravity_scale = original_gravity_scale

func _on_GrabCooldownTimer_timeout():
	$GrabCooldownTimer.stop()
	cooldown = false
