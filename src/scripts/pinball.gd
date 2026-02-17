extends RigidBody2D

func _process(_delta: float) -> void: # prevents gradient from rotating with ball for faux shine
	$gradient.rotation = -rotation
