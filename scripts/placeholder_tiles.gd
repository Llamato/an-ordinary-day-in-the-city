extends TileMapLayer

const CELL_SIZE = Vector2i(16, 16)
const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color.YELLOW * Color(1, 1, 1, 0.5)

# The object for pathfinding on 2D grids.
var _astar = AStarGrid2D.new()

var _start_point = Vector2i()
var _end_point = Vector2i()
var _path = PackedVector2Array()

func _ready():
	# Region should match the size of the playable area plus one (in tiles).
	# In this demo, the playable area is 17×9 tiles, so the rect size is 18×10.
	_astar.region = get_used_rect()
	_astar.cell_size = CELL_SIZE
	_astar.offset = CELL_SIZE * 0.5
	_astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	_astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_astar.update()
	var used_cells = get_used_cells();

	for cell in used_cells:
		var data = get_cell_tile_data(cell)
		if data == null:
			_astar.set_point_solid(cell, true)
			break
		if data.get_collision_polygons_count(0) != 0:
			_astar.set_point_solid(cell, true)
	#print("a* setup complete");
	#print_astar_solid_map(_astar);
	
func print_astar_solid_map(astar):
	for i in range(astar.region.position.x,astar.region.end.x):
		var temp = "";
		for j in range(astar.region.position.y,astar.region.end.y):
			var test = str(astar.is_point_solid(Vector2(i,j)));
			if astar.is_point_solid(Vector2(i,j)) == true:
				temp += "X";
			else:
				temp += "O";
		print(temp);




func round_local_position(local_position):
	return map_to_local(local_to_map(local_position))


func is_point_walkable(local_position):
	var map_position = local_to_map(local_position)
	if _astar.is_in_boundsv(map_position):
		return not _astar.is_point_solid(map_position)
	return false


func clear_path():
	if not _path.is_empty():
		_path.clear()
		# Queue redraw to clear the lines and circles.
		queue_redraw()


func find_path(local_start_point, local_end_point):
	clear_path()

	_start_point = local_to_map(local_start_point)
	_end_point = local_to_map(local_end_point)
	_path = _astar.get_point_path(_start_point, _end_point, true)

	# Redraw the lines and circles from the start to the end point.
	queue_redraw()

	return _path.duplicate()
