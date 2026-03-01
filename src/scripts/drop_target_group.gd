extends Node2D

## Points awarded upon dropping all targets in the group.
@export var bonus := 100
## If true, the targets reset after awarding bonus.
@export var reset := true
## Delay before resetting in seconds.
@export var reset_delay := 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
