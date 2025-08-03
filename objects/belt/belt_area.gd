@tool
extends Area2D

@export var bpm := 120.0

@onready var beat_box: CollisionShape2D = $BeatBox
@onready var snap: AudioStreamPlayer2D = $Snap
@onready var scan_line: Area2D = $ScanLine

var attached_items: Array[Node2D] = []
var four_tact_width := 0.0
var belt_speed := 0.0
var bit_width := 0.0

@onready var bit_one_four: Line2D = $BitOneFour
@onready var bit_one_four_sub_one: Line2D = $BitOneFourSubOne
@onready var bit_one_four_sub_two: Line2D = $BitOneFourSubTwo
@onready var bit_one_four_sub_three: Line2D = $BitOneFourSubThree

@onready var bit_two_four: Line2D = $BitTwoFour
@onready var bit_two_four_sub_one: Line2D = $BitTwoFourSubOne
@onready var bit_two_four_sub_two: Line2D = $BitTwoFourSubTwo
@onready var bit_two_four_sub_three: Line2D = $BitTwoFourSubThree

@onready var bit_three_four: Line2D = $BitThreeFour
@onready var bit_three_four_sub_one: Line2D = $BitThreeFourSubOne
@onready var bit_three_four_sub_two: Line2D = $BitThreeFourSubTwo
@onready var bit_three_four_sub_three: Line2D = $BitThreeFourSubThree

@onready var bit_four_four: Line2D = $BitFourFour
@onready var bit_four_four_sub_one: Line2D = $BitFourFourSubOne
@onready var bit_four_four_sub_two: Line2D = $BitFourFourSubTwo
@onready var bit_four_four_sub_three: Line2D = $BitFourFourSubThree

@onready var bits_and_sub_bits : Array[Line2D] = [
	$BitOneFour, $BitOneFourSubOne, $BitOneFourSubTwo, $BitOneFourSubThree, $BitTwoFour, $BitTwoFourSubOne, $BitTwoFourSubTwo, $BitTwoFourSubThree, $BitThreeFour, $BitThreeFourSubOne, $BitThreeFourSubTwo, $BitThreeFourSubThree, $BitFourFour, $BitFourFourSubOne, $BitFourFourSubTwo, $BitFourFourSubThree
]

var ghosts: Array[MarketItem] = [
	
]

func _ready() -> void:
	four_tact_width = beat_box.shape.get_rect().size.x * scale.x
	
	bit_width = four_tact_width / 3.0
	var sub_bit_width := bit_width / 4.0
	
	var four_bit_end := beat_box.to_global(beat_box.shape.get_rect().end)
	bit_one_four.global_position.x = four_bit_end.x
	bit_one_four_sub_one.global_position.x = bit_one_four.global_position.x - 1.0 * sub_bit_width
	bit_one_four_sub_two.global_position.x = bit_one_four.global_position.x - 2.0 * sub_bit_width
	bit_one_four_sub_three.global_position.x = bit_one_four.global_position.x - 3.0 * sub_bit_width

	bit_two_four.global_position.x = four_bit_end.x - 1.0 * bit_width
	bit_two_four_sub_one.global_position.x = bit_two_four.global_position.x - 1.0 * sub_bit_width
	bit_two_four_sub_two.global_position.x = bit_two_four.global_position.x - 2.0 * sub_bit_width
	bit_two_four_sub_three.global_position.x = bit_two_four.global_position.x - 3.0 * sub_bit_width

	bit_three_four.global_position.x = four_bit_end.x - 2.0 * bit_width
	bit_three_four_sub_one.global_position.x = bit_three_four.global_position.x - 1.0 * sub_bit_width
	bit_three_four_sub_two.global_position.x = bit_three_four.global_position.x - 2.0 * sub_bit_width
	bit_three_four_sub_three.global_position.x = bit_three_four.global_position.x - 3.0 * sub_bit_width

	bit_four_four.global_position.x = four_bit_end.x - 3.0 * bit_width
	bit_four_four_sub_one.global_position.x = bit_four_four.global_position.x - 1.0 * sub_bit_width
	bit_four_four_sub_two.global_position.x = bit_four_four.global_position.x - 2.0 * sub_bit_width
	bit_four_four_sub_three.global_position.x = bit_four_four.global_position.x - 3.0 * sub_bit_width

	var beat_time := 60.0 / bpm
	belt_speed = four_tact_width / beat_time

	if not Engine.is_editor_hint():
		snap.bpm = bpm

		area_entered.connect( _handle_area_entered )
		area_exited.connect( _handle_area_exited )
		scan_line.connect( "item_scanned", _handle_item_scanned )

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		pass
	else:
		for line : Line2D in bits_and_sub_bits:
			_translate_bit_guide(line, delta)
		for item : MarketItem in attached_items:
			if not item.picked:
				item.global_position.x += bit_width * delta * 2.0

func _translate_bit_guide( bit: Line2D, delta: float ) -> void:
	bit.global_position.x += bit_width * delta * 2.0
	var beat_box_end_x := beat_box.to_global(beat_box.shape.get_rect().end).x
	if bit.global_position.x > beat_box_end_x:
		bit.hide()

	if bit.global_position.x - bit_width > beat_box_end_x:
		bit.global_position.x = beat_box.to_global(beat_box.shape.get_rect().position).x
		bit.show()

func _handle_area_entered( entity: Area2D ) -> void:
	var item := entity.get_parent()
	attached_items.push_back( item )

	assert( item is MarketItem )
	item.placed.connect( _snap_placed_item )

func _handle_area_exited( entity: Area2D ) -> void:
	var item := entity.get_parent()
	assert( item is MarketItem )
	var item_idx := attached_items.find( item )
	if item_idx >= 0:
		var attached_item := attached_items[ item_idx ]
		attached_item.placed.disconnect( _snap_placed_item )
		attached_item = null

		attached_items.remove_at(item_idx)

func _snap_placed_item( item: MarketItem ) -> void:
	var item_global_pos_x := item.global_position.x
	for bit_idx : int in range( 0, bits_and_sub_bits.size() - 1 ):
		var bit1 := bits_and_sub_bits[bit_idx]
		var bit2 := bits_and_sub_bits[bit_idx + 1]
		if item_global_pos_x <= bit1.global_position.x and item_global_pos_x > bit2.global_position.x:
			item.global_position.x = bit1.global_position.x
			item.bit = bit1
			return

	if bits_and_sub_bits.size() > 0:
		var last_bit := bits_and_sub_bits[bits_and_sub_bits.size() - 1]
		item.global_position.x = last_bit.global_position.x
		item.bit = last_bit

func _handle_item_scanned( item: MarketItem ) -> void:
	# disable scannable capabitliy
	var area:= item.find_child("BitArea") as Area2D
	area.set_deferred("monitorable", false)
	area.set_deferred("monitoring", false)
	area.queue_free()
	
	# turn into a ghost
	item.ghost = true
	item.modulate.a = 0.7
	ghosts.push_back( item )
	var ghost_idx = ghosts.size() - 1
	item.killed.connect(
		func() -> void:
			ghosts.remove_at(ghost_idx)
			item.queue_free()
	)

	var soundPlayer := item.find_child("Sound") as AudioStreamPlayer2D
	soundPlayer.play()

	var timer := Timer.new()
	timer.wait_time = 60.0 / bpm * 4.0
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect( func() -> void: soundPlayer.play() )
	item.add_child(timer)

func clear_ghosts() -> void:
	for ghost:MarketItem in ghosts:
		ghost.queue_free()
	ghosts.clear()
