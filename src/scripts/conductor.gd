extends Node2D

# primary scenes
var TitleScreen : PackedScene = preload("res://scenes/title_screen.tscn")
var GameOver: PackedScene = preload("res://scenes/game_over.tscn")
var VictoryScreen: PackedScene = preload("res://scenes/victory_screen.tscn")
var ForestBoard: PackedScene = preload("res://scenes/table_forest.tscn")
var CaveBoard: PackedScene = preload("res://scenes/table_cave.tscn")

# hud scenes
var ScoreDisplayHud: PackedScene = preload("res://scenes/score_display.tscn")

var current_scene: Node2D
var current_hud: Node2D
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hud = ScoreDisplayHud.instantiate()
	$HudContainer.add_child(current_hud)
	current_scene = TitleScreen.instantiate()
	current_scene.connect("go_to_scene", _on_go_to_scene)
	current_scene.connect("update_message", _on_update_message)
	$TableContainer.add_child(current_scene)
	

func _on_go_to_scene(scene: Globals.SceneName):
	print("let's go to scene %s" % scene)
	match scene:
		Globals.SceneName.TITLE:
			switch_scene(TitleScreen)
		Globals.SceneName.GAMEOVER:
			switch_scene(GameOver)
		Globals.SceneName.VICTORY:
			switch_scene(VictoryScreen)
		Globals.SceneName.FOREST:
			switch_scene(ForestBoard)
			current_hud.update_message("0")
		Globals.SceneName.CAVE:
			switch_scene(CaveBoard)
		_:
			print("unexpected scene")
			
func _on_update_message(message: String):
	if current_hud.has_method("update_message"):
		current_hud.update_message(message)
	else:
		print("tried to update hud message, but no hud available")
	

func switch_scene(scene: PackedScene):
	var new_scene = scene.instantiate()
	current_scene.disconnect("go_to_scene", _on_go_to_scene)
	current_scene.disconnect("update_message", _on_update_message)
	new_scene.connect("go_to_scene", _on_go_to_scene)
	new_scene.connect("update_message", _on_update_message)
	
	var fadeOutTween = get_tree().create_tween()
	fadeOutTween.tween_property($FadeZone, "color",Color(0.0, 0.0, 0.0, 1.0), 1.0)
	await fadeOutTween.finished
	$TableContainer.remove_child(current_scene)
	$TableContainer.add_child(new_scene)
	current_scene.queue_free()
	current_scene = new_scene
	var fadeInTween = get_tree().create_tween()
	fadeInTween.tween_property($FadeZone, "color",Color(0.0, 0.0, 0.0, 0.0), 1.0)
