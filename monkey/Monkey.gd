extends RigidBody2D

const IMPULSE := Vector2(100, 0)

var left_pin_joint: PinJoint2D
var right_pin_joint: PinJoint2D

var right_hand_grab := false

var _direction := 0

func _ready():
	right_pin_joint = PinJoint2D.new()

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		_direction -= 1
	elif Input.is_action_just_pressed("ui_right"):
		_direction += 1
	else:
		_direction = 0
		
	if Input.is_action_pressed("grab"):
		pass
	
	apply_impulse(Vector2.ZERO, IMPULSE * _direction)


func _on_RightArmArea2D_body_entered(body):
	right_pin_joint.position = $RightArmPosition2D.position
	right_pin_joint.node_a = get_path()
	right_pin_joint.node_b = body.get_path()
	right_pin_joint.bias = 0.9
	if (!right_hand_grab):
		add_child(right_pin_joint)
		right_hand_grab = true
	
	print("entro aqui no hay duda")
