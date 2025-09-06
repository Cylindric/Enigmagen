class_name GameInputEvents


static var direction: Vector2


static func movement_input() -> Vector2:
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("move_up"):
		direction += Vector2.UP
	if Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN

	direction = direction.normalized()
	return direction


static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true
