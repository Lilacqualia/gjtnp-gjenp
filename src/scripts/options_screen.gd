extends Node2D

signal go_to_scene(scene: Globals.SceneName)
signal update_message(message: String)

# Called when the node enters the scene tree for the first time.
var master_index: int
var going_somewhere = false

func _ready() -> void:
	emit_signal("update_message", "BREAKFAST OPTIONS")
	master_index = AudioServer.get_bus_index("Master")
	if master_index > -1:
		var current_volume = AudioServer.get_bus_volume_linear(master_index)
		$MasterVolume.set_value_no_signal(current_volume)
	else:
		$MasterVolume.set_value_no_signal(1.0)

func _input(event: InputEvent) -> void:
	if not going_somewhere:
		if event.is_action_pressed("Toggle Options"):
			print("options time")
			going_somewhere = true
			emit_signal("go_to_scene", Globals.SceneName.TITLE)
		elif event.is_action_pressed("Options Right"):
			$MasterVolume.set_value($MasterVolume.value + $MasterVolume.step)
		elif event.is_action_pressed("Options Left"):
			$MasterVolume.set_value($MasterVolume.value - $MasterVolume.step)


func _on_master_volume_value_changed(value: float) -> void:
	if master_index > -1:
		AudioServer.set_bus_volume_linear(master_index, value)
