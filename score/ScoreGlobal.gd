extends Node

signal points_earned

var score := 0
var flying := false

func start():
	flying = true
	
	
func stop(distance):
	flying = false
	score += distance
	emit_signal("points_earned", score)
	print(score)
