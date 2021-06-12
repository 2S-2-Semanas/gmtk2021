extends Node

var _liana_grabbed := false


func _grab_liana():
	_liana_grabbed = true


func _release_liana():
	_liana_grabbed = false
