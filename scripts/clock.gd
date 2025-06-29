extends Node2D
@export var tickmarkTexture: Texture2D
@export var game_time_tick_marks = 15

@onready var gameTimer = $GameTimer
@onready var tickmarkTimer = $TickmarkTimer
@onready var clockBackground = $ClockBackground

var tickmarks = 0
func _ready() -> void:
	var tickmark_time = gameTimer.wait_time / game_time_tick_marks
	tickmarkTimer.wait_time = tickmark_time
	tickmarkTimer.start()

func _on_tickmark_timer_timeout() -> void:
	var clock_background_rect_size = clockBackground.get_rect().size
	var tickmark_distance = clock_background_rect_size.x / game_time_tick_marks
	tickmarks += 1
	if tickmarks >= game_time_tick_marks:
		tickmarkTimer.stop()
		return
	var xpos: float = tickmark_distance * tickmarks
	var ypos: float = clock_background_rect_size.y / 2
	var tickmark_position : Vector2 = Vector2(xpos, ypos)
	var tickmark = Sprite2D.new()
	tickmark.texture = tickmarkTexture
	tickmark.position = tickmark_position
	clockBackground.add_child(tickmark)

func _on_game_timer_timeout() -> void:
	var endscreen_file = load("res://scenes/enscreen.tscn")
	var endscreen_instance = endscreen_file.instantiate()
	get_tree().add_child(endscreen_instance)
	get_tree().paused = true
