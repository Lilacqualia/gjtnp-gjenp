extends CollisionShape2D

# Vibrate up and down to prevent ball sticking between boundary and objects.
func _physics_process(_delta: float) -> void:
	position.y = sin(Time.get_ticks_msec() / 20.0)
