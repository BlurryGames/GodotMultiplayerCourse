class_name Key extends Node2D

@export var followOffset: Vector2 = Vector2.ZERO
@export var targetPosition: Vector2 = Vector2.INF
@export var lerpSpeed: float = 5.0

var followingBody: CharacterBody2D = null

func _process(delta: float)-> void:
	if not multiplayer.multiplayer_peer:
		return
	
	if multiplayer.is_server():
		if followingBody:
			global_position = lerp(
				followingBody.global_position + followOffset,
				global_position,
				pow(0.5, delta * lerpSpeed))
			targetPosition = global_position
	else:
		global_position = HelperFunctions.clientInterpolate(
			global_position,
			targetPosition,
			delta)

func _on_area_2d_body_entered(body: Node2D)-> void:
	followingBody = body
