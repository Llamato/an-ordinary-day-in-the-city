extends TileMapLayer

enum Tile { OBSTACLE, START_POINT, END_POINT }

@onready var _tile_map = get_node("/root/Node2D/TileMapLayer")
@onready var _end_point = Vector2(0.,0.)
@onready var _sasha = get_node("/root/Node2D/TileMapLayer/Sasha")

func _unhandled_input(event):
	var _click_position = get_global_mouse_position()
	if _tile_map.is_point_walkable(_click_position):
		if event.is_action_pressed(&"teleport_to"):
			clear_path()
		if event.is_action_pressed(&"move_to"):
			clear_path()
			_end_point = _tile_map.local_to_map(_click_position)
			set_cell(_end_point, 0, Vector2i(Tile.END_POINT, 0))

func clear_path():
	erase_cell(_end_point)
	# Queue redraw to clear the lines and circles.
	queue_redraw()

func _process(delta: float) -> void:
	if (_sasha._is_idle()):
		clear_path()
