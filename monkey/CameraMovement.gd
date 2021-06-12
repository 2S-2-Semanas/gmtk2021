extends Camera2D

const SPEED: int = 10

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	event_bus.connect('monkey_grabbed', self, '_on_monkey_grabbed')

func _process(delta: float) -> void:
	var velocity = Vector2();
	velocity.x +=1;
	velocity = velocity * SPEED;
	position += velocity *delta; 

func _on_monkey_grabbed():
	self.zoom.x += 0.1
	self.zoom.y += 0.1
