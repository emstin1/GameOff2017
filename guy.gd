extends Node2D

#variables
var velocity  = Vector2()
var current_spd = 0

#constants
const MAX_VEL = 300
const MV_LAG  = 50

func _process(delta):
	# the movement code below gives us a bit of a lag effect
	# when chaning directions or starting from a dead stop.
	if (Input.is_action_pressed("player_left")):
		if not current_spd == -MAX_VEL:
			current_spd -= MV_LAG
		velocity.x = current_spd
	elif (Input.is_action_pressed("player_right")):
		if not current_spd == MAX_VEL:
			current_spd += MV_LAG
		velocity.x = current_spd
	else:
		while current_spd != 0:
			if current_spd < 0:
				current_spd += MV_LAG
			elif current_spd > 0:
				current_spd -= MV_LAG
		velocity.x = 0

	move(velocity * delta)

func _ready():
	set_process(true)