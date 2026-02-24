class_name Pinball extends RigidBody2D

signal ball_hit_something(hit_object: Node)

@export var roll_sound_upper_speed = 3000.0
@export var roll_pitch_multiplier = 1.5
var highest = 0

func _ready() -> void:
	$RollSound.play()
	
func _exit_tree() -> void:
	$RollSound.stop()
	print("highest velocity: %f" % highest)

func _process(_delta: float) -> void: # prevents gradient from rotating with ball for faux shine
	$gradient.rotation = -rotation
	# highest observed was 384, so let's go up to uhhh 300?
	highest = maxf(highest, linear_velocity.length())
	var sound_speed = minf(linear_velocity.length(), roll_sound_upper_speed) / roll_sound_upper_speed
	$RollSound.volume_linear = sound_speed
	# pitch scale goes from 0 to 16, 1 is baseline, 16 is max, so let's see what it sounds like
	var busIndex = AudioServer.get_bus_index("EggRoll")
	var pitchShifter = AudioServer.get_bus_effect(busIndex, 0)
	if pitchShifter is AudioEffectPitchShift:
		pitchShifter.pitch_scale = 1.0 + (sound_speed * roll_pitch_multiplier)

func _on_body_entered(body: Node) -> void:
	if(body.is_in_group("hittable_object")):
		emit_signal("ball_hit_something", body)
