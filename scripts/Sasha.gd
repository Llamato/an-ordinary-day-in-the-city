extends CharacterBody2D

@export var speed = 100

@onready var animatedSprite = $CollisionShape2D/AnimatedSprite2D

func _ready() -> void:
	pass

func get_input() -> void:
	var input_direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = input_direction * speed
	match input_direction:
		Vector2.DOWN:
			animatedSprite.play("D")
		Vector2.LEFT:
			animatedSprite.play("L")
		Vector2.RIGHT:
			animatedSprite.play("R")
		Vector2.UP:
			animatedSprite.play("U")
		Vector2.ZERO:
			animatedSprite.stop()

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
