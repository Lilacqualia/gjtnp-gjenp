extends Node2D

var PinballScene : PackedScene = preload("res://scenes/pinball.tscn")
var ball: Pinball
var score: int = 0
var table_is_done = false
var ball_resetter: Timer
var scroll_amount = 0.0
var okay_to_scroll = true

signal go_to_scene(scene: Globals.SceneName)
signal update_message(message: String)

@export var ResetPosition: Vector2 = Vector2(0.0, 0.0)
@export var NextTable : Globals.SceneName
@export var ScrollRate: float = 50.0
@export var ScrollRatio: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball_resetter = Timer.new()
	ball_resetter.one_shot = true
	ball_resetter.timeout.connect(_reset_the_ball)
	add_child.call_deferred(ball_resetter)
	ball_resetter.start.call_deferred(3.0)
	
func _process(delta: float):
	if okay_to_scroll and scroll_amount > 0.0:
		var amount_to_scroll = minf(delta * ScrollRate, scroll_amount) 
		$ScrollableElements.position.y += amount_to_scroll
		scroll_amount -= amount_to_scroll
		if to_local($ScrollableElements/ScrollStop.global_position).y >= 0.0:
			okay_to_scroll = false

func _reset_the_ball():
	var set_health_to = null
	if ball:
		ball.health -= 1
		print("health is now %d" % ball.health)
		if ball.health <= 0:
			emit_signal("go_to_scene", Globals.SceneName.GAMEOVER)
			return
		else:
			print("freeing old ball")
			ball.queue_free()
			set_health_to = ball.health
			ball = null
	if not ball:
		print("instantiating new ball")
		ball = PinballScene.instantiate()
		if set_health_to != null:
			ball.health = set_health_to
		(ball.get_node("Camera2D") as Camera2D).set_deferred("enabled", false)
		ball.connect("ball_hit_something", _on_pinball_hit)
		add_child.call_deferred(ball)
		ball.set_deferred("position", ResetPosition)
		ball.set_deferred("linear_velocity", Vector2.ZERO)

func _on_pinball_hit(hit_object: Node) -> void:
	hit_object.receive_hit(ball.linear_velocity)
	if hit_object.value:
		print("add %d points" % hit_object.value)
		score += hit_object.value
		scroll_amount += float(hit_object.value) * ScrollRatio
		emit_signal("update_message", str(score))
	if table_is_done:
		print("you win forest table")
		ask_conductor_for_next_table()
	
func ask_conductor_for_next_table():
	print("go to next table")
	ball.set_deferred("freeze", true)
	ball.set_deferred("linear_velocity", Vector2.ZERO)
	await get_tree().create_timer(3.0).timeout
	emit_signal("go_to_scene", NextTable)
