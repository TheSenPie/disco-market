class_name MarketItem extends Node2D

signal placed( MarketItem )

@onready var mouse_area: Area2D = $MouseArea
@onready var bit_area: Area2D = $BitArea


@onready var sound: AudioStreamPlayer2D = $Sound

var mouse_over: bool = false
var mouse_pos: Vector2 = Vector2.ZERO
var picked: bool = false

func _ready() -> void:
	mouse_area.mouse_entered.connect( func() -> void: mouse_over = true )
	mouse_area.mouse_exited.connect( func() -> void: mouse_over = false )

func _physics_process(delta: float) -> void:
	if picked:
		global_position = lerp( global_position, mouse_pos, 0.2 )

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and mouse_over:
			picked = true
			mouse_pos = event.position
			sound.play()
			get_viewport().set_input_as_handled()
		else:
			picked = false
			placed.emit(self)
	
	if event is InputEventMouseMotion and picked:
		mouse_pos = event.position
