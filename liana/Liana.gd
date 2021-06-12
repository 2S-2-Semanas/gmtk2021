extends Node2D


var segmentScene = preload('res://liana/lianaSegment/LianaSegment.tscn')

var segments: Array = []

var size = 30

onready var origin = $Origin 

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
		joint.bias = 0.9
		joint.softness = 0.1

		joint.node_a = lastSegment.get_path()
		joint.node_b = segment.get_path() 
		joint.position.y = segment.joinPoint

		lastSegment.add_child(joint)  

		lastSegment = segment 
