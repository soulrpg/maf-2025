class_name MovePlayerState extends AbstractPlayerState


func physics_process(delta: float) -> AbstractPlayerState:
	var direction: Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	# Flip the sprite horizontally if there is input on x-axis and it's positive
	if abs(direction.x) > 0:
		player.animated_sprite.flip_h = direction.x > 0
	
	# Normalize the direction so vector.length() ~= 1
	direction = direction.normalized()
	
	if direction:
		player.velocity = direction * player.speed
	else:
		player.velocity = Vector2.ZERO
		return IdlePlayerState.new(player)
	player.move_and_slide()
	return null


func on_enter() -> void:
	player.animated_sprite.play("move")


func on_exit() -> void:
	pass 
