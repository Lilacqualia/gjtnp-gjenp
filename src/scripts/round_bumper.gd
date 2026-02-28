extends StaticBody2D

#point value awarded when ball strikes this bumper
var value: int = 10

#how hard the bumper kicks the ball on contact. unlike flat bumpers, this shouldn't be affected as strongly by the bumper's scale
var kick_strength: int = 20

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

# receive_hit is called by the table any time the ball strikes something to handle scoring and table-wide mechanics
func receive_hit(_speed: Vector2) -> int:
	return value

func aim(ballpos: Vector2) -> Vector2:
	$egg_aimer.global_position = ballpos
	var rbumperaim: Vector2 = $egg_aimer.global_position - $self_location.global_position
	return rbumperaim * kick_strength
