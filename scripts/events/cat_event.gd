extends LocationEvent

func _ready() -> void:
	positiveButton.pressed.connect(on_pet_button_pressed)	
	negativeButton.pressed.connect(on_walk_by_button_pressed)
	
func fireEvent(choice: bool):
	super.fireEvent(choice)
	
func on_pet_button_pressed():
	var clock_file = load("res://scenes/clock.tscn")
	var clock_instance = clock_file.instance()
	
