extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func release_the_rats():
	$Rats.animation = "active"
	$RatRest.start()


func _on_rat_rest_timeout() -> void:
	$Rats.animation = "idle"
	print("rat rest")
