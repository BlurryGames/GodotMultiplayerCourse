class_name Door extends Node2D

@export var isOpen: bool = false
@export var doorOpen: Sprite2D = null
@export var doorClosed: Sprite2D = null
@export var collider: CollisionShape2D = null

func _on_multiplayer_synchronizer_delta_synchronized():
	setDoorProperties()

func activate(state: bool)-> void:
	if not multiplayer.is_server():
		return
	
	isOpen = state
	setDoorProperties()

func setDoorProperties()-> void:
	doorOpen.visible = isOpen
	doorClosed.visible = !isOpen
	collider.set_deferred("disabled", isOpen)
