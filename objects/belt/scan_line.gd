extends Area2D

signal item_scanned( item: MarketItem )

func _ready() -> void:
	area_entered.connect( _handle_area_entered )

func _handle_area_entered( entity: Area2D ) -> void:
	assert( entity is MarketItem )

	item_scanned.emit( entity )
