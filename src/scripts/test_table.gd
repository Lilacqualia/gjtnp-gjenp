extends Node2D

var PinballScene : PackedScene = preload("res://scenes/pinball.tscn")
@onready var pinball_spawn_point : Vector2 = $pinball.position


func _on_drain_killbox_body_entered(body: Node2D) -> void: # cribbed from the sample.
	if body.is_in_group("pinballs"):
		body.remove_from_group("pinballs")
		await get_tree().create_timer(1).timeout
		body.queue_free()
		var new_ball : Node2D = PinballScene.instantiate()
		new_ball.position = pinball_spawn_point
		add_child.call_deferred(new_ball)
