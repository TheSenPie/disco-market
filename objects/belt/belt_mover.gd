@tool
extends Sprite2D

@export var working:= false
@export var moving_speed:= -100.0

func _process(delta: float) -> void:
	if working:
		region_rect.position.x += moving_speed * delta
