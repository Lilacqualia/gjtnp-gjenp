extends StaticBody2D

#point value awarded when ball strikes this bumper
var value: int = 10

#how hard the bumper kicks the ball on contact. unlike flat bumpers, this shouldn't be affected as strongly by the bumper's scale
var kick_strength: int = 20

# receive_hit is called by the table any time the ball strikes something to handle scoring and table-wide mechanics
func receive_hit(_speed: Vector2) -> int:
	$HitSound.play()
	return value

func aim(ballpos: Vector2) -> Vector2:
	return (ballpos - global_position) * kick_strength
