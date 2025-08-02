@tool
extends Sprite2D

@export var working:= false
@export var moving_speed:= -100.0

func _process(delta: float) -> void:
	if working:
		region_rect.position.x += moving_speed * delta

		var region_pos_x := region_rect.position.x
		var region_pos_x_sign : float = sign( region_pos_x )
		region_rect.position.x = fmod( region_pos_x, 1000.0 )
