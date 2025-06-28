extends CharacterBody2D

enum State { IDLE, FOLLOW }

@export var speed = 100

@onready var animatedSprite = $CollisionShape2D/AnimatedSprite2D
@onready var astar_grid = AStarGrid2D.new()
@export var movement_speed: float = 16.0
@export var ARRIVE_DISTANCE = .02
@export var current_speed: Vector2 = Vector2(0., 0.)

@onready var _tile_map = get_node("../TileMapLayer")

var _state = State.IDLE
var _velocity = Vector2()

var _click_position = Vector2()
var _path = PackedVector2Array()
var _next_point = Vector2()

func _set_grid(active_grid: Rect2):
	astar_grid.region = active_grid
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.update()
	
func _ready() -> void:
	set_movement_target(get_position())
	
	
func _process(_delta):
	if _state != State.FOLLOW:
		return
	var arrived_to_next_point = _move_to(_next_point)
	if arrived_to_next_point:
		_path.remove_at(0)
		if _path.is_empty():
			_change_state(State.IDLE)
			return
		_next_point = _path[0]

func _move_to(local_position):
	var _velocity = (local_position - position).normalized() * 16
	position += _velocity * get_process_delta_time()
	return position.distance_to(local_position) < ARRIVE_DISTANCE

func _unhandled_input(event):
	_click_position = get_global_mouse_position()
	if _tile_map.is_point_walkable(_click_position):
		if event.is_action_pressed(&"teleport_to", false, true):
			_change_state(State.IDLE)
			global_position = _tile_map.round_local_position(_click_position)
		elif event.is_action_pressed(&"move_to"):
			_change_state(State.FOLLOW)

func set_movement_target(_movement_target: Vector2):
	if _state == State.IDLE:
		movement_speed = 0.
	else:
		movement_speed = 16.


func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	current_speed = safe_velocity
	_set_animation()
	move_and_slide()
	
func _change_state(new_state):
	if new_state == State.IDLE:
		_tile_map.clear_path()
	elif new_state == State.FOLLOW:
		_path = _tile_map.find_path(position, _click_position)
		if _path.size() < 2:
			_change_state(State.IDLE)
			return
		# The index 0 is the starting cell.
		# We don't want the character to move back to it in this example.
		_next_point = _path[1]
	_state = new_state


func _set_animation() -> void:
	if (abs(current_speed.length()) < 16):
		animatedSprite.stop()
		return
	var unit_direction = current_speed.normalized()
	var upness = unit_direction.dot(Vector2.UP)
	var leftness = unit_direction.dot(Vector2.LEFT)
	if (abs(upness) > abs(leftness)):
		if (upness > 0.):
			animatedSprite.play("U")
		else:
			animatedSprite.play("U")
	if (leftness > 0.):
			animatedSprite.play("L")
	else:
			animatedSprite.play("R")
