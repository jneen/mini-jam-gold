extends KinematicBody2D

export (int) var walk_speed = 1000
export (int) var run_speed = 1600
export (int) var jump_speed = -1800
export (int) var gravity_float = 3500
export (int) var gravity_fall = 5000
export (float) var jump_boost = 1.2

var velocity = Vector2.ZERO

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var wearing_crown : bool
var coins : int = 0
var invicible : bool = false
var jump_peaked = false

func damage(value : float):
	# skip if we're invincible
	if not $InvicibleTimer.is_stopped(): return

	if wearing_crown:
		wearing_crown = false
		$InvicibleTimer.start()
	else:
		splat()

func splat():
	print('TODO: splat')

func get_input():
	var dir = 0
	if Input.is_action_pressed("walk_right"):
		dir += 1
	if Input.is_action_pressed("walk_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * pick_speed(), acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func pick_gravity():
	if Input.is_action_pressed("jump") and velocity.y < 0:
		return gravity_float
	else:
		return gravity_fall

func pick_speed():
	if Input.is_action_pressed("interact"):
		return run_speed
	else:
		return walk_speed

func _physics_process(delta):
	get_input()
	velocity.y += pick_gravity() * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			velocity.x *= jump_boost
	Hud.get_node("UI/Coins/CoinsLabel").text = str(coins)
	Hud.get_node("UI/Heart/Label").text = str(coins) + "%"

func _on_InvicibleTimer_timeout():
	$InvicibleTimer.stop()
	invicible = false if invicible else invicible
