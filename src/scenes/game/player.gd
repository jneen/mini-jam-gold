extends KinematicBody2D

export (int) var walk_speed = 900
export (int) var run_speed = 1700
export (int) var carry_speed = 700
export (int) var walk_jump_speed = -1800
export (int) var run_jump_speed = -2400
export (int) var run_jump_threshold = 800
export (int) var gravity_float = 4000
export (int) var gravity_fall = 12000
export (int) var gravity_fall_cutoff = -500
export (float, 1.0, 2.0) var jump_boost = 1.2

onready var sprite = $AnimatedSprite

var velocity = Vector2.ZERO

export (float, 0, 1.0) var ground_friction = 0.2
export (float, 0, 1.0) var air_friction = 0.05
export (float, 0, 1.0) var ground_acceleration = 0.1
export (float, 0, 1.0) var air_acceleration = 0.1
export (float, 0, 1.0) var collision_momentum_dropoff = 0.1
export (Vector2) var carry_offset = Vector2(64, -32)
export (Vector2) var throw_force = Vector2(1700, -700)

var coins : int = 0
var invicible : bool = false
var frozen : bool = false
var is_wearing_crown : bool
var is_ducking : bool = false
var facing_dir : int = 0
var held_item
var held_item_original_parent
var buffer_jump : bool = false
var bonk : bool = false
var can_jump : bool = false
var ducking : bool = false

# warning-ignore:unused_argument
func damage(value : float):
	# skip if we're invincible
	if invicible: return

	if is_wearing_crown:
		lose_crown()
		$DamageSFX.play()
		$InvicibleTimer.start()
	else:
		splat()

func splat():
	if held_item:
		drop_item()

	$SplatSFX.play()
	frozen = true
	$RespawnTimer.start()

	velocity.x = 0.0
	velocity.y = 0.0
	facing_dir = 1
	sprite.flip_h = false

	var treasury = get_tree().get_root().get_node("Game/World/Entities/treasury")
	self.global_position = treasury.get_global_position()

func process_move():
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
	if frozen: return

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * pick_speed(), pick_acceleration())
	else:
		velocity.x = lerp(velocity.x, 0, pick_friction())

	if abs(velocity.x) < 10: velocity.x = 0


func pick_gravity():
	if Input.is_action_pressed("jump") and velocity.y < gravity_fall_cutoff:
		return gravity_float
	else:
		return gravity_fall

func carry(object):
	print(object)
	held_item = object
	held_item_original_parent = object.get_parent()
	held_item_original_parent.remove_child(object)
	add_child(object)
	object.position = carry_offset
	object.disable_physics()

func pick_speed():
	if is_wearing_crown: return run_speed
	if is_carrying(): return carry_speed
	if Input.is_action_pressed("interact"): return run_speed
	return walk_speed

func is_carrying():
	return held_item != null

func pick_jump_speed():
	if is_wearing_crown: return run_jump_speed
	if Input.is_action_pressed("interact") and abs(velocity.x) > run_jump_threshold:
		return run_jump_speed
	return walk_jump_speed

func wear_crown():
	# TODO: animation + sfx
	is_wearing_crown = true

func lose_crown():
	# TODO: animation + sfx
	is_wearing_crown = false

func is_moving_left():
	if is_wearing_crown: return facing_dir < 0
	return Input.is_action_pressed("walk_left") and velocity.x < 0

func is_moving_right():
	if is_wearing_crown: return facing_dir > 0
	return Input.is_action_pressed("walk_right") and velocity.x > 0

func play_move_sprite():
	if frozen: return sprite.play("idle")

	var is_moving = Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right")

	if ducking:
		sprite.play("crawl")
		if not is_moving: sprite.stop()
		return

	if Input.is_action_pressed("walk_left") or Input.is_action_pressed("walk_right"):
		sprite.play("run")
		return

	sprite.play("idle")

func animate_sprite():
	if is_moving_left():
		sprite.flip_h = true

	if is_moving_right():
		sprite.flip_h = false

	if held_item:
		var dir = 1
		if sprite.flip_h: dir = -1
		if sign(held_item.position.x) != sign(facing_dir):
			held_item.position.x *= -1



	play_move_sprite()

func jump():
	$JumpSFX.play()
	velocity.y = pick_jump_speed()
	velocity.x *= jump_boost

func process_jump():
	if frozen: return
	if is_on_floor():
		can_jump = true
		$CoyoteTimer.start()

	if Input.is_action_just_pressed("jump"):
		if can_jump:
			jump()
		else:
			$BufferJumpTimer.start()
			buffer_jump = true
	else:
		# note: no coyote jumps here. you have to actually be on the floor
		# to buffer jump
		if buffer_jump and is_on_floor():
			$BufferJumpTimer.stop()
			buffer_jump = false
			jump()


# func _process(delta):

func duck():
	print('duck')
	ducking = true
	$PlayerCollision.get_shape().set_extents(Vector2(120, 60))
# warning-ignore:return_value_discarded
	move_and_collide(64 * Vector2.DOWN)

func unduck():
	print('unduck')
	ducking = false
	$PlayerCollision.get_shape().set_extents(Vector2(60, 120))

func process_bonk(slide : Vector2):
	# if we're not trying to go up, there is no more bonk, and we should
	# not remember y-momentum
	if velocity.y >= 0:
		bonk = false
		velocity.y = slide.y
		return

	# so we know we tried to move up.

	# if the collided y-vel was zeroed out, we have head-bonked.
	if slide.y == 0:
		bonk = true

	# if we have head-bonked we should float a bit, but never actually go up
	if velocity.y < 0 and slide.y < 0 and bonk:
		velocity.y = 0

	velocity.y = lerp(velocity.y, slide.y, collision_momentum_dropoff / 2)

func direct_vector(v : Vector2):
	return Vector2(facing_dir, 1) * v

func drop_item():
	var current_position = held_item.global_position
	held_item.sleeping = false

	remove_child(held_item)
	held_item_original_parent.add_child(held_item)
	held_item.global_position = current_position

	held_item.enable_physics()
	self.held_item = null

func _physics_process(delta):
	if held_item:
		if not Input.is_action_pressed("interact"):
			var item = held_item
			drop_item()
			item.set_axis_velocity(direct_vector(throw_force))


	animate_sprite()
	process_move()
	velocity.y += pick_gravity() * delta
	var slide = move_and_slide(velocity, Vector2.UP, false, 4, PI/4, false)
	velocity.x = lerp(velocity.x, slide.x, collision_momentum_dropoff)

	process_bonk(slide)

	process_jump()

	if ducking and not Input.is_action_pressed("duck"):
		unduck()

	# [jneen] TODO: if is_carrying_crown():
	if Input.is_action_just_pressed("duck") and not is_carrying():
		duck()

func _on_InvicibleTimer_timeout():
	$InvicibleTimer.stop()
	invicible = false

func _on_RespawnTimer_timeout():
	$RespawnTimer.stop()
	frozen = false

func _on_BufferJumpTimer_timeout():
	$BufferJumpTimer.stop()
	buffer_jump = false

func _on_CoyoteTimer_timeout():
	$CoyoteTimer.stop()
	if not is_on_floor(): can_jump = false
