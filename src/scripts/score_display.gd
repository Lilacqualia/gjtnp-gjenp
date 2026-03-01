class_name ScoreDisplay extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BG/Numbers.text = "0"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_update_score_display(score: int) -> void:
	$BG/Numbers.text = str(score)

func update_message(message: String):
	$BG/Numbers.text = message
