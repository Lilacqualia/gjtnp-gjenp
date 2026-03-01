extends StaticBody2D

@export var value: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func receive_hit(_speed: Vector2) -> int: #-> void: # revision 1
	$Sprite2D.set_deferred("visible", false)
	$CollisionShape2D.set_deferred("disabled", true)
	$HitSound.play()
	return value # revision 1
