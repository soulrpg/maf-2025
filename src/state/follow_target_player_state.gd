class_name FollowTargetPlayerState extends AbstractPlayerState

var target_follower_component: TargetFollowerComponent = null


func _init(player: Player) -> void:
	self.player = player
	self.target_follower_component = player.get_node("TargetFollowerComponent")


func physics_process(delta: float) -> AbstractPlayerState:
	var direction: Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	if direction:
		return MovePlayerState.new(player)
	player.move_and_collide(player.velocity * delta)
	return null


func on_enter() -> void:
	player.animated_sprite.play("move")
	target_follower_component.target_reached.connect(_on_target_follower_component_target_reached)
	target_follower_component.enabled = true


func on_exit() -> void:
	target_follower_component.enabled = false 
	
	
func _on_target_follower_component_target_reached() -> void:
	player.change_state(IdlePlayerState.new(player))
