extends Node2D

@export var endscreen : PackedScene
	
func _on_game_time_timeout() -> void:
	var endscreen_instance = endscreen.instantiate()
	var tree = get_tree()
	tree.add_child(endscreen_instance)
	tree.paused = true
