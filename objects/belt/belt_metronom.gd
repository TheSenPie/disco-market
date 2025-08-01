extends AudioStreamPlayer2D

var bpm := 120.0

func _ready() -> void:
	volume_db = -10
	
	var timer = Timer.new()
	timer.wait_time = 60.0 / bpm
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect( _handle_timeout )
	add_child( timer )

func _handle_timeout() -> void:
	play()
