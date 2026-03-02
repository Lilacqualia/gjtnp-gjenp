class_name DropTargetGroup extends Node2D

signal generate_points(points: int)

## Points awarded upon dropping all targets in the group.
@export var bonus := 100
## If true, the targets reset after awarding bonus.
@export var reset := true
## Delay before resetting in seconds.
@export var reset_delay := 0.75

@onready var reset_timer = get_node("ResetTimer")
var targets : Array[Node]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_timer.wait_time = reset_delay;
	targets = get_children().filter(func(node): return node is DropTarget)
	for target in targets: target.target_dropped.connect(_on_target_dropped)

# Raise targets when reset timer expires.
func _on_reset_timer_timeout() -> void:
	$ResetSound.play()
	for target in targets: target.raise()

# Called when a child target is dropped.
func _on_target_dropped() -> void:
	if is_all_targets_down():
		$AllTargetsDown.play()
		reset_timer.start()
		emit_signal("generate_points", bonus)

# Returns true if all child targets are down.
func is_all_targets_down() -> bool:
	for target in targets: if not target.is_down(): return false
	return true
