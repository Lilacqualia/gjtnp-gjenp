extends Area2D

signal goal_confirmed

func _on_countdown_timeout() -> void:
	emit_signal("goal_confirmed")

func _on_goal_area_entered(body: Node2D) -> void:
	if body is Pinball:
		$Countdown.start(2)

func _on_goal_area_exited(body: Node2D) -> void:
	if body is Pinball:
		$Countdown.stop()
