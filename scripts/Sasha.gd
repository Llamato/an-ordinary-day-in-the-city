extends CharacterBody2D
class_name PlayerChar
enum State { IDLE, FOLLOW }

@export var speed = 100

@onready var animatedSprite = $CollisionShape2D/AnimatedSprite2D
@onready var astar_grid = AStarGrid2D.new()
@export var movement_speed: float = 16.0
@export var ARRIVE_DISTANCE = .4
@export var current_speed: Vector2 = Vector2(0., 0.)
@onready var _tile_map = $TileMapLayer

var _state = State.IDLE
var _velocity = Vector2()

var _click_position = Vector2()
var _path = PackedVector2Array()
var _next_point = Vector2()

#func _set_grid(active_grid: Rect2):
#	astar_grid.region = active_grid
#	astar_grid.cell_size = Vector2(16, 16)
#	astar_grid.update()
	
func _is_idle() -> bool:
	return _state == State.IDLE
	
func _ready() -> void:
	set_movement_target()
	
func _process(_delta):
	if _state != State.FOLLOW:
		return
	var arrived_to_next_point = _move_to(_next_point)
	if arrived_to_next_point:
		_set_animation(true)
		_path.remove_at(0)
		if _path.is_empty():
			_change_state(State.IDLE)
			_set_animation()
			return
		_next_point = _path[0]

func _move_to(local_position):
	var _space_diff = local_position - position
	_velocity = _snap_to_cardinal(_space_diff).normalized()
	if (abs(_space_diff.length())<4):
		_velocity = _space_diff.normalized()
	_velocity *= movement_speed 
	current_speed = _velocity
	move_and_collide(_velocity * get_process_delta_time())
	_set_animation()
	return position.distance_to(local_position) < ARRIVE_DISTANCE

func _unhandled_input(event):
	_click_position = get_global_mouse_position()
	if _tile_map != null && _tile_map.is_point_walkable(_click_position):
		if event.is_action_pressed(&"teleport_to", false, true):
			_change_state(State.IDLE)
			global_position = _tile_map.round_local_position(_click_position)
		elif event.is_action_pressed(&"move_to"):
			_change_state(State.FOLLOW)

func set_movement_target():
	return

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	current_speed = safe_velocity
	_set_animation()
	var collision = move_and_collide(safe_velocity)
	if collision:
		print("I collided with ", collision.get_collider().name)
	
func _change_state(new_state):
	if new_state == State.IDLE:
		_tile_map.clear_path()
		set_movement_target()
		_set_animation()
	elif new_state == State.FOLLOW:
		get_parent().queue_redraw()
		_path = _tile_map.find_path(position, _click_position)
		set_movement_target()
		_set_animation()
		if _path.size() < 2:
			_change_state(State.IDLE)
			return
		# The index 0 is the starting cell.
		# We don't want the character to move back to it in this example.
		_next_point = _path[1]
	
	_state = new_state


func _snap_to_cardinal(the_speed: Vector2) -> Vector2:
	var unit_direction = the_speed.normalized()
	var downness = unit_direction.dot(Vector2.DOWN)
	var rightness = unit_direction.dot(Vector2.RIGHT)
	if (abs(downness) > abs(rightness)):
		if (downness > 0.):
			return Vector2.DOWN
		else:
			return Vector2.UP
	else:
		if (rightness > 0.):
			return Vector2.RIGHT
		else:
			return Vector2.LEFT
	

func _set_animation(_force: bool = false) -> void:
	if _state == State.IDLE:
		animatedSprite.stop()
		return
	var unit_direction = _snap_to_cardinal(current_speed)
	match unit_direction:
		Vector2.UP:
			animatedSprite.play("U")
		Vector2.DOWN:
			animatedSprite.play("D")
		Vector2.LEFT:
			animatedSprite.play("L")
		Vector2.RIGHT:
			animatedSprite.play("R")
