extends RigidBody2D

class_name Monkey

signal liana_grabbed
signal liana_released
signal distance_calculated

const IMPULSE_MODULE := 10
const RELEASE_MULTIPLIER := 10

var initial_fly_point := 0
var final_fly_point := 0

var _left_pin_joint: PinJoint2D
var _right_pin_joint: PinJoint2D

var _right_monkey: Monkey = null
var _left_monkey: Monkey = null

var _grabbed_liana

var _current_monkey_liana_grabbed:= false
var _liana_grabbed_left:= false
var _liana_grabbed_right:= false 

var _direction := 0
var _speed := 1

var _impulse_vector: Vector2
var _impulse_angle: float

func _init():
	_init_left_pin_joint()
	_init_right_pin_joint()  

func _ready():
	_init_left_pin_joint()
	_init_right_pin_joint()
	
	connect("liana_grabbed", MonkeyGlobal, "_grab_liana")
	connect("liana_released", MonkeyGlobal, "_release_liana")
	
	connect("distance_calculated", ScoreGlobal, "stop")
	
	MonkeyGlobal.connect("fly_started", self, "_start_fly")
	MonkeyGlobal.connect("fly_ended", self, "_stop_fly")
	
	initial_fly_point = global_position.x

func _physics_process(_delta):
	if Input.is_action_pressed("ui_left"):
		_direction = - _speed
	elif Input.is_action_pressed("ui_right"):
		_direction = _speed
	else:
		_direction = 0
	
	_impulse_vector = Vector2.ZERO

	if(_grabbed_liana != null and _direction != 0):
		_impulse_vector = _calculate_liana_angle(_grabbed_liana.get_current_position(), _direction)
		_impulse_angle = abs(cos(_impulse_vector.angle()))
		
	if (Input.is_action_just_released("grab")):
		if(_current_monkey_liana_grabbed):
			apply_impulse(Vector2.DOWN, _impulse_vector * IMPULSE_MODULE * RELEASE_MULTIPLIER)
		_release_lianas()
	if (MonkeyGlobal._liana_grabbed and _current_monkey_liana_grabbed):
		apply_impulse(Vector2.DOWN, _impulse_vector * IMPULSE_MODULE * _impulse_angle)



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
		_grabbed_liana = body.liana
		emit_signal("liana_grabbed")

		_current_monkey_liana_grabbed = true
		_liana_grabbed_left = false
		_liana_grabbed_right = true


func _on_LeftArmArea2D_body_entered(body):
	if (_left_monkey != null):
		return
	
	var monkey = body as Monkey
	if (monkey == null) && (Input.is_action_pressed("grab") and !MonkeyGlobal._liana_grabbed):
		_grab_left_hand(body)
		_grabbed_liana = body.liana
		emit_signal("liana_grabbed")
		
		_current_monkey_liana_grabbed = true
		_liana_grabbed_left = true
		_liana_grabbed_right = false 


func _on_LeftArmArea2D_area_entered(area: Area2D):
	var monkey = area.get_parent() as Monkey
	if (monkey != null): 
		if(check_grab_monkey(monkey, true)):

			var can_grab = false
			if((area.get_name().find("Left") > -1) && monkey._left_monkey == null && !monkey._liana_grabbed_left):
				monkey._left_monkey = self
				can_grab = true
			if((area.get_name().find("Right") > -1) && monkey._right_monkey == null  && !monkey._liana_grabbed_right):
				monkey._right_monkey = self
				can_grab = true 

			if(!can_grab):
				return 

			_grab_left_hand(monkey) 
			event_bus.emit_signal('monkey_grabbed')
			_left_monkey = monkey 
		

func _on_RightArmArea2D_area_entered(area: Area2D): 
	var monkey = area.get_parent() as Monkey
	if (monkey != null):
		if(monkey._left_monkey == self || monkey._right_monkey == self): 
			return
		if(check_grab_monkey(monkey, false)): 
		
			var can_grab = false

			if((area.get_name().find("Left") > -1) && monkey._left_monkey == null && !monkey._liana_grabbed_left):
				monkey._left_monkey = self
				can_grab = true
			if((area.get_name().find("Right") > -1) && monkey._right_monkey == null && !monkey._liana_grabbed_right):
				monkey._right_monkey = self
				can_grab = true

			if(!can_grab):
				return 

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

	if(monkey._left_monkey == self || monkey._right_monkey == self):
		return false
		
	if (is_left_hand):
		if (self._left_monkey != null || self._liana_grabbed_left):
			return false 

	if (!is_left_hand):
		if(self._right_monkey != null || self._liana_grabbed_right):
			return false 
		
	return true  
	

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

	_grabbed_liana = null


func _release_right_hand():

	if (_liana_grabbed_right):
		emit_signal("liana_released")
		_current_monkey_liana_grabbed = false 
		_liana_grabbed_right = false 
		_right_pin_joint.node_b = get_path() 

	if (_right_monkey != null):
		return
		
	_right_pin_joint.node_b = get_path() 


func _release_left_hand():

	if (_liana_grabbed_left):
		emit_signal("liana_released")
		_current_monkey_liana_grabbed = false 
		_liana_grabbed_left = false  
		_left_pin_joint.node_b = get_path() 

	if (_left_monkey != null):
		return
		
	_left_pin_joint.node_b = get_path() 

func _start_fly():
	initial_fly_point = global_position.x


func _stop_fly():
	final_fly_point = global_position.x
	emit_signal("distance_calculated", final_fly_point - initial_fly_point)


func _calculate_liana_angle(liana_position: Vector2, direction: int):
	var liana_vector = global_position - liana_position
	var impulse_vector = liana_vector.rotated(deg2rad(90 *  - direction))
	var normalized = impulse_vector.normalized()
	return normalized 
