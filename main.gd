extends Node2D

@onready var belt: Area2D = $Belt

func _ready() -> void:
	BackgroundMusic.stop()

func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_pay_pressed() -> void:
	belt.clear_ghosts()
