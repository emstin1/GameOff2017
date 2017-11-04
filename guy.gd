extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var velocity  = Vector2()
const MAX_VEL = 300
var current_spd = 0

func move_left(spd):
	velocity.x = -spd

func move_right(spd):
	velocity.x = spd
	
func is_moving():
	return (Input.is_action_pressed("player_left")) or (Input.is_action_pressed("player_right"))

func _process(delta):
	
	
	if (Input.is_action_pressed("player_left")):
		if not current_spd == MAX_VEL:
			current_spd += 50
		velocity.x = -current_spd
	elif (Input.is_action_pressed("player_right")):
		if not current_spd == MAX_VEL:
			current_spd += 100
		velocity.x = current_spd
	else:
		current_spd = 0
		velocity.x = 0

	move(velocity * delta)

func _ready():
	set_process(true)