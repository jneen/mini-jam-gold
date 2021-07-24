extends KinematicBody2D

export (int) var speed = 1200
export (int) var jump_speed = -1800
export (int) var gravity = 4000

var velocity = Vector2.ZERO

export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var health : float = 100
var coins : int = 0
var invicible : bool = false

func damage(value : float):
	if $InvicibleTimer.is_stopped():
		print("damaged")
		invicible = true
		health -= value
		$InvicibleTimer.start()

func get_input():
	var dir = 0
	if Input.is_action_pressed("walk_right"):
		dir += 1
	if Input.is_action_pressed("walk_left"):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
	Hud.get_node("UI/Coins/CoinsLabel").text = str(coins)
	Hud.get_node("UI/Heart/Label").text = str(coins) + "%"


func _on_InvicibleTimer_timeout():
	$InvicibleTimer.stop()
	invicible = false if invicible else invicible
