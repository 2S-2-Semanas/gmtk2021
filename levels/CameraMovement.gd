extends Camera2D

const SPEED: int = 400
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

func _process(delta: float) -> void:
	var velocity = Vector2();
	velocity.x +=1;
	velocity = velocity * SPEED;
	position += velocity *delta; 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
