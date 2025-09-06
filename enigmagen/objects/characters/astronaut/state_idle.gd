extends NodeState


@onready var entity: Astronaut = $"../.."
@onready var animation: AnimatedSprite2D = %Animation


func _on_physics_process(_delta: float) -> void:
	if entity.direction == Vector2.LEFT:
		animation.play("idle_left")
	elif entity.direction == Vector2.RIGHT:
		animation.play("idle_right")
	elif entity.direction == Vector2.UP:
		animation.play("idle_up")
	elif entity.direction == Vector2.DOWN:
		animation.play("idle_down")
	else:
		animation.play("idle_down")


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()

	if GameInputEvents.is_movement_input():
		transition.emit("walk")


func _on_exit() -> void:
	animation.stop()
