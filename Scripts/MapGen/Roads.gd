extends TileMapLayer

var directions = {left = Vector2i(-1,0), right = Vector2i(1,0), up = Vector2i(0,1), down = Vector2i(0,-1)}

var cityBoundsLeft = 0
var cityBoundsUp = 0
var cityBoundsRight = 71
var cityBoundsDown = 39

var startPosition = Vector2i(cityBoundsRight/2,cityBoundsDown/2)

class MazeRunner:
	var pos : Vector2i:
		get:
			return pos
	#todo use direction of origin
	#todo save occupied directions if we checked them
	#	a not marked direction might still be occupied since another runner might populate it
	
	func _init(_pos : Vector2i) -> void:
		pos = _pos

func check_if_direction_is_open(pos: Vector2i, dir : Vector2i, length = 2) -> bool:
	for i in range(1,length+1):
		if get_cell_tile_data(pos + (dir * i)) != null:
			return false
	return true

func draw_rectangle(corner0: Vector2i, corner1: Vector2i):
	if corner0.x > corner1.x:
		var temp = corner0.x
		corner0.x = corner1.x
		corner1.x = temp
	if corner0.y > corner1.y:
		var temp = corner0.y
		corner0.y = corner1.y
		corner1.y = temp
	for x in range(corner0.x,corner1.x + 1):
		for y in range(corner0.y, corner1.y + 1):
			set_cell(Vector2i(x,y),0,Vector2i(0,0))

func generate_Map():
	
	var stack : Array[MazeRunner]
	stack.push_back(MazeRunner.new(startPosition))
	
	var rng = RandomNumberGenerator.new()
	var maxRuntimeCounter = 10000
	
	while stack.size() != 0 && maxRuntimeCounter > 0:
		maxRuntimeCounter -= 1
		print(maxRuntimeCounter)
		# might be interesting to choose a different strategy here. Even tho its less efficient ಥ_ಥ
		#var currentRunner : MazeRunner = stack.pop_back()
		var currentRunner : MazeRunner = stack.pop_at(rng.randi_range(0,stack.size()-1))
		#Should always be a multiple of 2
		var segmentLength = rng.randi_range(3,6) * 2
		#Bounds Check
		if currentRunner.pos.x + segmentLength > cityBoundsLeft && currentRunner.pos.x - segmentLength < cityBoundsRight:
			if currentRunner.pos.y + segmentLength> cityBoundsUp && currentRunner.pos.y - segmentLength < cityBoundsDown:
				
				var possibleDirections : Array[Vector2i] #Why do i have to use a dict godot ＞﹏＜
				
				if check_if_direction_is_open(currentRunner.pos, directions.left, segmentLength):
					possibleDirections.push_back(directions.left)
				
				if check_if_direction_is_open(currentRunner.pos, directions.right, segmentLength):
					possibleDirections.push_back(directions.right)
				
				if check_if_direction_is_open(currentRunner.pos, directions.up, segmentLength):
					possibleDirections.push_back(directions.up)
				
				if check_if_direction_is_open(currentRunner.pos, directions.down, segmentLength):
					possibleDirections.push_back(directions.down)
				
				if possibleDirections.size() > 0:
					var picked : Vector2i = possibleDirections.pick_random()
					draw_rectangle(currentRunner.pos, currentRunner.pos + picked * segmentLength)
					#Reminder Always depth first
					#Otherwise you will run int some unsavory Images
					stack.push_back(currentRunner)
					stack.push_back(MazeRunner.new(currentRunner.pos + picked * segmentLength))
					stack.push_back(MazeRunner.new(currentRunner.pos + picked * segmentLength))
				

func _init() -> void:
	generate_Map()
