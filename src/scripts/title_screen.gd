extends Node2D

signal go_to_scene(scene: Globals.SceneName)
signal update_message(message: String)

var handled_start = false

func _ready() -> void:
	emit_signal("update_message", "WELCOME BREAKFAST")
	if $TitleBGM.stream is AudioStreamWAV:
		($TitleBGM.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD
		($TitleBGM.stream as AudioStreamWAV).loop_end = 4980706
		$TitleBGM.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start Game") and handled_start == false:
		print("rules")
		handled_start = true
		
		emit_signal("go_to_scene", Globals.SceneName.RULES)
