class_name Spinner extends Area2D

## point value per spin
@export var value: int

signal generate_points(points: int)

var address

## How fast the spinner is spinning around its axis.
var speed := 0.0
## Rate of spin speed decay per second.
var _speed_decay := 4.0
## The rotation position the spinner "seeks" to rest at.
var _resting_axis_rotation := PI / 2
## How slow the spinner has to be moving to stop, and the minimum speed until it
## reaches rest position.
var _rest_speed_threshold := 3.0;
## How close the rotation has to be to resting position to stop.
var _rest_rotation_threshold := PI / 64

var _axis_rotation := _resting_axis_rotation 

func _ready() -> void: # stashes the spinner's own address to send to the ball
	address = get_node(get_path())

func _process(delta: float) -> void:
	speed -= _speed_decay * delta
	
	# If speed is slow enough...
	if speed <= _rest_speed_threshold:
		# If within threshold of resting position, reset rotation and stop spinning.
		if abs(fmod(_axis_rotation - _resting_axis_rotation, 2 * PI)) <= _rest_rotation_threshold:
			_axis_rotation = _resting_axis_rotation
			speed = 0.0
		# Otherwise keep speed right at the threshold for now. 
		else:
			speed = _rest_speed_threshold

	# if we were previously less than the rest point, and are now >= rest point, we completed a spin
	# when we complete a spin, emit Points
	var old_rotation = fmod(_axis_rotation, 2 * PI)
	var rotation_amount = speed * delta
	_axis_rotation += rotation_amount
	if rotation_amount > 0.0 and old_rotation < _resting_axis_rotation and old_rotation + rotation_amount >= _resting_axis_rotation:
		emit_signal("generate_points", value)

	# Simulate vertical spinning with scaling.
	$RotatingItems.set_scale(Vector2(1, sin(_axis_rotation)))

# rigidbodys like the ball can't detect entering areas, so this prompts the ball to
# start contact to keep the spinners' behavior consistent with everything else
func _on_body_entered(body: Node2D) -> void:
	if body is Pinball:  body._on_body_entered(address)

# scoring logic
func receive_hit(velocity: Vector2) -> int:
	speed = velocity.length() / 20
	print("speed: " + str(speed) + " mph")
	return 0
