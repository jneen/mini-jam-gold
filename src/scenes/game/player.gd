extends KinematicBody2D

export (int) var walk_speed = 900
export (int) var run_speed = 1700
export (int) var carry_speed = 700
export (int) var walk_jump_speed = -1800
export (int) var run_jump_speed = -2400
export (int) var gravity_float = 4000
export (int) var gravity_fall = 12000
export (int) var gravity_fall_cutoff = -500
export (float, 1.0, 2.0) var jump_boost = 1.2

var velocity = Vector2.ZERO

export (float, 0, 1.0) var ground_friction = 0.15
export (float, 0, 1.0) var air_friction = 0.05
export (float, 0, 1.0) var ground_acceleration = 0.3
export (float, 0, 1.0) var air_acceleration = 0.05

var coins : int = 0
var invicible : bool = false
var is_wearing_crown : bool
var is_carrying : bool = false
var is_ducking : bool = false
var facing_dir : int = 0
var held_item : String = ""

# warning-ignore:unused_argument
func damage(value : float):
	# skip if we're invincible
	if invicible: return

	if is_wearing_crown:
		lose_crown()
		$InvicibleTimer.start()
	else:
		splat()

func splat():
	print('TODO: splat')

func get_input():
# warning-ignore:unused_variable
	var moving = false
	var dir = 0

	if Input.is_action_pressed("walk_right"):
		dir += 1
		facing_dir = 1
	if Input.is_action_pressed("walk_left"):
		dir += -1
		facing_dir = -1

	if is_wearing_crown:
		move_player(facing_dir)
	else:
		move_player(dir)

func pick_acceleration():
	if is_on_floor():
		return ground_acceleration
	else:
		return air_acceleration
	
func pick_friction():
	if is_on_floor():
		return ground_friction
	else:
		return air_friction
	
func move_player(dir):
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * pick_speed(), pick_acceleration())
	else:
		velocity.x = lerp(velocity.x, 0, pick_friction())


func pick_gravity():
	if Input.is_action_pressed("jump") and velocity.y < gravity_fall_cutoff:
		return gravity_float
	else:
		return gravity_fall

func pick_speed():
	if is_wearing_crown: return run_speed
	if Input.is_action_pressed("interact"): return run_speed
	if is_carrying: return carry_speed
	return walk_speed

func pick_jump_speed():
	if Input.is_action_pressed("interact"): return run_jump_speed
	return walk_jump_speed

func wear_crown():
	# TODO: animation + sfx
	is_wearing_crown = true

func lose_crown():
	# TODO: animation + sfx
	is_wearing_crown = false

func _physics_process(delta):
	get_input()
	velocity.y += pick_gravity() * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = pick_jump_speed()
			velocity.x *= jump_boost

	# [jneen] TODO: if is_carrying_crown():
	if Input.is_action_just_pressed("duck"):
		wear_crown()

	# Update any GUI after doing character's work
	Hud.get_node("UI/Coins/CoinsLabel").text = str(coins)

	match held_item:
		"":
			Hud.get_node("UI/Powerup/PowerupIcon").texture = null
		"crown":
			print("beeboo")
			Hud.get_node("UI/Powerup/PowerupIcon").texture = preload("res://assets/icons/star.png")
		"coin":
			print("beeboo2")
			Hud.get_node("UI/Powerup/PowerupIcon").texture = preload("res://assets/props/coin.png")

func _on_InvicibleTimer_timeout():
	$InvicibleTimer.stop()
	invicible = false if invicible else invicible
