class_name Chest extends Node2D

@export var isLocked: bool = true
@export var chestLocked: Sprite2D = null
@export var chestUnlocked: Sprite2D = null

func _on_multiplayer_synchronizer_delta_synchronized():
	setChestProperties()

func onTestInteract(state: bool)-> void:
	if state:
		onInteractableInteracted()

func onInteractableInteracted()-> void:
	if isLocked:
		isLocked = false
		setChestProperties()

func setChestProperties()-> void:
	chestLocked.visible = isLocked
	chestUnlocked.visible = !isLocked
