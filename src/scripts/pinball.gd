extends RigidBody2D

signal ball_hit_something(hit_object: Node)

func _process(_delta: float) -> void: # prevents gradient from rotating with ball for faux shine
	$gradient.rotation = -rotation


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
	#if body:
		#print("ball thinks it hit something hittable")
	emit_signal("ball_hit_something", body)
	#else:
		


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	pass # Replace with function body.
