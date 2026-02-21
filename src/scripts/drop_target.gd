extends StaticBody2D

@export var value: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func receive_hit() -> void:
	$AnimatedSprite2D.animation = "inactive"
	$CollisionPolygon2D.set_deferred("disabled", true)
