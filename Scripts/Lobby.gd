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

func joinGame(adress: String):
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	var error: Error = peer.create_client(adress, port)
	if error:
		return error
	multiplayer.multiplayer_peer = peer

func onPlayerConnected(id: int)-> void:
	registerPlayer.rpc_id(id, playerInfo)

@rpc("any_peer", "reliable")
func registerPlayer(newPlayerInfo: Dictionary)-> void:
	var newPlayerID: int = multiplayer.get_remote_sender_id()
	players[newPlayerID] = newPlayerInfo
	playerConnected.emit(newPlayerID, newPlayerInfo)

func onPlayerDisconnected(id: int)-> void:
	players.erase(id)
	playerDisconnected.emit(id)

func onConnectedToServer()-> void:
	var peerID: int = multiplayer.get_unique_id()
	players[peerID] = playerInfo
	playerConnected.emit(peerID, playerInfo)

func onConnectionFailed()-> void:
	multiplayer.multiplayer_peer = null

func onServerDisconnected()-> void:
	multiplayer.multiplayer_peer = null
	players.clear()
	serverDisconnected.emit()
