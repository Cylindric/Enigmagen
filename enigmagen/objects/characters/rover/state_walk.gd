extends NodeState


@onready var entity: Rover = $"../.."
@onready var animation: AnimatedSprite2D = %Animation
@onready var navigation_agent: NavigationAgent2D = %NavigationAgent
@onready var marker: Line2D = $"../../Marker2D"

@export var min_speed: float = 5.0
@export var max_speed: float = 10.0

var _speed: float

func _ready() -> void:
	# Connect to the signal for when the path to the destination has been successfully computed.
	navigation_agent.velocity_computed.connect(on_safe_velocity_computed)
	
	# Set up the Rover once everything else is done.
	call_deferred("character_setup")


func character_setup() -> void:
	# Wait until the Physics system is ready.
	await get_tree().physics_frame
	
	# Wait for a small extra bit of time.
	await get_tree().create_timer(randf_range(0.1, 0.5)).timeout


func set_movement_target() -> void:
	# Pick a random location within the Rover's navigation mesh.
	var target_position: Vector2 = NavigationServer2D.map_get_random_point(
		navigation_agent.get_navigation_map(),
		navigation_agent.navigation_layers,
		false)
		
	# Set the rover to use the target position as it's destination.
	navigation_agent.target_position = target_position

	# Vary the speed a bit.
	_speed = randf_range(min_speed, max_speed)

	print("Moving to %s at %s" % [target_position, _speed])

func _on_physics_process(_delta : float) -> void:
	# If the destination has already been reached, pick a new one.
	if navigation_agent.is_navigation_finished():
		return

	# Get the position and direction to the next point in the path.
	var target_position: Vector2 = navigation_agent.get_next_path_position()
	var target_direction: Vector2 = entity.global_position.direction_to(target_position)
	var velocity: Vector2 = target_direction * _speed

	animation.play("idle_left")

	# rotate the entity to face the target direction.
	entity.rotation = target_direction.angle()
	
	#if target_direction.x > 0:
		#entity.direction = Vector2.RIGHT
	#elif target_direction.x < 0:
		#entity.direction = Vector2.LEFT
	#else:
		#entity.direction = Vector2.UP


	#if entity.direction == Vector2.LEFT:
		#animation.play("idle_left")
	#elif entity.direction == Vector2.RIGHT:
		#animation.play("idle_right")
	#elif entity.direction == Vector2.UP:
		#animation.play("idle_up")
	#elif entity.direction == Vector2.DOWN:
		#animation.play("idle_down")
	#else:
		#animation.play("idle_down")
	
	if navigation_agent.avoidance_enabled:
		navigation_agent.velocity = velocity
	else:
		entity.velocity = velocity
		entity.move_and_slide()


func on_safe_velocity_computed(safe_velocity: Vector2) -> void:
	print("The safe velocity %s has been computed" % safe_velocity)
	entity.velocity = safe_velocity
	entity.move_and_slide()


func _on_next_transitions() -> void:
	# If the destination has already been reached, go back to idle.
	if navigation_agent.is_navigation_finished():
		print("Transitioning Rover from Walk to Idle")
		transition.emit("idle")


func _on_enter() -> void:
	print("Entered rover State")
	# Find a new place to navigate towards.
	set_movement_target()
	animation.play("idle_up")


func _on_exit() -> void:
	print("Exiting rover State")
	animation.stop()
