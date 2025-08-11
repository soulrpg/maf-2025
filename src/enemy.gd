class_name Enemy extends CharacterBody2D

@export var speed: float = 300.0
@export var target: Node2D = null

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var target_follower_component: TargetFollowerComponent = $TargetFollowerComponent
@onready var steering_component: SteeringComponent = $SteeringComponent


func _ready() -> void:
	animated_sprite_2d.play("idle")
	target_follower_component.target = target


func _physics_process(delta):
	velocity = target_follower_component.computed_velocity
	move_and_collide(velocity * delta)
	# If sprite was flipped vertically we need to emit animation_changed signal
	# to update the TargetableComponent's collision polygon
	var old_flip_h: bool = animated_sprite_2d.flip_h
	animated_sprite_2d.flip_h = velocity.x > 0
	if old_flip_h != animated_sprite_2d.flip_h:
		animated_sprite_2d.animation_changed.emit()
