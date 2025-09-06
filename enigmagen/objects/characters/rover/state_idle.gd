extends NodeState


@onready var entity: Rover = $"../.."
@onready var animation: AnimatedSprite2D = %Animation

## Minimum idle time (in seconds)
@export var min_idle_time: float = 1.0

## How much time left to remain in idle state
var remaining_idle_time: float = min_idle_time


func _on_next_transitions() -> void:
	if remaining_idle_time <= 0:
		transition.emit("walk")


func _on_physics_process(_delta : float) -> void:
	remaining_idle_time -= _delta	


func _on_enter() -> void:
	remaining_idle_time = min_idle_time
	animation.play("idle_up")


func _on_exit() -> void:
	animation.stop()
