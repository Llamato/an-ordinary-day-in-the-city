extends LocationEvent

func _ready() -> void:
	super._ready()
	positiveButton.pressed.connect(on_pet_button_pressed)	
	negativeButton.pressed.connect(on_walk_by_button_pressed)
	
func fireEvent(choice: bool):
	super.fireEvent(choice)
	
func on_pet_button_pressed():
	super._on_positive_button_pressed()

func on_walk_by_button_pressed():
	super._on_negative_button_pressed()
