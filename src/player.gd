class_name Player extends CharacterBody2D

@export var speed: float = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play("idle")


func _physics_process(delta: float) -> void:
	var direction: Vector2
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	# Flip the sprite horizontally if there is input on x-axis and it's positive
	if abs(direction.x) > 0:
		animated_sprite.flip_h = direction.x > 0
		
	# Change the animation to move if there is input on either x or y-axis
	if direction.length() > 0:
		animated_sprite.play("move")
	else:
		animated_sprite.play("idle")
	
	# Normalize the direction so vector.length() ~= 1
	direction = direction.normalized()
	
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()
