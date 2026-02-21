class_name ScoreDisplay extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Numbers.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_update_score_display(score: int) -> void:
	$Numbers.text = str(score)
