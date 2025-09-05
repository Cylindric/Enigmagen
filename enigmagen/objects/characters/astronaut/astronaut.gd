class_name Astronaut 
extends CharacterBody2D

const SPRITE_SIZE := Vector2(16, 16)

@onready var animation: AnimatedSprite2D = $Animation

var direction := Vector2.ZERO
var atlas := AtlasTexture.new()


func _ready() -> void:
	var file := FileAccess.get_file_as_string("res://tilesets/mars/astronaut.json")
	var sprite_data = JSON.parse_string(file)
	
	atlas.atlas = load("res://tilesets/mars/" + sprite_data["meta"]["image"])
	var frames : SpriteFrames = SpriteFrames.new()

	var tags = sprite_data["meta"]["frameTags"]
	for tag in tags:
		print("Adding new tileset %s" % tag["name"])
		frames.add_animation(tag["name"])
		frames.set_animation_speed(tag["name"], 1)
		var first_frame: int = tag["from"]
		var last_frame: int = tag["to"]
		
		print("\tAdding new animation frames %d-%d" % [first_frame, last_frame])
		for i in range(first_frame, last_frame+1):
			var frame_data = sprite_data["frames"]["frame_%d" % i]
			var x = frame_data["frame"]["x"]/SPRITE_SIZE.x
			var y = frame_data["frame"]["y"]/SPRITE_SIZE.y
			var w = frame_data["frame"]["w"]/SPRITE_SIZE.x
			var h = frame_data["frame"]["h"]/SPRITE_SIZE.y

			# Add frame
			print("\t Adding sprite at %d,%d" % [x, y])
			var frame := AtlasTexture.new()
			frame.atlas = atlas.atlas
			frame.region = Rect2(
				Vector2(x, y), 
				Vector2(w, h)
			)
			frames.add_frame(tag["name"], frame)

	print("Frames in idle_down: %s" % frames.get_frame_count("idle_down"))
	animation.frames = frames
	print("Setting default animation to %s" % tags[0]["name"])
	animation.animation = tags[0]["name"]
