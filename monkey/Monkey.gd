extends RigidBody2D

class_name Monkey

const IMPULSE := Vector2(1500, 150)
const IMPULSE_AFTER_RELEASE := Vector2(300, -1000)

signal liana_grabed
signal liana_released

var _left_pin_joint: PinJoint2D
var _right_pin_joint: PinJoint2D

var _right_monkey: Monkey
var _left_monkey: Monkey

var _current_monkey_liana_grabbed:= false
var _liana_grabbed_left:= false
var _liana_grabbed_right:= false 

var _direction := 0
var _speed := 1

func _init():
	_init_left_pin_joint()
	_init_right_pin_joint()  

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

	if (monkey == null) && (Input.is_action_pressed("grab") and !MonkeyGlobal._liana_grabbed):
		_grab_right_hand(body)

		emit_signal("liana_grabed")

		_current_monkey_liana_grabbed = true
		_liana_grabbed_left = false
		_liana_grabbed_right = true


func _on_LeftArmArea2D_body_entered(body):
	if (_left_monkey != null):
		return
	
	var monkey = body as Monkey
	if (monkey == null) && (Input.is_action_pressed("grab") and !MonkeyGlobal._liana_grabbed):
		_grab_left_hand(body) 
		emit_signal("liana_grabed")
		_current_monkey_liana_grabbed = true
		_liana_grabbed_left = true
		_liana_grabbed_right = false 


func _on_LeftArmArea2D_area_entered(area: Area2D):
	var monkey = area.get_parent() as Monkey
	if (monkey != null): 
		if(check_grab_monkey(monkey, true)):
			_grab_left_hand(monkey) 
			event_bus.emit_signal('monkey_grabbed')
		_left_monkey = monkey
		

func _on_RightArmArea2D_area_entered(area: Area2D): 
	var monkey = area.get_parent() as Monkey
	if (monkey != null):
		if(check_grab_monkey(monkey, false)):
			_grab_right_hand(monkey) 
			event_bus.emit_signal('monkey_grabbed')
		_right_monkey = monkey

func check_grab_monkey(monkey: Monkey, is_left_hand):
	if (monkey._left_monkey != null && monkey._left_monkey == self):
		return false
	if (monkey._right_monkey != null && monkey._right_monkey == self):
		return false

	if (self._left_monkey != null && self._left_monkey == monkey):
		return false

	if (self._right_monkey != null && self._right_monkey == monkey):
		return false 

	if (self._left_monkey != null && self._right_monkey != null):
		return false
		
	if (is_left_hand):
		if (self._left_monkey != null || self._liana_grabbed_left):
			return false 

	if (!is_left_hand):
		if(self._right_monkey != null || self._liana_grabbed_right):
			return false 
		
	return true 

func _release_liana():
	_release_right_hand()
	_release_left_hand()  

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

	if (_liana_grabbed_right):
		emit_signal("liana_released")
		_current_monkey_liana_grabbed = false 
		_liana_grabbed_right = false


func _release_left_hand():
	if (_left_monkey != null):
		return
		
	_left_pin_joint.node_b = get_path() 

	if (_liana_grabbed_left):
		emit_signal("liana_released")
		_current_monkey_liana_grabbed = false 
		_liana_grabbed_left = false 
