extends RigidBody2D

class_name Monkey

const IMPULSE := Vector2(100, 0)

var _left_pin_joint: PinJoint2D
var _right_pin_joint: PinJoint2D

var _right_monkey: Monkey
var _left_monkey: Monkey

var _liana_grabbed:= false

var _direction := 0


func _init():
	_init_left_pin_joint()
	_init_right_pin_joint()


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		_direction -= 1
	elif Input.is_action_just_pressed("ui_right"):
		_direction += 1
	else:
		_direction = 0
		
	if Input.is_action_just_released("grab"):
		_release_liana()
	if (_liana_grabbed):
		apply_impulse(Vector2.ZERO, IMPULSE * _direction)


func _init_right_pin_joint():
	_right_pin_joint = PinJoint2D.new()
	_right_pin_joint.node_a = get_path()
	_right_pin_joint.node_b = get_path()
	_right_pin_joint.bias = 0.9
	add_child(_right_pin_joint)


func _init_left_pin_joint():
	_left_pin_joint = PinJoint2D.new()
	_left_pin_joint.node_a = get_path()
	_left_pin_joint.node_b = get_path()
	_left_pin_joint.bias = 0.9
	add_child(_left_pin_joint)


func _on_RightArmArea2D_body_entered(body):
	if (_right_monkey != null):
		return
		
	if (_liana_grabbed):
		return
	
	var monkey = body as Monkey
	if (monkey != null):
		_grab_right_hand(body)
		_right_monkey = monkey
	elif (Input.is_action_pressed("grab")):
		_grab_right_hand(body)
		_liana_grabbed = true


func _on_LeftArmArea2D_body_entered(body):
	if (_left_monkey != null):
		return
		
	if (_liana_grabbed):
		return
	
	var monkey = body as Monkey
	if (monkey != null):
		_grab_left_hand(body)
		_left_monkey = monkey
	elif (Input.is_action_pressed("grab")):
		_grab_left_hand(body)
		_liana_grabbed = true


func _release_liana():
	_release_right_hand()
	_release_left_hand()
	print("liana release")


func _grab_right_hand(body):
	_right_pin_joint.position = $RightArmPosition2D.position
	_right_pin_joint.node_b = body.get_path()


func _grab_left_hand(body):
	_left_pin_joint.position = $LeftArmPosition2D.position
	_left_pin_joint.node_b = body.get_path()


func _release_right_hand():
	if (_right_monkey != null):
		return
		
	_right_pin_joint.node_b = get_path()
	_liana_grabbed = false


func _release_left_hand():
	if (_left_monkey != null):
		return
		
	_left_pin_joint.node_b = get_path()
	_liana_grabbed = false
