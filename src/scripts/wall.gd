@tool
extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateChildren()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Walls do not change in gameplay, no need to update after _ready().
	if Engine.is_editor_hint(): updateChildren()

# Update child polygon geometry.
func updateChildren() -> void:
	$Line2D.points = polygon
	$StaticBody2D/CollisionPolygon2D.polygon = polygon
	
