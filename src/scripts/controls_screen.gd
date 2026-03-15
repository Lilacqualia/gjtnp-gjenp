extends Node2D

signal go_to_scene(scene: Globals.SceneName)
signal update_message(message: String)

var handled_start = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start Game") and handled_start == false:
		print("let's go!")
		handled_start = true
		
		emit_signal("go_to_scene", Globals.SceneName.FOREST)
