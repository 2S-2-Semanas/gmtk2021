extends Node2D
class_name Liana

const SegmentScene = preload("res://liana/lianaSegment/LianaSegment.tscn")

var segments: Array = []

var size = 30

onready var origin = $Origin 

func _ready():

	var lastSegment = SegmentScene.instance()

	lastSegment = origin

	for i in range(0, size):
		
		var segment = SegmentScene.instance()
		segment.liana = self
		
		lastSegment.add_child(segment)
		segments.append(segment)  

		var joint = PinJoint2D.new()
		joint.disable_collision = true
		joint.bias = 0.0
		joint.softness = 0.1

		joint.node_a = lastSegment.get_path()
		joint.node_b = segment.get_path()
		joint.bias = 0

		lastSegment.add_child(joint)  
		
		lastSegment = segment 

func get_current_position():
	return $Origin.global_position
