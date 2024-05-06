class_name PressurePlate extends Node2D

signal toggle(state: bool)

@export var plateUp: Sprite2D = null
@export var plateDown: Sprite2D = null
@export var isDown = false

var bodiesOnPlate: int = 0

func _on_area_2d_body_entered(_body: CharacterBody2D)-> void:
	if not multiplayer.is_server():
		return
	
	bodiesOnPlate += 1
	updatePlateState()

func _on_area_2d_body_exited(_body: CharacterBody2D)-> void:
	if not multiplayer.multiplayer_peer:
		return
	
	if not multiplayer.is_server():
		return
	
	bodiesOnPlate -= 1
	updatePlateState()

func _on_multiplayer_synchronizer_delta_synchronized():
	setPlateProperties()

func updatePlateState()-> void:
	isDown = bodiesOnPlate > 0
	toggle.emit(isDown)
	setPlateProperties()

func setPlateProperties()-> void:
	plateDown.visible = isDown
	plateUp.visible = !isDown
