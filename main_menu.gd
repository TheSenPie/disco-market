extends Control

func _ready() -> void:
	if not BackgroundMusic.is_playing():
		BackgroundMusic.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://credits_page.tscn")
