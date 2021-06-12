extends RigidBody2D

class_name Monkey

const IMPULSE := Vector2(1500, 150)
const IMPULSE_AFTER_RELEASE := Vector2(300, -1000)

signal liana_grabed
signal liana_released

var _current_monkey_liana_grabbed:= false

var _left_pin_joint: PinJoint2D
var _right_pin_joint: PinJoint2D

var _right_monkey: Monkey
var _left_monkey: Monkey

var _direction := 0
var _speed := 1

func _ready():
	_init_left_pin_joint()
	_init_right_pin_joint()
	
	connect("liana_grabed", MonkeyGlobal, "_grab_liana")
	connect("liana_released", MonkeyGlobal, "_release_liana")


func _physics_process(_delta):
	if Input.is_action_pressed("ui_left"):
		_direction = - _speed
	elif Input.is_action_pressed("ui_right"):
		_direction = _speed
	else:
		_direction = 0
		
	if (Input.is_action_just_released("grab")):
		if(MonkeyGlobal._liana_grabbed and _current_monkey_liana_grabbed):
			apply_impulse(Vector2.ZERO, Vector2(IMPULSE_AFTER_RELEASE.x * _direction, IMPULSE_AFTER_RELEASE.y))
		_release_lianas()
	if (MonkeyGlobal._liana_grabbed and _current_monkey_liana_grabbed):
		var resulting_impulse = IMPULSE
		resulting_impulse.x = IMPULSE.x * _direction *_delta
		resulting_impulse.y = IMPULSE.y * _delta
#		apply_impulse(Vector2.ZERO, resulting_impulse)
		apply_impulse(Vector2.ZERO, resulting_impulse)
#		apply_impulseVector2.ZERO, resulting_impulse)


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
	
	var monkey = body as Monkey
	if (monkey != null):
		_grab_right_hand(body)
		_right_monkey = monkey
		event_bus.emit_signal('monkey_grabbed')
	elif (Input.is_action_pressed("grab") and !MonkeyGlobal._liana_grabbed):
		_grab_right_hand(body)
		emit_signal("liana_grabed")
		_current_monkey_liana_grabbed = true


func _on_LeftArmArea2D_body_entered(body):
	if (_left_monkey != null):
		return
	
	var monkey = body as Monkey
	if (monkey != null):
		_grab_left_hand(body)
		_left_monkey = monkey
		event_bus.emit_signal('monkey_grabbed')
	elif (Input.is_action_pressed("grab") and !MonkeyGlobal._liana_grabbed):
		_grab_left_hand(body)
		emit_signal("liana_grabed")
		_current_monkey_liana_grabbed = true


func _grab_right_hand(body):
	_right_pin_joint.position = $RightArmPosition2D.position
	_right_pin_joint.node_a = get_path()
	_right_pin_joint.node_b = body.get_path()


func _grab_left_hand(body):
	_left_pin_joint.position = $LeftArmPosition2D.position
	_left_pin_joint.node_a = get_path()
	_left_pin_joint.node_b = body.get_path()


func _release_lianas():
	_release_right_hand()
	_release_left_hand()


func _release_right_hand():
	if (_right_monkey != null):
		return
		
	_right_pin_joint.node_b = get_path()
	emit_signal("liana_released")
	_current_monkey_liana_grabbed = false
	


func _release_left_hand():
	if (_left_monkey != null):
		return
		
	_left_pin_joint.node_b = get_path()
	emit_signal("liana_released")
	_current_monkey_liana_grabbed = false
