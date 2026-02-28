extends Node2D

var TitleScreen : PackedScene = preload("res://scenes/title_screen.tscn")
var GameOver: PackedScene = preload("res://scenes/game_over.tscn")
var ForestBoard: PackedScene = preload("res://scenes/table_forest.tscn")
var CaveBoard: PackedScene = preload("res://scenes/table_cave.tscn")

var current_scene: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_scene = TitleScreen.instantiate()
	current_scene.connect("go_to_scene", _on_go_to_scene)
	add_child(current_scene)

func _on_go_to_scene(scene: Globals.SceneName):
	print("let's go to scene %s" % scene)
	match scene:
		Globals.SceneName.TITLE:
			switch_scene(TitleScreen)
		Globals.SceneName.GAMEOVER:
			switch_scene(GameOver)
		Globals.SceneName.FOREST:
			switch_scene(ForestBoard)
		Globals.SceneName.CAVE:
			switch_scene(CaveBoard)
		_:
			print("unexpected scene")
			
func switch_scene(scene: PackedScene):
	var new_scene = scene.instantiate()
	current_scene.disconnect("go_to_scene", _on_go_to_scene)
	new_scene.connect("go_to_scene", _on_go_to_scene)
	remove_child(current_scene)
	add_child(new_scene)
	current_scene.queue_free()
	current_scene = new_scene
