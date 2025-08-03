extends Area2D

@export var item : PackedScene

var mouse_over: bool = false

func _ready() -> void:
	
	mouse_entered.connect( func() -> void: mouse_over = true )
	mouse_exited.connect( func() -> void: mouse_over = false )

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and mouse_over:
				var item: MarketItem= item.instantiate()
				item.z_index = 10
				item.global_position = event.global_position
				get_tree().get_current_scene().add_child( item )
				get_viewport().set_input_as_handled()
