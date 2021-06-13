extends Node2D

var random_generator: RandomGenerator
var element_timer: Timer


func _init():
	random_generator = load("res://utils/RandomGenerator.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	event_bus.connect('banana_eated', self, 'on_banana_eated')	
	randomize()
	
	element_timer = $LianaTimer

	random_generator.connect_timer(element_timer)
	random_generator.configure(self)
	random_generator.add_initial_rock_position($FirstColumnPosition.get_global_transform().origin)
	random_generator.add_initial_rock_position($SecondColumnPosition.get_global_transform().origin)
	random_generator.add_initial_rock_position($ThirdColumnPosition.get_global_transform().origin)
	random_generator.add_initial_rock_position($ForthColumnPosition.get_global_transform().origin)
	random_generator.emit_signal('rock_generator_loaded')

func on_banana_eated():
	print('banana eated mmm')
