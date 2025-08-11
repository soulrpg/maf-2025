class_name SteeringComponent extends Node2D

@export var parent_character: CharacterBody2D = null

func _physics_process(delta: float) -> void:
	var space_state = get_world_2d().direct_space_state
	var north_west_vec = Vector2(position.x - 32, position.y - 32)
	var north_vec = Vector2(position.x, position.y - 32)
	var north_east_vec = Vector2(position.x + 32, position.y - 32)
	var west_vec = Vector2(position.x - 32, position.y)
	var east_vec = Vector2(position.x + 32, position.y)
	var south_west_vec = Vector2(position.x - 32, position.y - 32)
	var south_vec = Vector2(position.x , position.y - 32)
	var south_east_vec = Vector2(position.x + 32, position.y - 32)
	
	var queries: Array[PhysicsRayQueryParameters2D] = []
	
	queries.append(PhysicsRayQueryParameters2D.create(position, north_west_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, north_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, north_east_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, west_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, east_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, south_west_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, south_vec))
	queries.append(PhysicsRayQueryParameters2D.create(position, south_east_vec))

	var queries_results: Array[Dictionary]
	for query in queries:
		query.exclude = [parent_character]
		queries_results.append(space_state.intersect_ray(query))
