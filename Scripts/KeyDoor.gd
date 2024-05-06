class_name KeyDoor extends Node2D

signal allPlayersFinished

@export var doorOpen: Sprite2D = null
@export var doorClosed: Sprite2D = null
@export var exitArea: Area2D = null
@export var isOpen: bool = false

var finishedPlayers: int = 0

func _on_area_2d_area_entered(area: Area2D)-> void:
	if not multiplayer.is_server():
		return
	
	if isOpen:
		return
	
	isOpen = true
	exitArea.monitoring = true
	area.get_owner().queue_free()
	setDoorProperties()

func _on_exit_area_body_entered(body: Node2D)-> void:
	body.queue_free()
	finishedPlayers += 1
	if finishedPlayers > len(multiplayer.get_peers()):
		allPlayersFinished.emit()

func _on_multiplayer_synchronizer_delta_synchronized()-> void:
	setDoorProperties()

func setDoorProperties()-> void:
	doorOpen.visible = isOpen
	doorClosed.visible = !isOpen
