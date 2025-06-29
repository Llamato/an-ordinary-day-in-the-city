extends Control
class_name DialogEvent
enum eventTypes  {Time_triggered, Position_triggered}

@export var dialogText = ""
@export var positiveButtonCaption = "Yes"
@export var negativeButtonCaption = "No"

@onready var dialogRoot = $"."
@onready var dialogBody = $VBoxContainer/HBoxContainer/Panel/NinePatchRect/CenterContainer/Panel/Label
@onready var positiveButton = $ButtonContainer/PositiveButton
@onready var negativeButton = $ButtonContainer/NegativeButton

signal positive_choice_chosen
signal negative_choice_chosen

func _ready() -> void:
	dialogBody.text = dialogText
	positiveButton.text = positiveButtonCaption
	negativeButton.text = negativeButtonCaption
	negativeButton.pressed.connect(_on_negative_button_pressed)
	positiveButton.pressed.connect(_on_positive_button_pressed)
	
	
func _on_positive_button_pressed() -> void:
	completeEvent()
	positive_choice_chosen.emit()

func _on_negative_button_pressed() -> void:
	completeEvent()
	negative_choice_chosen.emit()

func fireEvent():
	dialogRoot.visible = true
	dialogRoot.top_level = true

func completeEvent():
	dialogRoot.visible = false
	dialogRoot.top_level = false
	call_deferred("queue_free")
