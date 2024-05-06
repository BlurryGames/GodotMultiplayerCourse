class_name HelperFunctions extends Node

static func clientInterpolate(globalPosition: Vector2, targetPosition: Vector2, deltaTime: float, lerpSpeed: float = 25.0)-> Vector2:
	if targetPosition == Vector2.INF:
		return globalPosition
	
	if (globalPosition - targetPosition).length_squared() > 100.0 * 100.0:
		return targetPosition
	
	return lerp(targetPosition,
	globalPosition,
	pow(0.5, deltaTime * lerpSpeed))
