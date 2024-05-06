class_name PlayerFinder extends Node2D

@export var pivot: Node2D = null
@export var icon: Node2D = null
@export var angleOffset: float = 90.0

func _process(_delta: float)-> void:
	var canvasTransform: Transform2D = get_canvas_transform()
	var topLeft: Vector2 = -canvasTransform.origin / canvasTransform.get_scale()
	var size: Vector2 = get_viewport_rect().size / canvasTransform.get_scale()
	
	updateFinderPosition(Rect2(topLeft, size))
	updateFinderRotation()

func updateFinderPosition(bounds: Rect2)-> void:
	pivot.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	pivot.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)

func updateFinderRotation()-> void:
	var angle: float = (global_position - pivot.global_position).angle()
	pivot.global_rotation = angle + deg_to_rad(angleOffset)
	icon.global_rotation = 0
