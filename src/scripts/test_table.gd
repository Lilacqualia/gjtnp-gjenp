extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MouseButton.MOUSE_BUTTON_LEFT):
		$pinball.translate(get_global_mouse_position() - $pinball.global_position)
		$pinball.linear_velocity = Vector2.ZERO
	pass


func _on_pinball_hit(hit_object: Node) -> void:
	print("table thinks you hit %s" % hit_object.name)
	if hit_object.has_method("receive_hit"):
		hit_object.receive_hit()
