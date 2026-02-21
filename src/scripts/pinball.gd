extends RigidBody2D

signal ball_hit_something(hit_object: Node)

func _process(_delta: float) -> void: # prevents gradient from rotating with ball for faux shine
	$gradient.rotation = -rotation


func _on_body_entered(body: Node) -> void:
	if(body.is_in_group("hittable_object")):
		emit_signal("ball_hit_something", body)
