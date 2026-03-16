extends StaticBody2D

#point value awarded when ball strikes this bumper
var value: int = 20

#how hard the bumper kicks the ball on contact. unlike flat bumpers, this shouldn't be affected as strongly by the bumper's scale
var kick_strength: int = 20

var stable_scale: Vector2
var bumpty_scale = Vector2(0.06, 0.06)

func _ready():
	stable_scale = $Sprite2D.scale
  
# receive_hit is called by the table any time the ball strikes something to handle scoring and table-wide mechanics
func receive_hit(_speed: Vector2) -> int:
	$HitSound.play()
	var bumpingTween = get_tree().create_tween()
	bumpingTween.set_ease(Tween.EASE_OUT) 
	bumpingTween.set_trans(Tween.TRANS_CUBIC)
	bumpingTween.tween_property($Sprite2D, "scale", stable_scale + bumpty_scale, 0.04)
	bumpingTween.set_trans(Tween.TRANS_SPRING)
	bumpingTween.tween_property($Sprite2D, "scale", stable_scale, 0.15)
	return value

func aim(ballpos: Vector2) -> Vector2:
	return (ballpos - global_position) * kick_strength
