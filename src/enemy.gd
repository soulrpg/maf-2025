class_name Enemy extends CharacterBody2D

@export var speed: float = 300.0
@export var target: Node2D = null

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite_2d.play("idle")
	navigation_agent_2d.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	call_deferred("navigation_target_setup")


func navigation_target_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position


func _physics_process(delta):
	if not is_instance_valid(target):
		return
	navigation_agent_2d.target_position = target.global_position
	if navigation_agent_2d.is_navigation_finished():
		return
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)
	
	move_and_slide()
	# If sprite was flipped vertically we need to emit animation_changed signal
	# to update the TargetableComponent's collision polygon
	var old_flip_h: bool = animated_sprite_2d.flip_h
	animated_sprite_2d.flip_h = velocity.x > 0
	if old_flip_h != animated_sprite_2d.flip_h:
		animated_sprite_2d.animation_changed.emit()


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
