extends Camera2D

const SPEED: int = 20  

onready var advance_area : Area2D = $AdvanceArea
onready var advance_area_collision_shape : CollisionShape2D = $AdvanceArea/AdvanceAreaCollisionShape

var wanted_pos_x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_bus.connect('monkey_grabbed', self, '_on_monkey_grabbed')
	advance_area.connect('body_entered', self, 'on_advance_body_entered')

func _process(delta: float) -> void:
	var velocity = Vector2.RIGHT;
	velocity = velocity * SPEED;
	var movement = velocity * delta
	global_position += movement; 
	if(wanted_pos_x + get_shape_offset().x > global_position.x):
		global_position += movement * SPEED

func _on_monkey_grabbed():
	self.zoom.x += 0.1
	self.zoom.y += 0.1
	var shape: RectangleShape2D = advance_area_collision_shape.shape
	shape.extents = Vector2(shape.extents.x, shape.extents.y * 1.1)

func on_advance_body_entered(body):
	# if is main moke etc

	wanted_pos_x = body.global_position.x

func get_shape_offset():
	var shape: RectangleShape2D = advance_area_collision_shape.shape
	return shape.extents

