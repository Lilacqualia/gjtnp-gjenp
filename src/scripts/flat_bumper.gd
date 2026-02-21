extends Node2D

@onready var fbumperaim: Vector2 =  $Marker2D.global_position - $StaticBody2D.global_position # gets a vector aiming from bumper to marker

## multiplier that defines how hard the flat bumper should kick the ball. default is 20 but be aware that changing the node's scale will change the base strength of the bumper; a larger bumper will need less kick, and vice versa
@export var bumper_strength: float = 20.0

func _ready() -> void: # sets bumper to kick toward marker with user-defined strength
	$StaticBody2D.constant_linear_velocity = fbumperaim * bumper_strength
