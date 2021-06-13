extends Node

class_name RandomGenerator

signal rock_generator_loaded

var noise: OpenSimplexNoise
var element_timer: Timer

var width : int
var max_columns: int
var column_multipliear: int
var last_noise: float
var total_noise: float
var last_result: int
var last_opening: int
var world = null 

var initial_element_positions: Array = []
var generated_elements: Array = []

var element_resource: Resource
var score_body_resource: Resource

func _init():
	element_resource = load('res://liana/Liana.tscn')
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1.0
	noise.period = 1.0
	noise.persistence = 1.0
	last_noise = randf()
	total_noise = randf()
	last_result = (randi() % 3) + 1
	last_opening = 0

func configure(new_world):   
	world = new_world
	width = world.get_viewport().size.x
	max_columns = 4
	column_multipliear = pow(max_columns, 10)

func add_initial_rock_position(position: Vector2):
	initial_element_positions.push_back(position)

func generate_random_int(minimun, maximun) -> int:
	var diff = maximun - minimun
	var multiplier = pow(diff, 10)
	var noise_result = noise.get_noise_3d(total_noise, last_noise, last_result)
	last_noise = noise_result
	total_noise += last_noise
	var result = (int(round(abs(noise_result * multiplier))) % (diff + 1)) + minimun
	last_result = result
	return result

func generate_opening() -> int:
	return generate_random_int(1, max_columns)

func _on_ElementTimer_timeout():
	var camera = world.get_node("Node2D/Camera2D") as Camera2D
	if((camera.global_position.x + (1024/2)) < (initial_element_positions[0].x + 100)):
		return
	
	
	# add a new element
	var first_opening: int = generate_opening()
	while (last_opening == first_opening):
		first_opening = generate_opening()
	last_opening = first_opening
	var openings: Array = [ first_opening ]

#	if(generate_random_int(0, 5) == 0):
#		var second_opening: int = generate_opening()
#		while (second_opening == last_opening):
#			second_opening = generate_opening()
#		last_opening = second_opening
#		openings.append(second_opening)

	var elements = {}
	var arr = range(1, max_columns + 1)
	for i in range(1, max_columns + 1): 
		var ignore_element = false

		for opening in openings:
			if(i == opening):
				ignore_element = true

		if(!ignore_element):
			var element = element_resource.instance()
			world.add_child(element)
			element.global_position = initial_element_positions[i - 1]
			element_timer.connect_rock(element)
			elements[i] = element
			generated_elements.append(element)
	_recalculate_initial_positions()
	var limit = camera.global_position.x - (1024/2) #scene size, better get it from world
	_remove_unnecesary_elements(limit)

func connect_timer(timer): 
	element_timer = timer
	timer.connect("elements_generated", self, "_on_ElementTimer_timeout");
	
func _recalculate_initial_positions():
	for i in range(1, max_columns + 1):
#		print('----previous----')
#		print(initial_element_positions[i-1].x)
		var increment = rand_range(initial_element_positions[i - 1].x + 64*4*3 + 64*2, initial_element_positions[i - 1].x + 64*4*4)
#		print('----new----')
#		print(increment)
		initial_element_positions[i - 1].x = increment # ADVANCE 4 POSITIONS

func _remove_unnecesary_elements(limit: float):
	var new_generated_list: Array = []
	for i in range(0, generated_elements.size()):
		var liana = generated_elements[i] as Liana
		var origin = liana.get_node("Origin") as StaticBody2D
		var x_axis = origin.global_position.x
		if(x_axis < limit - 100):
			generated_elements[i].queue_free()
		else:
			new_generated_list.append(generated_elements[i])
	generated_elements = new_generated_list
	

