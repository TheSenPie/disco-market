extends Area2D

@export var bpm := 120.0

@onready var beat_box: CollisionShape2D = $BeatBox
@onready var snap: AudioStreamPlayer2D = $Snap
@onready var scan_line: Area2D = $ScanLine

var attached_items: Array[Node2D] = []
var beat_width := 0.0
var belt_speed := 0.0

func _ready() -> void:
	area_entered.connect( _handle_area_entered )
	area_exited.connect( _handle_area_exited )
	
	beat_width = beat_box.shape.get_rect().end.x - beat_box.shape.get_rect().position.x
	var beat_time := 60.0 / bpm
	belt_speed = beat_width / beat_time
	
	snap.bpm = bpm

func _physics_process(delta: float) -> void:
	for item : MarketItem in attached_items:
		if not item.picked:
			item.position += Vector2.RIGHT * belt_speed * delta

func _handle_area_entered( entity: Area2D ) -> void:
	attached_items.push_back( entity )

func _handle_area_exited( entity: Area2D ) -> void:
	var item := attached_items.find( entity )
	if item >= 0:
		attached_items.remove_at(item)
