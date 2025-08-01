extends Area2D

func _ready() -> void:
	area_entered.connect( _handle_area_entered )

func _handle_area_entered( entity: Area2D ) -> void:
	assert( entity is MarketItem )
	var sound : AudioStreamPlayer2D = entity.find_child("Sound")
	sound.play()
