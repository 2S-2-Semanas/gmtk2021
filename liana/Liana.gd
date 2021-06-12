extends Node2D


var segmentScene = preload('res://liana/LianaSegment/LianaSegment.tscn')

var segments: Array = []

var size = 20

onready var origin = $Origin
onready var ball = $Ball

func _ready():

	var lastSegment = segmentScene.instance()

	lastSegment = origin

	for i in range(0, size):

		var segment = segmentScene.instance() 
		segment.position.y = segment.joinPoint
		segments.append(segment) 
		lastSegment.add_child(segment)

		var joint = PinJoint2D.new()
		joint.disable_collision = true

		joint.node_a = lastSegment.get_path()
		joint.node_b = segment.get_path() 

		lastSegment.add_child(joint)  

		lastSegment = segment

func _input(event):
	if event is InputEventAction:
		if event.is_action_pressed('ui_accept'):
			ball.global_position = get_global_mouse_position()
