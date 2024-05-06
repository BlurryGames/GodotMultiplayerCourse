class_name Menu extends Node

@export var ui: Control = null
@export var levelContainer: Node = null
@export var levelScene: PackedScene = null
@export var ipLineEdit: LineEdit = null
@export var statusLabel: Label = null
@export var notConnectedHBox: HBoxContainer = null
@export var hostHBox: HBoxContainer = null

func _ready()-> void:
	multiplayer.connection_failed.connect(onConnectionFailed)
	multiplayer.connected_to_server.connect(onConnectedToServer)

@rpc("call_local", "authority", "reliable")
func hideMenu()-> void:
	ui.hide()

func _on_host_button_pressed()-> void:
	notConnectedHBox.hide()
	hostHBox.show()
	LobbyPtr.createGame()
	statusLabel.text = "Hosting!"

func _on_join_button_pressed()-> void:
	notConnectedHBox.hide()
	LobbyPtr.joinGame(ipLineEdit.text)
	statusLabel.text = "Connecting..."

func _on_start_button_pressed()-> void:
	hideMenu.rpc()
	changeLevel.call_deferred(levelScene)

func changeLevel(scene: PackedScene)-> void:
	for c in levelContainer.get_children():
		levelContainer.remove_child(c)
		c.levelComplete.disconnect(onLevelComplete)
		c.queue_free()
	
	var newLevel = scene.instantiate()
	levelContainer.add_child(newLevel)
	newLevel.levelComplete.connect(onLevelComplete)

func onConnectionFailed()-> void:
	statusLabel.text = "Failed to connect"
	notConnectedHBox.show()

func onConnectedToServer()-> void:
	statusLabel.text = "Connected!"

func onLevelComplete()-> void:
	call_deferred("changeLevel", levelScene)
