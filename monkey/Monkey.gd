extends RigidBody2D

const IMPULSE := Vector2(100, 0)

var _direction := 0

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_left"):
		_direction -= 1
	elif Input.is_action_just_pressed("ui_right"):
		_direction += 1
	else:
		_direction = 0
	
	apply_impulse(Vector2.ZERO, IMPULSE * _direction)
