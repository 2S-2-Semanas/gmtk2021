extends Node

signal fly_started
signal fly_ended

var _liana_grabbed := false


func _grab_liana():
	_liana_grabbed = true
	emit_signal("fly_ended")


func _release_liana():
	_liana_grabbed = false
	emit_signal("fly_started")
