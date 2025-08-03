class_name MarketItem extends Node2D

signal placed( MarketItem )
signal killed()
@onready var mouse_area: Area2D = $MouseArea
@onready var bit_area: Area2D = $BitArea

@onready var sound: AudioStreamPlayer2D = $Sound

var bit : Line2D

var mouse_over: bool = false
var mouse_pos: Vector2 = Vector2.ZERO
var picked: bool = false
var ghost: bool = false

func _ready() -> void:
	mouse_area.mouse_entered.connect( func() -> void: mouse_over = true )
	mouse_area.mouse_exited.connect( func() -> void: mouse_over = false )

func _physics_process(delta: float) -> void:
	if picked:
		global_position = lerp( global_position, mouse_pos, 0.2 )
	if ghost:
		visible = bit.visible
		global_position.x = bit.global_position.x

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed() and mouse_over:
				if ghost:
					killed.emit()
				else:
					picked = true
					mouse_pos = event.position
					sound.play()
					get_viewport().set_input_as_handled()
			else:
				picked = false
				placed.emit(self)
	
	if event is InputEventMouseMotion and picked:
		mouse_pos = event.position
