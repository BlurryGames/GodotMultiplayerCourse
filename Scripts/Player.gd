class_name Player extends CharacterBody2D

@export var movementSpeed: float = 300.0
@export var gravity: float = 30.0
@export var jumpStrength: float = 600.0

func _physics_process(delta: float)-> void:
	var horizontalInput: float = (
		Input.get_action_strength("MoveRight")
		- Input.get_action_strength("MoveLeft"))
	
	velocity.x = horizontalInput * movementSpeed
	velocity.y += gravity
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = -jumpStrength
	
	move_and_slide()
