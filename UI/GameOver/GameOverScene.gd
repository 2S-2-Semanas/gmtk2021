extends Control

onready var restart_button = $TextureRect/VBoxContainer/HBoxContainer/MarginContainer/RestartButton


# Called when the node enters the scene tree for the first time.
func _ready():
	restart_button.connect('button_down', self, 'on_restart_pressed')

func on_restart_pressed():
	event_bus.emit_signal('restart_game')
