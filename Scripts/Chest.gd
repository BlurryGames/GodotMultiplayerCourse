class_name Chest extends Node2D

@export var keyScene: PackedScene = null
@export var keySpawn: Node2D = null
@export var chestLocked: Sprite2D = null
@export var chestUnlocked: Sprite2D = null
@export var isLocked: bool = true

func _on_multiplayer_synchronizer_delta_synchronized():
	setChestProperties()

func onInteractableInteracted()-> void:
	if isLocked:
		isLocked = false
		var key: Node2D = keyScene.instantiate()
		keySpawn.add_child(key)
		setChestProperties()

func setChestProperties()-> void:
	chestLocked.visible = isLocked
	chestUnlocked.visible = !isLocked
