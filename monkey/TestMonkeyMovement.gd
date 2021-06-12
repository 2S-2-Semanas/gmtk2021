extends KinematicBody2D

export var speed := Vector2(300.0, 1000.0)
export var gravity := 100.0

var _velocity := Vector2.ZERO #our character will move 300 px per second in the x axis and 0 in the y axis


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calculate_move_velocity(_velocity, speed, direction, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, Vector2.UP) #is on floor will get updated here
	
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 0.0
	)

func calculate_move_velocity(linear_velocity: Vector2, speed: Vector2, direction: Vector2, is_jump_interrupted: bool) -> Vector2:
	var new_velocity := linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0: #if we are jumping
		new_velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		new_velocity.y = 0.0
	return new_velocity

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
