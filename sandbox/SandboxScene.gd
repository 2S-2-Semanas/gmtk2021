extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	event_bus.connect('banana_eated', self, 'on_banana_eated')

func on_banana_eated():
	print('banana eated mmm')
