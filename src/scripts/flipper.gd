extends Node2D

enum Flipper_Direction { 
	## left flipper activated by a and z
	LEFT,
	## right flipper activated by d and /
	RIGHT 
}

## Resting swing angle when activated, in degrees.
@export var swing_angle := 60.0

## Flip rotation speed, in degrees/s.
@export var flip_speed := 1200.0

## changes the triggering input *only*. use inspector -> node2d -> transform -> scale and set x to -1 to flip the actual object
@export var flipper_direction : Flipper_Direction

var input_action := ""

func _ready():
	if flipper_direction == Flipper_Direction.LEFT:
		$ActivationSound.bus = "LeftChannelOnly"
		input_action = "Left Flipper"
	else:
		$ActivationSound.bus = "RightChannelOnly"
		input_action = "Right Flipper"

func _process(delta):
	if Input.is_action_just_pressed(input_action):
		$ActivationSound.play()
	if Input.is_action_just_released(input_action):
		$DeactivationSound.play()

func _physics_process(delta: float) -> void:
	var flipping_up := Input.is_action_pressed(input_action);
	var velocity = -flip_speed if flipping_up else flip_speed
	$AnimatableBody2D.rotation_degrees = clampf(
		$AnimatableBody2D.rotation_degrees + velocity * delta,
		-swing_angle,
		0
	)
	
