extends Node2D

@export var endscreen : PackedScene

func _ready() -> void:
	print("Alive")
	var endscreen_instance = endscreen.instantiate()
	add_child(endscreen_instance)
	
	print("dead")
