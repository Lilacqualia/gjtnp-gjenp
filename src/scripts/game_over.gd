extends Node2D

signal go_home

var title_screen_path = "res://scenes/title_screen.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	$GridContainer/ReturnToTitleText.visible = true
	connect("go_home", go_back_home)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start Game") and is_connected("go_home", go_back_home):
		emit_signal("go_home")
		disconnect("go_home", go_back_home)
		
func go_back_home():
	print("let's go back home.")
	get_tree().change_scene_to_file(title_screen_path)
