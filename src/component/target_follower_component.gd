class_name TargetFollowerComponent extends Node2D

@export var navigation_agent_2d: NavigationAgent2D
@export var target: Node2D 
@export var character: CharacterBody2D
@export var speed: float = 300.0
@export var enabled: bool = true

signal target_reached


func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(_on_navigation_agent_2d_velocity_computed)
	call_deferred("navigation_target_setup")


func navigation_target_setup():
	await get_tree().physics_frame
	if target:
		navigation_agent_2d.target_position = target.global_position


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return
	if not enabled:
		return
	navigation_agent_2d.target_position = target.global_position
	if navigation_agent_2d.is_navigation_finished():
		target_reached.emit()
		return
		
	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)


func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if not enabled:
		return
	character.velocity = safe_velocity
