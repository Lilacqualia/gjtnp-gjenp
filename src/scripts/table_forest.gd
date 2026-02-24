extends Node2D

var PinballScene : PackedScene = preload("res://scenes/pinball.tscn")
var ball: Pinball
var score: int = 0
var table_is_done = false
var ball_resetter: Timer

signal update_score_display

@export var ResetPosition: Vector2 = Vector2(0.0, 0.0)
@export var ScoreToWin: int = 150
@export var NextScene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball_resetter = Timer.new()
	ball_resetter.one_shot = true
	ball_resetter.timeout.connect(_reset_the_ball)
	#ball_resetter.start(3.0)
	#ball = PinballScene.instantiate()
	#ball.position = ResetPosition
	add_child.call_deferred(ball_resetter)
	ball_resetter.start.call_deferred(3.0)
	
	
func _on_drain_killbox_body_entered(_body: Node2D) -> void: # cribbed from the sample.
	if ball_resetter.is_stopped():
		print("resetting ball")
		ball_resetter.start(3.0)

func _reset_the_ball():
	if ball:
		print("freeing old ball")
		ball.queue_free()
		ball = null
	if not ball:
		print("instantiating new ball")
		ball = PinballScene.instantiate()
		(ball.get_node("Camera2D") as Camera2D).set_deferred("enabled", false)
		ball.connect("ball_hit_something", _on_pinball_hit)
		add_child.call_deferred(ball)
		ball.set_deferred("position", ResetPosition)
		ball.set_deferred("linear_velocity", Vector2.ZERO)
	
	#call_deferred()
	#ball.position = ResetPosition
	#ball.linear_velocity = Vector2.ZERO
	

func _on_pinball_hit(hit_object: Node) -> void:
	hit_object.receive_hit()
	if hit_object.value:
		print("add %d points" % hit_object.value)
		score += hit_object.value
		emit_signal("update_score_display", score)
	if score >= ScoreToWin:
		print("you win forest table, time for cave table")
		if not table_is_done:
			table_is_done = true
			go_to_next_table()
			
func go_to_next_table():
	print("go to next table")
	ball.set_deferred("freeze", true)
	ball.set_deferred("linear_velocity", Vector2.ZERO)
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_packed(NextScene)
