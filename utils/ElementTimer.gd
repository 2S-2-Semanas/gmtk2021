extends Timer

signal elements_generated

const INITIAL_WAIT_TIME: float = 1.0
const MAX_COUNTER: int = 2

var level: float = 2
var counter: int = MAX_COUNTER

func connect_rock(rock):
	var error = connect("timeout", rock, "_on_LianaTimer_timeout")
	if error != null && error > 0:
		print(error)

func _on_LianaTimer_timeout() -> void:
	emit_signal("elements_generated", "res://liana/Liana.tscn")
	emit_signal("elements_generated", "res://banana/Banana.tscn")
