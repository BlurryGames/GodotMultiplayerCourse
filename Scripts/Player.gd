class_name Player extends CharacterBody2D

enum playerState { IDLE = 0, WALKING = 1, JUMP_STARTED = 2, JUMPING = 3, DOUBLE_JUMPING = 4, FALLING = 5 }

@export var playerCamera: PackedScene = null
@export var playerSprite: AnimatedSprite2D = null

@onready var initialSpriteScale: Vector2 = playerSprite.scale

@export var cameraHeight: float = -132.0
@export var movementSpeed: float = 300.0
@export var gravity: float = 30.0
@export var jumpStrength: float = 600.0
@export var maxJumps: int = 1

var cameraInstance: Camera2D = null
var currentInteractable: Area2D = null
var ownerID: int = 1
var jumpCount: int = 0
var state: playerState = playerState.IDLE

func _enter_tree()-> void:
	ownerID = name.to_int()
	set_multiplayer_authority(ownerID)
	if ownerID != multiplayer.get_unique_id():
		return
	
	setUpCamera()

func _process(_delta)-> void:
	if not multiplayer.multiplayer_peer:
		return
	
	if ownerID != multiplayer.get_unique_id():
		return
	
	updateCameraPosition()

func _physics_process(_delta: float)-> void:
	if ownerID != multiplayer.get_unique_id():
		return
	
	var horizontalInput: float = (
		Input.get_action_strength("MoveRight")
		- Input.get_action_strength("MoveLeft"))
	
	velocity.x = horizontalInput * movementSpeed
	velocity.y += gravity
	
	if Input.is_action_just_pressed("Interact"):
		if currentInteractable:
			currentInteractable.interact.rpc_id(1)
	
	handleMovementState()
	
	move_and_slide()
	
	faceMovementDirection(horizontalInput)


func _on_animated_sprite_2d_animation_finished()-> void:
	if state == playerState.JUMPING:
		playerSprite.play("Jump")

func _on_interaction_handler_area_entered(area: Area2D)-> void:
	currentInteractable = area

func _on_interaction_handler_area_exited(area: Area2D)-> void:
	if currentInteractable == area:
		currentInteractable = null

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
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		state = playerState.JUMP_STARTED
	elif is_on_floor() and is_zero_approx(velocity.x):
		state = playerState.IDLE
	elif is_on_floor() and not is_zero_approx(velocity.x):
		state = playerState.WALKING
	else:
		state = playerState.JUMPING
	
	if velocity.y > 0 and not is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			state = playerState.DOUBLE_JUMPING
		else:
			state = playerState.FALLING
	
	match state:
		playerState.IDLE:
			playerSprite.play("Idle")
			jumpCount = 0
		playerState.WALKING:
			playerSprite.play("Walk")
			jumpCount = 0
		playerState.JUMP_STARTED:
			playerSprite.play("JumpStart")
			jumpCount += 1
			velocity.y = -jumpStrength
		playerState.JUMPING:
			pass
		playerState.DOUBLE_JUMPING:
			playerSprite.play("DoubleJumpStart")
			jumpCount += 1
			if jumpCount <= maxJumps:
				velocity.y = -jumpStrength
		playerState.FALLING:
			playerSprite.play("Fall")
	
	if Input.is_action_just_released("Jump") and velocity.y < 0.0:
		velocity.y = 0.0
