class_name TargetableComponent extends Area2D

const epsilon: int = 2

@export var target_sprite: AnimatedSprite2D = null

var polys: Array = []
var collision_polygon: CollisionPolygon2D = null
var initial_scale: Vector2 = scale

# Only one TargetableComponent can be selected at once
# (handled by global signal target_selected)
var currently_targetted: bool = false


# Overrides _input_event method from CollisionObject2D
# Only fired if event actually happens inside the collision object (in this case Area2D)
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is not InputEventMouseButton:
		return
	if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		GlobalSignals.target_selected.emit()
		currently_targetted = true
		var material: ShaderMaterial = target_sprite.get_material()
		material.set_shader_parameter("width", 1)


func _ready() -> void:
	generate_polygon_from_sprite()
	target_sprite.animation_changed.connect(_on_animated_sprite_2d_animation_changed)
	GlobalSignals.target_selected.connect(_on_global_signals_target_selected)


# Generates CollisionPolygon2D as a child of TargetableComponent
func generate_polygon_from_sprite() -> void:
	var bitmap = BitMap.new()
	if target_sprite == null:
		return
	var frame_index: int = target_sprite.get_frame()
	var animation_name: String = target_sprite.animation
	var sprite_frames: SpriteFrames = target_sprite.get_sprite_frames()
	var current_texture: Texture2D = sprite_frames.get_frame_texture(animation_name, frame_index)

	var image: Image = current_texture.get_image()
	
	if not target_sprite.flip_h:
		image.flip_x()
	bitmap.create_from_image_alpha(image, 0.1)
	polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, current_texture.get_size()), epsilon)
	
	for poly in polys:
		collision_polygon = CollisionPolygon2D.new()
		if get_child(0) == null:
			add_child(collision_polygon)
		collision_polygon.polygon = poly
		if target_sprite.centered:
			collision_polygon.position -= Vector2(bitmap.get_size() / 2)
			collision_polygon.position += target_sprite.offset
		collision_polygon.position += target_sprite.get_transform().get_origin()


func _draw() -> void:
	pass
	#if target_sprite == null and OS.is_debug_build():
	#	return
	#for i in range(1, len(collision_polygon.polygon)):
	#	draw_line(
	#		collision_polygon.polygon[i] + collision_polygon.position,
	#		collision_polygon.polygon[i-1] + collision_polygon.position,
	#		Color.RED,
	#		0.5,
	#		true,
	#	)


func _on_animated_sprite_2d_animation_changed() -> void:
	generate_polygon_from_sprite()


func _on_global_signals_target_selected() -> void:
	currently_targetted = false
	var material: ShaderMaterial = target_sprite.get_material()
	material.set_shader_parameter("width", 0)
