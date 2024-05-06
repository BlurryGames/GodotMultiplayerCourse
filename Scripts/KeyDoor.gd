class_name KeyDoor extends Node2D

@export var isOpen: bool = false
@export var doorOpen: Sprite2D = null
@export var doorClosed: Sprite2D = null

func _on_area_2d_area_entered(area: Area2D):
	if not multiplayer.is_server():
		return
	
	if isOpen:
		return
	
	isOpen = true
	area.get_owner().queue_free()
	setDoorProperties()

func _on_multiplayer_synchronizer_delta_synchronized():
	setDoorProperties()

func setDoorProperties()-> void:
	doorOpen.visible = isOpen
	doorClosed.visible = !isOpen
