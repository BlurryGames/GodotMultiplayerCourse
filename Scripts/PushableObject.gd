class_name PushableObject extends RigidBody2D

var requestedAuthority: bool = false

func _ready()-> void:
	if not multiplayer.is_server():
		freeze = true

func push(impulse: Vector2, point: Vector2)-> void:
	if is_multiplayer_authority():
		apply_impulse(impulse, point)
	else:
		if not requestedAuthority:
			requestedAuthority = true
			requestAuthority.rpc_id(
				get_multiplayer_authority(),
				multiplayer.get_unique_id())

@rpc("any_peer", "call_remote", "reliable")
func requestAuthority(id: int)-> void:
	setPushableOwner.rpc(id)

@rpc("authority", "call_local", "reliable")
func setPushableOwner(id: int)-> void:
	requestedAuthority = false
	set_multiplayer_authority(id)
	freeze = multiplayer.get_unique_id() != id
