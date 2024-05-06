class_name Key extends Node2D

@export var followOffset: Vector2 = Vector2.ZERO
@export var lerpSpeed: float = 0.5

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

func _on_area_2d_body_entered(body: Node2D)-> void:
	followingBody = body
