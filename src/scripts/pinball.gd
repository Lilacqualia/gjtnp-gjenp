extends RigidBody2D

signal hit(hit_object: Node)

func _process(_delta: float) -> void: # prevents gradient from rotating with ball for faux shine
	$gradient.rotation = -rotation


func _on_body_entered(body: Node) -> void:
	pass # Replace with function body.
	if body.is_in_group("hittable_object"):
		print("ball thinks it hit something hittable")
		emit_signal("hit", body)
		
