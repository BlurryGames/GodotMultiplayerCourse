class_name Menu extends Control

@export var ipLineEdit: LineEdit = null
@export var statusLabel: Label = null

func _ready()-> void:
	multiplayer.connection_failed.connect(onConnectionFailed)
	multiplayer.connected_to_server.connect(onConnectedToServer)

func _on_host_button_pressed()-> void:
	LobbyPtr.createGame()

func _on_join_button_pressed()-> void:
	LobbyPtr.joinGame(ipLineEdit.text)
	statusLabel.text = "Connecting..."

func _on_start_button_pressed()-> void:
	pass

func onConnectionFailed()-> void:
	statusLabel.text = "Failed to connect"

func onConnectedToServer()-> void:
	statusLabel.text = "Connected!"
