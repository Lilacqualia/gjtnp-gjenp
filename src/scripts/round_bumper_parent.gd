extends Node2D

# the only purpose of this script is to make the adjustable values of the rbumper visible in the table scene's editor.
# would i have been better off just making the staticbody the top node? maybe! but i don't wanna change it now. lol.

##point value awarded when ball strikes this bumper
@export var value: int = 20

##how hard the bumper kicks the ball on contact. unlike flat bumpers, this shouldn't be affected as strongly by the bumper's scale
@export var kick_strength: int = 20

# 
func _ready() -> void:
	$StaticBody2D.value = value
	$StaticBody2D.kick_strength = kick_strength
