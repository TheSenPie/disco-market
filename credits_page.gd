extends Control

@onready var container: VBoxContainer = $VBoxContainer

signal credits_over

var showTween: Tween

func _ready() -> void:
	container.position.y = 850
	container.modulate.a = 1.0
	show()
	set_process_input(true)
	showTween = create_tween()
	# Scroll up
	showTween.tween_property(container, "position:y", -795.0, 16.0)
	showTween.tween_interval(0.5)
	# Fade out
	showTween.tween_property(container, "modulate:a", 0.0, 1.5)
	showTween.tween_callback(hide)
	showTween.tween_callback(_creadits_over)

func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("exit")):
		if (visible):
			_creadits_over()
	
func _creadits_over() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
