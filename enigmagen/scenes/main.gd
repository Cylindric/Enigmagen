extends Node2D

@onready var surface: TileMapLayer = %Surface

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	_init_grid()

func _init_grid() -> void:
	var screen_size := DisplayServer.window_get_size()

	@warning_ignore("integer_division")
	var columns := screen_size.x / 64

	@warning_ignore("integer_division")
	var rows := screen_size.y / 64
	
	print("Screen size is ", screen_size, " @ ", DisplayServer.screen_get_scale())
	print("Creating map with ", columns, " columns and ", rows, " rows.")
	
	for col in columns:
		for row in rows:
			var tile := rng.randi_range(0, 1)
			surface.set_cell(Vector2(col, row), 0, Vector2(tile, 0))
