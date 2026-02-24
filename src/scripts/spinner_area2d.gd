extends Area2D

## point value per spin
@export var value: int

var address

func _ready() -> void: # stashes the spinner's own address to send to the ball
	address = get_node(get_path())

# rigidbodys like the ball can't detect entering areas, so this prompts the ball to
# start contact to keep the spinners' behavior consistent with everything else
func _on_body_entered(body: Node2D) -> void:
	body._on_body_entered(address)

# scoring logic
func receive_hit(velocity) -> int:
	var speed: float = velocity.length()
	print("speed: " + str(speed) + " mph")
	var spins: int = speed/300
	print("spins: " + str(spins))
	return value * spins
