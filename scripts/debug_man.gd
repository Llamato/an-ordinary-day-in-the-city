extends CharacterBody2D

@export var speed = 20

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	position += direction * speed * delta
