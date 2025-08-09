class_name Player extends CharacterBody2D

@export var speed: float = 300.0

var state: AbstractPlayerState = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var target_follower_component: TargetFollowerComponent = $TargetFollowerComponent


func _ready() -> void:
	change_state(IdlePlayerState.new(self))
	GlobalSignals.target_selected.connect(_on_global_signals_target_selected)
	GlobalSignals.player_moving.connect(_on_global_signals_player_moving)
	GlobalSignals.player_idle.connect(_on_global_signals_player_idle)


func _physics_process(delta: float) -> void:
	state.physics_process(delta)


func change_state(new_state: AbstractPlayerState) -> void:
	if state != null:
		state.on_exit()
	state = new_state
	state.on_enter()


func _on_global_signals_target_selected(target: Node2D) -> void:
	# Assuming get_parent() always returns CharacterBody2D since
	# targetable_component should always be a direct child of it
	target_follower_component.target = target.get_parent()
	target_follower_component.navigation_target_setup()
	change_state(FollowTargetPlayerState.new(self))
	
func _on_global_signals_player_moving() -> void:
	change_state(MovePlayerState.new(self))
	
func _on_global_signals_player_idle() -> void:
	change_state(IdlePlayerState.new(self))
