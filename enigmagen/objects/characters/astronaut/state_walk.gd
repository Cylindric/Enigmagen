extends NodeState

@export var speed: int = 50

@onready var entity: Astronaut = $"../.."
@onready var animation: AnimatedSprite2D = $"../../Animation"


func _on_physics_process(_delta: float) -> void:
	var direction: Vector2 = GameInputEvents.movement_input()

	if entity.direction == Vector2.LEFT:
		animation.play("walk_left")
	elif entity.direction == Vector2.RIGHT:
		animation.play("walk_right")
	elif entity.direction == Vector2.UP:
		animation.play("walk_up")
	elif entity.direction == Vector2.DOWN:
		animation.play("walk_down")

	if direction != Vector2.ZERO:
		entity.direction = direction

	entity.velocity = direction * speed
	entity.move_and_slide()


func _on_next_transitions() -> void:
	if !GameInputEvents.is_movement_input():
		transition.emit("idle")


func _on_exit() -> void:
	animation.stop()
