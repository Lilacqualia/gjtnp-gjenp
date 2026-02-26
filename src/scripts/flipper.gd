extends Node2D

enum Flipper_Direction { 
	## left flipper activated by a and z
	LEFT,
	## right flipper activated by d and /
	RIGHT 
}

## resting state while untriggered. default value is 0. be aware that flipper appears at 45 degrees, not 0, in the editor
@export var min_rotation := 0.0

## resting state while triggered. default value is 45. be aware that flipper seems to overshoot this angle slightly and snap back, presumably to emulate a physical object
@export var max_rotation := 45.0

## speed at which flipper moves between states. default value is 3
@export var base_acceleration := 3.0

## changes the triggering input *only*. use inspector -> node2d -> transform -> scale and set x to -1 to flip the actual object
@export var flipper_direction : Flipper_Direction

var flipping_up := false
var acceleration = 0.0

func _ready():
	if flipper_direction == Flipper_Direction.LEFT:
		$ActivationSound.bus = "LeftChannelOnly"
	else:
		$ActivationSound.bus = "RightChannelOnly"

func _physics_process(delta: float) -> void:
	if flipper_direction == 0: #                           maps flipper to its left/right key. feels a little hacky, redo if it starts losing inputs
		if Input.is_action_just_pressed("Left Flipper"):
			flipping_up = true
			$ActivationSound.play()
		elif Input.is_action_just_released("Left Flipper"):
			flipping_up = false
			$DeactivationSound.play()
	elif flipper_direction == 1:
		if Input.is_action_just_pressed("Right Flipper"):
			flipping_up = true
			$ActivationSound.play()
		elif Input.is_action_just_released("Right Flipper"):
			flipping_up = false
			$DeactivationSound.play()
	
	if flipping_up:
		if $AnimatableBody2D.rotation > deg_to_rad(min_rotation) + 0.01:
			if acceleration == 0:
				acceleration = 2 * base_acceleration
			$AnimatableBody2D.rotation -= acceleration * delta
			acceleration += base_acceleration
		else:
			$AnimatableBody2D.rotation = deg_to_rad(min_rotation)
			acceleration = 0.0
	else:
		if $AnimatableBody2D.rotation < deg_to_rad(max_rotation) - 0.01:
			$AnimatableBody2D.rotation += acceleration * delta
			acceleration = base_acceleration * 4
		else:
			$AnimatableBody2D.rotation = deg_to_rad(max_rotation)
			acceleration = 0.0
