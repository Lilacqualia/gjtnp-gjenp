extends CharacterBody2D

var push_force = 600.0 # strength of the round bumper. adjust freely
@onready var positionx = position.x
@onready var positiony = position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# calls a package meant for a moving player character interacting with rigidbodys and co-opts it to kick
# the pinball in expected ways. it's hacky, there's surely a more efficient way, but it works*. 
# when the ball falls on top of one, the first bounce is weak. will work on changing that behavior
# but i think this is enough to get off the ground for now
func _physics_process(delta: float) -> void:
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			print("detected")
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force * 2)
			position.x = positionx # the bumpers wiggle around when struck by the ball. i will also see if there's a cleaner way to keep them in place than this
			position.y = positiony
