@tool

class_name DropTarget extends StaticBody2D

signal target_dropped

@export var value: int

var _down := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Show only appropriate sprite for grouped/solo.
	if get_parent() is DropTargetGroup:
		$Sprites/SoloSprite.visible = false
	else:
		$Sprites/GroupSprite.visible = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func receive_hit(_speed: Vector2) -> int: #-> void: # revision 1
	drop()
	target_dropped.emit();
	return value # revision 1

func drop() -> void:
	$Sprites.set_deferred("visible", false)
	$CollisionShape2D.set_deferred("disabled", true)
	$HitSound.play()
	$DropSound.play()
	_down = true

func raise() -> void:
	$Sprites.set_deferred("visible", true)
	$CollisionShape2D.set_deferred("disabled", false)
	_down = false
	
# Returns true if target has been dropped.
func is_down() -> bool:
	return _down
