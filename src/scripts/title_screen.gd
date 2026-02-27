extends Node2D

signal game_start

var ForestTable : PackedScene = preload("res://scenes/table_forest.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start Game"):
		emit_signal("game_start")
		disconnect("game_start", start_the_game)
		print("let's go!")

func start_the_game():
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(ForestTable)
