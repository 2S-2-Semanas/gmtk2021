extends Node

signal fly_started
signal fly_ended

var is_liana_grabbed := false
var n_monkeys := 1


func _grab_liana():
	is_liana_grabbed = true
	emit_signal("fly_ended")


func _release_liana():
	is_liana_grabbed = false
	emit_signal("fly_started")


func _add_monkey():
	n_monkeys += 1
