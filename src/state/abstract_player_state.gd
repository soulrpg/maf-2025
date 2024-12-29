class_name AbstractPlayerState extends Object

var player: Player


func _init(player: Player) -> void:
	self.player = player


func physics_process(delta: float) -> AbstractPlayerState:
	return null


func on_enter() -> void:
	pass


func on_exit() -> void:
	pass 