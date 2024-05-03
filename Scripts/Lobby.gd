class_name Lobby extends Node

signal playerConnected(peerID: int, playerInfo: Dictionary)
signal playerDisconnected(peerID: int)
signal serverDisconnected

const port: int = 7000
const maxConections: int = 2

var players: Dictionary = {}
var playerInfo: Dictionary = { "name": "Name" }

func _ready()-> void:
	multiplayer.peer_connected.connect(onPlayerConnected)
	multiplayer.peer_disconnected.connect(onPlayerDisconnected)
	multiplayer.connected_to_server.connect(onConnectedToServer)
	multiplayer.connection_failed.connect(onConnectionFailed)
	multiplayer.server_disconnected.connect(onServerDisconnected)

func createGame():
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_server(port, maxConections)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	players[1] = playerInfo
	playerConnected.emit(1, playerInfo)

func onPlayerConnected(id: int)-> void:
	pass

func onPlayerDisconnected(id: int)-> void:
	pass

func onConnectedToServer()-> void:
	pass

func onConnectionFailed()-> void:
	pass

func onServerDisconnected()-> void:
	pass
