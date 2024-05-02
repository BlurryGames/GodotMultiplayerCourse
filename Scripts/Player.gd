class_name Player extends CharacterBody2D

@export var playerSprite: AnimatedSprite2D = null

@export var movementSpeed: float = 300.0
@export var gravity: float = 30.0
@export var jumpStrength: float = 600.0

@onready var initialSpriteScale: Vector2 = playerSprite.scale

func _physics_process(delta: float)-> void:
	var horizontalInput: float = (
		Input.get_action_strength("MoveRight")
		- Input.get_action_strength("MoveLeft"))
	
	velocity.x = horizontalInput * movementSpeed
	velocity.y += gravity
	
	var isFalling: bool = velocity.y > 0 and not is_on_floor()
	var isJumping: bool = Input.is_action_just_pressed("Jump") and is_on_floor()
	var isJumpCancelled: bool = Input.is_action_just_released("Jump") and velocity.y < 0.0
	var isIdle: bool = is_on_floor() and is_zero_approx(velocity.x)
	var isWalking: bool = is_on_floor() and not is_zero_approx(velocity.x)
	
	if isJumping:
		velocity.y = -jumpStrength
	
	move_and_slide()
	
	if isJumping:
		playerSprite.play("JumpStart")
	elif isWalking:
		playerSprite.play("Walk")
	elif isFalling:
		playerSprite.play("Fall")
	elif isIdle:
		playerSprite.play("Idle")
	
	if not is_zero_approx(horizontalInput):
		if horizontalInput < 0:
			playerSprite.scale = Vector2(-initialSpriteScale.x, initialSpriteScale.y)
		else:
			playerSprite.scale = initialSpriteScale
