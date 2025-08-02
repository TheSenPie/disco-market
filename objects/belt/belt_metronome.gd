extends AudioStreamPlayer2D

var bpm := 120.0

var timer : Timer

func _init() -> void:
	volume_db = -10

	timer = Timer.new()
	timer.wait_time = 60.0 / bpm
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect( _handle_timeout )

func _ready() -> void:
	add_child( timer )

func _handle_timeout() -> void:
	play()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			timer.paused = !timer.paused
