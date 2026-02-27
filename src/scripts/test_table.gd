extends Node2D

var PinballScene : PackedScene = preload("res://scenes/pinball.tscn")
@onready var pinball_spawn_point : Vector2 = $pinball.position
var score: int
signal update_score_display

func _ready() -> void:
	score = 0

func _on_drain_killbox_body_entered(body: Node2D) -> void: # cribbed from the sample.
	if body.is_in_group("pinballs"):
		body.remove_from_group("pinballs")
		await get_tree().create_timer(1).timeout
		body.get_signal_list()
		body.queue_free()
		var new_ball : Node2D = PinballScene.instantiate()
		new_ball.position = pinball_spawn_point
		# reconnect the signal, since this is a new instance, and the signal isn't defined on the class
		new_ball.connect("ball_hit_something", _on_pinball_hit)
		add_child.call_deferred(new_ball)
	
func _on_pinball_hit(hit_object: Node) -> void:
	print("hit sensed") # revision 1
	var newpoints: int = hit_object.receive_hit($pinball.linear_velocity) # instances of this function that don't need this vector will have to take it in and just not use it
	print("add %d points" % newpoints)
	score += newpoints
	emit_signal("update_score_display", score)
#	if hit_object.value: # revision 0
#		print("add %d points" % hit_object.value)
#		score += hit_object.value
#		emit_signal("update_score_display", score)
