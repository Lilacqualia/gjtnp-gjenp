@tool

class_name DropTarget extends StaticBody2D

signal target_dropped

@export var value := 20

var _down := false
var tween : Tween

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
	$CollisionShape2D.set_deferred("disabled", true)
	$HitSound.play()
	$DropSound.play()
	_down = true
	reset_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property($Sprites, "scale", Vector2(0.0, 0.0), 0.08)

func raise() -> void:
	$CollisionShape2D.set_deferred("disabled", false)
	_down = false
	reset_tween()
	tween.set_trans(Tween.TRANS_SPRING)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprites, "scale", Vector2(1.0, 1.0), 0.2)
	
# Returns true if target has been dropped.
func is_down() -> bool:
	return _down
	
func reset_tween() -> void:
	if tween: tween.kill()
	tween = get_tree().create_tween()
