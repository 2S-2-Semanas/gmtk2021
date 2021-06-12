extends Node2D


onready var damage_area = $DamageArea


# Called when the node enters the scene tree for the first time.
func _ready():
	damage_area.connect('body_entered', self, 'on_body_entered')


func on_body_entered(body): 	
	if(body.has_method('free_both_hands')):
		body.free_both_hands()
