class_name DynamicNavigableTileMapLayer extends TileMapLayer

@export var world: Node2D = null
# TODO it should dynamically search for all other layers placed within <Map>
# and only remove polygons where the collision is added on the upper layers
# (right now handles one hardcoded layer)
@onready var tile_map_layer: TileMapLayer = %TileMapLayer


# This is basically a way to update tile data information dynamically
# Tells the engine to run _tile_data_runtime_update for coords which return true
func _use_tile_data_runtime_update(coords: Vector2i):
	if coords in tile_map_layer.get_used_cells():
		return true
	return false


func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData):
	tile_data.set_navigation_polygon(0, null)
