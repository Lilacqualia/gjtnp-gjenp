extends RigidBody2D

signal ball_hit_something(hit_object: Node)

var old_velocity: Vector2
var min_velocity_for_thunk = 200000.0
var max_velocity_for_thunk = 3000000.0

func _process(_delta: float) -> void: # prevents gradient from rotating with ball for faux shine
	$gradient.rotation = -rotation
	old_velocity = linear_velocity

func _on_body_entered(body: Node) -> void:
	if(body.is_in_group("hittable_object")):
		emit_signal("ball_hit_something", body)
	elif(body.is_in_group("walls")):
		var velocity_shift = old_velocity.distance_squared_to(linear_velocity)
		if velocity_shift >= min_velocity_for_thunk:
			$Thunk.volume_linear = (minf(velocity_shift, max_velocity_for_thunk) / max_velocity_for_thunk) * 0.85
			$Thunk.play()
