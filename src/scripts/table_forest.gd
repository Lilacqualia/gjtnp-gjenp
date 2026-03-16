extends Node2D

var PinballScene : PackedScene = preload("res://scenes/pinball.tscn")
var ball: Pinball
var score: int = 0
var table_is_done = false
var ball_resetter: Timer
var scroll_amount = 0.0
var okay_to_scroll = true
var drop_target_groups: Array[Node]
var spinners: Array[Node]

signal go_to_scene(scene: Globals.SceneName)
signal update_message(message: String)

@export var ResetPosition: Vector2 = Vector2(0.0, 0.0)
@export var NextTable : Globals.SceneName
@export var ScrollRate: float = 50.0
@export var ScrollRatio: float = 0.16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# start the bgm
	if $ForestBGM.stream is AudioStreamWAV:
		($ForestBGM.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD
		($ForestBGM.stream as AudioStreamWAV).loop_end = 2565818
		$ForestBGM.play()
	# set up the ball
	ball_resetter = Timer.new()
	ball_resetter.one_shot = true
	ball_resetter.timeout.connect(_reset_the_ball)
	add_child.call_deferred(ball_resetter)
	ball_resetter.start.call_deferred(3.0)
	# set up signals so drop target groups can generate bonus points
	drop_target_groups = find_children("*", "DropTargetGroup")
	for dtg in drop_target_groups:
		if dtg is DropTargetGroup:
			dtg.connect("generate_points", _on_generate_points)
	# set up signals so spinners can generate points as they spin
	spinners = find_children("*", "Spinner")
	for spinner in spinners:
		if spinner is Spinner:
			spinner.connect("generate_points", _on_generate_points)
	# set up signal for the goal zone
	$ScrollableElements/GoalBox/Area2D.connect("goal_confirmed", ask_conductor_for_next_table)
	# set up flipper sounds so that each flipper sound plays only once on each side,
	# no matter how many flippers there are in total
	var flippers = find_children("*", "Flipper")
	var left_flipper = flippers.find_custom(
		func(f): return f.flipper_direction == Flipper.Flipper_Direction.LEFT)
	if left_flipper > -1:
		flippers[left_flipper].sound_on = true
	var right_flipper = flippers.find_custom(
		func(f): return f.flipper_direction == Flipper.Flipper_Direction.RIGHT)
	if right_flipper > -1:
		flippers[right_flipper].sound_on = true

	
	
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
		ball.connect("egg_is_broken", _on_egg_is_broken)
		add_child.call_deferred(ball)
		ball.set_deferred("position", ResetPosition)
		ball.call_deferred("rebound", 1250.0, 0.7)

func _on_pinball_hit(hit_object: Node) -> void:
	var value = hit_object.receive_hit(ball.linear_velocity)
	if value is int and value > 0:
		print("add %d points" % value)
		score += value
		scroll_amount += float(value) * ScrollRatio
		emit_signal("update_message", str(score))
	
func _on_egg_is_broken():
	ball.set_deferred("freeze", true)
	ball.set_deferred("linear_velocity", Vector2.ZERO)
	await get_tree().create_timer(3.0).timeout
	emit_signal("go_to_scene", Globals.SceneName.GAMEOVER)
	
func _on_generate_points(value: int):
	if value > 0:
		print("generated %d points" % value)
		score += value
		scroll_amount += float(value) * ScrollRatio
		emit_signal("update_message", str(score))

func ask_conductor_for_next_table():
	print("go to next table")
	ball.set_deferred("freeze", true)
	ball.set_deferred("linear_velocity", Vector2.ZERO)
	await get_tree().create_timer(1.5).timeout
	emit_signal("go_to_scene", NextTable)
