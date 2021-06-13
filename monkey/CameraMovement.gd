extends Camera2D

const SPEED: int = 20  

onready var advance_area : Area2D = $AdvanceArea
onready var advance_area_collision_shape : CollisionShape2D = $AdvanceArea/AdvanceAreaCollisionShape

onready var death_floor: Area2D = $DeathFloor
onready var death_floor_collision_shape : CollisionShape2D = $DeathFloor/CollisionShape2D

onready var death_back: Area2D = $DeathBack
onready var death_back_collision_shape : CollisionShape2D = $DeathBack/CollisionShape2D

var wanted_pos_x = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_bus.connect('monkey_grabbed', self, '_on_monkey_grabbed')
	advance_area.connect('body_entered', self, 'on_advance_body_entered')
	death_floor.connect('body_entered', self, 'on_deathFloor_body_entered')
	death_back.connect('body_entered', self, 'on_deathBack_body_entered')

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

	var advance_area_shape: RectangleShape2D = advance_area_collision_shape.shape
	advance_area_shape.extents = Vector2(advance_area_shape.extents.x, advance_area_shape.extents.y * 1.1)

	var death_floor_shape: RectangleShape2D = death_floor_collision_shape.shape
	death_floor_shape.extents = Vector2(death_floor_shape.extents.x * 1.1, death_floor_shape.extents.y)
	death_floor.position.y = get_viewport().size.y + (death_floor_shape.extents.y / 2 ) + 10

	var death_back_shape: RectangleShape2D = death_back_collision_shape.shape
	death_back_shape.extents = Vector2(death_back_shape.extents.x, death_back_shape.extents.y * 1.1)
	death_back.position.x = - get_viewport().size.x - death_back_shape.extents.x 


func on_advance_body_entered(body):
	# if is main moke etc

	wanted_pos_x = body.global_position.x

func on_deathBack_body_entered(body):
	event_bus.emit_signal('game_over')
func on_deathFloor_body_entered(body):
	event_bus.emit_signal('game_over')

func get_shape_offset():
	var shape: RectangleShape2D = advance_area_collision_shape.shape
	return shape.extents

