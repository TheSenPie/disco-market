extends Node2D

func _ready() -> void:
	BackgroundMusic.stop()

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
