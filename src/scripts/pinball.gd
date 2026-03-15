class_name Pinball extends RigidBody2D

signal ball_hit_something(hit_object: Node)
signal egg_is_broken

const rebound_nocollide_layers := [2, 3, 4, 5, 6, 7]
const default_sprite_scale := Vector2(0.25, 0.25)
const rebounding_sprite_scale = Vector2(0.33, 0.33)

var old_velocity: Vector2
var min_velocity_for_thunk = 200000.0
var max_velocity_for_thunk = 3000000.0

var can_end_rebound = true;
var rebounding = false;

@export var roll_sound_upper_speed = 3000.0
@export var roll_pitch_multiplier = 2.5

@export var starting_health = 12
var health = starting_health
var spriteHealthChange: float

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$RollSound.play()
	spriteHealthChange = starting_health / float($Sprite2D.hframes * $Sprite2D.vframes)

func _exit_tree() -> void:
	$RollSound.stop()

func _process(_delta: float) -> void:
	var sound_speed = minf(linear_velocity.length(), roll_sound_upper_speed) / roll_sound_upper_speed
	# When rebounding, the egg is "flying" and not in contact with table, so no
	# roll sound.
	if rebounding: sound_speed = 0.0
	$RollSound.volume_linear = sound_speed
	# pitch scale goes from 0 to 16, 1 is baseline, 16 is max, so let's see what it sounds like
	var busIndex = AudioServer.get_bus_index("EggRoll")
	var pitchShifter = AudioServer.get_bus_effect(busIndex, 0)
	if pitchShifter is AudioEffectPitchShift:
		pitchShifter.pitch_scale = 1.0 + (sound_speed * roll_pitch_multiplier)
		old_velocity = linear_velocity
		
func _physics_process(_delta: float) -> void:
	if rebounding and can_end_rebound and $Area2D.get_overlapping_bodies().size() == 0:
		end_rebound()
   
func _on_body_entered(body: Node) -> void:
	if(body.is_in_group("hittable_object")) and rebounding == false:
		emit_signal("ball_hit_something", body)
		if(body.is_in_group("round_bumper")): # rbumper revision
			var kickaim: Vector2 = body.aim(self.global_position) # rbumper revision end
			apply_impulse(kickaim)
	elif(body.is_in_group("walls")):
		var velocity_shift = old_velocity.distance_squared_to(linear_velocity)
		if velocity_shift >= min_velocity_for_thunk:
			$Thunk.volume_linear = (minf(velocity_shift, max_velocity_for_thunk) / max_velocity_for_thunk) * 0.85
			$Thunk.play()
	elif body.is_in_group("thin_walls"):
		var velocity_shift = old_velocity.distance_squared_to(linear_velocity)
		if velocity_shift >= min_velocity_for_thunk:
			$GentleThunk.play()
			
	if(body.is_in_group("damage_kicker")):
		if body.has_method("release_the_rats"):
			body.release_the_rats()
		health -= 1
		if health > 0:
			play_egg_crack_sound()
			$Sprite2D.frame = floor((starting_health - health) / spriteHealthChange)
		else:
			play_egg_break_sound()
			$Sprite2D.visible = false
			emit_signal("egg_is_broken")
			return
		rebound()
		
func play_egg_crack_sound():
	$EggCrackSounds.get_children().pick_random().play()

func play_egg_break_sound():
	$EggBreak.play()

func rebound() -> void:
	rebounding = true
	can_end_rebound = false
	set_linear_velocity(Vector2(rng.randf_range(-750.0, 750.0), -1500))
	set_rebound_nocollide(true)
	var reboundScaleTween = get_tree().create_tween()
	reboundScaleTween.set_trans(Tween.TRANS_QUAD)
	reboundScaleTween.tween_property($Sprite2D, "scale", rebounding_sprite_scale, 0.5)
	reboundScaleTween.tween_property($Sprite2D, "scale", default_sprite_scale, 0.5)
	
	await get_tree().create_timer(1.0).timeout
	can_end_rebound = true

func end_rebound() -> void:
	set_rebound_nocollide(false)
	$Sprite2D.scale = default_sprite_scale
	rebounding = false
	
func set_rebound_nocollide(on: bool) -> void:
	for layer in rebound_nocollide_layers: set_collision_mask_value(layer, !on)
