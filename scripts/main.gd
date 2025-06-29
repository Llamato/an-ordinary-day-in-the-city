extends Node2D

@export var endscreen : PackedScene


const DRAW_COLOR = Color.YELLOW * Color(1, 1, 1, 0.5)

const BASE_LINE_WIDTH = 3.0
func _on_game_time_timeout() -> void:
	var endscreen_instance = endscreen.instantiate()
	var tree = get_tree()
	tree.add_child(endscreen_instance)
	tree.paused = true
	
func _on_positive_choice_chosen() -> void:
	print("Positive choice choosen")


func _on_negative_choice_choosen() -> void:
	print("Negative choice choosen")
	

@onready var tilemap = $TileMapLayer
func _draw():
	
	if tilemap._path.is_empty():
		return

	var last_point = tilemap._path[0]
	for index in range(1, len(tilemap._path)):
		var current_point = tilemap._path[index]
		draw_line(last_point, current_point, DRAW_COLOR, BASE_LINE_WIDTH, true)
		last_point = current_point
