extends CanvasLayer

onready var ui:Control = $Control
onready var points_label:Label = $Control/VBoxContainer/HBoxContainer/MarginContainer/HBoxContainer/Points
onready var bananas:Label = $Control/VBoxContainer/HBoxContainer/Control/HBoxContainer/Bananas

var banana_points = 0

func _ready():
	event_bus.connect('game_over', self, '_on_game_over')
	event_bus.connect('banana_eated', self, '_on_banana_eated')

	ScoreGlobal.connect('points_earned', self, '_on_points_earned')

	points_label.set_text(String(0))
	bananas.set_text(String(0))


func _on_game_over(): 
	ui.visible = false

func _on_points_earned(points):
	points_label.set_text(String(points))
	
func _on_banana_eated():
	banana_points += 1
	bananas.set_text(String(banana_points))

