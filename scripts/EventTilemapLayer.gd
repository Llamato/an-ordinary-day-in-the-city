extends TileMapLayer

@export var event_trigger_distance = 4

@onready var canves_base = $"../../../CanvasLayer"

var tile_to_event_map = null
var player_character = null
var dialog_in_progress = null
var completed_dialogs = []

signal dialog_positive_option_chosen
signal dialog_negative_option_chosen

func _ready() -> void:
	if has_meta("TileToEventMap"):
		tile_to_event_map = get_meta("TileToEventMap")
		
func _process(delta: float) -> void:
	if dialog_in_progress == null:
		for entity in get_tree().get_nodes_in_group("ete"):
			check_entity_position(entity)

func check_entity_position(entity):
	var entity_position = entity.position
	for tile_position in tile_to_event_map:
		var eventPosition = map_to_local(tile_position)
		var eventScene = tile_to_event_map[tile_position]
		if entity.position.distance_to(eventPosition) < event_trigger_distance && not (eventPosition in completed_dialogs):
			completed_dialogs.append(eventPosition)
			dialog_in_progress = eventScene.instantiate()
			dialog_in_progress.positive_choice_chosen.connect(_handle_positive_choice)
			dialog_in_progress.negative_choice_chosen.connect(_handle_negative_choice)
			canves_base.add_child(dialog_in_progress)

func _handle_positive_choice():
	dialog_in_progress.completeEvent()
	dialog_in_progress = null
	
func _handle_negative_choice():
	dialog_in_progress.completeEvent()
	dialog_in_progress = null
