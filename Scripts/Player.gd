class_name Player extends CharacterBody2D

@export var playerCamera: PackedScene = null
@export var cameraHeight: float = -132.0

@export var playerSprite: AnimatedSprite2D = null

@export var movementSpeed: float = 300.0
@export var gravity: float = 30.0
@export var jumpStrength: float = 600.0
@export var maxJumps: int = 1

@onready var initialSpriteScale: Vector2 = playerSprite.scale

var jumpCount: int = 0
var cameraInstance: Camera2D = null

func _ready()-> void:
	setUpCamera()

func _process(_delta)-> void:
	updateCameraPosition()

func _physics_process(_delta: float)-> void:
	var horizontalInput: float = (
		Input.get_action_strength("MoveRight")
		- Input.get_action_strength("MoveLeft"))
	
	velocity.x = horizontalInput * movementSpeed
	velocity.y += gravity
	
	handleMovementState()
	
	move_and_slide()
	
	faceMovementDirection(horizontalInput)


func _on_animated_sprite_2d_animation_finished():
	playerSprite.play("Jump")

func faceMovementDirection(horizontalInput: float)-> void:
	if not is_zero_approx(horizontalInput):
		if horizontalInput < 0:
			playerSprite.scale = Vector2(-initialSpriteScale.x, initialSpriteScale.y)
		else:
			playerSprite.scale = initialSpriteScale

func setUpCamera()-> void:
	cameraInstance = playerCamera.instantiate()
	cameraInstance.global_position.y = cameraHeight
	get_tree().current_scene.add_child.call_deferred(cameraInstance)

func updateCameraPosition()-> void:
	cameraInstance.global_position.x = global_position.x

func handleMovementState()-> void:
	var isFalling: bool = velocity.y > 0 and not is_on_floor()
	var isJumping: bool = Input.is_action_just_pressed("Jump") and is_on_floor()
	var isDoubleJumping: bool = Input.is_action_just_pressed("Jump") and isFalling
	var isJumpCancelled: bool = Input.is_action_just_released("Jump") and velocity.y < 0.0
	var isIdle: bool = is_on_floor() and is_zero_approx(velocity.x)
	var isWalking: bool = is_on_floor() and not is_zero_approx(velocity.x)
	
	if isJumping:
		playerSprite.play("JumpStart")
	elif isDoubleJumping:
		playerSprite.play("DoubleJumpStart")
	elif isWalking:
		playerSprite.play("Walk")
	elif isFalling:
		playerSprite.play("Fall")
	elif isIdle:
		playerSprite.play("Idle")
	
	if isJumping:
		jumpCount += 1
		velocity.y = -jumpStrength
	elif isDoubleJumping:
		jumpCount += 1
		if jumpCount <= maxJumps:
			velocity.y = -jumpStrength
	elif isJumpCancelled:
		velocity.y = 0.0
	elif is_on_floor():
		jumpCount = 0
