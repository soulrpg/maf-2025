class_name IdlePlayerState extends AbstractPlayerState


func physics_process(delta: float) -> AbstractPlayerState:
	var direction: Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction:
		return MovePlayerState.new(player)
	return null


func on_enter() -> void:
	player.animated_sprite.play("idle")


func on_exit() -> void:
	pass 
