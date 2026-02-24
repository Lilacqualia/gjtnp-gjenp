extends Area2D

## point value per spin
@export var value: int

#signal spinner_flipped(pointvalue) # revision 0

# revision 0
#func _on_body_entered(body: Node2D) -> void: # reads the speed of the pinball, determines how many times to spin, signals the board to add points
#	var momentum: Vector2 = body.linear_velocity
#	var speed: float = momentum.length()
#	print("speed: " + str(speed) + " mph")
#	var spins: int = speed/300
#	print("spins: " + str(spins))
#	emit_signal("spinner_flipped", value * spins)

# revision 1
func receive_hit(velocity) -> int:
	var speed: float = velocity.length()
	print("speed: " + str(speed) + " mph")
	var spins: int = speed/300
	print("spins: " + str(spins))
	return value * spins
