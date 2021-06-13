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

var initial_liana_positions: Array = []
var initial_banana_positions: Array = []
var generated_elements: Array = []

var liana_resource: Resource
var banana_resource: Resource
var score_body_resource: Resource

func _init():
	liana_resource = load('res://liana/Liana.tscn')
	banana_resource = load('res://banana/Banana.tscn')
	noise = OpenSimplexNoise.new()
	randomize()
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

func add_initial_position(liana: Vector2, banana: Vector2):
	initial_liana_positions.push_back(liana)
	initial_banana_positions.push_back(banana)

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

func _on_ElementTimer_timeout(sceneToLoad):
	var camera = world.get_node("Node2D/Camera2D") as Camera2D
	if(!(camera.global_position.x + (1024/2)) < (initial_liana_positions[0].x + 100)):
		if(liana_resource.resource_path == sceneToLoad):
			var first_opening: int = generate_opening()
			while (last_opening == first_opening):
				first_opening = generate_opening()
			last_opening = first_opening
			var openings: Array = [ first_opening ]
			generate_elements(camera, openings, liana_resource)
			generate_elements(camera, openings, liana_resource)
	elif(!(camera.global_position.x + (1024/2)) < (initial_banana_positions[0].x + 100)):
		if(banana_resource.resource_path == sceneToLoad):
			generate_elements(camera, [], banana_resource)
			generate_elements(camera, [], banana_resource)
	# add a new element

#	if(generate_random_int(0, 5) == 0):
#		var second_opening: int = generate_opening()
#		while (second_opening == last_opening):
#			second_opening = generate_opening()
#		last_opening = second_opening
#		openings.append(second_opening)
#	if(liana_resource.resource_path == sceneToLoad):
#		var first_opening: int = generate_opening()
#		while (last_opening == first_opening):
#			first_opening = generate_opening()
#		last_opening = first_opening
#		var openings: Array = [ first_opening ]
#		generate_elements(camera, openings, liana_resource)
#		generate_elements(camera, openings, liana_resource)
#	elif(banana_resource.resource_path == sceneToLoad):
#		generate_elements(camera, [], banana_resource)
#		generate_elements(camera, [], banana_resource)

func generate_elements(camera, openings, element_resource):
	var elements = {}
	# var arr = range(1, max_columns + 1)
	for i in range(1, max_columns + 1): 
		var ignore_element = false

		for opening in openings:
			if(i == opening):
				ignore_element = true

		if(!ignore_element):
			var element = element_resource.instance()
			world.add_child(element)
			if(element_resource.resource_path == liana_resource.resource_path):
				element.global_position = initial_liana_positions[i - 1]
			else:
				element.global_position = initial_banana_positions[i - 1]
			element_timer.connect_rock(element)
			elements[i] = element
			generated_elements.append(element)
	
	_recalculate_initial_positions(element_resource)
	var limit = camera.global_position.x - (1024/2) #scene size, better get it from world
	_remove_unnecesary_elements(limit, element_resource)

func connect_timer(timer): 
	element_timer = timer
	timer.connect("elements_generated", self, "_on_ElementTimer_timeout");
	
func _recalculate_initial_positions(element_resource: Resource):
	if(element_resource.resource_path == liana_resource.resource_path):
		_recalculate_liana_positions()
	else:
		_recalculate_banana_positions()

func _recalculate_liana_positions():
	for i in range(1, max_columns + 1):
#		print('----previous----')
#		print(initial_liana_positions[i-1].x)
		var increment = rand_range(initial_liana_positions[i - 1].x + 64*4*3 + 64*2, initial_liana_positions[i - 1].x + 64*4*4)
#		print('----new----')
#		print(increment)
		initial_liana_positions[i - 1].x = increment # ADVANCE 4 POSITIONS

func _recalculate_banana_positions():
	for i in range(1, max_columns +1): # this will only generate 4 bananas
		var increment_y = rand_range(200, 400)
		initial_banana_positions[i -1].y = increment_y
		var increment_x = rand_range(1, 1024)
		initial_banana_positions[i - 1].x += increment_x 

func _remove_unnecesary_elements(limit: float, element_resource: Resource):
	var new_generated_list: Array = []
	for i in range(0, generated_elements.size()):
#		var x_axis = node.global_position.x
		var x_axis = 0.0
		if(element_resource.resource_path == liana_resource.resource_path):
			var liana = generated_elements[i] as Liana
			if(liana == null):
				continue
			var origin = liana.get_node("Origin") as StaticBody2D
			x_axis = origin.global_position.x
		else:
			var banana = generated_elements[i] as Banana
			if(banana == null):
				continue
			var origin = banana.get_node("BananaArea") as Area2D
			x_axis = origin.global_position.x
		if(x_axis < limit - 100):
			generated_elements[i].queue_free()
		else:
			new_generated_list.append(generated_elements[i])
	generated_elements = new_generated_list
	

