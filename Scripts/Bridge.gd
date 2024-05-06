class_name Bridge extends Node2D

@export var collider: CollisionShape2D = null
@export var sprite: Sprite2D = null
@export var requiredActivators: int = 2
@export var lockedOpen: bool = false

var currentActivators: int = 0

func _on_multiplayer_synchronizer_delta_synchronized()-> void:
	setBridgeProperties()

func activate(state: bool)-> void:
	if lockedOpen:
		return
	
	if state:
		currentActivators += 1
	else:
		currentActivators -= 1
	
	if currentActivators >= requiredActivators:
		lockedOpen = true
		setBridgeProperties()

func setBridgeProperties()-> void:
	collider.set_deferred("disabled", !lockedOpen)
	sprite.visible = lockedOpen
