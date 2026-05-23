extends Node2D

signal go_to_scene(scene: Globals.SceneName)
signal update_message(message: String)

var handled_start = false
var credits_visible := false

func _ready() -> void:
	emit_signal("update_message", "WELCOME BREAKFAST")
	$Credits/RichTextLabel.meta_clicked.connect(_on_credits_meta_clicked)
	$CreditsButton.pressed.connect(_on_credits_button_clicked)
	if $TitleBGM.stream is AudioStreamWAV:
		($TitleBGM.stream as AudioStreamWAV).loop_mode = AudioStreamWAV.LOOP_FORWARD
		($TitleBGM.stream as AudioStreamWAV).loop_end = 4980706
		$TitleBGM.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Start Game") and handled_start == false:
		print("controls")
		handled_start = true
		
		emit_signal("go_to_scene", Globals.SceneName.CONTROLS)

func _on_credits_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _on_credits_button_clicked() -> void:
	credits_visible = !credits_visible
	$Credits.visible = credits_visible
	$CreditsButton.text = "BACK" if credits_visible else "CREDITS"
