class_name Pinball extends RigidBody2D

signal ball_hit_something(hit_object: Node)

var old_velocity: Vector2
var min_velocity_for_thunk = 200000.0
var max_velocity_for_thunk = 3000000.0

@export var roll_sound_upper_speed = 3000.0
@export var roll_pitch_multiplier = 1.5

@export var starting_health = 3
var health = starting_health

func _ready() -> void:
	$RollSound.play()
	
func _exit_tree() -> void:
	$RollSound.stop()

func _process(_delta: float) -> void:
	var sound_speed = minf(linear_velocity.length(), roll_sound_upper_speed) / roll_sound_upper_speed
	$RollSound.volume_linear = sound_speed
	# pitch scale goes from 0 to 16, 1 is baseline, 16 is max, so let's see what it sounds like
	var busIndex = AudioServer.get_bus_index("EggRoll")
	var pitchShifter = AudioServer.get_bus_effect(busIndex, 0)
	if pitchShifter is AudioEffectPitchShift:
		pitchShifter.pitch_scale = 1.0 + (sound_speed * roll_pitch_multiplier)
		old_velocity = linear_velocity

func _on_body_entered(body: Node) -> void:
	if(body.is_in_group("hittable_object")):
		emit_signal("ball_hit_something", body)
	elif(body.is_in_group("walls")):
		var velocity_shift = old_velocity.distance_squared_to(linear_velocity)
		if velocity_shift >= min_velocity_for_thunk:
			$Thunk.volume_linear = (minf(velocity_shift, max_velocity_for_thunk) / max_velocity_for_thunk) * 0.85
			$Thunk.play()
