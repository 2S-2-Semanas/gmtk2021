extends Node2D
class_name Banana

onready var banan_area: Area2D = $BananaArea 

# Called when the node enters the scene tree for the first time.
func _ready():
	banan_area.connect('area_entered', self, 'on_area_entered')
	banan_area.connect('body_entered', self, 'on_body_entered')


func on_area_entered(_area: Area2D):
	banana_eated()

func on_body_entered(_body: Node):
	banana_eated()

func banana_eated():
	event_bus.emit_signal('banana_eated')

	#animation ?

	queue_free()
