class_name Fire extends StaticBody2D

@onready var point_light: PointLight2D = $PointLight2D


func _process(delta: float) -> void:
	var current_timestamp: float = Time.get_unix_time_from_system() 
	point_light.energy = abs(sin(current_timestamp * 2)) / 4 + 0.75
	point_light.texture_scale = abs(sin(current_timestamp)) * 0.1 + 0.95
