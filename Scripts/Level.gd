class_name Level extends Node2D

signal levelComplete

@export var playerScenes: Array[PackedScene] = []
@export var spawnPoints: Array[Node2D] = []
@export var playersContainer: Node2D = null
@export var keyDoor: KeyDoor = null

var nextSpawnPointIndex: int = 0
var nextCharacterIndex: int = 0

func _ready()-> void:
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_disconnected.connect(deletePlayer)
	
	for id in multiplayer.get_peers():
		addPlayer(id)
	
	addPlayer(1)
	
	keyDoor.allPlayersFinished.connect(onAllPlayersFinished)

func _exit_tree()-> void:
	if not multiplayer.multiplayer_peer:
		return
	
	if not multiplayer.is_server():
		return
	
	multiplayer.peer_disconnected.disconnect(deletePlayer)

func addPlayer(id: int)-> void:
	var playerInstance: CharacterBody2D = playerScenes[nextCharacterIndex].instantiate()
	nextCharacterIndex += 1
	if nextCharacterIndex >= len(playerScenes):
		nextCharacterIndex = 0
	
	playerInstance.position = getSpawnPoint()
	playerInstance.name = str(id)
	playersContainer.add_child(playerInstance)

func deletePlayer(id: int)-> void:
	if not playersContainer.has_node(str(id)):
		return
	
	playersContainer.get_node(str(id)).queue_free()

func getSpawnPoint()-> Vector2:
	var spawnPoint: Vector2 = spawnPoints[nextSpawnPointIndex].position
	nextSpawnPointIndex += 1
	if nextSpawnPointIndex >= len(spawnPoints):
		nextSpawnPointIndex = 0
	return spawnPoint

func onAllPlayersFinished()-> void:
	keyDoor.allPlayersFinished.disconnect(onAllPlayersFinished)
	levelComplete.emit()
