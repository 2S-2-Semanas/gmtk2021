extends RigidBody2D

class_name Monkey

const IMPULSE := Vector2(100, 0)

var left_pin_joint: PinJoint2D
var right_pin_joint: PinJoint2D

var right_monkey: Monkey
var left_monkey: Monkey

var right_hand_grab := false
var left_hand_grab := false

var _direction := 0

func _ready():
	right_pin_joint = PinJoint2D.new()
	left_pin_joint = PinJoint2D.new()

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		_direction -= 1
	elif Input.is_action_just_pressed("ui_right"):
		_direction += 1
	else:
		_direction = 0
		
	if Input.is_action_just_released("grab"):
		_release_liana()
	if (right_hand_grab or left_hand_grab):
		apply_impulse(Vector2.ZERO, IMPULSE * _direction)


func _on_RightArmArea2D_body_entered(body):
	if (right_monkey != null or !Input.is_action_pressed("grab")):
		return
	var monkey = body as Monkey
	if (monkey != null):
		right_monkey = monkey
	
	right_pin_joint.position = $RightArmPosition2D.position
	right_pin_joint.node_a = get_path()
	right_pin_joint.node_b = body.get_path()
	right_pin_joint.bias = 0.9
	if (!right_hand_grab):
		add_child(right_pin_joint)
		right_hand_grab = true


func _on_LeftArmArea2D_body_entered(body):
	if (Input.is_action_pressed("grab") or left_monkey != null):
		return
	var monkey = body as Monkey
	if (monkey != null):
		left_monkey = monkey
	left_pin_joint.position = $LeftArmPosition2D.position
	left_pin_joint.node_a = get_path()
	left_pin_joint.node_b = body.get_path()
	left_pin_joint.bias = 0.9
	if (!left_pin_joint):
		add_child(left_pin_joint)
		left_hand_grab = true

func _release_liana():
	if (right_monkey != null):
		return
		
	right_pin_joint.node_b = get_path()
	right_hand_grab = false
