class_name Player extends CharacterBody2D

@export var speed: float = 300.0

var state: AbstractPlayerState = null

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	change_state(IdlePlayerState.new(self))


func _physics_process(delta: float) -> void:
	var new_state: AbstractPlayerState = state.physics_process(delta)
	if new_state != null:
		change_state(new_state)

func change_state(new_state: AbstractPlayerState) -> void:
	if state != null:
		state.on_exit()
	state = new_state
	state.on_enter()
